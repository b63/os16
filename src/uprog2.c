
#include "userlib.h"

// main method
int main() 
{
    enableInterrupts();
    // print the string to screen
    print_string("Something different!\n\r");
    // terminate ...
    terminate();
}
