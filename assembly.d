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

    if (node.nkind == NodeKind.numnode)
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
    case NodeKind.addNode:
        writeln("   add rax, rdi");
        break;
    case NodeKind.subNode:
        writeln("   sub rax, rdi");
        break;
    case NodeKind.mulnode:
        writeln("   imul rax, rdi");
        break;
    case NodeKind.divNode:
        writeln("   cqo");
        writeln("   idiv rdi");
        break;
    default:
        assert(0);
        break;
    }

    writeln("   push rax");
}
