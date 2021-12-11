#include "userlib.h" 
 
void main() { 
    int i=0; 
    int j=0;    
    int k=0; 
  
    enableInterrupts(); 
 
    for(i=0; i < 10; i++) { 
        print_int(i);
        print_string(" Hello\n\r"); 
        for(j=0; j < 10000; j++) { 
             for(k=0; k < 1000; k++) { 
 
             } 
        } 
     } 
    // terminate ... 
    terminate(); 
}
