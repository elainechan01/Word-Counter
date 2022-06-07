const std = @import("std");
const fs = std.fs;
const mem = std.mem;
const testing = std.testing;
const debug = std.debug;

// OPEN THIS FILE AND START WORKING!!
const wc = @import("./wc.zig");

// Maybe we don't want to give this hint...
const StringHashMap = std.StringArrayHashMap;

// If you need to allocate resorces, you will, pass the alloc around.
pub var alloc = testing.allocator;

pub fn main() anyerror!void {
    const args = try std.process.argsAlloc(alloc);
    const files = args[1..];
    //const files = std.os.argv[1..std.os.argv.len];

    for (files) |file| {
        const len = mem.len(file);

        var lines = try wc.readToString(file[0..len]);
        defer std.ArrayList(u8).fromOwnedSlice(alloc, lines).deinit();

        var word_map = try wc.wc(lines);
        defer word_map.deinit();

        wc.printWordCount(&word_map, file[0..len], wc.PrintFn{ .print = debug.print, });
    }
}

test "can open file" {
    const file = try wc.readToString("./src/main.zig");
    defer std.ArrayList(u8).fromOwnedSlice(alloc, file).deinit();
}

test "can get text from file" {
    const file = try wc.readToString("./src/main.zig");
    defer std.ArrayList(u8).fromOwnedSlice(alloc, file).deinit();

    try testing.expect(mem.indexOf(u8, file, "can get text from file") != null);
}

// This test might be kinda dumb? It also might be an interesting way of testing, using
// reflection and comptime type checking.
fn test_print(comptime fmt: []const u8, args: anytype) void {
    _ = fmt;
    const fields = @typeInfo(@TypeOf(args)).Struct.fields;
    inline for (fields) |field| {
        if (field.field_type == []const u8) {
            if (mem.eql(u8, @field(args, field.name), "file.name")) {return;}
        }
        if (field.field_type == usize) {
            if (@field(args, field.name) == 1) {return;}
        }
    }
    unreachable;
}
test "print fn does print stuff" {
    var map = StringHashMap(usize).init(alloc);
    defer map.deinit();

    try map.put("hello", 1);
    wc.printWordCount(&map, "file.name", .{ .print = test_print });
}

test "wc can count words" {
    var map = try wc.wc("one two three four");
    defer map.deinit();
    try testing.expectEqual(@as(usize, 4), map.count());
}

test "wc can count duplicates" {
    var map = try wc.wc("help help I have been been been help help I have");
    defer map.deinit();
    try testing.expectEqual(@as(usize, 4), map.count());

    try testing.expectEqual(@as(usize, 4), map.get("help").?);
    try testing.expectEqual(@as(usize, 2), map.get("I").?);
    try testing.expectEqual(@as(usize, 3), map.get("been").?);
    try testing.expectEqual(@as(usize, 2), map.get("have").?);
}

test "wc can count a zero length string" {
    var map = try wc.wc("");
    defer map.deinit();
    try testing.expectEqual(@as(usize, 0), map.count());
}

// More like the 2 above here

fn test_print_msno(comptime fmt: []const u8, args: anytype) void {
    _ = fmt;
    var found: usize = 0;
    const fields = @typeInfo(@TypeOf(args)).Struct.fields;
    inline for (fields) |field| {
        if (field.field_type == []const u8) {
            if (!mem.eql(u8, @field(args, field.name), "input/msno.txt")) {
                return;
            }
        }

        if (field.field_type == usize) {
            const c = @field(args, field.name);
            if (c == 1274) {
                found = c;
            }
        }
    }
    if (found == 1274) { return; }
    unreachable;
}
test "Missing No." {
    var lines = try wc.readToString("input/msno.txt");
    defer std.ArrayList(u8).fromOwnedSlice(alloc, lines).deinit();

    var word_map = try wc.wc(lines);
    defer word_map.deinit();

    try testing.expectEqual(@as(usize, 22), word_map.get("as").?);
    try testing.expectEqual(@as(usize, 2), word_map.get("-").?);
    try testing.expectEqual(@as(usize, 5), word_map.get("Nintendo").?);

    wc.printWordCount(&word_map, "input/msno.txt", wc.PrintFn{ .print = test_print_msno });
}

fn test_print_kernel(comptime fmt: []const u8, args: anytype) void {
    _ = fmt;
    var found: usize = 0;
    const fields = @typeInfo(@TypeOf(args)).Struct.fields;
    inline for (fields) |field| {
        if (field.field_type == []const u8) {
            if (!mem.eql(u8, @field(args, field.name), "input/kernel.txt")) {
                return;
            }
        }

        if (field.field_type == usize) {
            const c = @field(args, field.name);
            if (c == 7929) {
                found = c;
            }
        }
    }
    if (found == 7929) { return; }
    unreachable;
}
test "kernel input" {
    var lines = try wc.readToString("input/kernel.txt");
    defer std.ArrayList(u8).fromOwnedSlice(alloc, lines).deinit();

    var word_map = try wc.wc(lines);
    defer word_map.deinit();

    try testing.expectEqual(@as(usize, 2), word_map.get("Modern").?);
    try testing.expectEqual(@as(usize, 18), word_map.get("design").?);
    try testing.expectEqual(@as(usize, 2), word_map.get("(one").?);
    try testing.expectEqual(@as(usize, 142), word_map.get("is").?);
    try testing.expectEqual(@as(usize, 159), word_map.get("and").?);

    wc.printWordCount(&word_map, "input/kernel.txt", wc.PrintFn{ .print = test_print_kernel });
}

