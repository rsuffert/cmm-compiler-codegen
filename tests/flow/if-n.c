#include <stdio.h>

int a;
int b;

int main() {
    a = 1;
    b = 2;

    if (a > b && a != 0) {
        printf("A is better\n");
    } else {
        printf("B is better\n");
    }

    printf("a: %d\n", a);
    printf("b: %d\n", b);

    return 0;
}