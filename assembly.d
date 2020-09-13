/*
    何かしらの構造からアセンブリを出力するためのプログラム群
*/

module assembly;

import tokens, rdp, myerr;

/// 構文木を受け取ってアセンブリに変換する関数
void toAssembly(Node* node)
{
    import std.stdio : writeln, writefln;

    writeln(".intel_syntax noprefix");
    writeln(".globl main");
    writeln("main:");

    node.gen();

    writeln("   pop rax");
    writeln("   ret");
    return;
}

/// 構文木からスタックマシンをエミュレートする関数
void gen(Node* node)
{
    import std.stdio : writeln, writefln;

    if (node.nkind == NodeKind.NumNode)
    {
        writefln("   push %s", node.val);
        return;
    }

    gen(node.lhs);
    gen(node.rhs);

    writeln("   pop rdi");
    writeln("   pop rax");

    switch (node.nkind)
    {
    case NodeKind.AddNode:
        writeln("   add rax, rdi");
        break;
    case NodeKind.SubNode:
        writeln("   sub rax, rdi");
        break;
    case NodeKind.MulNode:
        writeln("   imul rax, rdi");
        break;
    case NodeKind.DivNode:
        writeln("   cqo");
        writeln("   idiv rdi");
        break;
    default:
        assert(0);
        break;
    }

    writeln("   push rax");
}
