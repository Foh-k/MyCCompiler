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
    opToken,
    numToken,
    eofToken
}

/// 各トークナイズされた値を保持。利用では連結リストを構成する
struct Token
{
    /// 保持しているトークンの種類
    TokenKind tkind;
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
            ret.insertAfter(ret[], Token(TokenKind.numToken, parse!int(p),
                    ' ', loc + (prevLen - p.length)));
            loc += (prevLen - p.length);
        }
        else if (p[0].isPunctuation())
        {
            ret.insertAfter(ret[], Token(TokenKind.opToken, 0, parse!char(p), loc++));
        }
        else
        {
            throw new LexicalError("トークナイズできません", loc);
        }
    }

    ret.insertAfter(ret[], Token(TokenKind.eofToken, 0, ' '));
    return ret;
}

/*
    次の値が期待する記号か調べる
    リストから渡される。sl.consume(値)って感じ。
    もし次のやつが数字のトークンなら構文エラー
*/
bool consume(SList!(Token) list, char t)
{
    if (list.front().tkind == TokenKind.opToken)
    {
        if (list.front().op == t)
        {
            list.removeFront();
            return true;
        }
    }

    return false;
}

/*
    次の値が数ならばその値を返す
    sl.expext();で呼び出し
    それ以外ならば構文エラー
*/
int expect(SList!(Token) list)
{
    if (list.front().tkind == TokenKind.numToken)
    {
        immutable int ret = list.front().val;
        list.removeFront();
        return ret;
    }
    else
    {
        throw new SyntaxError("数ではありません", list.front().loc);
    }
}
