#include <stdio.h>

int n;
int reversed;
int digit;

void main() {
    n = 1234;
    reversed = 0;

    while (n > 0) {
        digit = n % 10;
        reversed = reversed * 10 + digit;
        n = n / 10;
    }

    printf("Reversed: %d\n", reversed);
}