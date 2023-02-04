%lang starknet


struct VoteCounting{
votes_yes: felt,
votes_no:  felt,
}

struct VoterInfo{
allowed:felt,
}

@contract_interface
namespace Ivote {
    func admin() -> (owner:felt){
    }

    func isPaused() -> (paused:felt){
    }

    func get_voting_status() ->(res:VoteCounting){
    }
    func get_voters_info(_address) -> (res:VoterInfo){
    }

    func is_voter_registered(voter: felt) -> (is_registered: felt){
    }

    func vote(vote: felt) -> (){
    } 

    func pause () -> () {
    } 

    func unpause() -> () {
    }







}