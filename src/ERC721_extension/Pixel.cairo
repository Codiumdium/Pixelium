# SPDX-License-Identifier: GNU General Public License v3.0 or later

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_add, uint256_sub
from starkware.starknet.common.syscalls import get_caller_address

from immutablex.starknet.token.erc721.library import ERC721

from src.library.pairing_function import Cantor
from src.library.color import Color
from src.library.timer import Timer

func _pair{range_check_ptr}(x : Uint256, y : Uint256) -> (z : Uint256):
    let one = Uint256(1, 0)
    let (cantor_z) = Cantor.pair(x, y)
    let (z, _) = uint256_add(cantor_z, one)
    return (z=z)
end

func _unpair{range_check_ptr}(z : Uint256) -> (x : Uint256, y : Uint256):
    let one = Uint256(1, 0)
    let (cantor_z) = uint256_sub(z, one)
    let (cantor_x, cantor_y) = Cantor.unpair(cantor_z)
    return (x=cantor_x, y=cantor_y)
end

namespace Pixel:
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

    func set_color{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        x : Uint256, y : Uint256, red : felt, blue : felt, green : felt
    ):
        alloc_locals
        let (tokenId) = _pair(x, y)
        Timer.assert_timer_is_over(tokenId)
        Color.set_rgb(tokenId, red, blue, green)
        Timer.reset(tokenId)
        return ()
    end

    func get_color{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        x : Uint256, y : Uint256
    ) -> (red : felt, green : felt, blue : felt):
        let (tokenId) = _pair(x, y)
        let (red, green, blue) = Color.get_rgb(tokenId)
        return (red=red, green=green, blue=blue)
    end

    func get_location{range_check_ptr}(tokenId : Uint256) -> (x : Uint256, y : Uint256):
        let (x, y) = _unpair(tokenId)
        return (x, y)
    end

    func get_token_id{range_check_ptr}(x : Uint256, y : Uint256) -> (tokenID : Uint256):
        let (z) = _pair(x, y)
        return (x, y)
    end
end
