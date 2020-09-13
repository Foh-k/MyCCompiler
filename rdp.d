/*
    再帰的下降構文解析(recursive decent parsing)を行うためのモジュール
    それぞれのノードの属性とそのノードによって構成される二分木を定義している。
*/

module rdp;

import std.container : SList;
import myerr, tokens;

enum NodeKind
{
    AddNode,
    SubNode,
    MulNode,
    DivNode,
    NumNode
}

/// 2種類のコンストラクタを持つ、木構造を形成する構造体
struct Node
{
    NodeKind nkind;
    Node* lhs;
    Node* rhs;
    int val;

    this(NodeKind kind, Node* lhs, Node* rhs)
    {
        this.nkind = kind;
        this.lhs = lhs;
        this.rhs = rhs;
    }

    this(int num)
    {
        this.nkind = NodeKind.NumNode;
        this.val = num;
    }
}

Node* expr(SList!(Token) list)
{
    Node* node = list.mul();

    while (1)
    {
        if (list.consume('+'))
            node = new Node(NodeKind.AddNode, node, list.mul());
        else if (list.consume('-'))
            node = new Node(NodeKind.SubNode, node, list.mul());
        else
            return node;
    }
}

Node* mul(SList!(Token) list)
{
    Node* node = list.primary();

    while (1)
    {
        if (list.consume('*'))
            node = new Node(NodeKind.MulNode, node, list.primary());
        else if (list.consume('/'))
            node = new Node(NodeKind.DivNode, node, list.primary());
        else
            return node;
    }
}

Node* primary(SList!(Token) list)
{
    if (list.consume('('))
    {
        Node* node = expr(list);
        if (list.consume(')'))
            return node;
        else
            throw new SyntaxError(")が終わっていません", list.front().loc);
    }

    Node* node = new Node(list.expect());
    return node;
}

/// デバッグ用の木構造出力関数。だいぶ見にくいのでなんか改良考えないとなぁ…
void treeWrite(Node* root)
{
    import std.container : DList;
    import std.stdio : write, writeln;

    auto q = new DList!(Node*)(root);
    while (!q.empty())
    {
        auto f = q.front();
        q.removeFront();
        if (f.nkind == NodeKind.NumNode)
            write(f.val, "  ");
        else
            write(f.nkind, "  ");

        if (f.lhs)
            q.insertBack(f.lhs);
        if (f.rhs)
            q.insertBack(f.rhs);
    }
    writeln();
}
