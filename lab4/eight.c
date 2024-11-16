#include <stdio.h>

int alternateWithZero(int n) {
    int result = 0;
    int multiplier = 1;
    while (n > 0) {
        int digit = n % 10;
        result += digit * multiplier;
        multiplier *= 100;
        n /= 10;
    }

    return result;
}

int main() {
    int number;
    printf("Введите число: ");
    scanf("%d", &number);
    int result = alternateWithZero(number);
    printf("Результат: %d\n", result);

    return 0;
}
