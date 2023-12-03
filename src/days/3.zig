const std = @import("std");
const utils = @import("../utils.zig");

const Grid = []const []const u8;
const Vec2D = struct { x: i64, y: i64 };
const SchematicNumber = struct {
    pos: Vec2D,
    length: usize,
    value: usize,
};

fn get_value_at_position(grid: Grid, p: Vec2D) ?u8 {
    if (p.y >= grid.len or p.y < 0) return null;
    const uy = utils.to_usize(p.y);
    const line = grid[uy];

    if (p.x >= line.len or p.x < 0) return null;
    const ux = utils.to_usize(p.x);

    const value = line[ux];
    return value;
}

fn is_part_number(grid: Grid, n: SchematicNumber) bool {
    for (0..3) |y_off| {
        const y: i64 = -1 + utils.to_i64(y_off);
        for (0..n.length + 2) |x_off| {
            const x: i64 = -1 + utils.to_i64(x_off);
            const p = Vec2D{ .x = n.pos.x + x, .y = n.pos.y + y };
            if (get_value_at_position(grid, p)) |value| {
                switch (value) {
                    '.', '0'...'9' => continue,
                    else => return true,
                }
            }
        }
    }
    return false;
}

fn find_gear_position(grid: Grid, n: SchematicNumber) ?Vec2D {
    for (0..3) |y_off| {
        const y: i64 = -1 + utils.to_i64(y_off);
        for (0..n.length + 2) |x_off| {
            const x: i64 = -1 + utils.to_i64(x_off);
            const p = Vec2D{ .x = n.pos.x + x, .y = n.pos.y + y };
            if (get_value_at_position(grid, p)) |value| {
                switch (value) {
                    '*' => return p,
                    else => continue,
                }
            }
        }
    }
    return null;
}

pub fn run1(child_allocator: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(child_allocator);
    var allocator = arena.allocator();
    defer arena.deinit();

    var input_file = try utils.read_day_input(allocator, 3);
    const grid = input_file.lines();

    var part_total: usize = 0;

    for (grid, 0..) |line, y| {
        var parser = std.fmt.Parser{ .buf = line, .pos = 0 };

        while (parser.pos < line.len) {
            if (std.ascii.isDigit(parser.peek(0).?)) {
                const old_x = parser.pos;
                const value = parser.number().?;

                const n = SchematicNumber{
                    .length = parser.pos - old_x,
                    .pos = .{ .x = utils.to_i64(old_x), .y = utils.to_i64(y) },
                    .value = value,
                };

                if (is_part_number(grid, n)) {
                    part_total += n.value;
                }

                continue;
            }
            _ = parser.char();
        }
    }

    std.debug.print("{d}\n", .{part_total});
}

pub fn run2(child_allocator: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(child_allocator);
    var allocator = arena.allocator();
    defer arena.deinit();

    var input_file = try utils.read_day_input(allocator, 3);
    const grid = input_file.lines();

    var gears = std.AutoHashMap(Vec2D, usize).init(allocator);
    var gears_total: usize = 0;

    for (grid, 0..) |line, y| {
        var parser = std.fmt.Parser{ .buf = line, .pos = 0 };

        while (parser.pos < line.len) {
            if (std.ascii.isDigit(parser.peek(0).?)) {
                const old_x = parser.pos;
                const value = parser.number().?;

                const n = SchematicNumber{
                    .length = parser.pos - old_x,
                    .pos = .{ .x = utils.to_i64(old_x), .y = utils.to_i64(y) },
                    .value = value,
                };

                if (find_gear_position(grid, n)) |gear_pos| {
                    var maybe_first_value = gears.get(gear_pos);
                    if (maybe_first_value) |first_value| {
                        gears_total += first_value * n.value;
                    } else {
                        try gears.put(gear_pos, n.value);
                    }
                }

                continue;
            }
            _ = parser.char();
        }
    }

    std.debug.print("{d}\n", .{gears_total});
}
