#include <stdio.h>

int i;
int j;
int k;
int f;

int main() {
    f = 0;
    for(i = 0; i < 5; i++) {
        for(j = 0; j < 5; j++) {
            if (j == 0) {
                continue;
            }

            if (j > 2) {
                break;
            }

            k = 0;
            do {
                k++;
            } while (k < j);
            f += k;
            printf("k: %d\n", k);

            k = 0;
            while(k < i) {
                k++;
            }
            f += k;
            printf("k: %d\n", k);
        }
    }
    printf("f: %d\n", f);

    return 0;
}