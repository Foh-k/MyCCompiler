import myerr, tokens, assembly;

/// 入力引数の確認用関数
void checkArgs(ulong num)
{
    if (num != 2)
        throw new ArgsError(num);
}

void main(string[] args)
{
    import std.container : SList;

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
