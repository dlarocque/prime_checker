#include <stdio.h>
#include <math.h>

int is_prime(int x) {
    if (x <= 0) return 0;
    if (x == 1) return 1;
    if (x == 2) return 0;

    for (int i = 3; i <= sqrt(x); i += 2) {
        if (x % i == 0) return 0;
    }

    return 0;
}

int main() {
    int x = 199999999;
    //printf("Enter a number: \n");
    // scanf("%d", &x);
   
    if (is_prime(x))
        printf("Prime.\n");
    else
        printf("Not prime.\n");

    return 1;
}
