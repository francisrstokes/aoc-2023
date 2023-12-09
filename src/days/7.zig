const std = @import("std");
const utils = @import("../utils.zig");

const DAY_NUM = 7;

const FiveOfAKind: usize = 7;
const FourOfAKind: usize = 6;
const FullHouse: usize = 5;
const ThreeOfAKind: usize = 4;
const TwoPair: usize = 3;
const OnePair: usize = 2;
const HighCard: usize = 1;

const CardsInfo = struct {
    const Self = @This();

    ace: usize = 0,
    two: usize = 0,
    three: usize = 0,
    four: usize = 0,
    five: usize = 0,
    six: usize = 0,
    seven: usize = 0,
    eight: usize = 0,
    nine: usize = 0,
    ten: usize = 0,
    jack: usize = 0,
    queen: usize = 0,
    king: usize = 0,

    pairs: usize = 0,
    triples: usize = 0,
    quadruples: usize = 0,
    quintuples: usize = 0,

    pub fn add(self: *Self, comptime card: []const u8) void {
        @field(self, card) += 1;
        switch (@field(self, card)) {
            5 => {
                self.quintuples += 1;
                self.quadruples -= 1;
            },
            4 => {
                self.quadruples += 1;
                self.triples -= 1;
            },
            3 => {
                self.triples += 1;
                self.pairs -= 1;
            },
            2 => self.pairs += 1,
            else => {},
        }
    }

    pub fn hand_value(self: *Self) usize {
        if (self.quintuples == 1) return FiveOfAKind;
        if (self.quadruples == 1) return FourOfAKind;
        if (self.triples == 1 and self.pairs == 1) return FullHouse;
        if (self.triples == 1) return ThreeOfAKind;
        if (self.pairs == 2) return TwoPair;
        if (self.pairs == 1) return OnePair;
        return HighCard;
    }
};

const Hand = struct {
    const Self = @This();

    cards: []const u8,
    value: usize,
    bid: usize,

    pub fn parse(line: []const u8) !Hand {
        const cards = line[0..5];
        const bid = try std.fmt.parseInt(usize, line[6..], 10);

        var info = CardsInfo{};

        for (cards) |card| {
            switch (card) {
                'A' => info.add("ace"),
                '2' => info.add("two"),
                '3' => info.add("three"),
                '4' => info.add("four"),
                '5' => info.add("five"),
                '6' => info.add("six"),
                '7' => info.add("seven"),
                '8' => info.add("eight"),
                '9' => info.add("nine"),
                'T' => info.add("ten"),
                'J' => info.add("jack"),
                'Q' => info.add("queen"),
                'K' => info.add("king"),
                else => unreachable,
            }
        }

        const value = info.hand_value();
        return Self{ .cards = cards, .value = value, .bid = bid };
    }

    fn get_card_value(card: u8) usize {
        return switch (card) {
            '2' => 2,
            '3' => 3,
            '4' => 4,
            '5' => 5,
            '6' => 6,
            '7' => 7,
            '8' => 8,
            '9' => 9,
            'T' => 10,
            'J' => 11,
            'Q' => 12,
            'K' => 13,
            'A' => 14,
            else => unreachable,
        };
    }

    pub fn is_stronger_than(self: *const Self, other: Self) bool {
        // Hand to hand
        if (self.value > other.value) return true;
        if (self.value < other.value) return false;

        // Card by card
        for (0..5) |i| {
            const value = Hand.get_card_value(self.cards[i]);
            const other_value = Hand.get_card_value(other.cards[i]);
            if (value == other_value) continue;
            return value > other_value;
        }

        unreachable;
    }

    pub fn is_weaker_than(self: *const Self, other: Self) bool {
        return !self.is_stronger_than(other);
    }

    pub fn cmp(ctx: void, a: Self, b: Self) bool {
        _ = ctx;
        return a.is_weaker_than(b);
    }

    pub fn print(self: *const Self) void {
        std.debug.print("[{d}] {s} @ {d}\n", .{ self.value, self.cards, self.bid });
    }
};

pub fn run1(child_allocator: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(child_allocator);
    var allocator = arena.allocator();
    defer arena.deinit();

    var input_file = try utils.read_day_input(allocator, DAY_NUM);
    const lines = input_file.lines();

    var hands = try std.ArrayList(Hand).initCapacity(allocator, input_file._lines.items.len);
    for (lines) |line| {
        hands.appendAssumeCapacity(try Hand.parse(line));
    }
    var hands_slice = try hands.toOwnedSlice();
    std.sort.insertion(Hand, hands_slice, {}, Hand.cmp);

    var total_winnings: usize = 0;
    for (hands_slice, 1..) |hand, rank| {
        total_winnings += hand.bid * rank;
    }

    std.debug.print("{d}\n", .{total_winnings});
}

pub fn run2(child_allocator: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(child_allocator);
    var allocator = arena.allocator();
    defer arena.deinit();

    var input_file = try utils.read_day_input(allocator, DAY_NUM);
    _ = input_file;

    // std.debug.print("{d}\n", .{lowest_location});
}
