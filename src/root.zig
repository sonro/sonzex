pub const Size = usize;

pub fn FlatList(comptime _: type) type {
    return struct {
        const Self = @This();

        pub const empty = Self{};

        pub fn len(_: Self) Size {
            return 0;
        }
    };
}
