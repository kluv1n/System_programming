# include <stdio.h>

int main() {
    long long number = 4731757613;
    int sum = 0;

    while (number > 0) {
        sum += number % 10;
        number /= 10;      
    }

    printf("%d\n", sum);
    return 0;
}