#include <stdio.h>

int main() {
    int n, count = 0;
    printf("Введите значение n: ");
    scanf("%d", &n);
    for (int i = 1; i <= n; i++) {
        if (i % 5 == 0 && i % 3 != 0 && i % 7 != 0) {
            count++;
        }
    }
    printf("Количество целых чисел: %d\n", count);

    return 0;
}
