#include <stdio.h>

int n;

int main() {
    n = 13;

    while(n != 1) {
        printf(" %d\n", n);
        if (n % 2 == 0) {
            n = n / 2;
        } else {
            n = (3 * n) + 1;
        }
    }
    printf(" 1\n");

    return 0;
}