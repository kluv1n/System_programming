#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]){
    if(argc==3){
        int b = atoi(argv[1]);
        int c = atoi(argv[2]);
        int res = (((c-b)-b)/b);
        printf("%d\n", res);
    }else{
        printf("wrong");
    }
    return 0;
}