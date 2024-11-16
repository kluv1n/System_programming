#include <stdio.h>
#include <string.h>

#define MAX_ATTEMPTS 5
#define PASSWORD "secret123"

int main() {
    char input[50];
    int attempts = 0;

    while (attempts < MAX_ATTEMPTS) {
        printf("Введите пароль: ");
        scanf("%49s", input);

        if (strcmp(input, PASSWORD) == 0) {
            printf("Вошли\n");
            return 0;
        } else {
            printf("Неверный пароль\n");
        }

        attempts++;
    }

    printf("Неудача\n");
    return 0;
}
