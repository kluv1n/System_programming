#include <stdio.h>
#include <stdlib.h>

extern void init_array(long);       // Initialize array
extern void free_array();           // Free array memory
extern long arr_push(long);         // Push element to end
extern long arr_pop();              // Pop element from start
extern long count_odd();            // Count odd numbers
extern long count_even();           // Count even numbers
extern long ends_with_one();        // Count numbers ending with 1

int main() {
    long n, value;

    printf("Введите размер массива: ");
    scanf("%ld", &n);

    init_array(n);

    printf("Добавьте элементы в массив:\n");
    for (long i = 0; i < n; i++) {
        printf("Введите число: ");
        scanf("%ld", &value);
        arr_push(value);
    }

    printf("\nЧисло нечетных чисел: %ld\n", count_odd());
    printf("Число четных чисел: %ld\n", count_even());
    printf("Число чисел, оканчивающихся на 1: %ld\n", ends_with_one());

    printf("\nУдаляем элементы из начала массива:\n");
    for (long i = 0; i < n; i++) {
        printf("%ld\n", arr_pop());
    }

    free_array();
    return 0;
}
