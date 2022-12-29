%lang starknet



from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import deploy
from starkware.cairo.common.uint256 import Uint256, uint256_add
from lib.cairo_contracts.src.openzeppelin.token.erc721.library import ERC721


@storage_var
func last_tokenID() -> (token_id: Uint256) {
}

// Initializer

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    _name:felt, _symbol:felt
) {
    ERC721.initializer(_name, _symbol);
    last_tokenID.write(Uint256(0,0));
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

@external
func safeMint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    _recipient:felt, _token_id:Uint256, tokenURI:felt,
) ->(token_id:Uint256){
    alloc_locals;
    let last_token : Uint256 = last_tokenID.read();
    let one_uint : Uint256 = Uint256(1,0);
    let (local new_tokenID, _) = uint256_add(a=last_token, b=one_uint);
    last_tokenID.write(new_tokenID);
    ERC721._mint(_recipient, _token_id);
    ERC721._set_token_uri(_token_id, tokenURI);
    return (token_id=new_tokenID);
}
