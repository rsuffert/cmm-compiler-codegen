#include <stdio.h>

int res;
int e;
int f;

int twoParams(int a, int b) {
    int c;
    int d;
    c = 12;
    d = 23;
    e = 30;
    printf("a: %d\n", a);
    printf("b: %d\n", b);
    printf("c: %d\n", c);
    printf("d: %d\n", d);
    printf("e: %d\n", e);
    printf("f: %d\n", f);
    return f + c * d;
}

int main() {
    f = 50;
    res = twoParams(2, 3);
    printf("twoParams result: %d\n", res);
    return 0;
}