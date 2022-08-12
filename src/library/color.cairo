# SPDX-License-Identifier: GNU General Public License v3.0 or later

# https://www.cairo-lang.org/docs/hello_cairo/intro.html#the-primitive-type-field-element-felt
# https://en.wikipedia.org/wiki/RGB

# Not usefull
# https://www.cairo-lang.org/docs/reference/common_library.html#bitwise
# const MASK_RED = 255  # 2**8-1 # 0b 00000000 00000000 11111111
# const MASK_GREEN = 65280  # 2**16-2**8 # 0b 00000000 11111111 00000000
# const MASK_BLUE = 16711680  # 2**24-2**16 0b 11111111 00000000 00000000

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import unsigned_div_rem

@storage_var
func Color_color() -> (color : felt):
end

namespace Color:
    func set_rgb{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        red : felt, green : felt, blue : felt
    ):
        let new_color = red + green * 2 ** 8 + blue * 2 ** 16
        Color_color.write(new_color)
        return ()
    end

    func get_rgb{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        red : felt, green : felt, blue : felt
    ):
        let (color) = Color_color.read()
        let (color, red) = unsigned_div_rem(color, 2 ** 8)
        let (color, green) = unsigned_div_rem(color, 2 ** 8)
        let (_, blue) = unsigned_div_rem(color, 2 ** 8)
        return (red, green, blue)
    end
end
