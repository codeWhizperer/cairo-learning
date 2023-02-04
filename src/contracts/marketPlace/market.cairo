%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import (get_caller_address, get_contract_address)
from starkware.cairo.common.uint256 import (Uint256, uint256_signed_nn_le)
from starkware.cairo.common.math_cmp import is_not_zero
from src.interface.IERC20 import IERC20
from src.interface.IERC721 import IERC721



//  what is an NFT marketPlace?
// A platform for sale of nfts, where there are two categories of people:
// Seller:
// List Item for sale: contract address, tokenId, price, sellerAddress
// Buyer: buy item listed


// Listing struct

struct Listing{
id:felt,
contractAddress:felt,
tokenId:Uint256,
seller:felt,
price: felt,
status:felt,
}


// constants
// To receive ether  payment
const ETH_CONTRACT = 0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7;

@storage_var
func all_listing(id:felt) -> (token: Listing) {
}
@storage_var
func listing_id() -> (id: felt) {
}

@storage_var
func listing_status() -> (status: felt) {
}

@storage_var
func token_listings() -> (token: Listing) {
}


// @view
// func get_all_listing{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (token:Listing) {
//     let listings = token_listings.read();
//     return (listings);
// }
@view
func get_a_listing{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    id:felt
) -> (token:Listing) {
    let item = all_listing.read(id);
    return item;
}



@external
func listItem{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    contract_address:felt,
    token_id:Uint256,
    price:felt,
) {
    let (caller) = get_caller_address();
    let (address_this) = get_caller_address();
    let (prevId) = listing_id.read();
    let (prevStatus) = listing_status.read();

    let index = prevId + 1;
    let listing = Listing(index,contract_address,token_id,caller,price,prevStatus);
    listing_id.write(index);
    all_listing.write(index, listing);
    IERC721.transferFrom(contract_address, caller, address_this, token_id);
    return();
}



// an account fills the order by passing in the 1 of token to purchase.
// to purchase order: approve the market place to spend the nft 
// also have to approve the eth contract to spender the buyer erc20
// if the conditions are met, then you can transfer nft marketPlace to buyer.

@external
func buyToken{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    id:felt,
) {

    alloc_locals;
    let (buyer) = get_caller_address();
    let (address_this) = get_contract_address();
    let (listing) = get_a_listing(id);
    let listing_price_in_uint = Uint256(listing.price,0);
    let token_id = listing.tokenId;
    let seller = listing.seller; 

    with_attr error_message("NFT: Listing does not exist"){
    let is_exist = is_not_zero(seller);
    assert is_exist = 1;
    }

    // check listing is not sold yet
    with_attr error_message("NFT:Listing has already been sold!"){
    let (is_sold) = listing_status.read();
    assert 0 = is_sold;
    }

    // check that the user has beforehand approved the address of the NFTMarket contract to spend the listing price from his ETH balance

    with_attr error_message("NFT: approve the listing price to be spent"){
    let (approved) = IERC20.allowance(ETH_CONTRACT,buyer, address_this);
    let (less_than) =  uint256_signed_nn_le(listing_price_in_uint, approved);
    assert less_than = 1;
    }

    IERC20.transferFrom(ETH_CONTRACT, buyer, address_this, listing_price_in_uint);

    listing_status.write(1);

    // transfer ether to seller

    IERC20.transfer(ETH_CONTRACT, seller, listing_price_in_uint);
    let token_contract_address = listing.contractAddress;

    IERC721.transferFrom(token_contract_address, address_this, buyer, token_id);

    return();
}