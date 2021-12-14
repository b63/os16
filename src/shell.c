#include "userlib.h"

// size of buffer to store read in line
#define LINE      256
// size of buffer to store command
#define CMD       256
// size of buffer to store argument to command
#define ARG       256
// size of maximum file in bytes
#define MAX_FILE  13312

int split(char *line, char *cmd, char *arg);

// utility functions (same as in kernel.c)
int strcmpn(char *a, char *b, int n);
int strcmp(char *a, char *b);
int atoi(char *str, int *x);

void copy_command(char *src, char *dst);
void dir_command();
void delete_command(char *fname);
void execute_command(char *fname, int blockopt);
void type_command(char *fname);

int main() {
    // buffer to store line read in
    char line[LINE];
    // buffer to store the command 
    char cmd[CMD];
    // buffer to store the rest of line after command
    char arg[ARG]; 
    // first argument if multiple
    char arg0[ARG]; 
    // second argument if multiple
    char arg1[ARG]; 
    // status returned by syscall
    int status;
    // store an parsed integers
    int x = -1;

    enableInterrupts();

    // infinite loop
    while (1)
    {
        // print shell prompt
        print_string("Shell> ");
        // read till enter (\r) into line buffer
        read_string(line, LINE);
        // go to new line
        print_string("\n\r");

        // split the line that was just read in
        split(line, cmd, arg);

        // check if cmd is type
        if (strcmp(cmd, "type"))
        {
            if (!*arg) {
                print_string("type <name>\n\r");
                continue;
            }

            type_command(arg);
        }
        else if (strcmp(cmd, "execute")) // check if 'execute'
        {
            split(arg, arg0, arg1);
            if (!*arg0 || (*arg1 && !strcmp(arg1, "&"))) 
            {
                print_string("execute <name> [&]\n\r");
                continue;
            }
            execute_command(arg0, *arg1 != '&');
        }
        else if (strcmp(cmd, "delete"))
        {
            if (!*arg) {
                print_string("delete <name>\n\r");
                continue;
            }

            delete_command(arg);
        }
        else if (strcmp(cmd, "copy"))
        {
            *arg1 = 0;
            split(arg, arg0, arg1);
            if (!*arg1 || !*arg0)
            {
                print_string("copy <src> <dst>\n\r");
                continue;
            }

            copy_command(arg0, arg1);
        }
        else if (strcmp(cmd, "dir"))
        {
            dir_command();
        }
        else if (strcmp(cmd, "ps"))
        {
            show_processes();
        }
        else if (strcmp(cmd, "kill"))
        {
            if (!*arg)
            {
                print_string("kill <segment index>\n\r");
                continue;
            }

            // try to parse the integer
            if (atoi(arg, &x))
            {
                print_string("error: unable to parse ");
                print_string(arg);
                print_string("\n\r");
                continue;
            }

            kill(x);
        }
        else if (strcmp(cmd, "sleep"))
        {
            if (!*arg)
            {
                print_string("sleep <seconds>\n\r");
                continue;
            }

            // try to parse the integer
            if (atoi(arg, &x))
            {
                print_string("error: unable to parse ");
                print_string(arg);
                print_string("\n\r");
                continue;
            }

            sleep(x);
        }
        else if (*cmd)
        {
            // unkown comand
            print_string("unrecognized command: ");
            print_string(cmd);
            print_string("\n\r");
        }
    }
}

/**
 * parse str as an integer and write result to x.
 * will result in overflow of x if tr is too large
 *
 * Returns non-zero if failed, 0 if success.
 */
int atoi(char *str, int *x)
{
    int sign = 1;
    int n = 0;

    if (!str)
        return 1;

    if (*str == '-') {
        sign = -1;
        if(!*++str)
            return 2; // got "-"
    } else if (*str == '+') {
        sign = 1;
        if(!*++str)
            return 2; // got "+"
    }

    while (*str)
    {
        if (*str < '0' || *str > '9')
            return 3; // not a digit
        n =  n*10 + (*str - '0');
        ++str;
    }

    *x = sign * n;
    return 0;
}

/**
 * Implements "type <name>" shell command.
 *   fname   name of file whose contents to print
 */
void type_command(char *fname)
{
    char buffer[MAX_FILE+1]; /* the maximum size of a file*/ 
    int status;

    buffer[MAX_FILE] = 0;// premptively null terminate

    // read in file to buffer
    status = read_file(fname, buffer, MAX_FILE);
    if (status < 0) 
    {
        // file was not found
        print_string(fname);
        print_string(": file not found\n\r");
    } 
    else 
    {
        // file was found, print it out
        print_string(buffer);
        print_string("\n\r");
    }
}

