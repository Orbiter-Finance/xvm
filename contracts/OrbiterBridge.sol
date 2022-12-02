//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

interface IERC20 {
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

contract OrbiterBridge is ReentrancyGuard {
    constructor() {}

    event SwapEvent(address maker, address token, uint256 value, bytes[] data);
    event SwapFailEvent(
        bytes32 tradeId,
        address token,
        address to,
        uint256 value
    );

    event SwapOKEvent(
        bytes32 tradeId,
        address token,
        address to,
        uint256 value
    );

    function transfer(address to, uint256 value) internal {
        (bool success, ) = to.call{value: value}("");
        require(success, "ERROR");
    }

    function transferERC20(
        address token,
        address to,
        uint256 value
    ) internal {
        bool success = IERC20(token).transferFrom(msg.sender, to, value);
        require(success, "ERROR");
    }

    function swap(
        address payable maker,
        address token,
        uint256 value,
        bytes[] calldata data
    ) external payable nonReentrant {
        //  expect=> chainId,token,address,value
        if (token == address(0)) {
            transfer(maker, msg.value);
            emit SwapEvent(maker, address(0), msg.value, data);
        } else {
            transferERC20(token, maker, value);
            emit SwapEvent(maker, token, value, data);
        }
    }

    function swapFail(
        bytes32 tradeId,
        address token,
        address to,
        uint256 value
    ) external payable nonReentrant {
        if (token == address(0)) {
            transfer(to, msg.value);
            emit SwapFailEvent(tradeId, address(0), to, msg.value);
        } else {
            transferERC20(token, to, value);
            emit SwapFailEvent(tradeId, token, to, value);
        }
    }

    function swapOK(
        bytes32 tradeId,
        address token,
        address to,
        uint256 value
    ) external payable nonReentrant {
        if (token == address(0)) {
            transfer(to, msg.value);
            emit SwapOKEvent(tradeId, address(0), to, msg.value);
        } else {
            transferERC20(token, to, value);
            emit SwapOKEvent(tradeId, token, to, value);
        }
    }
}
