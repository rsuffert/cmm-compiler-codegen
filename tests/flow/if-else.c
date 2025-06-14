#include <stdio.h>
#include <stdbool.h>

int a;
int b;
bool greater;

int main() {
    a = 10;
    b = 11;

    greater = a > b;

    if (greater) {
        printf("GREATER!\n");
    } else {
        printf("LESS!\n");
    }

    printf("a: %d\n", a);
    printf("b: %d\n", b);

    return 0;
}