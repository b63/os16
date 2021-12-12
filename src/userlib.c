#include "userlib.h"

// defined in lib.asm
extern int interrupt(int, int, int, int, int);


int yield()
{
    return interrupt(0x21, 0x09, 0, 0, 0);
}

int kill(int segment)
{
    return interrupt(0x21, 0x0b, segment, 0, 0);
}

int sleep(int time)
{
    return interrupt(0x21, 0xa1, time, 0, 0);
}


int show_processes()
{
    return interrupt(0x21, 0x0a, 0, 0, 0);;
}


int put_str(char *ptr, char color, int row, int col)
{
    return interrupt(0x21, 0xff, ptr, color, (row << 8) | (col & 0xff)); 
}


// call interrupt with right arguments
int print_string(char *ptr) 
{ 
    return interrupt(0x21, 0x00, ptr, 0, 0); 
}

// call interrupt with right arguments
int read_char(char *buf)
{ 
    return interrupt(0x21, 0x11, buf, 0, 0); 
}

// call interrupt with right arguments
int read_string(char *buf, int n)
{ 
    return  interrupt(0x21, 0x01, buf, n, 0); 
}

// call interrupt with right arguments
int read_file(char *file, char *buf, int n)
{ 
    return interrupt(0x21, 0x03, file, buf, n); 
}

// call interrupt with right arguments
int read_disk_dir(char *buffer)
{ 
    // actual file names can't be > 6 bytes so it should be ok
    char *filename = "__DISK_DIRECTORY";
    return interrupt(0x21, 0x03, filename, buffer, 1); 
}

// call interrupt with right arguments
int execute(char *file, int blockopt)
{ 
    return interrupt(0x21, 0x04, file, blockopt, 0); 
}

// call interrupt with right arguments
int delete_file(char *file)
{
    return interrupt(0x21, 0x07, file, 0, 0); 
}

// call interrupt with right arguments
int write_file(char *file,  char *buffer, int sectors)
{
    return interrupt(0x21, 0x08, file, buffer, sectors); 
}

// call interrupt with right arguments
void terminate()
{
    interrupt(0x21, 0x05, 0, 0, 0);
}

/**
 * Prints the given integer in base 10.
 *    x    the integer to print to screen
 * Return: number of characters printed
 */
int print_int(int x)
{
    // should be enough to hold 32-bit ints
    char buf[12];
    char *ptr = buf+11; // point to end of buf
    int q, r; // quotient, remainder
    int sign = 1; // default positive

    // null terminate buf
    *ptr = 0;
    // check sign
    if (x < 0)
    {
        // note down as negative and make positive (could overflow but who cares YOLO)
        sign = -1;
        x = -x;
    }
    else if (x == 0)
    {
        // x is zero so write digit 0 and skidaddle 
        *(--ptr) = '0';
    }

    // go until x is zero
    while (x > 0)
    {
        // get digit in ones place
        q = x/10;
        r = x - q*10;
        // write the digit to appropriate place
        *(--ptr) = r + '0';
        x = q;
    }

    if (sign < 0)
    {
        // if it was negative add in the sign
        *(--ptr) = '-';
    }

    // print the digits to the screen
    return print_string(ptr);
}


/**
 * Prints the given integer in base 10 to the given buffer.
 *    x        the integer to print to screen
 *    dst      buffe rto write to
 *    n        maximum size of buffer
 * Return: maximum number of characters written.
 */
int sprintInt(int x, char *dst, int n)
{
    // should be enough to hold 32-bit ints
    char buf[12];
    char *ptr = buf+11; // point to end of buf
    int q, r; // quotient, remainder
    int sign = 1; // default positive

    // null terminate buf
    *ptr = 0;
    // check sign
    if (x < 0)
    {
        // note down as negative and make positive (could overflow but who cares YOLO)
        sign = -1;
        x = -x;
    }
    else if (x == 0)
    {
        // x is zero so write digit 0 and skidaddle 
        *(--ptr) = '0';
    }

    // go until x is zero
    while (x > 0)
    {
        // get digit in ones place
        q = x/10;
        r = x - q*10;
        // write the digit to appropriate place
        *(--ptr) = r + '0';
        x = q;
    }

    if (sign < 0)
    {
        // if it was negative add in the sign
        *(--ptr) = '-';
    }

    strcpyn(dst, n, ptr);
    r = (buf+11) - ptr;

    return  n-1 < r ? n-1 : r;
}


/**
 * Copy at most n-1 bytes to buffer from null-terminated string src.
 * dst will be null-terminated.
 *   dst   destination buffer
 *   n     size of dst
 *   src   source buffer
 *  Returns: the number of bytes copied from src to dst
 */
int strcpyn(char *dst, int n, char *src)
{
    char *ptr = dst;
    while (*src && --n)
        *(ptr++) = *(src++);
    *ptr = 0;

    return ptr - dst;
}
