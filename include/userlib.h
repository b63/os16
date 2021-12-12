#ifndef USER_LIB
#define USER_LIB

#define WIDTH   80
#define HEIGHT  25
#define CHAR_COLOR(FG,BG) ((BG << 4) | (FG & 0x7))

/**
 * Prints the characters starting from the address
 * pointed to by str till a null is reached.
 * 
 * str            pointer to character to print
 */
int print_string(char*);

/**
 * Prints the given integer in base 10.
 *    x    the integer to print to screen
 * Return: number of characters printed
 */
int print_int(int);

/**
 * readChar: read a character from the keyboard.   
 *  c     The address of byte into which to place the 
 *        character read from the keyboard.
 * Return: 1  
 */
int read_char(char*);

/**
 * Reads characters until a carriage-return is read.
 * Backspace/Delete removes characters from screen.
 * The second parameters denotes the size of the buffer
 * given; no more than n characters will be written to buf.
 *
 * buf           pointer to start of buffer
 * n             size of buffer; maximum number of characters
 *               written is n-1 (last is for null terminator)
 *
 * Returns the number of characters read.
 */
int read_string(char*, int);

/**
 * Reads file from disk and loads it into buf of size n
 *   filename     name of file to search for
 *   buf          buffer to write contents of file
 *   n            maximum size of buffer
 * Returns: number of sectors read (even if buf is not  big
 *          enough to store all of the last sector)
 *
 */
int read_file(char*, char*, int);

/**
 * Reads file same name and loads it into free segment.
 *   name      char* to name of file
 *   blockopt  whether to block running process until spawned one is done
 * Returns: -2 if no free segment, -1 if file not found, -3 if not executable
 */
int execute(char*, int);

/**
 * Delete file from disk with name file.
 *   file    pointer to null-terminated string of name of file to delete
 *
 * Returns 1 is succesfully deleted, -1 if not found.
 */
int delete_file(char *file);

/**
 * Write sectors number of sectors to disk from buffer
 * under file name file. At most 26 sectors are written.
 *   file         pointer to name of file
 *   buffer       point to buffer, must be at least sectors*512 in size
 *   sectors      number of sectors to write, clipped to 26
 *
 * Returns the number of sectors written, or 
 *         -1 if there is no Disk Directory entry available for the file, or 
 *         -2 if there are insufficient free sectors to hold the file
 */
int write_file(char *file,  char *buffer, int sectors);

/**
 * Reads in the disk directory to buffer.
 * Returns 1.
 */
int read_disk_dir(char *buffer);

/**
 * syscall to hand control over to kernel, permanently.
 * Runs the shell.
 */
void terminate();

// yeidl rest of time slice
void yeild();

// kill process running on given segment index 
int kill(int segment);

// sleep for time number of seconds
int sleep(int time);

// diplay list of processes
int show_processes();

// put string starting at row and col
int put_str(char *ptr, char color, int row, int col);

// write int to dst buffer
int sprintInt(int x, char *dst, int n);

// copy string from one buf to another
int strcpyn(char *dst, int n, char *src);

// enable ignorable interrupts
extern void enableInterrupts();

#endif
