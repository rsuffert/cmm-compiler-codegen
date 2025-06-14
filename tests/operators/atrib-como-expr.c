#include <stdio.h>

int a;
int b;
int c;

int main() {
    a = 1;
    b = a + 2;
    a = (b = (c = 7) * 3) + 2;

    printf("a (23)=%d\n", a);
    printf("b (21)=%d\n", b);
    printf("c (7)=%d\n", c);

    return 0;
}
