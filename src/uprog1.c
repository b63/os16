#include "userlib.h" 
 
#define COL WIDTH-20
#define ROW HEIGHT-2

void main() { 
    int i=0; 
    int j=0;    
    int k=0; 
    int offset = 0;
    char *ptr;
    char buf[50];
  
    enableInterrupts(); 
 

    for(i=0; i < 100; i++) { 
        offset = strcpyn(buf, 50, "uprog1: ");
        offset += sprintInt(i, buf+offset, 50-offset);
        offset += strcpyn(buf+offset, 50-offset, " Hello");

        put_str(buf, CHAR_COLOR(3, 4), ROW, COL);
        for(j=0; j < 1000; j++) { 
             for(k=0; k < 1000; k++) { 
             } 
        } 
     } 

    ptr = buf;
    while (*ptr)
        *ptr++ = ' ';

    put_str(buf, CHAR_COLOR(0, 0), ROW, COL);
    // terminate ... 
    terminate(); 
}
