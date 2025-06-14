#include <stdio.h>

int a;
int b;
int c;
int d;
int e;

int main() {
    a = 10;

    for ( b = 0; b < a;)
    {
        printf("b: %d\n", b);
        break;
    }
    for (; c < a;)
    {
        c++;
        printf("c: %d\n", c);
    }
    d = 0;
    for (e = 10;;) {
        if (d == 100) {
            printf("d: end %d\n", d);
            break;
        }
        d++;  
    }

    return 0;
}