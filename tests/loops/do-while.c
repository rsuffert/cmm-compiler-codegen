#include <stdio.h>

int a;
int b;

int main() {
    a = 0;
    do {
        a++;
    } while (a < 2);
    printf("a: %d\n", a);

    b = 0;
    do {
        b++;
    } while (b < 0);
    printf("b: %d\n", b);

    return 0;
}