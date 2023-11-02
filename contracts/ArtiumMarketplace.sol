// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ArtNFT is ERC721, Ownable {
    uint256 private _nextTokenId;

    constructor() ERC721("ArtNFT", "ANFT") Ownable(msg.sender) {}

    function safeMint(address to) external onlyOwner returns (uint256) {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        return tokenId;
    }
}

contract Marketplace {
    IERC20 public artiumToken;
    ArtNFT public artNFT;
    IERC721 public nftToken;

    constructor(address _artiumToken) {
        artiumToken = IERC20(_artiumToken);
        artNFT = new ArtNFT();
        nftToken = IERC721(artNFT);
    }

    struct Artwork {
        string name;
        address artist;
    }

    mapping(uint256 => Artwork) public artInfo;

    function mintArt(Artwork memory artwork) public {
        uint256 tokenId = artNFT.safeMint(msg.sender);

        artInfo[tokenId] = artwork;
    }

    function setArtist(uint256 _tokenId) public {
        require(
            artInfo[_tokenId].artist == address(0),
            "Artist is already set"
        );
        artInfo[_tokenId].artist = msg.sender;
    }

    struct ArtProposal {
        address artist;
        uint256 upvotes;
        uint256 downvotes;
        uint256 closingTime;
        bool isMinted;
        bool threshold;
        string name;
    }

    mapping(uint256 => ArtProposal) public artProposals;
    uint256 public proposalCounter;

    event ArtProposed(uint256 proposalId, address owner);
    event ArtVoted(uint256 proposalId, address voter, int256 vote);
    event ArtMinted(uint256 proposalId, uint256 tokenId);

    // Voting period = 10 mins
    // Upvote and Downvote threshold = 3
    // Proposal Fee to be locked = 100 Artium

    function proposeArt(string memory _name) public {
        require(
            artiumToken.transferFrom(msg.sender, address(this), 100),
            "Transfer failed"
        );
        artProposals[proposalCounter] = ArtProposal({
            artist: msg.sender,
            upvotes: 0,
            downvotes: 0,
            closingTime: block.timestamp + 600,
            isMinted: false,
            threshold: false,
            name: _name
        });

        emit ArtProposed(proposalCounter, msg.sender);
        proposalCounter++;
    }

    function upVote(uint256 proposalId) external {
        require(
            artProposals[proposalId].closingTime < block.timestamp,
            "Voting closed!"
        );
        artProposals[proposalId].upvotes++;
    }

    function downVote(uint256 proposalId) external {
        require(
            artProposals[proposalId].closingTime < block.timestamp,
            "Voting closed!"
        );
        artProposals[proposalId].downvotes++;
    }

    // status : 1->enough upvote, 2->neutral, 3->enough downvote

    function generateResult(uint256 proposalId) external returns (uint) {
        ArtProposal storage _artProposal = artProposals[proposalId];

        require(
            _artProposal.closingTime > block.timestamp,
            "Voting not closed!"
        );

        if (_artProposal.downvotes >= 3) {
            _artProposal.threshold = true;
            return 3;
        }
        else if (_artProposal.upvotes >= 3) {
            require(_artProposal.isMinted == false, "Art is already minted!");

            require(
                artiumToken.transfer(_artProposal.artist, 100),
                "Transfer failed"
            );

            Artwork memory _artwork = Artwork({
                name: _artProposal.name,
                artist: _artProposal.artist
            });

            mintArt(_artwork);
            _artProposal.isMinted = true;

            return 1;
        }

        else {
            require(_artProposal.isMinted == false, "Art already minted");
            require(artiumToken.transfer(_artProposal.artist, 100), "Transfer failes");

            _artProposal.isMinted = true;

            return 2;
        }
    }
}