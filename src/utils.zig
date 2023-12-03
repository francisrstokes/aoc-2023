const std = @import("std");

pub const FileLines = struct {
    const Self = @This();

    allocator: std.mem.Allocator,
    file_contents: []const u8,
    _lines: std.ArrayList([]const u8),

    pub fn init(allocator: std.mem.Allocator, file_contents: []const u8, file_lines: std.ArrayList([]const u8)) !Self {
        return .{
            .allocator = allocator,
            .file_contents = file_contents,
            ._lines = file_lines,
        };
    }

    pub fn deinit(self: *Self) void {
        self.allocator.free(self.file_contents);
        self._lines.deinit();
    }

    pub fn lines(self: *Self) []const []const u8 {
        return self._lines.items;
    }
};

pub fn read_file_lines(allocator: std.mem.Allocator, path: []const u8) !FileLines {
    const file = try std.fs.openFileAbsolute(path, .{});
    defer file.close();

    var file_contents = try file.readToEndAlloc(allocator, std.math.maxInt(usize));
    var lines = std.ArrayList([]const u8).init(allocator);

    var it = std.mem.split(u8, file_contents, "\n");
    while (it.next()) |line| {
        try lines.append(line);
    }

    return FileLines.init(allocator, file_contents, lines);
}

pub fn read_day_input(allocator: std.mem.Allocator, day: u32) !FileLines {
    const rel_path = try std.fmt.allocPrint(allocator, "./inputs/day{d}.txt", .{day});
    defer allocator.free(rel_path);

    var day_path = try allocator.alloc(u8, 1024);
    defer allocator.free(day_path);

    var real_path = try std.fs.cwd().realpath(rel_path, day_path);

    return try read_file_lines(allocator, real_path);
}

pub fn split_arraylist(allocator: std.mem.Allocator, s: []const u8, sep: []const u8) !std.ArrayList([]const u8) {
    var result = std.ArrayList([]const u8).init(allocator);
    var it = std.mem.split(u8, s, sep);
    while (it.next()) |item| {
        try result.append(item);
    }
    return result;
}
