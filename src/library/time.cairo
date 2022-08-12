# SPDX-License-Identifier: GNU General Public License v3.0 or later

# https://starknet.io/docs/hello_starknet/more_features.html

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

@storage_var
func Time_time(id : Uint256) -> (time : felt):
end

namespace Time:
    func set_time{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        id : Uint256, time : felt
    ):
        Time_time.write(id, time)
        return ()
    end

    func get_time{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        id : Uint256
    ) -> (time : felt):
        let (time) = Time_time.read(id)
        return (time)
    end
end
