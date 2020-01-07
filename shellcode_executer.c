#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>


int main (int argc, char* argv[]){
    if (argc < 2) {
        printf("USAGE: %s {shellcode file}", argv[0]);
    }

    FILE *f = fopen(argv[1], "rb");
    fseek(f, 0, SEEK_END);
    long fsize = ftell(f);
    fseek(f, 0, SEEK_SET);  /* same as rewind(f); */

    uint8_t *shellcode = malloc(fsize + 1);
    fread(shellcode, 1, fsize, f);
    fclose(f);


    ((void (*)())shellcode)();
}
