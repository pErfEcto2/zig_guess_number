const std = @import("std");

const rand_gen = std.Random.DefaultPrng;
const stdin = std.io.getStdIn().reader();
const print = std.debug.print;
const alloc = std.heap.page_allocator;

pub fn main() !void {
    var rand = rand_gen.init(@as(u64, @intCast(std.time.microTimestamp())));
    const N = 100;
    var num = rand.random().int(u32) % (N + 1);
    var buf = std.ArrayList(u8).init(alloc);
    defer buf.deinit();

    print("try to guess the number from 0 to {}\n", .{N});

    while (true) {
        print("ur guess: ", .{});
        buf.clearRetainingCapacity();

        _ = stdin.streamUntilDelimiter(buf.writer(), '\n', 10) catch {
            print("input is too long\n", .{});
            continue;
        };

        const tmp = std.fmt.parseInt(u32, buf.items, 10) catch {
            print("invalid input\n", .{});
            continue;
        };

        if (num == tmp) {
            print("u guessed!\ndo u wanna play again?(y = yes, anything else = no) ", .{});
            buf.clearRetainingCapacity();
            _ = stdin.streamUntilDelimiter(buf.writer(), '\n', 2) catch {
                break;
            };

            if (buf.items[0] == 'y') {
                num = rand.random().int(u32) % (N + 1);
                continue;
            } else break;
        } else if (tmp > num) {
            print("my number is less\n", .{});
        } else {
            print("my number is bigger\n", .{});
        }
    }
}
