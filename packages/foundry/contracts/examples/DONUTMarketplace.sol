// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/**
 * @title DONUTMarketplace
 * @notice Example: Simple NFT marketplace accepting DONUT
 * @dev Demonstrates DONUT token integration for payments
 */
contract DONUTMarketplace {
    IERC20 public immutable donut;
    
    struct Listing {
        address nftContract;
        uint256 tokenId;
        address seller;
        uint256 price; // In DONUT
        bool active;
    }
    
    mapping(bytes32 => Listing) public listings;
    uint256 public listingCount;
    
    event Listed(
        bytes32 indexed listingId,
        address indexed seller,
        address nftContract,
        uint256 tokenId,
        uint256 price
    );
    
    event Sold(
        bytes32 indexed listingId,
        address indexed buyer,
        address indexed seller,
        uint256 price
    );
    
    event Cancelled(bytes32 indexed listingId);
    
    error NotOwner();
    error NotActive();
    error InsufficientPayment();
    error TransferFailed();
    
    constructor(address _donut) {
        donut = IERC20(_donut);
    }
    
    /**
     * @notice List an NFT for sale
     * @param nftContract Address of the NFT contract
     * @param tokenId Token ID to list
     * @param price Price in DONUT tokens
     */
    function list(
        address nftContract,
        uint256 tokenId,
        uint256 price
    ) external returns (bytes32) {
        IERC721 nft = IERC721(nftContract);
        
        // Verify ownership
        if (nft.ownerOf(tokenId) != msg.sender) revert NotOwner();
        
        // Transfer NFT to marketplace
        nft.transferFrom(msg.sender, address(this), tokenId);
        
        // Create listing
        bytes32 listingId = keccak256(
            abi.encodePacked(nftContract, tokenId, msg.sender, listingCount++)
        );
        
        listings[listingId] = Listing({
            nftContract: nftContract,
            tokenId: tokenId,
            seller: msg.sender,
            price: price,
            active: true
        });
        
        emit Listed(listingId, msg.sender, nftContract, tokenId, price);
        return listingId;
    }
    
    /**
     * @notice Buy a listed NFT with DONUT
     * @param listingId ID of the listing to purchase
     */
    function buy(bytes32 listingId) external {
        Listing storage listing = listings[listingId];
        
        if (!listing.active) revert NotActive();
        
        // Mark as inactive
        listing.active = false;
        
        // Transfer DONUT from buyer to seller
        bool success = donut.transferFrom(
            msg.sender,
            listing.seller,
            listing.price
        );
        if (!success) revert TransferFailed();
        
        // Transfer NFT to buyer
        IERC721(listing.nftContract).transferFrom(
            address(this),
            msg.sender,
            listing.tokenId
        );
        
        emit Sold(listingId, msg.sender, listing.seller, listing.price);
    }
    
    /**
     * @notice Cancel a listing
     * @param listingId ID of the listing to cancel
     */
    function cancel(bytes32 listingId) external {
        Listing storage listing = listings[listingId];
        
        if (listing.seller != msg.sender) revert NotOwner();
        if (!listing.active) revert NotActive();
        
        listing.active = false;
        
        // Return NFT to seller
        IERC721(listing.nftContract).transferFrom(
            address(this),
            listing.seller,
            listing.tokenId
        );
        
        emit Cancelled(listingId);
    }
}
