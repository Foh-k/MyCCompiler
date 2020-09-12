#!/bin/bash
assert(){
    expected="$1"
    input="$2"

    ./mycc "$input" > tmp.s
    cc -o tmp tmp.s
    ./tmp
    actual="$?"

    if [ "$actual" = "$expected" ]; then
        echo "$input => $actual"
    else
        echo "$expected expected, but got $actual"
        exit 1
    fi
}

assert 24 "4 + 20"
assert 46 "12 + 34 - 5 + 5"

echo OK