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

    string exp;

    if (token.front().kind != TokenKind.numberToken)
    {
        exp = exp.text(token.front().op);
        throw new SyntaxError("数ではありません", exp, exp.length);
    }
    writeln(".intel_syntax noprefix");
    writeln(".globl main");
    writeln("main:");
    writefln("  mov rax, %s", token.front().val);
    exp = exp.text(token.front().val);
    token.removeFront();

    while (!token.empty())
    {
        auto t = token.front();
        token.removeFront();
        exp = exp.text(t.op);

        if (t.kind == TokenKind.operatorToken && t.op == '+')
        {
            t = token.front();
            token.removeFront();

            if (t.kind != TokenKind.numberToken)
            {
                exp = exp.text(t.op);
                throw new SyntaxError("数ではありません", exp, exp.length);
            }

            writefln("  add rax, %s", t.val);
            exp = exp.text(t.val);

        }
        else if (t.kind == TokenKind.operatorToken && t.op == '-')
        {
            t = token.front();
            token.removeFront();

            if (t.kind != TokenKind.numberToken)
            {
                exp = exp.text(t.op);
                throw new SyntaxError("数ではありません", exp, exp.length);
            }

            writefln("  sub rax, %s", t.val);
            exp = exp.text(t.val);
        }
        else if (t.kind == TokenKind.eofToken)
        {
            break;
        }
        else if (t.kind == TokenKind.numberToken)
        {
            exp = exp.text(t.val);
            throw new SyntaxError("不正な入力", exp, exp.length);
        }
        else
        {
            exp = exp.text(t.op);
            throw new SyntaxError("予期しない演算子", exp, exp.length);
        }
    }
    writeln("   ret");
    return;
}
