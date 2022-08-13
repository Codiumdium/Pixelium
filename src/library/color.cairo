# SPDX-License-Identifier: GNU General Public License v3.0 or later

# https://www.cairo-lang.org/docs/hello_cairo/intro.html#the-primitive-type-field-element-felt
# https://en.wikipedia.org/wiki/RGB

# Not usefull
# https://www.cairo-lang.org/docs/reference/common_library.html#bitwise
# const MASK_RED = 255  # 2**8-1 # 0b 00000000 00000000 11111111
# const MASK_GREEN = 65280  # 2**16-2**8 # 0b 00000000 11111111 00000000
# const MASK_BLUE = 16711680  # 2**24-2**16 0b 11111111 00000000 00000000

%lang starknet
from starkware.cairo.common.math import assert_not_zero
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.math import unsigned_div_rem
from starkware.starknet.common.syscalls import get_caller_address
from immutablex.starknet.token.erc721.library import ERC721

@storage_var
func Color_color(tokenId : Uint256) -> (color : felt):
end

namespace Color:
    func set_rgb{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        tokenId : Uint256, red : felt, green : felt, blue : felt
    ):
        alloc_locals

        let (caller) = get_caller_address()
        let (is_approved) = ERC721._is_approved_or_owner(caller, tokenId)
        with_attr error_message("ERC721_extension: You are not allowed to change this color!"):
            assert_not_zero(caller * is_approved)
        end
        let new_color = red + green * 2 ** 8 + blue * 2 ** 16
        Color_color.write(tokenId, new_color)
        return ()
    end

    func get_rgb{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        tokenId : Uint256
    ) -> (red : felt, green : felt, blue : felt):
        let (color) = Color_color.read(tokenId)
        let (color, red) = unsigned_div_rem(color, 2 ** 8)
        let (color, green) = unsigned_div_rem(color, 2 ** 8)
        let (_, blue) = unsigned_div_rem(color, 2 ** 8)
        return (red, green, blue)
    end
end
