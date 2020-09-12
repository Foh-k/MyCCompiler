/*
    各種エラーを記述するためのクラスの定義がされているモジュール
    各操作のステップごとに対応するエラーを出力するためのメンバ関数が定義されている。
    基本的に全てのコンパイラに関するモジュールに対してimportする
*/

module myerr;

/// 引数の過不足を補足するためのクラス
class ArgsError : Error
{
    /// ユーザーの入力数
    ulong inputs;
    /// 期待する入力数
    ulong expect;

    /*
    コンストラクタ
    throw new ArgsError(ユーザーの入力数, (期待する入力数));
    で呼び出し
    */
    this(ulong inputs, ulong expect = 2, Throwable nextInChain = null) pure nothrow @nogc @safe
    {
        string msg = "引数の個数が正しくありません";
        super(msg, nextInChain);
        inputs = inputs;
        expect = expect;
    }

    /// エラー出力用関数
    void errWrite()
    {
        import std.stdio : stderr, writeln;

        stderr.writeln(msg);
        stderr.writeln("期待する入力数 : ", expect);
        stderr.writeln("実際の入力数 : ", inputs);
    }
}

/// トークナイズ時のエラーを補足するためのクラス
class TokenError : Error
{
    /// ユーザーの入力全体
    string userInput;
    /// エラーの発生した場所
    ulong errLoc;

    /*
    コンストラクタ
    throw new TokenError("入力文字列", エラー位置);
    で呼び出し
    */
    this(ulong loc, Throwable nextInChain = null) pure nothrow @nogc @safe
    {
        string msg = "トークナイズできません";
        super(msg, nextInChain);
        errLoc = loc;
    }

    /// エラー出力用関数
    void errWrite()
    {
        import std.stdio : stderr, writefln;
        import std.range : cycle, take;

        stderr.writeln(msg);
        stderr.writefln("(%s)文字目に不正な入力", errLoc);
    }
}

/// 構文エラーを補足するためのクラス
/// トークナイズ時のエラーを補足するためのクラス
class SyntaxError : Error
{
    /// ユーザーの入力全体
    string userInput;
    /// エラーの発生した場所
    ulong errLoc;

    /*
    コンストラクタ
    throw new SyntaxError("エラー内容", エラー位置);
    で呼び出し
    */
    this(string msg, ulong loc, Throwable nextInChain = null) pure nothrow @nogc @safe
    {
        super(msg, nextInChain);
        errLoc = loc;
    }

    /// エラー出力用関数
    void errWrite()
    {
        import std.stdio : stderr, writefln;

        stderr.writeln(msg);
        stderr.writefln("(%s)文字目に不正な入力", errLoc);
    }
}
