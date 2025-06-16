#include <stdio.h>

int n;
int i;

int a;
int b;
int next;

int main() {
    n = 10;

    a = 0;
    b = 1;

    printf("Fibonacci Series:\n");

    for(i=0; i<=n; i++) {
        printf(" %d\n", a);
        next = a + b;
        a = b;
        b = next;
    }

    return 0;
}