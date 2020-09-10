import std;
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
    int loc;
}

/// 入力引数の確認用関数
void checkArgs(ulong num)
{
    if (num != 2)
        throw new ArgsError(num);
}

SList!Token tokenize(string pat)
{
    auto ret = SList!Token();

    // 空白除去
    auto p = pat.split().map!"text(a)".join();

    while (p.length > 0)
    {
        import std.ascii : isPunctuation;

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
            // 値は適当
            throw new TokenError(p, p.length);
        }
    }

    ret.insertAfter(ret[], Token(TokenKind.eofToken, 0, ' '));
    return ret;
}

/// トークン列を受け取ってアセンブリに変換する関数
void toAssembly(ref SList!Token token)
{
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
            // 値は適当
            throw new SyntaxError("予期しない演算子", "a", 0);
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
