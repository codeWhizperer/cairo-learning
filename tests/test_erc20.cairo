%lang starknet
 from starkware.cairo.common.uint256 import Uint256
 from starkware.cairo.common.cairo_builtins import HashBuiltin
 from src.interface.IERC20 import IERC20
from starkware.starknet.common.syscalls import (get_contract_address, get_caller_address)


const OWNER = 0x00348f5537be66815eb7de63295fcb5d8b8b2ffe09bb712af4966db7cbb04a91;
const TEST_ACC1 = 0x00348f5537be66815eb7de63295fcb5d8b8b2ffe09bb712af4966db7cbb04a95;

@external
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        alloc_locals;

    local contract_address:felt;

    %{ context.contract_address = deploy_contract("./src/contracts/erc20/ERC20.cairo", [1692660622324978785132669949272929,5459521, 18]).contract_address %}
    %{ ids.contract_address = context.contract_address %}
    return();
}





 @external
 func test_proxy_contract{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    tempvar contract_address;
    %{ ids.contract_address = context.contract_address %}
    let (name) = IERC20.name(contract_address=contract_address);
    let (symbol) = IERC20.symbol(contract_address=contract_address);
    let (decimals) = IERC20.decimals(contract_address=contract_address);

    assert name = 1692660622324978785132669949272929;
    assert symbol = 5459521;
    assert decimals = 18;
    return();
 }

 @external
 func test_proxy_mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        alloc_locals;
    tempvar contract_address;
    %{ ids.contract_address = context.contract_address %}
    // let (caller) = get_caller_address();
    let (prevBal) = IERC20.balanceOf(contract_address=contract_address, account=OWNER);
    assert prevBal.low = 0;
    assert prevBal.high = 0;

     IERC20.mint(contract_address=contract_address,recipient=OWNER, amount=Uint256(100, 0));
    let (newBal) = IERC20.balanceOf(contract_address,account=OWNER);
    assert newBal.low = 100;
    assert newBal.high = 0;

    return ();
 }