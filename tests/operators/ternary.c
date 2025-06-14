#include <stdio.h>

int a;
int b;
int c;
int d;

int main() {
    a = 7;
    b = 12;
    c = (a > b) ? a : b;
    d = (a > b) ? a : ((b > 10) ? b : 0);

    printf("a: %d\n", a);
    printf("b: %d\n", b);
    printf("c: %d\n", c);
    printf("d: %d\n", d);

    return 0;
}