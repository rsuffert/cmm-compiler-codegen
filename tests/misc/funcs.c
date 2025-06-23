#include <stdio.h>

int e;

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
    return 0;
}

int main() {
    twoParams(2, 3);
    return 0;
}