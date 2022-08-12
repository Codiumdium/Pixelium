%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.bool import TRUE, FALSE

from starkware.cairo.common.uint256 import Uint256, uint256_eq
from src.library.pairing_function import Cantor

@view
func test_cantor_pair{
    syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*
}():
    let x = Uint256(0, 0)
    let y = Uint256(0, 0)
    let z = Uint256(0, 0)
    let (res_z) = Cantor.pair(x, y)
    let (is_equal) = uint256_eq(z, res_z)
    assert is_equal = TRUE

    let x = Uint256(1, 0)
    let y = Uint256(0, 0)
    let z = Uint256(1, 0)
    let (res_z) = Cantor.pair(x, y)
    let (is_equal) = uint256_eq(z, res_z)
    assert is_equal = TRUE

    let x = Uint256(0, 0)
    let y = Uint256(1, 0)
    let z = Uint256(2, 0)
    let (res_z) = Cantor.pair(x, y)
    let (is_equal) = uint256_eq(z, res_z)
    assert is_equal = TRUE

    let x = Uint256(1, 0)
    let y = Uint256(1, 0)
    let z = Uint256(4, 0)
    let (res_z) = Cantor.pair(x, y)
    let (is_equal) = uint256_eq(z, res_z)
    assert is_equal = TRUE

    let x = Uint256(5, 0)
    let y = Uint256(17, 0)
    let z = Uint256(270, 0)
    let (res_z) = Cantor.pair(x, y)
    let (is_equal) = uint256_eq(z, res_z)
    assert is_equal = TRUE

    let x = Uint256(52, 0)
    let y = Uint256(1, 0)
    let z = Uint256(1432, 0)
    let (res_z) = Cantor.pair(x, y)
    let (is_equal) = uint256_eq(z, res_z)
    assert is_equal = TRUE

    return ()
end

@view
func test_cantor_unpair{
    syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*
}():
    alloc_locals

    let z = Uint256(0, 0)
    let x = Uint256(0, 0)
    let y = Uint256(0, 0)
    let (res_x, res_y) = Cantor.unpair(z)
    let (is_equal_x) = uint256_eq(x, res_x)
    let (is_equal_y) = uint256_eq(y, res_y)
    assert is_equal_x = TRUE
    assert is_equal_y = TRUE

    let z = Uint256(1, 0)
    let x = Uint256(1, 0)
    let y = Uint256(0, 0)
    let (res_x, res_y) = Cantor.unpair(z)
    let (is_equal_x) = uint256_eq(x, res_x)
    let (is_equal_y) = uint256_eq(y, res_y)
    assert is_equal_x = TRUE
    assert is_equal_y = TRUE

    let z = Uint256(2, 0)
    let x = Uint256(0, 0)
    let y = Uint256(1, 0)
    let (res_x, res_y) = Cantor.unpair(z)
    let (is_equal_x) = uint256_eq(x, res_x)
    let (is_equal_y) = uint256_eq(y, res_y)
    assert is_equal_x = TRUE
    assert is_equal_y = TRUE

    let z = Uint256(4, 0)
    let x = Uint256(1, 0)
    let y = Uint256(1, 0)
    let (res_x, res_y) = Cantor.unpair(z)
    let (is_equal_x) = uint256_eq(x, res_x)
    let (is_equal_y) = uint256_eq(y, res_y)
    assert is_equal_x = TRUE
    assert is_equal_y = TRUE

    let z = Uint256(270, 0)
    let x = Uint256(5, 0)
    let y = Uint256(17, 0)
    let (res_x, res_y) = Cantor.unpair(z)
    let (is_equal_x) = uint256_eq(x, res_x)
    let (is_equal_y) = uint256_eq(y, res_y)
    assert is_equal_x = TRUE
    assert is_equal_y = TRUE

    let z = Uint256(1432, 0)
    let x = Uint256(52, 0)
    let y = Uint256(1, 0)
    let (res_x, res_y) = Cantor.unpair(z)
    let (is_equal_x) = uint256_eq(x, res_x)
    let (is_equal_y) = uint256_eq(y, res_y)
    assert is_equal_x = TRUE
    assert is_equal_y = TRUE
    

    return ()
end
