/*
    トークン構造体の定義や
    トークンへの変換(トークナイズ)
    もしくはトークン列に対する操作を記述するモジュール
*/

module tokens;

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
            ret.insertAfter(ret[], Token(TokenKind.numberToken, parse!int(p),
                    ' ', loc + (prevLen - p.length)));
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
