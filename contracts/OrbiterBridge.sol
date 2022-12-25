// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "./Multicall.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IERC20 {
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

contract OrbiterBridge is Ownable, ReentrancyGuard, Multicall {
    mapping(address => bool) public getMaker;

    event Transfer(
        address token,
        address recipient,
        uint256 value,
        bytes[] data
    );
    event Swap(address maker, address token, uint256 value, bytes[] data);
    event SwapOK(
        bytes32 tradeId,
        address token,
        address to,
        uint256 value
    );
    event SwapFail(bytes32 tradeId, address token, address to, uint256 value);

    event ChangeMaker(address indexed maker, bool enable);

    constructor(address maker) {
        changeMaker(maker, true);
    }

    modifier onlyMaker() {
        _checkMaker();
        _;
    }

    function _checkMaker() internal view virtual {
        require(getMaker[_msgSender()], "Ownable: caller is not the maker");
    }

    function changeMaker(address maker, bool enable) public {
        getMaker[maker] = enable;
        emit ChangeMaker(maker, enable);
    }

    function tranfer(
        address token,
        address payable recipient,
        uint256 value
    ) private {
        require(value > 0, "Value Err");
        if (token == address(0)) {
            recipient.transfer(value);
        } else {
            bool success = IERC20(token).transferFrom(
                msg.sender,
                recipient,
                value
            );
            require(success, "Tranfer Err");
        }
    }

    function transfer(
        address token,
        address payable recipient,
        uint256 value,
        bytes[] memory data
    ) external payable nonReentrant {
        emit Transfer(token, recipient, value, data);
        tranfer(token, recipient, value);
    }

    function swap(
        address payable maker,
        address token,
        uint256 value,
        bytes[] calldata data
    ) external payable nonReentrant {
        value = token == address(0) ? msg.value : value;
        emit Swap(maker, token, value, data);
        tranfer(token, maker, value);
    }

    function swapFail(
        bytes32 tradeId,
        address token,
        address payable to,
        uint256 value
    ) external payable onlyMaker nonReentrant {
        emit SwapFail(tradeId, token, to, value);
        tranfer(token, to, value);
    }

    function swapOK(
        bytes32 tradeId,
        address token,
        address payable to,
        uint256 value
    ) external payable onlyMaker nonReentrant {
        emit SwapOK(tradeId, token, to, value);
        tranfer(token, to, value);
    }
}
