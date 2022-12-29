%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from  src.interface.IERC721 Import IERC721




// CONSTANTS

const NAME = 1692660622325569080943028654924641
const SYMBOL = 5456198

@external
func __setup__() {
    %{
    declared = declare("src/NFT.cairo")
    prepared = prepare(declared,[ids.NAME, ids.SYMBOL])
    context.erc721_custom_address = deploy(prepared).contract_address
    %}
    return ();
}

@external
func test_erc721_custom_deploy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
) {
    tempvar erc721_custom_address:felt;

    %{
    ids.erc721_custom_address = context.erc721_custom_address
    %}

    let (name) = IERC721.name(contract_address=erc721_custom_address);
    let (symbol) = IERC721.symbol(contract_address= erc721_custom_address);

    assert NAME = name;
    assert SYMBOL = symbol;
}