# SPDX-License-Identifier: GNU General Public License v3.0 or later

# Pairing functions
# These types of functions encode two numbers into a single number
# or decode a single number into two numbers
# @see https://en.wikipedia.org/wiki/Pairing_function

from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_add,
    uint256_sub,
    uint256_mul,
    uint256_unsigned_div_rem,
    uint256_sqrt,
)

# Cantor pairing function
# @see https://en.wikipedia.org/wiki/Pairing_function
# @see https://math.stackexchange.com/questions/222709/inverting-the-cantor-pairing-function
namespace Cantor:
    # Encode two numbers into a single number
    # @params x 128 bits unsigned number
    # @params y 128 bits unsigned number
    # @return z 256 bits unsigned number
    func pair{range_check_ptr}(x : Uint256, y : Uint256) -> (z : Uint256):
        let one = Uint256(1, 0)
        let two = Uint256(2, 0)
        let (a, _) = uint256_add(x, y)  # x + y
        let (b, _) = uint256_add(a, one)  # x + y + 1
        let (c, _) = uint256_mul(a, b)  # (x + y) * (x + y + 1)
        let (d, _) = uint256_unsigned_div_rem(c, two)  # ((x + y) * (x + y + 1)) / 2
        let (z, _) = uint256_add(d, y)  # (((x + y) * (x + y + 1)) / 2) + y
        return (z=z)
    end

    # Decode a single number into two numbers
    # @params z 256 bits unsigned number
    # @return x and y two 128 bits unsigned numbers
    func unpair{range_check_ptr}(z : Uint256) -> (x : Uint256, y : Uint256):
        alloc_locals

        let one = Uint256(1, 0)
        let two = Uint256(2, 0)
        let eight = Uint256(8, 0)

        # w
        let (a, _) = uint256_mul(eight, z)  # 8 * z
        let (b, _) = uint256_add(a, one)  # 8 * z +1
        let (sqrt) = uint256_sqrt(b)  # sqrt(8 * z + 1)
        let (c) = uint256_sub(sqrt, one)  # sqrt(8 * z + 1) - 1
        let (w, _) = uint256_unsigned_div_rem(c, two)  # w = floor((sqrt(8 * z + 1) - 1) / 2)
        # In this particular case uint256_unsigned_div_rem simulates the floor function

        # t
        let (d, _) = uint256_mul(w, w)  # w * w
        let (e, _) = uint256_add(d, w)  # w * w + w
        let (t, _) = uint256_unsigned_div_rem(e, two)  # t = (w * w + w) / 2

        # y and x
        let (y) = uint256_sub(z, t)  # y = z - t
        let (x) = uint256_sub(w, y)  # x = w - y
        return (x=x, y=y)
    end
end

# Square spiral pairing function
# https://www.desmos.com/calculator/augmltextm?lang=fr
# TODO
