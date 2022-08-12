%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from src.library.color import Color, Color_color

@view
func test_set_color{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}():
    alloc_locals

    let id = Uint256(42, 0)
    let red = 0
    let green = 0
    let blue = 0
    let new_color = red + green * 2 ** 8 + blue * 2 ** 16
    Color.set_rgb(id, red, green, blue)
    let (color) = Color_color.read(id)
    assert color = new_color

    let id = Uint256(1, 0)
    let red = 255
    let green = 255
    let blue = 255
    let new_color = red + green * 2 ** 8 + blue * 2 ** 16
    Color.set_rgb(id, red, green, blue)
    let (color) = Color_color.read(id)
    assert color = new_color

    let id = Uint256(854, 0)
    let red = 42
    let green = 128
    let blue = 31
    let new_color = red + green * 2 ** 8 + blue * 2 ** 16
    Color.set_rgb(id, red, green, blue)
    let (color) = Color_color.read(id)
    assert color = new_color

    return ()
end

@view
func test_get_color{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}():
    alloc_locals

    let id = Uint256(42, 0)
    let red = 0
    let green = 0
    let blue = 0
    let new_color = red + green * 2 ** 8 + blue * 2 ** 16
    Color_color.write(id, new_color)
    let color = Color.get_rgb(id)
    assert color.red = red
    assert color.green = green
    assert color.blue = blue

    let id = Uint256(314, 0)
    let red = 255
    let green = 255
    let blue = 255
    let new_color = red + green * 2 ** 8 + blue * 2 ** 16
    Color_color.write(id, new_color)
    let color = Color.get_rgb(id)
    assert color.red = red
    assert color.green = green
    assert color.blue = blue

    let id = Uint256(956, 0)
    let red = 42
    let green = 128
    let blue = 31
    let new_color = red + green * 2 ** 8 + blue * 2 ** 16
    Color_color.write(id, new_color)
    let color = Color.get_rgb(id)
    assert color.red = red
    assert color.green = green
    assert color.blue = blue

    return ()
end
