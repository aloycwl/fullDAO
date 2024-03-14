// SPDX-License-Identifier: None
pragma solidity 0.8.0;

contract Hashes {
    bytes32 internal constant ETF = 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef; // event Transfer
    bytes32 internal constant EAP = 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925; // event Approve
    bytes32 internal constant EAA = 0x17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31; // event ApproveForAll
    bytes32 internal constant EVO = 0x33952ef907843fd2ddd118a92dd935debf65b72965a557a364ea08deffca032f; // event Vote

    bytes32 internal constant STR = 0x0000002000000000000000000000000000000000000000000000000000000000; // string(0x20)
    bytes32 internal constant ERR = 0x08c379a000000000000000000000000000000000000000000000000000000000; // Error code
    bytes32 internal constant ER1 = 0x000000096e6f2061636365737300000000000000000000000000000000000000; // "no access"
    bytes32 internal constant ER2 = 0x0000000b6e6f20617070726f76616c0000000000000000000000000000000000; // "no approval"
    bytes32 internal constant ER3 = 0x0000000973757370656e64656400000000000000000000000000000000000000; // "suspended"    || Node length
    bytes32 internal constant ER4 = 0x0000000773696720657272000000000000000000000000000000000000000000; // "sig err"      || tokenURI
    bytes32 internal constant ER5 = 0x00000007616d7420657272000000000000000000000000000000000000000000; // "amt err"      || Total Nodes

    bytes32 internal constant TFM = 0x23b872dd00000000000000000000000000000000000000000000000000000000; // transferFrom   || Fee
    bytes32 internal constant OWO = 0x6352211e00000000000000000000000000000000000000000000000000000000; // ownerOf        || Owner
    bytes32 internal constant AFA = 0xe985e9c500000000000000000000000000000000000000000000000000000000; // approvedForAll || List
    bytes32 internal constant APP = 0x095ea7b300000000000000000000000000000000000000000000000000000000; // approved       || Signer
    bytes32 internal constant INF = 0x80ac58cd00000000000000000000000000000000000000000000000000000000; // interface1     || Count
    bytes32 internal constant IN2 = 0x5b5e139f00000000000000000000000000000000000000000000000000000000; // interface2     || Proxy
    bytes32 internal constant TTF = 0xa9059cbb00000000000000000000000000000000000000000000000000000000; // transfer       || MAC
    bytes32 internal constant TP5 = 0x2fea05d400000000000000000000000000000000000000000000000000000000; // isTop5         || Top5
    bytes32 internal constant VOT = 0xc9d27afe00000000000000000000000000000000000000000000000000000000; // vote
}