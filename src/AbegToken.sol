// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "solmate/utils/MerkleProofLib.sol";
import "solmate/tokens/ERC1155.sol";

contract Merkle is ERC1155 {
    bytes32 public root;
    mapping(address => mapping(uint256 => bool)) public hasClaimed;

    constructor(bytes32 _root) {
        root = _root;
    }

    function uri(uint256 id) public view virtual override returns (string memory) {
        return "";
    }

    function claim(
        address _claimer,
        uint256 _tokenId,
        uint256 _amount,
        bytes32[] calldata _proof
    ) external returns (bool success) {
        require(!hasClaimed[_claimer][_tokenId], "already claimed");

        bytes32 leaf = keccak256(abi.encodePacked(_claimer, _tokenId, _amount));
        bool verificationStatus = MerkleProofLib.verify(_proof, root, leaf);
        // require(verificationStatus, "not whitelisted");

        hasClaimed[_claimer][_tokenId] = true;
        _mint(_claimer, _tokenId, _amount, "");

        return true;
    }
}