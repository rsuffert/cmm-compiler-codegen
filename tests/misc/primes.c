#include <stdio.h>
#include <stdbool.h>

int i;
int n;
bool isPrime;

int main() {
    n = 29;
    isPrime = true;

    for(i=2; i<n; i++) {
        if (n % 2 == 0) {
            isPrime = false;
            break;
        }
    }

    if (isPrime) {
        printf("The number is prime!\n");
    } else {
        printf("The number is not prime...\n");
    }
}