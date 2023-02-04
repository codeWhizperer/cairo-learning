%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import deploy
from starkware.starknet.common.syscalls import (get_caller_address)




@storage_var
func store_name(address:felt) -> (name: felt) {
}

@event
func stored_name(address:felt, name:felt) {
}

@external
func store_ens_name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    _name:felt
) {
    let (caller) = get_caller_address();
    store_name.write(caller, _name);
    stored_name.emit(caller, _name);
    return ();
}


@view
func get_ens_name{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    address:felt
) -> (user:felt) {
 let (name) = store_name.read(address);
    return(name,);
}