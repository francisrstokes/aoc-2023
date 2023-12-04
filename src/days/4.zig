const std = @import("std");
const utils = @import("../utils.zig");

const DAY_NUM = 4;
const WINNERS_PER_CARD = 10;
const NUMS_PER_CARD = 25;

pub fn run1(child_allocator: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(child_allocator);
    var allocator = arena.allocator();
    defer arena.deinit();

    var input_file = try utils.read_day_input(allocator, DAY_NUM);

    var winners = try std.ArrayList(usize).initCapacity(allocator, WINNERS_PER_CARD);
    var total_points: usize = 0;

    for (input_file.lines()) |line| {
        var parser = std.fmt.Parser{ .buf = line, .pos = 0 };

        // Ignore card number
        _ = parser.until(':');
        _ = parser.char();
        utils.consume_whitespace(&parser);

        for (0..WINNERS_PER_CARD) |_| {
            const winner = parser.number().?;
            winners.appendAssumeCapacity(winner);
            utils.consume_whitespace(&parser);
        }

        // Consume the '|'
        _ = parser.char();
        utils.consume_whitespace(&parser);

        var card_points: usize = 0;
        for (0..NUMS_PER_CARD) |_| {
            const num = parser.number().?;

            for (winners.items) |winner| {
                if (winner == num) {
                    if (card_points == 0) {
                        card_points = 1;
                    } else {
                        card_points *= 2;
                    }
                    break;
                }
            }

            utils.consume_whitespace(&parser);
        }
        total_points += card_points;

        winners.clearRetainingCapacity();
    }

    std.debug.print("{d}\n", .{total_points});
}

pub fn run2(child_allocator: std.mem.Allocator) !void {
    _ = child_allocator;
}
