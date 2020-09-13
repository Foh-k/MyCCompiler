module tools.convgraph;

import std;

class Name
{
    private long n;
    this(long num)
    {
        this.n = num;
    }

    string getName()
    {
        return n.to!string;
    }

    string next()
    {
        this.n += 1;
        return n.to!string;
    }
}

/// treeは二分木であり、rhs,lhsに子ノードを保持している。
void writeGraphviz(T)(T* root)
{
    writeln("digraph G {");
    auto name = new Name(0);
    writef("%s -> ", name.getName());

    void writeNode(T)(T* node)
    {
        string s = name.next();
        writeln(s);

        // 子ノードを持つ場合、必ず子は2つ
        if (!(node.rhs && node.lhs))
        {
            writefln(`%s [label="%s"]`, s, node.val);
            return;
        }

        writefln(`%s [label="%s"]`, s, node.nkind);
        writef("%s -> ", s);
        writeNode(node.rhs);
        writef("%s -> ", s);
        writeNode(node.lhs);
    }

    writeNode(root);
    writeln("}");
}
