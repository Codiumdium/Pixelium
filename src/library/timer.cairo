# SPDX-License-tolkenIdentifier: GNU General Public License v3.0 or later

# This code associates a unique identifier to a timer.
# @see https://starknet.io/docs/hello_starknet/more_features.html

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.bool import TRUE, FALSE

from starkware.starknet.common.syscalls import get_block_timestamp

# Associates a unique identifier to a timer.
# @param tokenId an unique identifier
# @return time the time of the end of the timer
@storage_var
func Timer_timer(tolkenId : Uint256) -> (time : felt):
end

# The timer duration
# @return time the timer duration
@storage_var
func Timer_time() -> (time : felt):
end

namespace Timer:
    # Set the timer duration
    # @param time the timer duration
    func initialize{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(time : felt):
        Timer_time.write(time)
        return ()
    end

    # Reset the timer associated with a tokenId by updating the end time of the timer.
    # @param tokenId an unique identifier
    func reset{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        tokenId : Uint256
    ):
        let (block_timestamp) = get_block_timestamp()
        let (time) = Timer_time.read()
        let new_time = block_timestamp + time
        Timer_timer.write(tokenId, new_time)
        return ()
    end

    # Check if the timer is over
    # @param tokenId an unique identifier
    func assert_timer_is_over{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        tokenId : Uint256
    ):
        alloc_locals
        let (block_timestamp) = get_block_timestamp()
        let (timer) = Timer_timer.read(tokenId)
        let (is_timer_over) = is_le(timer, block_timestamp)
        with_attr error_message("Timer: the timer is not over!"):
            assert is_timer_over = TRUE
        end
        return ()
    end

    # func set_time{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    #     tolkenId : Uint256, time : felt
    # ):
    #     stamp.write(tolkenId, time)
    #     return ()
    # end

    # func get_time{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    #     tolkenId : Uint256
    # ) -> (time : felt):
    #     let (time) = stamp.read(tolkenId)
    #     return (time)
    # end
end
