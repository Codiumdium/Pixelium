# SPDX-License-Identifier: GNU General Public License v3.0 or later

# Pixel
# This code is the logic behind a pixel for the Pixelium grid
# Each pixel is an NFT identified by a tokenId
# Each pixel has :
# - a location on the grid (encoded and decoded from the tokendId)
# - a color (RGB 24 bits)
# - a timer (you can change the state of a pixel if only the timer is over.)

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_add, uint256_sub
from starkware.starknet.common.syscalls import get_caller_address

from immutablex.starknet.token.erc721.library import ERC721

from src.library.pairing_function import Cantor
from src.library.color import Color
from src.library.timer import Timer

# Encode two numbers into a single number.
# We can not use the value 0 because a tokenId can not be 0
# @params x 128 bits unsigned number
# @params y 128 bits unsigned number
# @return z 256 bits unsigned number
func _pair{range_check_ptr}(x : Uint256, y : Uint256) -> (z : Uint256):
    let one = Uint256(1, 0)
    let (cantor_z) = Cantor.pair(x, y)
    let (z, _) = uint256_add(cantor_z, one)
    return (z=z)
end

# Decode a single number into two numbers
# We can not use the value 0 because a tokenId can not be 0
# @params z 256 bits unsigned number
# @return x and y two 128 bits unsigned numbers
func _unpair{range_check_ptr}(z : Uint256) -> (x : Uint256, y : Uint256):
    let one = Uint256(1, 0)
    let (cantor_z) = uint256_sub(z, one)
    let (cantor_x, cantor_y) = Cantor.unpair(cantor_z)
    return (x=cantor_x, y=cantor_y)
end

namespace Pixel:
    # Create a new NFT pixel from coordinates
    # And initialize its timer
    # @params x 128 bits unsigned number
    # @params y 128 bits unsigned number
    func mint{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        x : Uint256, y : Uint256
    ):
        let (tokenId) = _pair(x, y)
        let (account) = get_caller_address()
        ERC721._mint(account, tokenId)
        # ERC721._mint uses _exist(tokenId) so this ensures tokenId is unique
        Timer.reset(tokenId)
        Color.set_rgb(tokenId, 42, 42, 42)
        return ()
    end

    # Change the color of a single pixel
    # A color can only be changed by the owner of a pixel.
    # And if the timer of this pixel is over
    # @params x 128 bits unsigned number
    # @params y 128 bits unsigned number
    # @param red the red channel of the color
    # @param green the green channel of the color
    # @param blue the blue channel of the color
    func set_color{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        x : Uint256, y : Uint256, red : felt, green : felt, blue : felt
    ):
        alloc_locals
        let (tokenId) = _pair(x, y)
        Timer.assert_timer_is_over(tokenId)
        Color.set_rgb(tokenId, red, green, blue)
        Timer.reset(tokenId)
        return ()
    end

    # Get the color of a single pixel
    # @params x 128 bits unsigned number
    # @params y 128 bits unsigned number
    # @return the red, green and blue channels of the color
    func get_color{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        x : Uint256, y : Uint256
    ) -> (red : felt, green : felt, blue : felt):
        let (tokenId) = _pair(x, y)
        let (red, green, blue) = Color.get_rgb(tokenId)
        return (red=red, green=green, blue=blue)
    end

    # Get the location on the grid of a pixel identified by its tokendId
    # @param tokenId an unique identifier (256 bits unsigned numbers)
    # @return x and y two 128 bits unsigned numbers
    func get_location{range_check_ptr}(tokenId : Uint256) -> (x : Uint256, y : Uint256):
        let (x, y) = _unpair(tokenId)
        return (x, y)
    end

    # Get the tokenId of a pixel from its location
    # @params x 128 bits unsigned number
    # @params y 128 bits unsigned number
    # @return x and y two 128 bits unsigned numbers
    func get_token_id{range_check_ptr}(x : Uint256, y : Uint256) -> (tokenId : Uint256):
        let (z) = _pair(x, y)
        return (tokenId=z)
    end
end
