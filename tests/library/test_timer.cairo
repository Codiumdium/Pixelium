%lang starknet

# https://docs.swmansion.com/protostar/docs/tutorials/testing/cheatcodes/warp

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from src.library.timer import Timer, Timer_time, Timer_timer

@view
func test_initialize{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}():
    alloc_locals
    let time = 42
    Timer.initialize(time)
    let (read_time) = Timer_time.read()
    assert read_time = time

    let time = 0
    Timer.initialize(time)
    let (read_time) = Timer_time.read()
    assert read_time = time
    return ()
end

@view
func test_reset{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}():
    alloc_locals

    let tokenId5 = Uint256(5, 0)
    let tokenId8 = Uint256(8, 0)
    let time = 42
    Timer.initialize(time)

    %{ stop_warp = warp(0) %}
    Timer.reset(tokenId5)
    let (read_timer5) = Timer_timer.read(tokenId5)
    assert read_timer5 = 42

    %{ stop_warp = warp(79652) %}
    Timer.reset(tokenId5)
    %{ stop_warp = warp(85252) %}
    Timer.reset(tokenId5)
    let (read_timer5) = Timer_timer.read(tokenId5)
    assert read_timer5 = 85252 + time

    let (read_timer8) = Timer_timer.read(tokenId8)
    assert read_timer8 = 0
    Timer.reset(tokenId8)
    let (read_timer8) = Timer_timer.read(tokenId8)
    assert read_timer8 = 85252 + time

    return ()
end

@view
func test_assert_timer_is_over{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}():
    alloc_locals
    let tokenId5 = Uint256(5, 0)
    let tokenId8 = Uint256(8, 0)
    let time = 42
    Timer.initialize(time)

    %{ stop_warp = warp(0) %}
    Timer.reset(tokenId5)
    %{ expect_revert(error_message="Timer: the timer is not over!") %}
    Timer.assert_timer_is_over(tokenId5)
   
    %{ stop_warp = warp(12) %}
    %{ expect_revert(error_message="Timer: the timer is not over!") %}
    Timer.assert_timer_is_over(tokenId5)

    %{ stop_warp = warp(41) %}
    %{ expect_revert(error_message="Timer: the timer is not over!") %}
    Timer.assert_timer_is_over(tokenId5)

    %{ stop_warp = warp(42) %}
    Timer.assert_timer_is_over(tokenId5)

    %{ stop_warp = warp(50) %}
    Timer.assert_timer_is_over(tokenId5)

    Timer.reset(tokenId8)
    %{ expect_revert(error_message="Timer: the timer is not over!") %}
    Timer.assert_timer_is_over(tokenId8)

    return ()
end

# @view
# func test_set_time{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}():
#     alloc_locals

# let id = Uint256(42, 0)
#     let time = 42
#     Time.set_time(id, time)
#     let (res_time) = Timer_time.read(id)
#     assert time = res_time

# return ()
# end

# @view
# func test_get_time{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}():
#     alloc_locals
#     let id = Uint256(42, 0)
#     let time = 42
#     Timer_time.write(id, time)
#     let (res_time) = Time.get_time(id)
#     assert time = res_time
#     return ()
# end
