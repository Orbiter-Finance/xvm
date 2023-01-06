// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "./Multicall.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IERC20 {
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function balanceOf(address account) external view returns (uint256);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

contract OrbiterBridge is Ownable, ReentrancyGuard, Multicall {
    mapping(address => bool) public getMaker;
    event Swap(address indexed maker, address indexed token);
    event SwapAnswer(
        uint256 indexed op,
        address indexed operator,
        address indexed recipient,
        bytes32 tradeId
    );

    event ChangeMaker(address indexed maker, bool indexed enable);

    constructor(address maker) {
        changeMaker(maker, true);
    }

    receive() external payable {}

    function changeMaker(address maker, bool enable) public onlyOwner {
        getMaker[maker] = enable;
        emit ChangeMaker(maker, enable);
    }

    function withdraw(address token) external onlyOwner {
        if (token != address(0)) {
            bool success = IERC20(token).transfer(
                msg.sender,
                IERC20(token).balanceOf(address(this))
            );
            require(success, "Withdraw Fail");
        } else {
            payable(msg.sender).transfer(address(this).balance);
        }
    }

    function forward(
        address token,
        address payable recipient,
        uint256 value
    ) private {
        // require(value > 0, "Value Wrong");
        if (token == address(0)) {
            require(address(this).balance >= value, "Insufficient Balance");
            recipient.transfer(value);
        } else {
            require(
                IERC20(token).allowance(msg.sender, address(this)) >= value,
                "Insufficient Balance"
            );
            bool success = IERC20(token).transferFrom(
                msg.sender,
                recipient,
                value
            );
            require(success, "Tranfer Wrong");
        }
    }

    /// @notice This method allows you to initiate a Swap transaction
    /// @dev You can call our contract Swap anywhere
    /// @param maker maker wallet address
    /// @param token source chain token, chain mainToken address is 0x000....000
    /// @param value source chain send token value
    /// @param data Additional parameters
    function swap(
        address payable maker,
        address token,
        uint256 value,
        bytes calldata data
    )
        external
        payable
        nonReentrant
    {
        value = token == address(0) ? msg.value : value;
        emit Swap(maker, token);
        forward(token, maker, value);
    }

    function swapAnswer(
        bytes32 tradeId,
        address payable to,
        address token,
        uint256 op,
        uint256 value
    ) external payable {
        require(getMaker[msg.sender], "Ownable: caller is not the maker");
        emit SwapAnswer(op, msg.sender, to, tradeId);
        forward(token, to, value);
    }
}
