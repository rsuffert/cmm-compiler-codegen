#include <stdio.h>

int num;
int i;
int div;
int sum;
int count;
int n;

int main() {
    n = 3;
    num = 2;
    count = 0;

    while (count < n) {
        sum = 0;

        for(div=1; div<num; div++) {
            if (num % div == 0) {
                sum += div;
            }
        }

        if (sum == num) {
            printf("Found a perfect number: %d\n", num);
            count++;
        }

        num++;
    }

    return 0;
}