#include <stdio.h>

int a;
int b;
int c;
int d;
int e;

int main() {
    a = 10;

    for (b = 0; b < a; b++) {
        printf("b: %d\n", b);
    }

    for (;;) {
        c++;
        printf("c: %d\n", c);
        break;
    }

    d = 0;

    for (e = 10; e != d; e--) {
        if (e != 2) {
            d++;
            printf("d: %d\n", d);
            continue;
        }
    }

    return 0;
}