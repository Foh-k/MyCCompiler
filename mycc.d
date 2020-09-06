import std.stdio; // writeln, writefln
import std.conv; // text
import std.container; // SList 
import std.array; // split, join
import std.algorithm.iteration; // map
import std.ascii; // isDigit

enum TokenKind
{
    operatorToken,
    numberToken,
    eofToken
}

struct Token
{
    TokenKind kind;
    int val;
    char op;
}

SList!Token tokenize(string pat)
{
    auto ret = SList!Token();

    // 空白除去
    auto p = pat.split().map!"text(a)".join();

    while (p.length > 0)
    {
        if (p[0].isPunctuation())
        {
            ret.insertAfter(ret[], Token(TokenKind.operatorToken, 0, parse!char(p)));
        }
        else if (p[0].isDigit())
        {
            ret.insertAfter(ret[], Token(TokenKind.numberToken, parse!int(p), ' '));
        }
        else
        {
            stderr.writeln("トークナイズできません");
            assert(0);
        }
    }

    ret.insertAfter(ret[], Token(TokenKind.eofToken, 0, ' '));
    return ret;
}

void main(string[] args)
{
    if (args.length != 2)
    {
        stderr.writeln("引数の個数が正しくありません");
        assert(0);
    }

    auto token = args[1].tokenize();

    writeln(".intel_syntax noprefix");
    writeln(".globl main");
    writeln("main:");
    writefln("  mov rax, %s", token.front().val);
    token.removeFront();

    while (!token.empty())
    {
        auto t = token.front();
        token.removeFront();
        if (t.kind == TokenKind.operatorToken && t.op == '+')
        {
            t = token.front();
            token.removeFront();

            writefln("  add rax, %s", t.val);

        }
        else if (t.kind == TokenKind.operatorToken && t.op == '-')
        {
            t = token.front();
            token.removeFront();

            writefln("  sub rax, %s", t.val);
        }
        else if (t.kind == TokenKind.eofToken)
        {
            break;
        }
        else
        {
            stderr.writeln("予期しない演算子");
            assert(0);
        }
    }

    writeln("   ret");
    return;
}
