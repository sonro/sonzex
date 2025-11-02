const std = @import("std");
const testing = std.testing;

const FlatList = @import("flat_list").FlatList;

const Type = struct { Obj: type, List: type };
const TestFn = fn (comptime T: Type, test_data: anytype) anyerror!void;

fn testEmpty(comptime T: Type, _: anytype) !void {
    const list = T.List.empty;
    try testing.expectEqual(0, list.len());
}

test "empty list" {
    try testLists(testEmpty, .{});
}

fn testLists(test_fn: TestFn, test_data: anytype) !void {
    inline for (types) |T| {
        try test_fn(T, test_data);
    }
}

const types: []const Type = &.{
    .{ .Obj = ScalerObj, .List = ScalerList },
    .{ .Obj = SliceObj, .List = SliceList },
    .{ .Obj = MixSliceObj, .List = MixSliceList },
    .{ .Obj = MixedObj, .List = MixedList },
};

const ScalerList = FlatList(ScalerObj);
const SliceList = FlatList(SliceObj);
const MixSliceList = FlatList(MixSliceObj);
const MixedList = FlatList(MixedObj);

/// Only scalar types
const ScalerObj = struct {
    a: f32,
    b: f32,

    const fixtures: []const ScalerObj = &.{
        .{ .a = 0.1, .b = 0.2 },
        .{ .a = 1.1, .b = 1.2 },
        .{ .a = 2.1, .b = 2.2 },
    };
};

/// Only same type slice types
const SliceObj = struct {
    a: []const i32,
    b: []const i32,

    const fixtures: []const SliceObj = &.{
        .{ .a = &.{}, .b = &.{} },
        .{ .a = &.{ 4, 5, 6 }, .b = &.{} },
        .{ .a = &.{ 7, 8, 9 }, .b = &.{ 77, 88 } },
        .{ .a = &.{ 10, 11, 12 }, .b = &.{ 110, 111, 112 } },
    };
};

/// Only mixed type slice types
const MixSliceObj = struct {
    a: []const i32,
    b: []const u8,

    const fixtures: []const MixSliceObj = &.{
        .{ .a = &.{}, .b = &.{} },
        .{ .a = &.{ 4, 5, 6 }, .b = &.{} },
        .{ .a = &.{ 7, 8, 9 }, .b = &.{ 77, 88 } },
        .{ .a = &.{ 10, 11, 12 }, .b = &.{ 110, 111, 112 } },
    };
};

/// Mixed scalar and slices types
const MixedObj = struct {
    a: []const i32,
    b: []const u8,
    c: f32,

    const fixtures: []const MixedObj = &.{
        .{ .a = &.{}, .b = &.{}, .c = 0.1 },
        .{ .a = &.{ 4, 5, 6 }, .b = &.{}, .c = 0.2 },
        .{ .a = &.{ 7, 8, 9 }, .b = &.{ 77, 88 }, .c = 0.3 },
        .{ .a = &.{ 10, 11, 12 }, .b = &.{ 110, 111, 112 }, .c = 0.4 },
    };
};
