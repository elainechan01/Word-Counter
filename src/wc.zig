const std = @import("std");
const fs = std.fs;
const io = std.io;
const mem = std.mem;
const testing = std.testing;
const debug = std.debug;
const zig = std.zig;

const StringHashMap = std.StringArrayHashMap;

pub const PrintFn = struct {
    print: fn(comptime fmt: []const u8, args: anytype) void
};
const printer = PrintFn{ .print = debug.print };

// If you need to allocate resorces, you will, pass the allocator around.
var alloc = testing.allocator;

/// Read the whole file into a buffer and return that buffer,
/// don't free whatever you have used to allocate the buffer until after you have used it.
///
/// Remember to close the file.
///
///                                   This means any error can be returned
pub fn readToString(path: []const u8) anyerror![]u8 {
    const file = try fs.cwd().openFile(path, .{.read=true});
    var buf_reader = io.bufferedReader(file.reader());
    const stream = buf_reader.reader();
    const stat_file = try file.stat();
    const res = try stream.readAllAlloc(alloc, stat_file.size);

    // close file
    file.close();

    return res;
}

/// You must return the StringHashMap that contians all the words and counts.
///
/// Remember don't free any of the keys or values of this map, don't free the map either.
pub fn wc(lines: []const u8) anyerror!StringHashMap(usize) {
    var map = StringHashMap(usize).init(alloc);

    var iterator = std.mem.tokenize(u8, lines, "\r\n");

    while (true){
        var paragraph = iterator.next();
        //std.debug.print("Paragraph: {s}\n", .{paragraph});
        
        if (paragraph == null) break;

        var buffer = std.mem.tokenize(u8, paragraph.?, " ");
        while (true) {
            var token = buffer.next();
            //std.debug.print("Token: {s}\n",.{token});

            if (token == null) break;

            var isFound = map.contains(token.?);
            if (isFound){
                var val = map.getPtr(token.?);
                val.?.* += 1;
            }else{
                try map.put(token.?, 1);
            }
        }
    }

    return map;
}

/// Each word must be printed like `print.print("{s}, {}\n", word, count)` and the total
/// `print.print("{s} {}\n", path, total)`.
pub fn printWordCount(
    word_map: *const StringHashMap(usize),
    path: []const u8, comptime print: PrintFn
) void {
    // init

    var it = word_map.iterator();

    var count: usize = 0;

    // print each word
    while (it.next()) |entry| {
        if (entry.value_ptr.* > 1){
            print.print("{s} {}\n",.{entry.key_ptr.*, entry.value_ptr.*});
            count += entry.value_ptr.*;
        } else {
            count += 1;
        }
    }

    // total
    print.print("\n{s} {}\n",.{path, count});
}
