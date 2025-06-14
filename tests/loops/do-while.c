#include <stdio.h>

int a;
int b;

int main() {
    a = 0;
    b = 0;
    do {
        a++;
        b += 2;
    } while (a < 2);
    printf("a: %d\n", a);
    printf("b: %d\n", b);

    b = 0;
    do {
        a += 2;
        b++;
    } while (b < 0);
    printf("a: %d\n", a);
    printf("b: %d\n", b);

    return 0;
}