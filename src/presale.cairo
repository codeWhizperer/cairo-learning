// %lang starknet


// from starkware.cairo.common.cairo_builtins import HashBuiltin
// from starkware.starknet.common.syscalls import deploy
// from starkware.cairo.common.bool import TRUE
// from starkware.starknet.common.syscalls import (get_caller_address, get_contract_address)
// from  src.interface.IERC20 import IERC20

// // token contract address

// // constant
// const REGFEE = 1000000000000000
// const tokenAddress = 0x00179ab4b2c1a9d03f027fab1b4e5b271abfa7e031f02659e3e2d1e99c8480d3

// // state variable
// @storage_var
// func token_contract() -> (res: felt) {
// }

// @storage_var
// func admin_address() -> (res: felt) {
// }

// @storage_var
// func registered_address(address:felt) -> (status: felt) {
// }

// @storage_var
// func claimed_address(address:felt) -> (status: felt) {
// }


// // constructor


// // @constructor
// func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
//     admin:felt, tokenAddress:felt
// ) {
//     admin_address.write(admin);
//     token_contract.write(tokenAddress);
//     return();
// }
// // setter function
// @external
// func register{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
//     user:felt
// ) {

//     // set of instructions first!!!


//     registered_address.write(user);
// }