#include <stdio.h>

int a;
int b;

int main() {
    a = 1;
    while (a <= 5) {
        b = 0;
        while (b < 2) {
            a = a + 1;
            b = b + 1;
        }
    }
    return 0;
}