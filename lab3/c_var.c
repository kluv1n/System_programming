#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]){
    int a = atoi(argv[1]);
    int b = atoi(argv[2]);
    int c = atoi(argv[3]);
    int res = ((((c*b)+a)-b)/c);
    printf("%d\n", res);
    return 0;
}