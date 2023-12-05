const std = @import("std");
const utils = @import("../utils.zig");

const DAY_NUM = 5;

const Range = struct { dest: usize, source: usize, size: usize };
const SeedRange = struct { start: usize, size: usize };

fn parse_map(map: *std.ArrayList(Range), lines: []const []const u8, line_index: usize) usize {
    var index = line_index + 1; // Skip the title line
    var parser: std.fmt.Parser = undefined;
    while (true) : (index += 1) {
        if (index >= lines.len or lines[index].len == 0) {
            return index + 1;
        }

        parser.buf = lines[index];
        parser.pos = 0;

        const dest = parser.number().?;
        utils.consume_whitespace(&parser);
        const source = parser.number().?;
        utils.consume_whitespace(&parser);
        const size = parser.number().?;

        const range = Range{ .dest = dest, .source = source, .size = size };
        map.appendAssumeCapacity(range);
    }
}

fn range_map_lookup(map: *std.ArrayList(Range), index: usize) ?usize {
    for (map.items) |range| {
        if (index >= range.source and index < range.source + range.size) {
            const offset = index - range.source;
            return range.dest + offset;
        }
    }
    return null;
}

pub fn run1(child_allocator: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(child_allocator);
    var allocator = arena.allocator();
    defer arena.deinit();

    var input_file = try utils.read_day_input(allocator, DAY_NUM);
    const lines = input_file.lines();
    const seed_line = lines[0];
    const other_lines = lines[2..];

    var seeds = try std.ArrayList(usize).initCapacity(allocator, 20);
    var parser = std.fmt.Parser{ .buf = seed_line, .pos = 7 };

    while (parser.pos < seed_line.len) {
        const num = parser.number().?;
        seeds.appendAssumeCapacity(num);
        utils.consume_whitespace(&parser);
    }

    // Create a bunch of range maps...
    var seed_soil = try std.ArrayList(Range).initCapacity(allocator, 50);
    var soil_fertilizer = try std.ArrayList(Range).initCapacity(allocator, 50);
    var fertilizer_water = try std.ArrayList(Range).initCapacity(allocator, 50);
    var water_light = try std.ArrayList(Range).initCapacity(allocator, 50);
    var light_temperature = try std.ArrayList(Range).initCapacity(allocator, 50);
    var temperature_humidity = try std.ArrayList(Range).initCapacity(allocator, 50);
    var humidity_location = try std.ArrayList(Range).initCapacity(allocator, 50);

    // ...and populate their contents by parsing the rest of the file.
    var line_index: usize = parse_map(&seed_soil, other_lines, 0);
    line_index = parse_map(&soil_fertilizer, other_lines, line_index);
    line_index = parse_map(&fertilizer_water, other_lines, line_index);
    line_index = parse_map(&water_light, other_lines, line_index);
    line_index = parse_map(&light_temperature, other_lines, line_index);
    line_index = parse_map(&temperature_humidity, other_lines, line_index);
    line_index = parse_map(&humidity_location, other_lines, line_index);

    var lowest_location: usize = std.math.maxInt(usize);
    for (seeds.items) |seed| {
        const soil_index = range_map_lookup(&seed_soil, seed) orelse continue;
        const fertilizer_index = range_map_lookup(&soil_fertilizer, soil_index) orelse continue;
        const water_index = range_map_lookup(&fertilizer_water, fertilizer_index) orelse continue;
        const light_index = range_map_lookup(&water_light, water_index) orelse continue;
        const temperature_index = range_map_lookup(&light_temperature, light_index) orelse continue;
        const humidity_index = range_map_lookup(&temperature_humidity, temperature_index) orelse continue;
        const location_index = range_map_lookup(&humidity_location, humidity_index) orelse continue;

        if (location_index < lowest_location) {
            lowest_location = location_index;
        }
    }

    std.debug.print("{d}\n", .{lowest_location});
}

pub fn run2(child_allocator: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(child_allocator);
    var allocator = arena.allocator();
    defer arena.deinit();

    var input_file = try utils.read_day_input(allocator, DAY_NUM);
    const lines = input_file.lines();
    const seed_line = lines[0];
    const other_lines = lines[2..];

    var seeds = try std.ArrayList(SeedRange).initCapacity(allocator, 10);
    var parser = std.fmt.Parser{ .buf = seed_line, .pos = 7 };

    while (parser.pos < seed_line.len) {
        const start = parser.number().?;
        utils.consume_whitespace(&parser);
        const count = parser.number().?;
        utils.consume_whitespace(&parser);
        seeds.appendAssumeCapacity(.{ .start = start, .size = count });
    }

    // Create a bunch of range maps...
    var seed_soil = try std.ArrayList(Range).initCapacity(allocator, 50);
    var soil_fertilizer = try std.ArrayList(Range).initCapacity(allocator, 50);
    var fertilizer_water = try std.ArrayList(Range).initCapacity(allocator, 50);
    var water_light = try std.ArrayList(Range).initCapacity(allocator, 50);
    var light_temperature = try std.ArrayList(Range).initCapacity(allocator, 50);
    var temperature_humidity = try std.ArrayList(Range).initCapacity(allocator, 50);
    var humidity_location = try std.ArrayList(Range).initCapacity(allocator, 50);

    // ...and populate their contents by parsing the rest of the file.
    var line_index: usize = parse_map(&seed_soil, other_lines, 0);
    line_index = parse_map(&soil_fertilizer, other_lines, line_index);
    line_index = parse_map(&fertilizer_water, other_lines, line_index);
    line_index = parse_map(&water_light, other_lines, line_index);
    line_index = parse_map(&light_temperature, other_lines, line_index);
    line_index = parse_map(&temperature_humidity, other_lines, line_index);
    line_index = parse_map(&humidity_location, other_lines, line_index);

    var lowest_location: usize = std.math.maxInt(usize);
    for (seeds.items, 1..) |seed_range, seed_range_index| {
        for (seed_range.start..seed_range.start + seed_range.size) |seed| {
            const soil_index = range_map_lookup(&seed_soil, seed) orelse continue;
            const fertilizer_index = range_map_lookup(&soil_fertilizer, soil_index) orelse continue;
            const water_index = range_map_lookup(&fertilizer_water, fertilizer_index) orelse continue;
            const light_index = range_map_lookup(&water_light, water_index) orelse continue;
            const temperature_index = range_map_lookup(&light_temperature, light_index) orelse continue;
            const humidity_index = range_map_lookup(&temperature_humidity, temperature_index) orelse continue;
            const location_index = range_map_lookup(&humidity_location, humidity_index) orelse continue;

            if (location_index < lowest_location) {
                lowest_location = location_index;
            }
        }
        std.debug.print("[{d}/{d}]\n", .{ seed_range_index, seeds.items.len });
    }

    std.debug.print("{d}\n", .{lowest_location});
}
