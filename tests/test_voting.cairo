%lang starknet

from src.interface.Ivote import Ivote
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Constants:

const ADMIN = 1010;
const NUMBER_VOTER = 3;
const VOTER_1 = 111;
const VOTER_2 = 222;
const VOTER_3 = 333;

const VOTER_4 = 444;


// DEPLOY AT THE BEGINNING OF THE TEST SUITES

@external
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
%{
declared = declare("src/contracts/voting/voting.cairo")
prepared = prepare(declared, [ids.ADMIN, ids.NUMBER_VOTER, ids.VOTER_1,ids.VOTER_2, ids.VOTER_3])
context.context_vote_address = deploy(prepared).contract_address
%}
return ();
}


@external
func test_deployment{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    tempvar vote_contract:felt;

    %{
    ids.vote_contract = context.context_vote_address
    %}

    let (admin_res) = Ivote.admin(contract_address= vote_contract);
    let (voter_1) = Ivote.is_voter_registered(contract_address=vote_contract, voter=VOTER_1);
    let (voter_2) = Ivote.is_voter_registered(contract_address=vote_contract, voter=VOTER_2);
    let (voter_3) = Ivote.is_voter_registered(contract_address=vote_contract, voter=VOTER_3);

    assert ADMIN = admin_res;
    assert 1 = voter_1;
    assert 1 = voter_2;
    assert 1 = voter_3;

    return();

}

@external
func test_is_paused{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    tempvar vote_contract : felt;
    %{
    ids.vote_contract = context.context_vote_address
    %}
    let (is_paused) = Ivote.isPaused(contract_address=vote_contract);

    assert 0 = is_paused;

    %{stop_prank_admin = start_prank(ids.ADMIN, ids.vote_contract) %}
    Ivote.pause(contract_address=vote_contract);
    %{stop_prank_admin()%}
    let (is_paused) = Ivote.isPaused(contract_address=vote_contract);

     assert 1 = is_paused;

    return();
}

@external
func test_voters_info{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
   
   tempvar vote_contract : felt;

   %{
   ids.vote_contract = context.context_vote_address
   %}

   let (voter_1_status) = Ivote.get_voters_info(contract_address= vote_contract, _address=VOTER_1);
   let (voter_2_status) = Ivote.get_voters_info(contract_address= vote_contract, _address=VOTER_2);
   let (voter_3_status) = Ivote.get_voters_info(contract_address= vote_contract, _address=VOTER_3);
   let (voter_4_status) = Ivote.get_voters_info(contract_address= vote_contract, _address=VOTER_4);
    let voter_1_allowed = voter_1_status.allowed;
    let voter_2_allowed = voter_2_status.allowed;
    let voter_3_allowed = voter_3_status.allowed;
    let voter_4_allowed = voter_4_status.allowed;
    assert 1 = voter_1_allowed;
    assert 1 = voter_2_allowed;
    assert 1 = voter_3_allowed;
    assert 0 = voter_4_allowed;
    return();
}

@external
func vote{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
      tempvar vote_contract : felt;

   %{
   ids.vote_contract = context.context_vote_address
   %}

    %{ stop_prank_voter_1= start_prank(ids.VOTER_1, ids.vote_contract)%}
    Ivote.vote(contract_address=vote_contract, vote=0);
    %{stop_prank_voter_1()%}

    let (vote_status)= Ivote.get_voting_status(contract_address=vote_contract);
    let votes_yes = vote_status.votes_yes;
    assert 0 = votes_yes;
    let votes_no = vote_status.votes_no;
    assert 1 = vote_status.votes_yes;

    let (voter_1_status) = Ivote.get_voters_info(contract_address=vote_contract, _address= VOTER_1);
    let voter_1_allowed = voter_1_status.allowed;
    assert 0 = voter_1_allowed;

    %{ expect_revert(error_message="not allowed to vote") %}
    %{ stop_prank_voter = start_prank(ids.VOTER_1, ids.vote_address) %}
    Ivote.vote(contract_address=vote_contract, vote=0);
    %{ stop_prank_voter() %}
    return();
}