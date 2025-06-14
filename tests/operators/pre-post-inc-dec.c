#include <stdio.h>

int a;
int b;
int c;
int d;

int main() {
    a = 10;
    b = a++;
    c = ++a;
    d = a-- + --b;

    printf("a: %d\n", a);
    printf("b: %d\n", b);
    printf("c: %d\n", c);
    printf("d: %d\n", d);

    return 0;
}