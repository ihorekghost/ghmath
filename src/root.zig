const std = @import("std");
const assert = std.debug.assert;

//Floating point vectors
pub const Vec2f16 = Vec2(f16);
pub const Vec3f16 = Vec3(f16);
pub const Vec4f16 = Vec4(f16);

pub const Vec2f32 = Vec2(f32);
pub const Vec3f32 = Vec3(f32);
pub const Vec4f32 = Vec4(f32);

pub const Vec2f64 = Vec2(f64);
pub const Vec3f64 = Vec3(f64);
pub const Vec4f64 = Vec4(f64);

pub const Vec2f128 = Vec2(f128);
pub const Vec3f128 = Vec3(f128);
pub const Vec4f128 = Vec4(f128);

//Signed integer vectors
pub const Vec2i8 = Vec2(i8);
pub const Vec3i8 = Vec3(i8);
pub const Vec4i8 = Vec4(i8);

pub const Vec2i16 = Vec2(i16);
pub const Vec3i16 = Vec3(i16);
pub const Vec4i16 = Vec4(i16);

pub const Vec2i32 = Vec2(i32);
pub const Vec3i32 = Vec3(i32);
pub const Vec4i32 = Vec4(i32);

pub const Vec2i64 = Vec2(i64);
pub const Vec3i64 = Vec3(i64);
pub const Vec4i64 = Vec4(i64);

pub const Vec2i128 = Vec2(i128);
pub const Vec3i128 = Vec3(i128);
pub const Vec4i128 = Vec4(i128);

//Unsigned integer vectors
pub const Vec2u8 = Vec2(u8);
pub const Vec3u8 = Vec3(u8);
pub const Vec4u8 = Vec4(u8);

pub const Vec2u16 = Vec2(u16);
pub const Vec3u16 = Vec3(u16);
pub const Vec4u16 = Vec4(u16);

pub const Vec2u32 = Vec2(u32);
pub const Vec3u32 = Vec3(u32);
pub const Vec4u32 = Vec4(u32);

pub const Vec2u64 = Vec2(u64);
pub const Vec3u64 = Vec3(u64);
pub const Vec4u64 = Vec4(u64);

pub const Vec2u128 = Vec2(u128);
pub const Vec3u128 = Vec3(u128);
pub const Vec4u128 = Vec4(u128);

//Usize vectors
pub const Vec2usize = Vec2(usize);
pub const Vec3usize = Vec3(usize);
pub const Vec4usize = Vec4(usize);

//Isize vectors
pub const Vec2isize = Vec2(isize);
pub const Vec3isize = Vec3(isize);
pub const Vec4isize = Vec4(isize);

//c_char vectors
pub const Vec2char = Vec2(c_char);
pub const Vec3char = Vec3(c_char);
pub const Vec4char = Vec4(c_char);

//c_short vectors
pub const Vec2short = Vec2(c_short);
pub const Vec3short = Vec3(c_short);
pub const Vec4short = Vec4(c_short);

//c_ushort vectors
pub const Vec2ushort = Vec2(c_ushort);
pub const Vec3ushort = Vec3(c_ushort);
pub const Vec4ushort = Vec4(c_ushort);

//c_int vectors
pub const Vec2int = Vec2(c_int);
pub const Vec3int = Vec3(c_int);
pub const Vec4int = Vec4(c_int);

//c_uint vectors
pub const Vec2uint = Vec2(c_uint);
pub const Vec3uint = Vec3(c_uint);
pub const Vec4uint = Vec4(c_uint);

//c_long vectors
pub const Vec2long = Vec2(c_long);
pub const Vec3long = Vec3(c_long);
pub const Vec4long = Vec4(c_long);

//c_ulong vectors
pub const Vec2ulong = Vec2(c_ulong);
pub const Vec3ulong = Vec3(c_ulong);
pub const Vec4ulong = Vec4(c_ulong);

//c_longlong vectors
pub const Vec2longlong = Vec2(c_longlong);
pub const Vec3longlong = Vec3(c_longlong);
pub const Vec4longlong = Vec4(c_longlong);

//c_ulonglong vectors
pub const Vec2ulonglong = Vec2(c_ulonglong);
pub const Vec3ulonglong = Vec3(c_ulonglong);
pub const Vec4ulonglong = Vec4(c_ulonglong);

///`len` element vector type with elements of type `Element`.
pub fn Vec(len: comptime_int, comptime Element: type) type {
    return @Vector(len, Element);
}

///**Two-dimensional** vector type with elements of type `Element`.
pub fn Vec2(comptime Element: type) type {
    return Vec(2, Element);
}

///**Three-dimensional** vector type with elements of type `Element`.
pub fn Vec3(comptime Element: type) type {
    return Vec(3, Element);
}

///**Four-dimensional** vector type with elements of type `Element`.
pub fn Vec4(comptime Element: type) type {
    return Vec(4, Element);
}

/// Converts a floating point vector type into an integer vector type keeping the same amount of bits for each element.
pub fn FloatToIntVector(comptime Vector: type) type {
    var vector_info = @typeInfo(Vector);
    assert(vector_info == .vector);

    var child_info = @typeInfo(vector_info.vector.child);
    assert(child_info == .float);

    const bits = child_info.float.bits;

    child_info = .{ .int = .{ .signedness = .signed, .bits = bits } };

    vector_info.vector.child = @Type(child_info);

    return @Type(vector_info);
}

