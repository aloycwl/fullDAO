// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Top5} from "../Governance/Top5.sol";
import {ECDSA} from "../Util/ECDSA.sol";
import {DynamicPrice} from "../Util/DynamicPrice.sol";

contract Attachment is ECDSA, DynamicPrice, Top5 {
    function _mint(address adr) private {
        assembly {
            let tid := add(sload(INF), 0x01) // count++
            sstore(INF, tid)

            mstore(0x00, adr) // balanceOf(msg.sender)++
            let tmp := keccak256(0x00, 0x20)
            sstore(tmp, add(sload(tmp), 0x01))

            mstore(0x00, tid) // ownerOf[tid] = msg.sender
            tmp := keccak256(0x00, 0x20)
            sstore(tmp, adr)

            log4(0x00, 0x00, ETF, 0x00, adr, tid) // emit Transfer()
        }
    }

    // for rewards
    function mint2(
        uint256 tkn,
        uint256 len,
        uint256 bid,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        assembly {
            // transfer(msg.sender, tkn);
            mstore(0x80, TTF)
            mstore(0x84, caller())
            mstore(0xa4, tkn)
            pop(call(gas(), sload(TTF), 0x00, 0x80, 0x44, 0x00, 0x00))
        }
        unchecked {
            for (uint256 i; i < len; ++i) _mint(msg.sender);
        }
        isVRS(tkn, len, bid, v, r, s);
        _setTop5(msg.sender);
    }

    // normal minting
    function mint(
        uint256 lis,
        uint256 len,
        uint256 bid,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external payable {
        bytes32 tmp;
        unchecked {
            for (uint256 i; i < len; ++i) _mint(msg.sender);
        }
        assembly {
            tmp := add(AFA, lis)
        }
        _pay(tmp, owner(), len);
        isVRS(lis, len, bid, v, r, s);
        _setTop5(msg.sender);
    }

    function mint(address adr, uint256 amt) external onlyOwner {
        unchecked {
            for (uint256 i; i < amt; ++i) _mint(adr);
        }
        _setTop5(adr);
    }

    function burn(uint256 tid) public notBan0 {
        assembly {
            mstore(0x00, tid) // ownerOf(tid)
            let ptr := keccak256(0x00, 0x20)
            let frm := sload(ptr)

            if iszero(eq(frm, caller())) {
                // require(ownerOf(tid) == msg.sender)
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER2)
                revert(0x80, 0x64)
            }

            sstore(ptr, 0x00) // ownerOf[id] = toa
            sstore(add(ptr, 0x03), 0x00) // approve[tid] = toa

            mstore(0x00, frm) // --balanceOf(msg.sender)
            let tmp := keccak256(0x00, 0x20)
            sstore(tmp, sub(sload(tmp), 0x01))

            log4(0x00, 0x00, ETF, frm, 0x00, tid) // emit Transfer()
        }
    }

    // burn multiple and mint
    function merge(
        uint256[] calldata ids,
        uint256 lis,
        uint256 bid,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external payable {
        unchecked {
            for (uint256 i; i < ids.length; ++i) burn(ids[i]);
        }
        _mint(msg.sender);
        isVRS(lis, 0, bid, v, r, s);
    }

    // change of metadata
    function upgrade(
        uint256 lis,
        uint256 tid,
        uint256 bid,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external payable {
        burn(tid);
        _mint(msg.sender);
        bytes32 tmp;
        assembly {
            tmp := add(AFA, lis)
        }
        _pay(tmp, owner(), 1);
        isVRS(lis, tid, bid, v, r, s);
    }
}
