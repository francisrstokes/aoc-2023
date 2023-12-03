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
    const uy = @as(usize, @bitCast(p.y));
    const line = grid[uy];

    if (p.x >= line.len or p.x < 0) return null;
    const ux = @as(usize, @bitCast(p.x));

    const value = line[ux];
    return value;
}

fn is_part_number(grid: Grid, n: SchematicNumber) bool {
    for (0..3) |y_off| {
        const y: i64 = -1 + @as(i64, @bitCast(y_off));
        for (0..n.length + 2) |x_off| {
            const x: i64 = -1 + @as(i64, @bitCast(x_off));
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

pub fn run1(child_allocator: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(child_allocator);
    var allocator = arena.allocator();
    defer arena.deinit();

    var input_file = try utils.read_day_input(allocator, 3);
    const grid = input_file.lines();

    var part_total: usize = 0;

    for (grid, 0..) |line, y| {
        var x_off: i64 = 0;

        inner: while (x_off < line.len) {
            const ux_off = @as(usize, @bitCast(x_off));
            const value = line[ux_off];
            if (utils.is_ascii_digit(value)) {
                var end = ux_off + 1;
                var len: usize = 1;

                while (true) {
                    if (end >= line.len) break;
                    if (!utils.is_ascii_digit(line[end])) break;
                    end += 1;
                    len += 1;
                }

                const n = SchematicNumber{
                    .length = len,
                    .pos = .{ .x = x_off, .y = @as(i64, @bitCast(y)) },
                    .value = try std.fmt.parseInt(usize, line[ux_off..end], 10),
                };
                const is_part = is_part_number(grid, n);

                if (is_part) {
                    part_total += n.value;
                }

                x_off = @as(i64, @bitCast(end));
                continue :inner;
            }
            x_off += 1;
        }
    }

    std.debug.print("{d}\n", .{part_total});
}

pub fn run2(child_allocator: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(child_allocator);
    var allocator = arena.allocator();
    defer arena.deinit();

    var input_file = try utils.read_day_input(allocator, 3);
    _ = input_file;
}
