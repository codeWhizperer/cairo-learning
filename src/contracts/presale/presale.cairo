%lang starknet


from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import deploy
from starkware.cairo.common.bool import TRUE
from starkware.starknet.common.syscalls import (get_caller_address, get_contract_address)
from  src.interface.IERC20 import IERC20
from starkware.cairo.common.uint256 import (Uint256, uint256_add, uint256_sub, uint256_unsigned_div_rem,uint256_signed_nn_le)

// token contract address

// constant
const ETH_CONTRACT = 0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7;
const REGFEE = 1000000000000000;
// 0x050f2003bf969b5aa6b6edbd4b047869e13b96b2611f046415049f48549f7c53

// state variable
@storage_var
func token_contract() -> (res: felt) {
}

@storage_var
func admin_address() -> (res: felt) {
}

@storage_var
func registered_address(address:felt) -> (status: felt) {
}

@storage_var
func claimed_address(address:felt) -> (status: felt) {
}


// constructor


@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    admin:felt, tokenAddress:felt
) {
    admin_address.write(admin);
    token_contract.write(tokenAddress);
    return();
}
// setter function
@external
func register{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    user:felt
) {

    alloc_locals;

    let (address_this) = get_contract_address();
    let (msgSender) = get_caller_address();
    let (token) = token_contract.read();
    let regprice = Uint256(REGFEE,0);
    // 1. check if user has not registered before;
    with_attr error_message("Presale: You have already registered!!"){
    let (registered_status) = registered_address.read(msgSender);
    assert registered_status = 0;
    }
    //check that the user has beforehand approved the address of the ICO contract to spend the registration amount from his ETH balance

    with_attr error_message("Presale: You need to approve 0.001ETH"){
    let (approved) = IERC20.allowance(ETH_CONTRACT, msgSender, address_this);
    let (less_than) = uint256_signed_nn_le(regprice, approved);
    assert less_than = 1;
    }

    IERC20.transferFrom(ETH_CONTRACT,msgSender,address_this, regprice);

    registered_address.write(msgSender,1);
    return ();
}

@external
func claim{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address:felt
) {
// check if address  to claim is registered
let (is_registered) = registered_address.read(address);

with_attr error_message("Presale: You are not eligible to participate, register first!"){
assert is_registered = 1;
}

// check if the caller has not claimed

with_attr error_message("Presale: You have already claimed"){

    let (claim_status) = claimed_address.read(address);
    assert claim_status = 0;
}

let claim_amount = Uint256(20,0);
let (address_this) = get_contract_address();
let (token) = token_contract.read();
let  (admin) = admin_address.read();

IERC20.transferFrom(token,admin, address, claim_amount);

claimed_address.write(address, 1);

return();
}

@view
func is_registered{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    address:felt
) -> (status:felt) {
    let (is_registered) = registered_address.read(address);
    return (status= is_registered);
}