const std = @import("std");
const day1 = @import("./days/1.zig");
const day2 = @import("./days/2.zig");
const day3 = @import("./days/3.zig");
const day4 = @import("./days/4.zig");
const day5 = @import("./days/5.zig");
const day6 = @import("./days/6.zig");
const day7 = @import("./days/7.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.deinit();
    }

    try day7.run1(allocator);
    try day7.run2(allocator);
}
