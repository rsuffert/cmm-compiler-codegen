#include <stdio.h>

int res;

int add(int a, int b) {
    int res;

    if (b == 0) {
        res = a;
    } else {
        res = add(++a, --b);
    }

    return res;
}

int main() {
    res = add(3, 2);
    printf("res: %d\n", res);
    return 0;
}