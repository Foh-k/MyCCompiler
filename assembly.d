/*
    何かしらの構造からアセンブリを出力するためのプログラム群
*/

module assembly;

import tokens, myerr;
import std.container : SList;

/// トークン列を受け取ってアセンブリに変換する関数
void toAssembly(ref SList!Token token)
{
    import std.conv : text;
    import std.stdio : writeln, writefln;

    writeln(".intel_syntax noprefix");
    writeln(".globl main");
    writeln("main:");
    writefln("  mov rax, %s", token.expect());

    while (!token.empty())
    {
        switch (token.front().kind)
        {
        case TokenKind.opToken:
            if (token.consume('+'))
                writefln("  add rax, %s", token.expect());
            else if (token.consume('-'))
                writefln("  sub rax, %s", token.expect());
            else
                throw new SyntaxError("予期しない演算子", token.front().loc);

            break;

        case TokenKind.numToken:
            throw new SyntaxError("不正な入力", token.front().loc);
            break;

        default: // eof
            token.removeFront();
            break;
        }
    }
    writeln("   ret");
    return;
}
