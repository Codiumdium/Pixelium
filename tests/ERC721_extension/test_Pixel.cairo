%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.uint256 import Uint256, uint256_eq

from src.ERC721_extension.Pixel import Pixel
from src.ERC721_extension.Pixel import _pair, _unpair
from src.library.timer import Timer

@view
func test_mint{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}():
    alloc_locals

    %{ stop_prank_callable = start_prank(123) %}
    let zero = Uint256(0, 0)
    Timer.initialize(42)
    Pixel.mint(zero, zero)

    let x = Uint256(42, 0)
    let y = Uint256(314, 0)
    Pixel.mint(x, y)
    %{ expect_revert(error_message="ERC721: token already minted") %}
    Pixel.mint(x, y)
    return ()
end

@view
func test_get_location{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}():
    alloc_locals
    %{ stop_prank_callable = start_prank(123) %}

    let x = Uint256(42, 0)
    let y = Uint256(314, 0)
    let (tokenId) = _pair(x, y)
    Pixel.mint(x, y)
    let (location_x, location_y) = Pixel.get_location(tokenId)
    assert location_x = x
    assert location_y = y
    return ()
end

@view
func test_get_color{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}():
    alloc_locals
    %{ stop_prank_callable = start_prank(123) %}
    let x = Uint256(42, 0)
    let y = Uint256(314, 0)
    Pixel.mint(x, y)
    let (red, green, blue) = Pixel.get_color(x, y)
    assert red = 42
    assert green = 42
    assert blue = 42

    return ()
end

@view
func test_set_color{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}():
    alloc_locals
    %{ stop_prank_callable = start_prank(123) %}
    %{ stop_warp = warp(0) %}
    Timer.initialize(42)

    let x = Uint256(42, 0)
    let y = Uint256(314, 0)
    Pixel.mint(x, y)
    %{ expect_revert(error_message="Timer: the timer is not over!") %}
    Pixel.set_color(x, y, 12, 53, 89)

    %{ stop_warp = warp(40) %}
    %{ expect_revert(error_message="Timer: the timer is not over!") %}
    Pixel.set_color(x, y, 124, 14, 125)
    
    %{ stop_warp = warp(42) %}
    Pixel.set_color(x, y, 127, 153, 189)
    let (red, green, blue) = Pixel.get_color(x, y)
    assert red = 127
    assert green = 153
    assert blue = 189

    %{ stop_warp = warp(50) %}
    %{ expect_revert(error_message="Timer: the timer is not over!") %}
    Pixel.set_color(x, y, 145, 18, 9)

    %{ stop_warp = warp(85) %}
    Pixel.set_color(x, y, 17, 53, 89)
    let (red, green, blue) = Pixel.get_color(x, y)
    assert red = 17
    assert green = 53
    assert blue = 89

    return ()
end

@view
func test__pair{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}():
    let x = Uint256(0, 0)
    let y = Uint256(0, 0)
    let z = Uint256(1, 0)
    let (res_z) = _pair(x, y)
    let (is_equal) = uint256_eq(z, res_z)
    assert is_equal = TRUE

    let x = Uint256(1, 0)
    let y = Uint256(0, 0)
    let z = Uint256(2, 0)
    let (res_z) = _pair(x, y)
    let (is_equal) = uint256_eq(z, res_z)
    assert is_equal = TRUE

    let x = Uint256(0, 0)
    let y = Uint256(1, 0)
    let z = Uint256(3, 0)
    let (res_z) = _pair(x, y)
    let (is_equal) = uint256_eq(z, res_z)
    assert is_equal = TRUE

    let x = Uint256(1, 0)
    let y = Uint256(1, 0)
    let z = Uint256(5, 0)
    let (res_z) = _pair(x, y)
    let (is_equal) = uint256_eq(z, res_z)
    assert is_equal = TRUE

    let x = Uint256(5, 0)
    let y = Uint256(17, 0)
    let z = Uint256(271, 0)
    let (res_z) = _pair(x, y)
    let (is_equal) = uint256_eq(z, res_z)
    assert is_equal = TRUE

    let x = Uint256(52, 0)
    let y = Uint256(1, 0)
    let z = Uint256(1433, 0)
    let (res_z) = _pair(x, y)
    let (is_equal) = uint256_eq(z, res_z)
    assert is_equal = TRUE

    return ()
end

@view
func test__unpair{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}():
    alloc_locals

    let z = Uint256(1, 0)
    let x = Uint256(0, 0)
    let y = Uint256(0, 0)
    let (res_x, res_y) = _unpair(z)
    let (is_equal_x) = uint256_eq(x, res_x)
    let (is_equal_y) = uint256_eq(y, res_y)
    assert is_equal_x = TRUE
    assert is_equal_y = TRUE

    let z = Uint256(2, 0)
    let x = Uint256(1, 0)
    let y = Uint256(0, 0)
    let (res_x, res_y) = _unpair(z)
    let (is_equal_x) = uint256_eq(x, res_x)
    let (is_equal_y) = uint256_eq(y, res_y)
    assert is_equal_x = TRUE
    assert is_equal_y = TRUE

    let z = Uint256(3, 0)
    let x = Uint256(0, 0)
    let y = Uint256(1, 0)
    let (res_x, res_y) = _unpair(z)
    let (is_equal_x) = uint256_eq(x, res_x)
    let (is_equal_y) = uint256_eq(y, res_y)
    assert is_equal_x = TRUE
    assert is_equal_y = TRUE

    let z = Uint256(5, 0)
    let x = Uint256(1, 0)
    let y = Uint256(1, 0)
    let (res_x, res_y) = _unpair(z)
    let (is_equal_x) = uint256_eq(x, res_x)
    let (is_equal_y) = uint256_eq(y, res_y)
    assert is_equal_x = TRUE
    assert is_equal_y = TRUE

    let z = Uint256(271, 0)
    let x = Uint256(5, 0)
    let y = Uint256(17, 0)
    let (res_x, res_y) = _unpair(z)
    let (is_equal_x) = uint256_eq(x, res_x)
    let (is_equal_y) = uint256_eq(y, res_y)
    assert is_equal_x = TRUE
    assert is_equal_y = TRUE

    let z = Uint256(1433, 0)
    let x = Uint256(52, 0)
    let y = Uint256(1, 0)
    let (res_x, res_y) = _unpair(z)
    let (is_equal_x) = uint256_eq(x, res_x)
    let (is_equal_y) = uint256_eq(y, res_y)
    assert is_equal_x = TRUE
    assert is_equal_y = TRUE

    return ()
end