fn test_print_prime(comptime fmt: []const u8, args: anytype) void {
    _ = fmt;
    var found: usize = 0;
    const fields = @typeInfo(@TypeOf(args)).Struct.fields;
    inline for (fields) |field| {
        if (field.field_type == []const u8) {
            if (!mem.eql(u8, @field(args, field.name), "input/prime.txt")) {
                return;
            }
        }

        if (field.field_type == usize) {
            const c = @field(args, field.name);
            if (c == 8218) {
                found = c;
            }
        }
    }
    if (found == 8218) { return; }
    unreachable;
}
test "prime input" {
    var lines = try wc.readToString("input/prime.txt");
    defer std.ArrayList(u8).fromOwnedSlice(alloc, lines).deinit();

    var word_map = try wc.wc(lines);
    defer word_map.deinit();

    try testing.expectEqual(@as(usize, 3), word_map.get("Thunderwing,").?);
    try testing.expectEqual(@as(usize, 2), word_map.get("Shockwave,").?);
    try testing.expectEqual(@as(usize, 20), word_map.get("Decepticons").?);
    try testing.expectEqual(@as(usize, 2), word_map.get("extraterrestrial").?);
    try testing.expectEqual(@as(usize, 4), word_map.get("\"The").?);

    wc.printWordCount(&word_map, "input/prime.txt", wc.PrintFn{ .print = test_print_prime });
}

test "tests show no diff" {
    var tests = try wc.readToString("./testbytes");
    defer std.ArrayList(u8).fromOwnedSlice(alloc, tests).deinit();

    for (tests) |*b| {
        b.* -= 1;
    }

    var main_file = try wc.readToString("./src/main.zig");
    defer std.ArrayList(u8).fromOwnedSlice(alloc, main_file).deinit();

    try testing.expect(mem.indexOf(u8, main_file, tests) != null);
}

const temple_expected = @embedFile("../out/temple.txt");
var templ_idx: usize = 0;
var templ_buf: [temple_expected.len]u8 = mem.zeroes([temple_expected.len]u8);
fn print_temple(comptime fmt: []const u8, args: anytype) void {
    const string = std.fmt.allocPrint(alloc, fmt, args) catch unreachable;
    defer alloc.destroy(string.ptr);

    for (string) |char| {
        templ_buf[templ_idx] = char;
        templ_idx += 1;
    }
}
test "compare output of temple" {
    var lines = @embedFile("../input/temple.txt");

    var word_map = try wc.wc(lines);
    defer word_map.deinit();

    wc.printWordCount(&word_map, "./temple.txt", wc.PrintFn{ .print = print_temple });

    try testing.expectEqualStrings(temple_expected, &templ_buf);
}
const kernel_expected = @embedFile("../out/kernel.txt");
var kernel_idx: usize = 0;
var kernel_buf: [kernel_expected.len]u8 = mem.zeroes([kernel_expected.len]u8);
fn print_kernel(comptime fmt: []const u8, args: anytype) void {
    const string = std.fmt.allocPrint(alloc, fmt, args) catch unreachable;
    defer alloc.destroy(string.ptr);

    for (string) |char| {
        kernel_buf[kernel_idx] = char;
        kernel_idx += 1;
    }
}
test "compare output of kernel" {
    var lines = @embedFile("../input/kernel.txt");

    var word_map = try wc.wc(lines);
    defer word_map.deinit();

    wc.printWordCount(&word_map, "./kernel.txt", wc.PrintFn{ .print = print_kernel });

    try testing.expectEqualStrings(kernel_expected, kernel_buf[0..kernel_expected.len]);
}
const prime_expected = @embedFile("../out/prime.txt");
var prime_idx: usize = 0;
var prime_buf: [prime_expected.len]u8 = mem.zeroes([prime_expected.len]u8);
fn print_prime(comptime fmt: []const u8, args: anytype) void {
    const string = std.fmt.allocPrint(alloc, fmt, args) catch unreachable;
    defer alloc.destroy(string.ptr);

    for (string) |char| {
        prime_buf[prime_idx] = char;
        prime_idx += 1;
    }
}
test "compare output of prime" {
    var lines = @embedFile("../input/prime.txt");

    var word_map = try wc.wc(lines);
    defer word_map.deinit();

    wc.printWordCount(&word_map, "./prime.txt", wc.PrintFn{ .print = print_prime });

    try testing.expectEqualStrings(prime_expected, prime_buf[0..prime_expected.len]);
}
const msno_expected = @embedFile("../out/msno.txt");
var msno_idx: usize = 0;
var msno_buf: [msno_expected.len]u8 = mem.zeroes([msno_expected.len]u8);
fn print_msno(comptime fmt: []const u8, args: anytype) void {
    const string = std.fmt.allocPrint(alloc, fmt, args) catch unreachable;
    defer alloc.destroy(string.ptr);

    for (string) |char| {
        msno_buf[msno_idx] = char;
        msno_idx += 1;
    }
}
test "compare output of msno" {
    var lines = @embedFile("../input/msno.txt");

    var word_map = try wc.wc(lines);
    defer word_map.deinit();

    wc.printWordCount(&word_map, "./msno.txt", wc.PrintFn{ .print = print_msno });

    try testing.expectEqualStrings(msno_expected, msno_buf[0..msno_expected.len]);
}

// test "convert to bytes" {
//     var tests = try wc.readToString("./out.txt");
//     for (tests) |*b| {
//         b.* += 1;
//     }
//     var fd = try fs.cwd().openFile("./testbytes", fs.File.OpenFlags{
//         .write = true,
//     });
//     defer fd.close();
//     var written = try fd.write(tests);
//     while (written < tests.len) { written += try fd.write(tests[written..]); }
// }
