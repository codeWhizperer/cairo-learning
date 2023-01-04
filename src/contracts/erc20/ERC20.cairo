%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import deploy
from lib.cairo_contracts.src.openzeppelin.token.erc20.library import ERC20
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.bool import TRUE
from starkware.starknet.common.syscalls import (get_caller_address)

// CONSTRUCTOR
@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    _name:felt, _symbol:felt, _decimal:felt, recipient:felt
) {
ERC20.initializer(_name, _symbol,_decimal);
return();
}

// GETTERS
@view
func name{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
) -> (name:felt) {
    let name = ERC20.name();
    return (name);
}

@view
func symbol{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
) -> (symbol:felt) {
    let symbol = ERC20.symbol();
    return (symbol);
}

@view
func decimals{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (decimals:felt) {
    let (decimals) = ERC20.decimals();
    return (decimals,);
}

@view
func totalSupply{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
) -> (totalSupply:Uint256) {
    let (total_supply) = ERC20.total_supply();
    return (total_supply,);
}

@view
func balanceOf{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
address:felt
) -> (balance:Uint256) {
    let (balance) = ERC20.balance_of(address);
    return (balance,);
}

@view
func allowance{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    owner:felt, spender:felt
) -> (remaining:Uint256) {
    let (remaining) = ERC20.allowance(owner,spender);
    return (remaining,);
}

// SETTER

@external
func transfer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    recipient:felt, amount:Uint256
) -> (success:felt) {
    ERC20.transfer(recipient,amount);
    return (TRUE,);
}

@external
func transferFrom{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    sender:felt,recipient:felt, amount:Uint256
) -> (success:felt) {
    ERC20.transfer_from(sender,recipient,amount);
    return (TRUE,);
}

@external
func mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    amount:Uint256
) {
    let (msgSender) = get_caller_address();
    ERC20._mint(msgSender,amount);
    return ();
}

@external
func approve{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    spender:felt, amount:Uint256
) -> (success:felt) {
    ERC20.approve(spender,amount);
    return (TRUE,);
}