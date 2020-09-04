import std.stdio;
import std.conv;

void main(string[] args)
{
    if(args.length != 2)
    {
        stderr.writeln("引数の個数が正しくありません");
        return;
    }

    writeln(".intel_syntax noprefix");
    writeln(".globl main");
    writeln("main:");
    writefln("  mov rax, %s", args[1].to!int);
    writeln("   ret");
    return;
}
