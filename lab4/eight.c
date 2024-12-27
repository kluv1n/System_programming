#include <stdio.h>

int alternating_zero_number(int num) {
    int result = 0, factor = 1;
    while (num > 0) {
        result += (num % 10) * factor;
        factor *= 100;
        num /= 10;
    }
    return result;
}

int main() {
    int num;
    printf("Введите число: ");
    scanf("%d", &num);
    printf("Результат: %d\n", alternating_zero_number(num)*10);
    return 0;
}
