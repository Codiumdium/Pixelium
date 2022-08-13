%lang starknet

from immutablex.starknet.token.erc721.library import ERC721_owners
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from src.library.color import Color, Color_color

@view
func test_set_rgb{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}():
    alloc_locals

    let account = 53
    %{ stop_prank_callable = start_prank(53) %}

    let tokenId = Uint256(42, 0)
    ERC721_owners.write(tokenId, account)
    let red = 0
    let green = 0
    let blue = 0
    let new_color = red + green * 2 ** 8 + blue * 2 ** 16
    Color.set_rgb(tokenId, red, green, blue)
    let (color) = Color_color.read(tokenId)
    assert color = new_color

    let tokenId = Uint256(1, 0)
    ERC721_owners.write(tokenId, account)
    let red = 255
    let green = 255
    let blue = 255
    let new_color = red + green * 2 ** 8 + blue * 2 ** 16
    Color.set_rgb(tokenId, red, green, blue)
    let (color) = Color_color.read(tokenId)
    assert color = new_color

    # %{ stop_prank_callable = start_prank(758) %}
    let tokenId = Uint256(42, 0)
    ERC721_owners.write(tokenId, 7853)
    let red = 42
    let green = 128
    let blue = 31
    let new_color = red + green * 2 ** 8 + blue * 2 ** 16
    %{ expect_revert(error_message="ERC721_extension: You are not allowed to change this color!")%}
    Color.set_rgb(tokenId, red, green, blue)

    return ()
end

@view
func test_get_rgb{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}():
    alloc_locals

    let tokenId = Uint256(42, 0)
    let red = 0
    let green = 0
    let blue = 0
    let new_color = red + green * 2 ** 8 + blue * 2 ** 16
    Color_color.write(tokenId, new_color)
    let color = Color.get_rgb(tokenId)
    assert color.red = red
    assert color.green = green
    assert color.blue = blue

    let tokenId = Uint256(314, 0)
    let red = 255
    let green = 255
    let blue = 255
    let new_color = red + green * 2 ** 8 + blue * 2 ** 16
    Color_color.write(tokenId, new_color)
    let color = Color.get_rgb(tokenId)
    assert color.red = red
    assert color.green = green
    assert color.blue = blue

    let tokenId = Uint256(956, 0)
    let red = 42
    let green = 128
    let blue = 31
    let new_color = red + green * 2 ** 8 + blue * 2 ** 16
    Color_color.write(tokenId, new_color)
    let color = Color.get_rgb(tokenId)
    assert color.red = red
    assert color.green = green
    assert color.blue = blue

    return ()
end
