// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {ERC20} from "../GameAsset/ERC20.sol";
import {ERC721} from "../GameAsset/ERC721.sol";
import {Node} from "../Governance/Node.sol";
import {Upgrade} from "../Deploy/Upgrade.sol";
import {Hashes} from "../Util/Hashes.sol";
import {CrossChain} from "../CrossChain/CrossChain.sol";
import "../Vote/VoteTypes.sol";
import {Market} from "../Market/Market.sol";

contract Deployer is Hashes {
    constructor() {
        address adr;
        address ad2;
        address ad3;
        adr = ad2 = ad3 = msg.sender;
        (
            Upgrade e20,
            Upgrade e72,
            Upgrade nod,
            Upgrade crc,
            Upgrade mkt,
            GameAdd vo1,
            GameRemove vo2,
            WithdrawBulk vo3
        ) = (
                new Upgrade(address(new ERC20())),
                new Upgrade(address(new ERC721())),
                new Upgrade(address(new Node())),
                new Upgrade(address(new CrossChain())),
                new Upgrade(address(new Market())),
                new GameAdd(),
                new GameRemove(),
                new WithdrawBulk()
            );

        assembly {
            sstore(0x01, nod)
            sstore(0x02, e72)
            sstore(0x03, e20)
            sstore(0x04, crc)
            sstore(0x05, mkt)

            // e20(address(e20)).mint();
            mstore(
                0x80,
                0x40c10f1900000000000000000000000000000000000000000000000000000000
            )
            mstore(0x84, nod)
            mstore(0xa4, 0x5955e3bb3e743fec00000)
            pop(call(gas(), e20, 0x00, 0x80, 0x44, 0x00, 0x00)) // mint(nod, 6.75m)
            mstore(0x84, adr)
            mstore(0xa4, 0x108b2a2c2802909400000)
            pop(call(gas(), e20, 0x00, 0x80, 0x44, 0x00, 0x00)) // mint(adr, 1.25m)
            mstore(0x84, e72)
            mstore(0xa4, 0x1a784379d99db42000000)
            pop(call(gas(), e20, 0x00, 0x80, 0x44, 0x00, 0x00)) // mint(e72, 2m)

            // Upgrade(e72).mem(APP, adr);
            mstore(
                0x80,
                0xb88bab2900000000000000000000000000000000000000000000000000000000
            )

            // Upgrade(e72).mem(APP, ad2);
            mstore(0x84, APP)
            mstore(0xa4, ad2)
            pop(call(gas(), e72, 0x00, 0x80, 0x44, 0x00, 0x00)) // e72.signer = ad2
            pop(call(gas(), nod, 0x00, 0x80, 0x44, 0x00, 0x00)) // nod.signer = ad2

            // Upgrade(e72).mem(ER4, str);
            mstore(0x84, ER4)
            mstore(0xa4, 0x59)
            pop(call(gas(), e72, 0x00, 0x80, 0x44, 0x00, 0x00)) // e72.uri1 = len
            mstore(0x84, add(ER4, 0x01))
            mstore(
                0xa4,
                0x68747470733a2f2f776879696e6469616e2e64646e732e6e65742f69706e732f
            )
            pop(call(gas(), e72, 0x00, 0x80, 0x44, 0x00, 0x00)) // e72.uri2 = str2
            mstore(0x84, add(ER4, 0x02))
            mstore(
                0xa4,
                // 0x6b326b3472386f6b6a6b7a667637366a6f397938636565656877343071376a6c // testnet
                // 0x6b326b3472386e6c776e646c6d687577756b676863326f7a6373786c72776c73 // BSC
                0x6b326b3472386a7064656e6869356932686b6461346c76393130303265316a64 // Sepolia
            )
            pop(call(gas(), e72, 0x00, 0x80, 0x44, 0x00, 0x00)) // e72.uri3 = str3
            mstore(0x84, add(ER4, 0x03))
            mstore(
                0xa4,
                // 0x78696a66303268613973796e6e65363171326d7269626f702f00000000000000 // testnet
                // 0x646a307077747965356935306f7972306b346b36776472382f00000000000000 // BSC
                0x6e3668697277327871377364626d6878353264746e62716a2f00000000000000 // Sepolia
            )
            pop(call(gas(), e72, 0x00, 0x80, 0x44, 0x00, 0x00)) // e72.uri4 = str4

            // Upgrade(nod).mem(adr << 5, true);
            mstore(0x84, shl(0x05, ad3))
            mstore(0xa4, 0x01)
            pop(call(gas(), nod, 0x00, 0x80, 0x44, 0x00, 0x00)) // game[ad3] = true

            // Upgrade(nod).mem(TTF, gg2);
            mstore(0x84, TTF)
            mstore(0xa4, e20)
            pop(call(gas(), nod, 0x00, 0x80, 0x44, 0x00, 0x00)) // nod.e20 = e20
            pop(call(gas(), crc, 0x00, 0x80, 0x44, 0x00, 0x00)) // crc.e20 = e20
            pop(call(gas(), e72, 0x00, 0x80, 0x44, 0x00, 0x00)) // e72.e20 = e20
            pop(call(gas(), mkt, 0x00, 0x80, 0x44, 0x00, 0x00)) // mkt.e20 = e20

            // Upgrade(nod).mem(TP5, e72);
            mstore(0x84, TP5)
            mstore(0xa4, e72)
            pop(call(gas(), nod, 0x00, 0x80, 0x44, 0x00, 0x00)) // nod.e72 = e72
            pop(call(gas(), crc, 0x00, 0x80, 0x44, 0x00, 0x00)) // crc.e72 = e72
            mstore(0xa4, nod)
            pop(call(gas(), mkt, 0x00, 0x80, 0x44, 0x00, 0x00)) // mkt.e72 = nod

            // Upgrade(mkt).mem(TFM, 0.5%);
            mstore(0x84, TFM)
            mstore(0xa4, 0x32)
            pop(call(gas(), mkt, 0x00, 0x80, 0x44, 0x00, 0x00)) // mkt.fee = 50 (0.5%)

            // Upgrade(e72).mem(ER5, 0x0c);
            mstore(0x84, ER5)
            mstore(0xa4, 0x4563918244f40000)
            pop(call(gas(), crc, 0x00, 0x80, 0x44, 0x00, 0x00)) // crc.tkn = 5e18
            mstore(0xa4, 0x010)
            pop(call(gas(), e72, 0x00, 0x80, 0x44, 0x00, 0x00)) // e72.totalNodes = 10
            mstore(0xa4, 0x3635c9adc5dea00000)
            pop(call(gas(), mkt, 0x00, 0x80, 0x44, 0x00, 0x00)) // mkt.nonVoteVol = 1000e18

            // Upgrade(e72).mem(ER3, 0x01)
            mstore(0x84, ER3)
            mstore(0xa4, 0x01)
            pop(call(gas(), e72, 0x00, 0x80, 0x44, 0x00, 0x00)) // e72.nodeAdjust = 1

            // Upgrade(nod).mem(vo_, ad_);
            mstore(0x84, 0x01)
            mstore(0xa4, vo1)
            pop(call(gas(), nod, 0x00, 0x80, 0x44, 0x00, 0x00)) // nod.voteTypes[1] = vo1
            mstore(0x84, 0x02)
            mstore(0xa4, vo2)
            pop(call(gas(), nod, 0x00, 0x80, 0x44, 0x00, 0x00)) // nod.voteTypes[2] = vo2
            mstore(0x84, 0x03)
            mstore(0xa4, vo3)
            pop(call(gas(), nod, 0x00, 0x80, 0x44, 0x00, 0x00)) // nod.voteTypes[3] = vo3

            // Upgrade(e20).mem(OWO, adr);
            mstore(0x84, OWO)
            mstore(0xa4, adr)
            pop(call(gas(), nod, 0x00, 0x80, 0x44, 0x00, 0x00)) // nod.owner = adr
            mstore(0xa4, nod)
            pop(call(gas(), e20, 0x00, 0x80, 0x44, 0x00, 0x00)) // e20.owner = nod
            pop(call(gas(), e72, 0x00, 0x80, 0x44, 0x00, 0x00)) // e72.owner = nod
            pop(call(gas(), crc, 0x00, 0x80, 0x44, 0x00, 0x00)) // crc.owner = nod
            pop(call(gas(), mkt, 0x00, 0x80, 0x44, 0x00, 0x00)) // mkt.owner = nod
        }
    }

    function contractAddresses()
        external
        view
        returns (
            address nod,
            address e72,
            address e20,
            address crc,
            address mkt
        )
    {
        assembly {
            nod := sload(0x01)
            e72 := sload(0x02)
            e20 := sload(0x03)
            crc := sload(0x04)
            mkt := sload(0x04)
        }
    }
}
