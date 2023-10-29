// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ArtiumNFT is ERC721, Ownable {
    IERC20 public artiumToken;
    uint256 private _nextTokenId;

    struct Artwork {
        string name;
        address artist;
    }

    mapping(uint256 => Artwork) public artInfo;

    constructor(address _artiumToken)
        ERC721("ArtiumNFT", "ANFT")
        Ownable(msg.sender) {
        artiumToken = IERC20(_artiumToken);
    }

    function safeMint(uint256 _tokenId) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(artInfo[_tokenId].artist, tokenId);
    }

    function setArtist(uint256 _tokenId) public {
        require(
            artInfo[_tokenId].artist == address(0),
            "Artist is already set"
        );
        artInfo[_tokenId].artist = msg.sender;
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override {
        require(artInfo[tokenId].artist != address(0));
        super.transferFrom(from, to, tokenId);
    }

    struct ArtProposal {
        address artist;
        uint256 upvotes;
        uint256 downvotes;
        bool isMinted;
        string name;
    }

    mapping(uint256 => ArtProposal) public artProposals;
    uint public proposalCounter;

    event ArtProposed(uint256 proposalId, address owner);
    event ArtVoted(uint256 proposalId, address voter, int256 vote);
    event ArtMinted(uint256 proposalId, uint256 tokenId);

    // Voting period = 10 mins
    // Upvote and Downvote threshold = 3
    // Proposal Fee to be locked = 100 Artium

    function proposeArt (string memory _name) public {
        require(artiumToken.transferFrom(msg.sender, address(this), 100), "Transfer failed");
        artProposals[proposalCounter] = ArtProposal({
            artist: msg.sender,
            upvotes: 0,
            downvotes: 0,
            isMinted: false,
            name: _name
        });

        emit ArtProposed(proposalCounter, msg.sender);
        proposalCounter++;
    }
}
