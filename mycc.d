import std.container : SList;
import myerr;

/// トークンの種類
enum TokenKind
{
    operatorToken,
    numberToken,
    eofToken
}

/// 各トークナイズされた値を保持。利用では連結リストを構成する
struct Token
{
    /// 保持しているトークンの種類
    TokenKind kind;
    /// トークンが数字である場合その値
    int val;
    /// トークンが記号である場合その種類
    char op;
    /// 全体の入力におけるそのトークンの位置
    ulong loc;
}

/// 入力引数の確認用関数
void checkArgs(ulong num)
{
    if (num != 2)
        throw new ArgsError(num);
}

/// トークナイズを行う関数。入力は評価したい式を文字列で
SList!Token tokenize(string pat)
{
    auto ret = SList!Token();
    ulong loc;
    auto p = pat;

    while (p.length > 0)
    {
        import std.ascii : isPunctuation, isDigit, isWhite;
        import std.conv : parse;

        if (p[0].isWhite())
        {
            p = p[1 .. $];
            loc++;
        }
        else if (p[0].isDigit())
        {
            ulong prevLen = p.length;
            ret.insertAfter(ret[], Token(TokenKind.numberToken,
                    parse!int(p), ' ', loc + (prevLen - p.length)));
            loc += (prevLen - p.length);
        }
        else if (p[0].isPunctuation())
        {
            ret.insertAfter(ret[], Token(TokenKind.operatorToken, 0, parse!char(p), loc++));
        }
        else
        {
            throw new TokenError(pat, loc);
        }
    }

    ret.insertAfter(ret[], Token(TokenKind.eofToken, 0, ' '));
    return ret;
}

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
        else if(t.kind == TokenKind.numberToken)
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

void main(string[] args)
{
    try
    {
        // 引数確認
        checkArgs(args.length);
        // トークナイズ
        auto token = tokenize(args[1]);
        // アセンブリ出力
        token.toAssembly();
    }
    catch (ArgsError e)
    {
        e.errWrite();
        assert(0);
    }
    catch (TokenError e)
    {
        e.errWrite();
        assert(0);
    }
    catch (SyntaxError e)
    {
        e.errWrite();
        assert(0);
    }
}
