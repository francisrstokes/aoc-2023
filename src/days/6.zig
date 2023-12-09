const std = @import("std");
const utils = @import("../utils.zig");

// Input is small enough today to just embed it structurely directly.
const RaceRecord = struct {
    time: usize,
    distance: usize,
};

pub fn run1(child_allocator: std.mem.Allocator) !void {
    _ = child_allocator;
    var total_ways_to_beat: usize = 1;

    const records = [_]RaceRecord{
        .{ .time = 45, .distance = 295 },
        .{ .time = 98, .distance = 1734 },
        .{ .time = 83, .distance = 1278 },
        .{ .time = 73, .distance = 1210 },
    };

    for (&records) |record| {
        var ways_to_beat: usize = 0;
        for (1..record.time) |time_waited| {
            const time_remaining = record.time - time_waited;
            const distance = time_remaining * time_waited;
            if (distance > record.distance) {
                ways_to_beat += 1;
            }
        }

        if (ways_to_beat >= 1) {
            total_ways_to_beat *= ways_to_beat;
        }
    }

    std.debug.print("{d}\n", .{total_ways_to_beat});
}

pub fn run2(child_allocator: std.mem.Allocator) !void {
    _ = child_allocator;
    var total_ways_to_beat: usize = 0;

    const record = RaceRecord{ .time = 45988373, .distance = 295173412781210 };

    for (1..record.time) |time_waited| {
        const time_remaining = record.time - time_waited;
        const distance = time_remaining * time_waited;
        if (distance > record.distance) {
            total_ways_to_beat += 1;
        }
    }

    std.debug.print("{d}\n", .{total_ways_to_beat});
}
