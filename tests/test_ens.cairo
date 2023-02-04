%lang starknet

 from starkware.cairo.common.cairo_builtins import HashBuiltin
from src.contracts.ens.ens import store_ens_name, get_ens_name
const CALLER = 0x00348f5537be66815eb7de63295fcb5d8b8b2ffe09bb712af4966db7cbb04a91;
const NAME = 322918500091226412576622;
const NAMEerr= 25700;

@external
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
) {
    %{context.contract_address = deploy_contract("./src/contracts/ens/ens.cairo") %}
    return ();
}

@external
func test_name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
) {
%{stop_prank = start_prank(ids.CALLER)%}

store_ens_name(NAME);

%{expect_events({"name" : "stored_name", "data" : [ids.CALLER, ids.NAME]})%}

%{stop_prank%}
return();
}

@view
func test_view_name{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> () {

%{stop_prank = start_prank(ids.CALLER)%}

store_ens_name(NAME);

let (name) = get_ens_name(CALLER);
assert NAME = name;
%{stop_prank%}

return();

 }