#include <stdio.h>

int a;
int b;
int c;

int main() {
    a = 5;
    b = 10;
    a += 3;
    c = a += b;
    printf("a: %d\n", a);
    printf("b: %d\n", b);
    printf("c: %d\n", c);
    
    return 0;
}