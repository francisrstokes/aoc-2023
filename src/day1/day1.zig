const std = @import("std");
const utils = @import("../utils.zig");

const zigex = @import("zigex");

const WordedDigit = struct {
    word: []const u8,
    digit: u8,
};

const WordedDigits = [_]WordedDigit{
    .{ .word = "one", .digit = 1 },
    .{ .word = "two", .digit = 2 },
    .{ .word = "six", .digit = 6 },
    .{ .word = "four", .digit = 4 },
    .{ .word = "five", .digit = 5 },
    .{ .word = "nine", .digit = 9 },
    .{ .word = "three", .digit = 3 },
    .{ .word = "seven", .digit = 7 },
    .{ .word = "eight", .digit = 8 },
};

fn parse_line(line: []const u8, line_num: usize) u8 {
    const LineDigits = [2]u8;

    var digits = LineDigits{ 0, 0 };

    var i: usize = 0;
    var done = false;
    while (!done) {
        if (line[i] >= '1' and line[i] <= '9') {
            digits[0] = line[i] - '0';
            done = true;
            continue;
        }
        i += 1;
    }

    i = line.len - 1;
    done = false;
    while (!done) {
        if (line[i] >= '1' and line[i] <= '9') {
            digits[1] = line[i] - '0';
            done = true;
            continue;
        }
        i -= 1;
    }

    const final_value = digits[0] * 10 + digits[1];

    std.debug.print("{d}: {d} {d} = {d}\n", .{ line_num, digits[0], digits[1], final_value });

    return final_value;
}

pub fn run1(allocator: std.mem.Allocator) !void {
    var input_file = try utils.read_day_input(allocator, 1);
    defer input_file.deinit();

    var sum: usize = 0;
    for (input_file.lines(), 1..) |line, line_num| {
        const value = parse_line(line, line_num);
        sum += value;
    }
    std.debug.print("sum: {d}\n", .{sum});
}