/// Rounds down `vector` and returns the result as an integer vector with the same amount of bits for each element as in the original.
pub fn intFloor(vector: anytype) FloatToIntVector(@TypeOf(vector)) {
    return @intFromFloat(@floor(vector));
}

/// Rounds up `vector` and returns the result as an integer vector with the same amount of bits for each element as in the original.
pub fn intCeil(vector: anytype) FloatToIntVector(@TypeOf(vector)) {
    return @intFromFloat(@ceil(vector));
}

/// Normalize `vector`. **`vector` elements must be of floating point type**.
pub fn normalize(vector: anytype) @TypeOf(vector) {
    comptime {
        const vector_info = @typeInfo(@TypeOf(vector));

        if (@typeInfo(vector_info.vector.child) != .float) @compileError("Expected floating point element vector type, found `" ++ vector_info.vector.child ++ "` instead.");
    }

    assert(length(vector) != 0); // vector's length cannot be 0

    return vector / @as(@TypeOf(vector), @splat(length(vector)));
}

/// Normalize `vector`. **`vector` elements must be of floating point type**.
pub fn normalizeOrZero(vector: anytype) @TypeOf(vector) {
    const vector_length = length(vector);

    if (vector_length == 0) return @splat(0);

    return vector / @as(@TypeOf(vector), @splat(vector_length));
}

/// Calculate length of `vector`. **`vector` elements must be of floating point type**.
pub fn length(vector: anytype) @typeInfo(@TypeOf(vector)).vector.child {
    comptime {
        const element_info = @typeInfo(@typeInfo(@TypeOf(vector)).vector.child);

        if (element_info != .float) @compileError("`vector` elements are of type `" ++ @typeInfo(@TypeOf(vector)).vector.child ++ "`, expected floating point type instead.");
    }

    return @sqrt(lengthSquared(vector));
}

/// Calculate squared length of `vector`. Same as `length(vector) * length(vector)`, but **should perform faster due to lack of `@sqrt(...)`**.
pub fn lengthSquared(vector: anytype) @typeInfo(@TypeOf(vector)).vector.child {
    return @reduce(.Add, vector * vector);
}

/// Calculate dot product of `vector1` and `vector2`.
pub fn dot(vector1: anytype, vector2: anytype) @typeInfo(@TypeOf(vector1, vector2)).vector.child {
    return @reduce(.Add, vector1 * vector2);
}

/// Returns `true` if every element of `vector1` equals to corresponding element of `vector2`. Otherwise, returns `false`.
pub fn eql(vector1: anytype, vector2: anytype) bool {
    return truthy(vector1 == vector2);
}

/// Check if a position is inside a rectangle.
pub fn insideRect(pos: anytype, rect_pos: anytype, rect_size: anytype) bool {
    return pos[0] >= rect_pos[0] and pos[1] >= rect_pos[1] and pos[0] < (rect_pos[0] + rect_size[0]) and pos[1] < (rect_pos[1] + rect_size[1]);
}

/// Check if a position is inside an area defined by `bounds`.
// pub fn inBounds(pos: anytype, bounds: anytype) bool {
//     return pos[0] >= 0 and pos[1] >= 0 and pos[0] < bounds[0] and pos[1] < bounds[1];
// }

/// Calculate an orthogonal vector to `vector`. **`vector` must be a 2D vector**.
pub fn orthogonal2(vector: anytype) @TypeOf(vector) {
    comptime {
        const vector_info = @typeInfo(@TypeOf(vector));

        if (vector_info.vector.len != 2) @compileError("`vector` must be a 2D vector, a " ++ vector_info.vector.len ++ "D vector is given instead.");
    }

    return @TypeOf(vector){ vector[1], -vector[0] };
}

/// Returns `true` if all elements of `vector` are equal to `true`. Otherwise, returns `false`.
pub fn truthy(vector: anytype) bool {
    comptime {
        const vector_info = @typeInfo(@TypeOf(vector));

        if (vector_info.vector.child != bool) @compileError("`vector` must be a boolean vector, a `" ++ vector_info.vector.child ++ "` vector is given instead.");
    }

    return @reduce(.And, vector);
}

/// Calculate distance between `vector1` and `vector2`.
pub fn distance(vector1: anytype, vector2: anytype) @typeInfo(@TypeOf(vector1, vector2)).vector.child {
    return length(vector2 - vector1);
}

/// Calculate distance squared between `vector1` and `vector2`. **Performs faster than `distance(...)`**, due to lack of `@sqrt()` inside `lengthSquared(...)`.
pub fn distanceSquared(vector1: anytype, vector2: anytype) @typeInfo(@TypeOf(vector1, vector2)).vector.child {
    return lengthSquared(vector2 - vector1);
}

/// Calculate direction vector from `from` to `to`. **Vectors' elements must be of floating point type**. Asserts that `from != to`.
pub fn direction(from: anytype, to: anytype) @TypeOf(from, to) {
    return normalize(to - from);
}

/// Calculate direction vector from `from` to `to`. **Vectors' elements must be of floating point type**.
pub fn directionOrZero(from: anytype, to: anytype) @TypeOf(from, to) {
    return normalizeOrZero(to - from);
}

pub fn limitLength(vector: anytype, limit: std.meta.Child(@TypeOf(vector))) @TypeOf(vector) {
    if (length(vector) > limit) {
        return normalizeOrZero(vector) * @as(@TypeOf(vector), @splat(limit));
    }

    return vector;
}
