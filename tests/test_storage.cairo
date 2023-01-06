%lang starknet
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_builtins import HashBuiltin

@contract_interface
namespace StorageContract {
  func increase_balance(amount:Uint256){
  }
  func get_balance() -> (res:Uint256){
  }
  func get_id() -> (res:felt){
  }  
}


@external
func test_proxy_contract{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
alloc_locals;

local contract_address:felt;

// deploy contract and put its address into a local variable.second arguement is the constructor calldata
%{ ids.contract_address = deploy_contract("./src/contracts/storage/storage.cairo", [100, 0, 1]).contract_address%}

let (res) = StorageContract.get_balance(contract_address=contract_address);
assert res.low = 100;
assert res.high =0;

let (id) = StorageContract.get_id(contract_address=contract_address);

assert id = 1;


StorageContract.increase_balance(contract_address=contract_address,amount=Uint256(50,0));

let (res) = StorageContract.get_balance(contract_address=contract_address);

assert res.low = 150;
assert res.high = 0;
return ();


}