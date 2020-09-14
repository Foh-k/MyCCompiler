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
    Node* node = list.unary();

    while (1)
    {
        if (list.consume('*'))
            node = new Node(NodeKind.MulNode, node, list.unary());
        else if (list.consume('/'))
            node = new Node(NodeKind.DivNode, node, list.unary());
        else
            return node;
    }
}

Node* unary(SList!(Token) list)
{
    if (list.consume('+'))
        return list.primary();

    if (list.consume('-'))
    {
        Node* dummy = new Node(0);
        Node* node = new Node(NodeKind.SubNode, dummy, list.primary());
        return node;
    }

    return list.primary();
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
