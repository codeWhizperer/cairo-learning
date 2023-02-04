%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import assert_not_zero
from starkware.starknet.common.syscalls import deploy
from lib.cairo_contracts.src.openzeppelin.access.ownable.library import Ownable
from lib.cairo_contracts.src.openzeppelin.security.pausable.library import Pausable

// struct that stores the status of the vote i.e votes_yes || votes_no

struct VoteCounting{
votes_yes:felt,
votes_no:felt,
}


// struct that stores if voter is allowed to vote
struct VoterInfo{
allowed:felt,
}


// State variables

@storage_var
func voting_status() -> (res: VoteCounting) {
}

@storage_var
func voters_info(address:felt) -> (res: VoterInfo) {
}

@storage_var
func registered_voter(address:felt) -> (is_registered:felt) {
}

// constructor
// @dev Initialize contract
// @implicit syscall_ptr,
// @implicit pedersen_ptr,
// @implicit range_check_ptr
// @param admin_address : admin can pause and resume the voting
// @params registered_addresses_len: number of registered voters
// @params registered_addresses : array with the addresses of registered voters


@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    admin_address:felt, registered_addresses_len: felt, registered_addresses: felt*
) {
    alloc_locals;
    Ownable.initializer(admin_address);
    _register_voters(registered_addresses_len, registered_addresses);
    return();
}
// @constructor
// func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
//     admin_address: felt, registered_addresses_len: felt, registered_addresses: felt*
// ) {
//     alloc_locals;
//     Ownable.initializer(admin_address);
//     _register_voters(registered_addresses_len, registered_addresses);
//     return ();
// }


// GETTERS


@view
func admin{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
) -> (owner:felt) {
    return Ownable.owner();
}

@view
func isPaused{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
) -> (paused:felt) {
    return Pausable.is_paused();
}

@view
func get_voting_status{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
) -> (res:VoteCounting) {
    let status = voting_status.read();
    return status;

}


@view
func get_voters_info{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    _address:felt
) -> (res: VoterInfo) {
    let voters = voters_info.read(_address);
    return voters;
}

@view
func is_voter_registered{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    voter:felt
) -> (is_registered:felt) {
    let (registered) = registered_voter.read(voter);
    return (is_registered= registered);
}

func _assert_allowed{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
info:VoterInfo
) {
with_attr error_message("VoterInfo: Your address is not allowed to vote."){
assert_not_zero(info.allowed);
}

return();


    
}

// state-changing function:

func _register_voters{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
registered_addresses_len:felt, registered_address:felt*
) {
    if (registered_addresses_len ==0){
    return();
    } 
     let votante_info = VoterInfo(allowed=1);
     registered_voter.write(registered_address[registered_addresses_len - 1], 1);
     voters_info.write(registered_address[registered_addresses_len -1],votante_info);
     return _register_voters(registered_addresses_len - 1, registered_address);
}

// @dev Given a vote, it checks if the caller can vote and updates the status of the vote, and the status of the voter
@external
func vote{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(vote:felt) {
    // 1.check if the voting is paused
    alloc_locals;
    Pausable.assert_not_paused();
    // 2.check if caller has voted before
    let (caller) = get_caller_address();
    let (info) = voters_info.read(caller);
    _assert_allowed(info);
    // Mark that the voter has already voted and update in the storage
    let updates_info = VoterInfo(allowed=0);
    voters_info.write(caller, updates_info);

    let (status) = voting_status.read();

    local updated_voting_status:VoteCounting;

    if(vote == 0){
    assert updated_voting_status.votes_no = status.votes_no + 1;
    assert updated_voting_status.votes_yes = status.votes_yes;
    }

    if(vote == 1){
    assert updated_voting_status.votes_yes = status.votes_yes + 1;
    assert updated_voting_status.votes_no = status.votes_no;
    }

    voting_status.write(updated_voting_status);
    return();

}

// @dev Pause voting. only admin can resume voting
// @implicit syscall_ptr(felt*)
// @implicit pedersen_ptr (HashBuiltins)
// @implicit range_check_ptr
@external
func pause{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // assert that only owner can pause
    Ownable.assert_only_owner();
    Pausable._pause();
    return();
}



// @dev Resume voting. only admin can resume voting
// @implicit syscall_ptr(felt*)
// @implicit pedersen_ptr (HashBuiltins)
// @implicit range_check_ptr
@external
func unpause{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    Ownable.assert_only_owner();
    Pausable._unpause();
    return();
}