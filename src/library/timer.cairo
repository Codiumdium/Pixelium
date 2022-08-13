# SPDX-License-tolkenIdentifier: GNU General Public License v3.0 or later

# https://starknet.io/docs/hello_starknet/more_features.html

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.bool import TRUE, FALSE

from starkware.starknet.common.syscalls import get_block_timestamp

@storage_var
func Timer_timer(tolkenId : Uint256) -> (time : felt):
end

@storage_var
func Timer_time() -> (time : felt):
end

namespace Timer:
    func initialize{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(time : felt):
        Timer_time.write(time)
        return ()
    end

    func reset{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        tokenId : Uint256
    ):
        let (block_timestamp) = get_block_timestamp()
        let (time) = Timer_time.read()
        let new_time = block_timestamp + time
        Timer_timer.write(tokenId, new_time)
        return ()
    end

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
