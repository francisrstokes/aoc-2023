const std = @import("std");
const day1 = @import("./days/1.zig");
const day2 = @import("./days/2.zig");
const day3 = @import("./days/3.zig");
const day4 = @import("./days/4.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.deinit();
    }

    try day4.run1(allocator);
    try day4.run2(allocator);
}
