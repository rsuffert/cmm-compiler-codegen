#include <stdio.h>

int n1;
int n2;

int main() {
    n1 = 48;
    n2 = 18;

    while (n1 != n2) {
        if (n1 > n2) {
            n1 = n1 - n2;
        } else {
            n2 = n2 - n1;
        }
    }

    printf("Greatest common divisor: %d\n", n1);

    return 0;
}