#include <stdio.h>

int n;
int original;
int reversed;
int digit;

int main() {
    n = 123321;
    original = n;
    reversed = 0;

    while (n > 0) {
        digit = n % 10;
        reversed = reversed * 10 + digit;
        n = n / 10;
    }

    if (reversed == original) {
        printf("Is palindrome!\n");
    } else {
        printf("Is not palindrome...\n");
    }

    return 0;
}