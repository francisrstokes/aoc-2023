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
    .{ .word = "three", .digit = 3 },
    .{ .word = "four", .digit = 4 },
    .{ .word = "five", .digit = 5 },
    .{ .word = "six", .digit = 6 },
    .{ .word = "seven", .digit = 7 },
    .{ .word = "eight", .digit = 8 },
    .{ .word = "nine", .digit = 9 },
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

fn parse_line2(line: []const u8, line_num: usize) u8 {
    const LineDigits = [2]u8;

    var digits = LineDigits{ 0, 0 };

    var i: usize = 0;
    var done = false;
    outer_loop_1: while (!done) {
        for (WordedDigits) |worded_digit| {
            if (std.mem.startsWith(u8, line[i..], worded_digit.word)) {
                digits[0] = worded_digit.digit;
                break :outer_loop_1;
            }
        }

        if (line[i] >= '1' and line[i] <= '9') {
            digits[0] = line[i] - '0';
            break;
        }
        i += 1;
    }

    i = line.len - 1;
    done = false;
    outer_loop_2: while (!done) {
        if (line[i] >= '1' and line[i] <= '9') {
            digits[1] = line[i] - '0';
            break;
        }

        for (WordedDigits) |worded_digit| {
            const end_index: i64 = @as(i64, @bitCast(i)) - @as(i64, @bitCast(worded_digit.word.len - 1));
            const uend_index = @as(usize, @bitCast(end_index));

            if (end_index < 0) {
                continue;
            }

            if (std.mem.startsWith(u8, line[uend_index..], worded_digit.word)) {
                digits[1] = worded_digit.digit;
                break :outer_loop_2;
            }
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

pub fn run2(allocator: std.mem.Allocator) !void {
    var input_file = try utils.read_day_input(allocator, 1);
    defer input_file.deinit();

    var sum: usize = 0;
    for (input_file.lines(), 1..) |line, line_num| {
        const value = parse_line2(line, line_num);
        sum += value;
    }
    std.debug.print("sum: {d}\n", .{sum});
}
