const std = @import("std");
const day1 = @import("./day1/day1.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.deinit();
    }

    try day1.run1(allocator);
}
