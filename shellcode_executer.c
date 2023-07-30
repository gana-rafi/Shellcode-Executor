#include <sys/mman.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stddef.h>


int main (int argc, char* argv[]){
  if (argc < 2) {
      printf("USAGE: %s {shellcode file}", argv[0]);
  }

  FILE *f = fopen(argv[1], "rb");
  fseek(f, 0, SEEK_END);
  size_t fsize = ftell(f);
  fseek(f, 0, SEEK_SET);  /* same as rewind(f); */

  uint8_t *shellcode = mmap(NULL, fsize + 1, PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
  fread(shellcode, 1, fsize, f);
  fclose(f);

  mprotect(shellcode, fsize + 1, PROT_READ | PROT_EXEC);
    
  ((void (*)())shellcode)();
}