/**
 * Implements "execute <name>" shell command.
 *   fname     name of file on disk to load as executable
 *   blockopt  whether to block current process
 */
void execute_command(char *fname, int blockopt)
{
    int status;

    // try to run the program
    status = execute(fname, blockopt);
    switch(status)
    {
        case -4:
            // file was not found
            print_string("no free PCB available \n\r");
            break;
        case -3:
            // file was not an executable
            print_string(fname);
            print_string(": not an executable\n\r");
            break;
        case -2:
            // segment was not valid
            print_string("no segment available\n\r");
            break;
        case -1:
            // file was not found
            print_string(fname);
            print_string(": file not found\n\r");
            break;
    }
}

/**
 * Implements "delete <name>" shell command.
 *   fname   name of file to delete from disk
 */
void delete_command(char *fname)
{
    int status;

    status = delete_file(fname);
    if (status == -1)
    {
        print_string("File not found: ");
        print_string(fname);
        print_string("\n\r");
    }
}


/**
 * Implements "dir" shell command.
 * Prints all files in disk directory.
 */
void dir_command()
{
    char buffer[MAX_FILE+1]; /* the maximum size of a file*/ 
    // store file name
    char fname[7];
    // pointer within list of sectors in disk_dir
    char *ptr;
    // number of sectors read
    int   j  = 0;
    // offset to entry in disk directory
    int byte = 0;

    buffer[MAX_FILE] = 0;// premptively null terminate

    // read in the disk directory
    read_disk_dir(buffer);

    // search all entries to find entry with file name
    for(byte = 0; byte < 512; byte += 32)
    {
        if (*(buffer+byte))
        {
            // copy over file name to local buffer
            strcpyn(fname, 7, buffer+byte);
            // count number of sectors used by file
            j = 0;
            ptr = buffer+byte+6;
            while (j++ < 26 && *(ptr++))
                ;
            print_string(fname);
            print_string("     ");
            print_int(j-1);
            print_string("\n\r");
        }
    }

}

/**
 * Implements "copy <src> <dst>" shell command.
 *   src   source file to copy
 *   dst   destination file to copy to 
 */
void copy_command(char *src, char *dst)
{
    char buffer[MAX_FILE+1]; /* the maximum size of a file*/ 
    int j; // number of bytes read

    buffer[MAX_FILE] = 0;// premptively null terminate

    // read in file to buffer
    j = read_file(src, buffer, MAX_FILE);
    if (j == -1)
    {
        print_string("File not found: ");
        print_string(src);
        print_string("\n\r");
        return;
    }
    // write file
    j = write_file(dst, buffer, j);
    if (j == -1)
    {
        print_string("Disk directory is full.\n\r");
    }
    else if (j == -2)
    {
        print_string("Disk is full.\n\r");
    }
}

/**
 * Splits null-terminated line at first occurence of space character (' '),
 * stores the first in cmd and the second in arg.
 *
 * The size of cmd and arg should be at least a big as line.
 *
 *   line    char* to line
 *   cmd     buffer to store command (first part)
 *   arg     buffer to store argument (second part)
 * Returns:  1 if a space was found, and line was split. 0 otherwise.
 */
int split(char *line, char *cmd, char *arg)
{
    char *ptr = line;
    char *spc = line;
    // go till space or null
    while (*ptr && *ptr != ' ')
        *(cmd++) = *(ptr++); // copy over to command
    if (*ptr == ' ') spc = ptr;
    *cmd = 0; // null terminate command

    if (*ptr) // store argument in arg, if we haven't hit null yet
    {
        ++ptr; // skip the space character
        while (*ptr) // go till null
            *(arg++) = *(ptr++); // copy over to arg
    }
    *arg = 0; // null terminate arg

    return *spc == ' ' ? 1 : 0;
}

/**
 * Returns true if at most first n characters null-terminated strings a and b are the same.
 *    a      pointer to one of the strings
 *    b      pointer to the other string
 *    n      maximum number of characters to compare
 */
int strcmpn(char *a, char *b, int n) {
    // keep comparing till n is 0 or hit end of a or b
    while (n-- && *a && *b) {
        if (*(a++) != *(b++))
            return 0; // not equal return 0
    }
    // n < 0 -> n chars equal
    // *a == *b  -> hit end of a or b check that both a AND b end
    return n < 0 || *a == *b;
}

/**
 * compare two null terminated strings.
 *   a       start of string to compare
 *   b       start of string to compare to
 * Returns: 0 is not same, non-zero if same
 */
int strcmp(char *a, char *b) {
    // keep going till a or b hits null
    while (*a && *b) {
        if (*(a++) != *(b++))
            return 0; // short-circuit if not same
    }
    return *a == *b; // both a and b should have hit null
}
