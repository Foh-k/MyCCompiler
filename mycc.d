import myerr, tokens, rdp, assembly;
// import tools.convgraph; // デバッグ用


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
        // 字句解析
        auto token = tokenize(args[1]);
        // 構文解析
        auto tree = token.expr();
        // tree.writeGraphviz(); // デバッグ用
        // アセンブリ出力
        tree.toAssembly();
    }
    catch (ArgsError e)
    {
        e.errWrite();
        assert(0);
    }
    catch (LexicalError e)
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
