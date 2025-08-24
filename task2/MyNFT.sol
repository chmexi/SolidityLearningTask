// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyNFT is ERC721 {
    // 记录下一个将被铸造的 tokenId
    uint256 private _nextTokenId = 1;
    mapping(uint256 => string) _tokenURIs;
    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {

    }

    function mintNFT(address recipient, string calldata tokenURI_) public {
        _mint(recipient, _nextTokenId);
        _tokenURIs[_nextTokenId] = tokenURI_;
        _nextTokenId++;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "URI query for nonexistent token");
        return _tokenURIs[tokenId]; 
    }

    function _exists(uint256 tokenId) private view returns(bool) {
        return bytes(_tokenURIs[tokenId]).length > 0;
    }
}