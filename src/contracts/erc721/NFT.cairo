%lang starknet



from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import deploy
from starkware.cairo.common.uint256 import Uint256, uint256_add
from lib.cairo_contracts.src.openzeppelin.token.erc721.library import ERC721


@storage_var
func token_counter() -> (token_id: felt) {
}

// deployed address: 0x07183c4dda4389b7beeb0671407e2fcfd64ccc60c14c44e9069e1f75ce52a7e5
// Initializer

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    _name:felt, _symbol:felt
) {
    ERC721.initializer(_name, _symbol);
    return();
}

// GETTERS

@view
func name{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (name:felt) {
    let name = ERC721.name();
    return (name);
}

@view
func symbol{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
) -> (symbol:felt) {
   let symbol = ERC721.symbol();
   return (symbol); 
}

@view
func balanceOf{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
_recipient:felt
) -> (balance:Uint256) {
    let balance = ERC721.balance_of(_recipient);
    return (balance);
}

@view
func tokenURI{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    _token_id:Uint256
) -> (token_uri:felt) {
    let token_uri = ERC721.token_uri(_token_id);
    return (token_uri);
}

@view
func getApproved{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    token_id:Uint256
) -> (approved:felt) {
 let approved =   ERC721.get_approved(token_id);
 return (approved);
}

@view
func isApprovedForAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr} (owner: felt, operator: felt) -> (isApproved: felt) {
    let (isApproved) = ERC721.is_approved_for_all(owner, operator);
    return (isApproved,);
}

// EXTERNAL:

@external
func approve{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    spender:felt, token_id:Uint256
) {
    ERC721.approve(spender,token_id);
    return();
}

@external
func setApprovalForAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
operator:felt, approved: felt
) {
    ERC721.set_approval_for_all(operator,approved);
    return();
}

@view
func ownerOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr} (tokenId: Uint256) -> (owner: felt) {
    let (owner) = ERC721.owner_of(tokenId);
    return (owner,);
}


// External function calls

@external
func transferFrom{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    _from:felt, to:felt, token_id:Uint256
) {
    ERC721.transfer_from(_from, to, token_id);
    return();
}

@external
func mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    to:felt
) {
    let (prev_token_id) = token_counter.read();

    let new_token_id = prev_token_id + 1;

    ERC721._mint(to, Uint256(new_token_id,0));
    token_counter.write(new_token_id);
    return ();
}

