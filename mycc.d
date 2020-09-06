import std.stdio;
import std.conv;

void main(string[] args)
{
    if (args.length != 2)
    {
        stderr.writeln("引数の個数が正しくありません");
        return;
    }

    writeln(".intel_syntax noprefix");
    writeln(".globl main");
    writeln("main:");
    writefln("  mov rax, %s", parse!int(args[1]));

    while (args[1].length > 0)
    {
        auto op = parse!char(args[1]);
        if (op == '+')
        {
            writefln("  add rax, %s", parse!int(args[1]));
        }
        else if (op == '-')
        {
            writefln("  sub rax, %s", parse!int(args[1]));
        }
        else
        {
            // Error
            stderr.writeln("予期しない入力です");
        }
    }

    writeln("   ret");
    return;
}
