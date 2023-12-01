const std = @import("std");
const utils = @import("../utils.zig");

const zigex = @import("zigex");

pub fn run1(child_allocator: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(child_allocator);
    var allocator = arena.allocator();
    defer arena.deinit();

    var input_file = try utils.read_day_input(allocator, 1);

    var first_re = try zigex.Regex.init(allocator, "^.*?(\\d).*$", .{});
    var second_re = try zigex.Regex.init(allocator, "^.*(\\d).*?$", .{});

    var sum: usize = 0;
    for (input_file.lines(), 1..) |line, line_num| {
        var first_match = try first_re.match(line);
        var second_match = try second_re.match(line);

        if (first_match) |*fm| {
            if (second_match) |*sm| {
                const first_digit = (try fm.get_group(1)).?.value[0] - '0';
                const second_digit = (try sm.get_group(1)).?.value[0] - '0';

                const final_value = first_digit * 10 + second_digit;

                std.debug.print("{d}: {d} {d} = {d}\n", .{ line_num, first_digit, second_digit, final_value });
                sum += final_value;
            }
        }
    }
    std.debug.print("sum: {d}\n", .{sum});
}

pub fn run2(child_allocator: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(child_allocator);
    var allocator = arena.allocator();
    defer arena.deinit();

    var input_file = try utils.read_day_input(allocator, 1);

    var first_re = try zigex.Regex.init(allocator, "^.*?(\\d|one|two|three|four|five|six|seven|eight|nine).*$", .{});
    var second_re = try zigex.Regex.init(allocator, "^.*(\\d|one|two|three|four|five|six|seven|eight|nine).*?$", .{});

    var num_map = std.StringHashMap(usize).init(allocator);
    try num_map.put("1", 1);
    try num_map.put("2", 2);
    try num_map.put("3", 3);
    try num_map.put("4", 4);
    try num_map.put("5", 5);
    try num_map.put("6", 6);
    try num_map.put("7", 7);
    try num_map.put("8", 8);
    try num_map.put("9", 9);
    try num_map.put("one", 1);
    try num_map.put("two", 2);
    try num_map.put("three", 3);
    try num_map.put("four", 4);
    try num_map.put("five", 5);
    try num_map.put("six", 6);
    try num_map.put("seven", 7);
    try num_map.put("eight", 8);
    try num_map.put("nine", 9);

    var sum: usize = 0;
    for (input_file.lines(), 1..) |line, line_num| {
        var first_match = try first_re.match(line);
        var second_match = try second_re.match(line);

        if (first_match) |*fm| {
            if (second_match) |*sm| {
                const first_string = (try fm.get_group(1)).?.value;
                const first_digit = num_map.get(first_string).?;
                const second_string = (try sm.get_group(1)).?.value;
                const second_digit = num_map.get(second_string).?;

                const final_value = first_digit * 10 + second_digit;

                std.debug.print("{d}: {d} {d} = {d}\n", .{ line_num, first_digit, second_digit, final_value });
                sum += final_value;
            }
        }
    }
    std.debug.print("sum: {d}\n", .{sum});
}
