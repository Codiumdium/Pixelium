%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from src.library.time import Time, Time_time

@view
func test_set_time{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}():
    alloc_locals

    let id = Uint256(42, 0)
    let time = 42
    Time.set_time(id, time)
    let (res_time) = Time_time.read(id)
    assert time = res_time

    return ()
end

@view
func test_get_time{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}():
    alloc_locals
    let id = Uint256(42, 0)
    let time = 42
    Time_time.write(id, time)
    let (res_time) = Time.get_time(id)
    assert time = res_time
    return ()
end
