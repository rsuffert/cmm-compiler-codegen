#include <stdio.h>

int a;
int b;
int c;

int main() {
    a = 1;
    b = a + 2;
    c = a + 3 * b + 4;

    printf(" a (1)=  %d\n", a);
    printf(" b (3)=  %d\n", b);
    printf(" c (14)=  %d\n", c);

    return 0;
}