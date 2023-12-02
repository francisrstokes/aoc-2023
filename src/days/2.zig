const std = @import("std");
const utils = @import("../utils.zig");

const zigex = @import("zigex");

const SampleInfo = struct { reds: usize, blues: usize, greens: usize };
const GameInfo = struct {
    const Self = @This();

    const Colors = enum {
        Red,
        Green,
        Blue,
        Unknown,

        pub fn from_str(str: []const u8) Colors {
            var start: usize = 0;
            for (str) |c| {
                if (c == ' ') {
                    start += 1;
                    continue;
                }
                break;
            }

            if (std.mem.eql(u8, str[start..], "red")) {
                return Colors.Red;
            } else if (std.mem.eql(u8, str[start..], "green")) {
                return Colors.Green;
            } else if (std.mem.eql(u8, str[start..], "blue")) {
                return Colors.Blue;
            }

            return Colors.Unknown;
        }
    };

    id: usize,
    samples: std.MultiArrayList(SampleInfo),

    pub fn init(allocator: std.mem.Allocator, line: []const u8) !Self {
        const main_parts = try utils.split_arraylist(allocator, line[5..], ": ");
        const id = try std.fmt.parseInt(usize, main_parts.items[0], 10);
        const samples = try utils.split_arraylist(allocator, main_parts.items[1], ";");

        var game_info = Self{
            .id = id,
            .samples = std.MultiArrayList(SampleInfo){},
        };

        for (samples.items) |sample| {
            var info = SampleInfo{ .reds = 0, .blues = 0, .greens = 0 };

            var it = std.mem.splitAny(u8, sample, ",");
            while (it.next()) |color_count| {
                const res = try utils.NumResult.read_num_from_string(color_count);

                switch (Colors.from_str(color_count[res.consumed + 1 ..])) {
                    .Red => info.reds += res.value,
                    .Blue => info.blues += res.value,
                    .Green => info.greens += res.value,
                    else => unreachable,
                }
            }

            try game_info.samples.append(allocator, info);
        }

        return game_info;
    }

    pub fn print(self: *const Self) void {
        std.debug.print("Game {d}:\n", .{self.id});

        const reds = self.samples.items(.reds);
        const greens = self.samples.items(.greens);
        const blues = self.samples.items(.blues);

        for (0..self.samples.len) |i| {
            std.debug.print("  Sample {d}:\n", .{i});
            std.debug.print("    reds={d}\n", .{reds[i]});
            std.debug.print("    greens={d}\n", .{greens[i]});
            std.debug.print("    blues={d}\n", .{blues[i]});
        }
    }

    pub fn possible_with(self: *const Self, limits: SampleInfo) bool {
        const reds = self.samples.items(.reds);
        const greens = self.samples.items(.greens);
        const blues = self.samples.items(.blues);

        for (0..self.samples.len) |i| {
            if (reds[i] > limits.reds or greens[i] > limits.greens or blues[i] > limits.blues) {
                return false;
            }
        }

        return true;
    }

    pub fn get_maximal_limits(self: *const Self) SampleInfo {
        const reds = self.samples.items(.reds);
        const greens = self.samples.items(.greens);
        const blues = self.samples.items(.blues);

        var red_max: usize = 0;
        var green_max: usize = 0;
        var blue_max: usize = 0;

        for (reds) |value| red_max = @max(value, red_max);
        for (greens) |value| green_max = @max(value, green_max);
        for (blues) |value| blue_max = @max(value, blue_max);

        return .{ .reds = red_max, .greens = green_max, .blues = blue_max };
    }
};

pub fn run1(child_allocator: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(child_allocator);
    var allocator = arena.allocator();
    defer arena.deinit();

    const limits = SampleInfo{ .reds = 12, .greens = 13, .blues = 14 };

    var input_file = try utils.read_day_input(allocator, 2);
    var id_sum: usize = 0;

    for (input_file.lines()) |line| {
        const info = try GameInfo.init(allocator, line);
        if (info.possible_with(limits)) {
            id_sum += info.id;
        }
    }

    std.debug.print("{d}\n", .{id_sum});
}

pub fn run2(child_allocator: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(child_allocator);
    var allocator = arena.allocator();
    defer arena.deinit();

    var input_file = try utils.read_day_input(allocator, 2);
    var power_sum: usize = 0;

    for (input_file.lines()) |line| {
        const info = try GameInfo.init(allocator, line);
        var limits = info.get_maximal_limits();
        power_sum += limits.reds * limits.greens * limits.blues;
    }

    std.debug.print("{d}\n", .{power_sum});
}
