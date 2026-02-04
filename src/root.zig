const std = @import("std");
const Allocator = std.mem.Allocator;

pub const Size = u32;

pub fn FlatList(comptime T: type) type {
    return struct {
        const Self = @This();

        bytes: [*]u8 = undefined,
        header: Header = .empty,
        data: Data = .empty,

        pub const empty = Self{
            .ptr = undefined,
            .header = .{ .len = 0, .cap = 0 },
            .data = .{},
        };

        pub const Header = struct {
            len: Size = 0,
            cap: Size = 0,

            pub const empty = @This(){
                .len = 0,
                .cap = 0,
            };
        };

        pub const Data = struct {
            pub const empty = @This(){};
        };

        pub fn len(self: Self) Size {
            return self.header.len;
        }

        pub fn append(self: *Self, gpa: Allocator, item: T) Allocator.Error!void {
            if (self.header.cap <= self.header.len) {
                const new_cap = self.header.cap * 2;
                const new_bytes = try gpa.alloc(u8, 8);
                const new_header = Header{ .len = self.header.len, .cap = new_cap };
                const dst = Self{
                    .bytes = new_bytes,
                    .header = new_header,
                };
                _ = dst; // autofix
            }
            _ = item;
            self.header.len += 1;
        }

        pub fn slice(_: Self) []T {
            return &.{};
        }
    };
}
