#define MAIN
#include "proc.h"

// bhavin k
// CS 456

// for printing to row/col on the screen
#define VMEM_HIGH 0xB000
#define VMEM_LOW 0x8000
#define WIDTH   80
#define HEIGHT  25
#define CHAR_COLOR(FG,BG) ((BG << 4) | (FG & 0x7))
#define PUTVMEM(OFFSET,CHAR) putInMemory(VMEM_HIGH, VMEM_LOW+OFFSET,CHAR)

#define VREG(HIGH,LOW) ((HIGH) << 8) | ((LOW) &  0xff)
// bcc is WAY too basic to inline these automatically so...
#define PUT_CHAR(CHAR) interrupt(0x10, VREG(0x0E, CHAR), 0, 0, 0)
#define READ_CHAR()    (interrupt(0x16, 0, 0, 0, 0) & 0xFF)

// maximum file size in bytes
#define MAX_FILE           13312
// magic number denoting file as executable
#define EXEC_MAGIC_NUM     "420"
// number of bytes in the magic number
#define EXEC_MAGIC_OFFSET  3
// get segment index given address in segment
#define SEGMENT_INDEX(addr) (((addr >> 12) & 0xf)-2)
// get start of segment given segment index
#define INDEX_SEGMENT(index) ((index+2) << 12)
#define KPRINTSTR(str) setKernelDataSegment();printString(str);restoreDataSegment()
// number to increment sleep counter by each interrupt
#define SLEEP_TIME 1

// utility routines
int writeSector(char *buffer, int sector);
int readFile(char *filename, char *buf, int n);
int strcmpn(char *a, char *b, int n);
int bstrcmpn(char *str, char *buf, int n);
int strcmp(char *a, char *b);
int memcpyn(char *dst, int m, char *src, int n);
int strcpyn(char *dst, int n, char *src);
int strlen(char *str);
void putChar(char c, char color, int row, int col);
void putStr(char *str, int maxlen, char color, int row, int col);
void printw(char *ptr, int w);
void printintw(int, int w);
int printStringn(char*,int);
int printInt(int);
int sprintInt(int x, char *dst, int n);
void kStrCopy(char *src, char *dest, int len);
void update_proc_sleep();
void update_proc_blocked(int segi);

// syscall routines
void terminate();
int writeFile(char *fname, char *buffer, int sectors);
int deleteFile(char *fname);
int executeProgram(char *name, int blockopt);
int printString(char*);
int readString(char *buf, int n);
int readSector(char *buf, int sector);
int handleInterrupt21(int ax, int bx, int cx, int dx);
int handleTimerInterrupt(int ds, int ss);
void showProcesses();
void yield();
int kill(int segment);
int sleep(int time);
int block(int segi);

// assembly routines
extern int loadWordKernel(int addr);
extern int loadCharKernel(int addr);
extern void setKernelDataSegment();
extern void restoreDataSegment();
extern void makeInterrupt21();
extern void makeTimerInterrupt();
extern void returnFromTimer(int ds, int ss);
extern void resetSegments();
extern void launchProgram(int segment);
extern void putInMemory(int segment, int offset, char b);
extern void disableInterrupts();
extern void enableInterrupts();
extern int interrupt(char irq, int ax, int bx, int cx, int dx);

int main()
{
    //int i = 0;
    //interrupt(0x10, VREG(0, 0x13), 0, 0, 0);
    //for (i = 0; i < 100; ++i)
    //{
    //    interrupt(0x10, VREG(0x0c, 0xaf), VREG(0, 0), i, 10);
    //    interrupt(0x10, VREG(0x0c, 0xaf), VREG(1, 0), i, 10);
    //}
    //while(1) {};
    //char buffer[512];
    //int i = 0;
    //char buffer[MAX_FILE];
    // set up IVT
    makeInterrupt21();
    // set up timed interrutps
    makeTimerInterrupt();

    initializeProcStructures();

    // check funtionality of writeSector
    //strcpyn(buffer, 512, "This is the beginning");
    //writeFile("dank", buffer, 1);
    //strcpyn(buffer, 512, "the kernel is gone and i am here");
    //writeFile("KERNEL", buffer, 1);
    executeProgram("shell");
    while(1){};
}


// kills the process loaded into given segement index
int kill(int segi)
{

    struct PCB *pcb;
    int ret = -1;

    if (segi < 0 || segi > 7)
    {
        setKernelDataSegment();
        printString("error: no process with segment index ");
        printInt(segi);
        printString("\n\r");
        restoreDataSegment();
        return -1;
    }


    // iterate through pcb pool
    setKernelDataSegment();
    pcb = pcbPool;
    for (pcb = pcbPool; pcb < pcbPool+8; ++pcb)
    {
        if (pcb->state == DEFUNCT) continue;
        if (SEGMENT_INDEX(pcb->segment) == segi)
        {
            ret = 1;
            break;
        }
    }
    restoreDataSegment();

    if (ret == -1)
    {
        setKernelDataSegment();
        printString("error: no process with segment index ");
        printInt(segi);
        printString("\n\r");
        restoreDataSegment();
        return -1;
    }

    setKernelDataSegment();

    // remove from ready queue
    disableInterrupts();
    removeFromQueue(pcb);
    restoreInterrupts();
    releaseMemorySegment(segi);

    // notify
    printString("killed ");
    printString(pcb->name);
    printString("\n\r");

    // release pcb
    releasePCB(pcb);

    // restore blocked process 
    update_proc_blocked(segi);

    // fire interrupt vector 0x08 if killing currenly running process
    if (running == pcb) {
        yield();
    }

    restoreDataSegment();

    return ret;
}


// puts running process to sleep for time seconds
// and yields
int sleep(int time)
{
    union  state_info_t  *state_info;
    struct sleep_info_t  *sleep_info;

    setKernelDataSegment();
    if (running == NULL) // idk
        return 0; 

    // initialize sleep counters etc.
    state_info = &(running->state_info);
    sleep_info = &(state_info->sleep_info);

    sleep_info->full    = time*12;
    sleep_info->current = 0;

    // remove from queue -- shouldn't be in queue
    // removeFromQueue(running);
    // what if timer interrupts in the middle of this...
    running->state = SLEEPING;
    restoreDataSegment();

    yield();

    return 1;
}

/**
 * Put running process in BLOCKED state waiting for
 * the process loaded to segment index segi to finish.
 *
 * Note: ds should set to kernel data-segment
 *
 * Returns non-zero result if unsucessful.
 * Returns zero if sucessful.
 */
int block(int segi)
{
    union  state_info_t  *state_info;
    struct block_info_t  *block_info;

    if (segi < 0 || segi > 7)
    {
        return 1;
    }

    state_info = &(running->state_info);
    block_info = &(state_info->block_info);

    block_info->wait_pseg = segi;
    running->state = BLOCKED;

    return 0;
}


/**
 * Finds processes that were BLOCKED waiting for process
 * with given segment index to finish.
 * Puts those processes back on the queue.
 */
void update_proc_blocked(int segi) 
{
    union  state_info_t  *state_info;
    struct block_info_t  *block_info;
    struct PCB           *pcb;

    if (segi < 0 || segi > 7)
        return;

    setKernelDataSegment();
    // iterate through pcb pool
    pcb = pcbPool;
    for (pcb = pcbPool; pcb < pcbPool+8; ++pcb)
    {
        // find blocked processes that were waiting on process
        // with segment index segi
        if (pcb->state != BLOCKED )
            continue;
        if (pcb->state_info.block_info.wait_pseg != segi)
            continue;
        // put it in READY and add to queue
        pcb->state = READY;
        addToReady(pcb);
    }
    restoreDataSegment();
}


/**
 * Updates the counter for any sleeping processes.
 * If any have timed out, then it'll put them back
 * on the scheduler queue.
 */
void update_proc_sleep()
{
    struct PCB *pcb;
    struct sleep_info_t *sleep_info;

    // iterate through pcb pool to update sleeping processes
    pcb = pcbPool;
    for (pcb = pcbPool; pcb < pcbPool+8; ++pcb)
    {
        if (pcb->state != SLEEPING) continue;
        sleep_info = &(pcb->state_info.sleep_info);

        // update amount of time slept
        sleep_info->current += SLEEP_TIME;

        // check if over time
        if (sleep_info->current >= sleep_info->full)
        {
            // time's up, put process in queue
            pcb->state = READY;
            addToReady(pcb);
        }
    }
}


/**
 * Called to handle interrupt vector 0x08.
 * Checks for any process ready and starts running them.
 *     ds   data segment of currently running process
 *     ss   stack segment of currently running process
 */
int handleTimerInterrupt(int ds, int ss)
{
    struct PCB *pcb;
    int add_to_queue = 0;

    // updaate counter for sleeping processes
    update_proc_sleep();

    if (running->state != DEFUNCT)
    {
        running->segment = ds;
        running->stackPointer = ss;
        add_to_queue = (running->state != SLEEPING && running->state != BLOCKED);

        // only add to queue those that are not sleeping or blocked
        if (add_to_queue)
            running->state = READY;

        // don't add IDLE to queue
        if (add_to_queue && !strcmp(running->name, "IDLE"))
            addToReady(running);
    }

    // get a ready process
    pcb = removeFromReady();

    // use idle if none avaialble
    if (pcb == NULL)
    {
        pcb = &idleProc;
    }

    // start running
    pcb->state = RUNNING;
    running = pcb;
    returnFromTimer(pcb->segment, pcb->stackPointer);

    return 0;
}

/**
 * Prints currenlty running/blocked/sleeping processes
 * along with the segment index where they are loaded.
 */
void showProcesses()
{
    struct PCB *pcb;
    int n;
    setKernelDataSegment();

    // iterate through pcb pool
    pcb = pcbPool;
    for (pcb = pcbPool; pcb < pcbPool+8; ++pcb)
    {
        if (pcb->state == DEFUNCT) continue;
        printw(pcb->name, 10);
        printintw(SEGMENT_INDEX(pcb->segment), 3);
        printw("", 3);

        switch(pcb->state)
        {
            case RUNNING:
                printw("RUNNING",  10);
                break;
            case READY:
                printw("READY",  10);
                break;
            case BLOCKED:
                printw("BLOCKED",  10);
                break;
            case SLEEPING:
                printw("SLEEPING", 10);
                break;
            case STARTING:
                printw("STARTING",  10);
                break;
            default:
                printw("UNKOWN",   10);
                break;
        }
        printString("\n\r");
    }
    restoreDataSegment();
}

// print w-width fields padded to the right
void printw(char *ptr, int w)
{
    int n = printString(ptr);
    int diff;
    if (n < w) {
        diff = w - n;
        while (diff-- > 0)
            PUT_CHAR(' ');
    }
}

// print w-width ints padded to the left
void printintw(int x, int w)
{
    char buf[13];
    int diff;
    int n = sprintInt(x, buf, 13);

    if (n < w) {
        diff = w - n;
        while (diff-- > 0)
            PUT_CHAR(' ');
    }
    printString(buf);
}


/* kStrCopy(char *src, char *dest, int len) copy at most 
 * len characters from src which is addressed relative to  
 * the current data segment into dest, 
 * which is addressed relative to the kernel's data segment  
 * (0x1000). 
 */ 
void kStrCopy(char *src, char *dest, int len) { 
   int i=0; 
   for (i=0; i < len; i++) { 
        putInMemory(0x1000, dest+i, src[i]); 
        if (src[i] == 0x00) { 
            return; 
        } 
   } 
}

/**
 * syscall to hand control over to kernel, permanently.
 * Runs the shell.
 */
void terminate()
{
    int segi;

    setKernelDataSegment();
    segi = SEGMENT_INDEX(running->segment);
    // free up segment
    releaseMemorySegment(segi);
    // release PCB
    releasePCB(running);
    restoreDataSegment();
    // restore blocked process 
    update_proc_blocked(segi);

    yield();
}

/**
 * Reads file same name and loads it into memory at free segemtn.
 *   name      char* to name of file
 *   blockopt  whether to block currently running process until the newly
 *             spawned process quits
 * Returns: -2 if no free segment, -1 if file not found, -3 if not executable
 */
int executeProgram(char *name, int blockopt)
{
    char buffer[MAX_FILE]; /* the maximum size of a file*/ 
    char magic_num[EXEC_MAGIC_OFFSET+1];
    int k = 0, i = 0;
    int ret = 0;
    int segi;
    int segment;
    struct PCB *pcb;

    k = readFile(name, buffer, MAX_FILE);
    if (k < 0)
        return -1;

    // check if executable
    for (i = 0; i < EXEC_MAGIC_OFFSET; ++i)
        magic_num[i] = loadCharKernel(EXEC_MAGIC_NUM+i);
    magic_num[i] = 0;

    // return -3 if not executable
    ret = strcmpn(magic_num, buffer, EXEC_MAGIC_OFFSET);
    if (!ret)
    {
        return -3;
    }

    // get free memory segment to load program
    setKernelDataSegment();
    segi = getFreeMemorySegment();
    restoreDataSegment();

    // turn segment index into actual segemnt offset
    segment = INDEX_SEGMENT(segi);

    if (segi == NO_FREE_SEGMENTS)
        return -2;


    k = (k << 9);
    for (i = EXEC_MAGIC_OFFSET; i < k; ++i)
    {
        putInMemory(segment, i-EXEC_MAGIC_OFFSET, *(buffer+i));
    }

    // create PCB for process
    setKernelDataSegment();
    pcb = getFreePCB();
    restoreDataSegment();

    if (pcb == NULL)
        return -4;
    // set process name
    kStrCopy(name, pcb->name, 7);

    setKernelDataSegment();
    pcb->state = STARTING;
    pcb->segment = segment;
    pcb->stackPointer = 0xff00;

    // setup stack for segment
    initializeProgram(segment);

    // put current process in BLOCKED stated if blockopt is true
    disableInterrupts(); // getting interrupted here will probably screw things up
    if (blockopt)
    {
        block(segi);
    }
    addToReady(pcb);
    restoreInterrupts();

    restoreDataSegment();

    if (blockopt)
        yield();

    return 1;
}

/**
 * ueidl syscall to give up reamining time slice
 */
void yield()
{
    // raise interrupt with interrupt vector 0x8
    interrupt(0x08, 0, 0, 0, 0);
}

/**
 * Custom interupt handler routine for interrupt 0x21.
 *
 * printString: print a null terminated string at the current cursor location.   
 *  AX:    0x00   
 *  BX:    The address of the string to be printed.   
 *  CX:    Unused   
 *  DX:    Unused   
 * Return: The number of characters that were printed.  
 *
 * readChar: read a character from the keyboard.   
 *  AX:    0x11 
 *  BX:    The address of the buffer into which to place the 
 *         character read from the keyboard.
 *  CX:  Unused   
 *  DX:  Unused   
 * Return: 1  
 *
 * readString: read characters from the keyboard until ENTER is pressed 
 *    (or buffer is full)
 *  AX:    0x01 
 *  BX:    The address of the buffer into which to place the 
 *         characters read from the keyboard.   
 *  CX:   size of the buffer
 *  DX:  Unused 
 * Return: The number of characters that were placed into the 
 *         buffer. (Excluding the null terminator)
 *
 * readFile: read file into buffer
 *  AX: 0x03
 *  BX: address to char containing the name of the file
 *  CX: address of buffer where file should be written
 *  DX: size of buffer 
 * Return: number of sectors read or -1 if file not found.
 *
 * executeProgram: load the program into memory and execute it. 
 *  AX: 0x04 
 *  BX: The name of the program to execute. 
 *  CX: whether to block current process until spawned one is done 
 *  DX: Unused 
 * Return: -1 if the program was not found. -2 if no free segments.
 *         -4 if no PCBs are available.
 *
 * terminate: terminate the currently running program, and reload the shell.
 *  AX: 0x05 
 *  BX: Unused 
 *  CX: Unused 
 *  DX: Unused 
 *
 * deleteFile: delete a file from the disk. 
 *  AX: 0x07 
 *  BX: The name of the file to be deleted. 
 *  CX: Unused 
 *  DX: Unused 
 * Return: 1 if the file is successfully deleted or  
 *   -1 if the file cannot be found.
 *
 *
 * writeFile: write a file to the disk. 
 *  AX: 0x08 
 *  BX: The name of the file to be written. 
 *  CX: The address of a buffer containing the data for the file. 
 *  DX: The number of sectors to be written. 
 * Return: The number of sectors written, or 
 *         -1 if there is no Disk Directory entry available for the file, or 
 *         -2 if there are insufficient free sectors to hold the file
 *
 *
 * yield:  give up the remainder of the time slice. 
 *  AX:  0x09 
 *  BX:  Unused 
 *  CX:  Unused 
 *  DX:  Unused 
 * Return:  1
 *
 * showProcesses: list the currently executing processes 
 *  AX: 0x0A 
 *  BX: Unused 
 *  CX: Unused 
 *  DX: Unused 
 * Return: 1 
 *
 * kill:  kill the process executing in the segment with index  
 *        indicated by BX 
 *  AX:  0x0B 
 *  BX:  the segment index 
 *  CX:  Unused 
 *  DX:  Unused 
 * Return:  1 if the process is successfully killed 
 *          -1 if there is no process executing in segment BX
 *
 *
 * sleep: cause the process to sleep for the number of seconds 
 *        indicated by BX 
 *  AX: 0xA1 
 *  BX: the number of seconds to sleep 
 *  CX: Unused 
 *  DX: Unused 
 * Return: 1
 */
int handleInterrupt21(int ax, int bx, int cx, int dx)
{
    int ret = -1;
    int i = 0;
    char buffer[20];

    switch(ax)
    {
        case 0x00:
            // printString syscall
            ret = printString((char*)bx);
            break;

        case 0xff:
            // putStr syscall
            putStr((char*)bx, strlen((char*)bx), cx, (dx >> 8) & 0xff, dx & 0xff);
            ret = 1;
            break;

        case 0xa1:
            // sleep syscall
            ret = sleep(bx);
            break;

        case 0x0b:
            // kill syscall
            ret = kill(bx);
            break;

        case 0x0a:
            // ps syscall
            showProcesses();
            ret = 1;
            break;

        case 0x09:
            // yield syscall
            yield();
            ret = 1;
            break;

        case 0x03:
            // readFile syscall
            // note: changing ds to kernel data segment still didn't work here
            //       it made buffer unreachable
            for (i = 0; i < 17; ++i)
                buffer[i] = loadCharKernel("__DISK_DIRECTORY"+i);

            if (strcmp((char*)bx, buffer)) {
                ret = readSector((char*)cx, 2);
            } else {
                ret = readFile((char*)bx, (char*)cx, (int) dx);
            }
            break;

        case 0x04:
            // executeProgram syscall
            ret = executeProgram((char*)bx, cx);
            break;

        case 0x05:
            // terminate syscall
            terminate(); // assuming no return
            break;

        case 0x07:
            // delete file
            ret = deleteFile((char*)bx);
            break;

        case 0x08:
            // write file to disk
            ret = writeFile((char*)bx, (char*)cx, (int)dx);
            break;

        case 0x11:
            // readChar syscall
            *((char*)bx) = (char) READ_CHAR();
            ret = 1;
            break;

        case 0x01:
            // readString syscall
            ret = readString((char*)bx, cx);
            break;
    }

    return ret;
}


/************************
 *
 *   UNCHANCED CODE FROM PROJECT 4
 *
 *******************/


/**
 * Writes at most 26 sectors from buffer to disk
 * under file name fname. If file with same exists,
 * it will be overwritten.
 *    fname    name of file
 *    buffer   buffer with contents, must be at least sectors*512 in size
 *    sectors  number of sectors to write to disk
 *
 * Returns -1 if no space for new directory entry,
 *  -2 if all the sectors (<26) could be written.
 *  If all the requested sectors (<26) were written
 *  succesfully, returns the total number of sectors written.
 */
int writeFile(char *fname, char *buffer, int sectors)
{
    // load disk map here
    char disk_map[512];
    // load sector w/ disk directory here
    char disk_dir[512];
    // list of free sectors for new sectors if needed
    char file_sectors[26];
    // pointer within list of sectors in disk_dir
    char *ptr;
    char *mptr;
    // number of sectors written
    int   j  = 0;
    // offset to entry in disk directory
    int byte = 0;
    // offset to first free entry
    int free_entry = -1;

    // read the two sectors containing disk map and disk dir
    readSector(disk_map, 1);
    readSector(disk_dir, 2);

    // clip sectors to 26
    sectors = (sectors < 26 ? sectors : 26);

    //printString(fname);
    //printString(" ");
    //printInt(sectors);
    //printString("\n\r");

    // search all entries to find entry with file name
    for(; byte < 512; byte += 32)
    {
        if (free_entry < 0 && !*(disk_dir+byte))
            free_entry = byte;
        if (bstrcmpn(fname, disk_dir + byte, 6))
            break;
    }

    if (byte < 512)
    {
        // need to overwrite the file
        // start of list of sectors
        ptr  = disk_dir + byte + 6;;
        j = 0;
        while (j < sectors && *ptr)
        {
            //printString("writing sector ");
            //printInt(*ptr);
            //printString(" j=");
            //printInt(j);
            //printString("\n\r");
            writeSector(buffer + (j++<<9), *(ptr++));
        }

        if (j == sectors)
        {
            // delete remaining sectors of old file from disk map
            while (j < 26 && *ptr) {
                //printString("deleting sector ");
                //printInt(*ptr);
                //printString(" j=");
                //printInt(j);
                //printString("\n\r");

                disk_map[*ptr] = 0; // mark as empty in disk map
                *(ptr++) = 0;       // set null in disk entry
                ++j;
            }
        }
    }
    else if (free_entry < 0)
    {
        // no free directory entry
        return -1;
    }
    else
    {
        //  there is a free directory entry
        //  write name into disk_dir
        strcpyn(disk_dir+free_entry, 7, fname);
        ptr = disk_dir+free_entry+6;
    }


    // find free sectors 
    mptr = disk_map;

    while (mptr != disk_map + 512 && j < sectors)
    {
        if (!*mptr)
        {
            writeSector(buffer + (j++ << 9), mptr-disk_map);
            *mptr = 0xff;
            *(ptr++) = mptr - disk_map;
        }
        ++mptr;
    }

    // end list of sectors in directory entry with null if it's not full
    if (j < 26)
        *ptr = 0;

    // write the new disk map and disk dir to disk
    writeSector(disk_map, 1);
    writeSector(disk_dir, 2);

   return j == sectors ? j : -2;
}



int deleteFile(char *fname)
{
    // load disk map here
    char disk_map[512];
    // load sector w/ disk directory here
    char disk_dir[512];
    // pointer within list of sectors in disk_dir
    char *ptr;
    // number of sectors read
    int   j  = 0;
    // offset to entry in disk directory
    int byte = 0;

    // read the two sectors containing disk map and disk dir
    readSector(disk_map, 1);
    readSector(disk_dir, 2);

    // search all entries to find entry with file name
    for(; byte < 512; byte += 32)
    {
        if (bstrcmpn(fname, disk_dir + byte, 6))
            break;
    }

    // check that filename was found
    if (byte >= 512)
        return -1;

    // start of list of sectors
    ptr  = disk_dir + byte + 6;;
    // read full sectors to buf
    // stop when 26 sectors or after hitting 0x00
    while (j < 26 && *ptr) 
    {
        disk_map[*(ptr++)] = 0; // mark as empty in disk map
    }

    // mark beginning of entry with null
    *(disk_dir + byte) = 0;

    // write the new disk map and disk dir to disk
    writeSector(disk_map, 1);
    writeSector(disk_dir, 2);
   return j;

}

/**
 * Write data to the given sector (512 bytes) in floppy disk
 * using contents from buffer.
 *
 * buf         buffer to read contents to write from (at least 512 characters)
 * sector      absolute offset for sector
 */
int writeSector(char *buf, int sector)
{

    int q         = sector/18;
    int relsector = sector - q*18 + 1;
    int head      = q & 1;
    int track     = sector/36;

    interrupt(0x13, VREG(0x03, 0x01), (int) buf, VREG(track, relsector), VREG(head, 0x00));

    return 1;
}



/**
 * Prints at most n characters from str
 *   str        char* to start of string
 *   n          max chars
 * Returns: number of chars printed
 */
int printStringn(char *str, int n)
{
    char *start = str;
    while (*str != 0 && n--)
        PUT_CHAR(*(str++));
    return str - start;
}


/**
 * Reads file from disk and loads it into buf of size n
 *   filename     name of file to search for
 *   buf          buffer to write contents of file
 *   n            maximum size of buffer
 * Returns: number of sectors read (even if buf is not  big
 *          enough to store the last sector)
 *          -1 if file is not found
 *
 */
int readFile(char *filename, char *buf, int n) 
{
    // load sector w/ disk directory here
    char disk_dir[512];
    // load last sector here (if buf isn't big enough)
    char sector_data[512];
    // pointer within list of sectors in disk_dir
    char *ptr;
    // number of sectors read
    int   j  = 0;
    // offset to entry in disk directory
    int byte = 0;

    // read in the disk directory
    readSector(disk_dir, 2);

    // search all entries to find entry with file name
    for(; byte < 512; byte += 32)
    {
        if (bstrcmpn(filename, disk_dir + byte, 6))
            break;
    }

    // check that filename was found
    if (byte >= 512)
        return -1;

    // start of list of sectors
    ptr  = disk_dir + byte + 6;;
    // read full sectors to buf
    // stop when 26 sectors or after hitting 0x00 or buffer full
    while (n >= 512 && j < 26 && *ptr) 
    {
        readSector(buf+512*(j++), *(ptr++));
        n -= 512;
    }
    // read full sector to sector_data then copy part of it to buf
    if (n > 0 && j < 26 && *ptr)
    {
        readSector(sector_data, *ptr);
        memcpyn(buf+512*(j++), n, sector_data, 512);

    }
    return j;
}

/**
 * Copy at most n bytes from src to a buffer dst of size m.
 *   dst   destination buffer
 *   m     size of dst
 *   src   source buffer
 *   n     size of src
 *  Returns: min(n,m), the number of bytes copied from src to dst
 */
int memcpyn(char *dst, int m, char *src, int n)
{
    int k = (m < n ? m : n); // min(n,m)
    n = k;
    // copy to dst till one buf runs out
    while (n--) 
        *(dst++) = *(src++);

    return n;
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




/*************************************** 
*    UNCHANGED OLD CODE FROM PROJECT 2
*************************************** **/
/**
 * Prints the characters starting from the address
 * pointed to by str till a null is reached.
 * 
 * str            pointer to character to print
 */
int printString(char *str)
{
    char *start = str;
    while (*str != 0)
        PUT_CHAR(*(str++));
    return str - start;
}

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
int readString(char *buf, int n)
{
    char *start = buf;
    char *end   = buf + n-1;
    char c;

    while ((c = READ_CHAR()) != '\r')
    {
        if (c == 0x08)
        {
            if (buf != start)
            {
                --buf;
                PUT_CHAR(0x08);
                PUT_CHAR(' ');
                PUT_CHAR(0x08);
            }
        }
        else if (buf != end)
        {
            *buf = c;
            PUT_CHAR(c);
            ++buf;
        }
    }
    *buf = 0;
    return buf - start;
}

/**
 * Prints the given integer in base 10.
 *    x    the integer to print to screen
 * Return: number of characters printed
 */
int printInt(int x)
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
    return printString(ptr);
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
 * Reads the given sector from floppy disk
 * and write the contents to buf.
 *
 * buf         buffer to write contents of sector (at least 512 characters)
 * sector      absolute offset for sector
 */
int readSector(char *buf, int sector)
{
    int q         = sector/18;
    int relsector = sector - q*18 + 1;
    int head      = q & 1;
    int track     = sector/36;

    interrupt(0x13, VREG(0x02, 0x01), (int) buf, VREG(track, relsector), VREG(head, 0x00));

    return 1;
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


/**
 * compare one null terminated string (str)
 * with the string composed of at most first n
 * characaters of buf.
 *
 *  str   null-terminated string
 *  buf   buffer containing the string to compare against
 *  n     maximum size of string from buf to consider
 *
 *
 * Returns 1 if same, 0 is false.
 */
int bstrcmpn(char *str, char *buf, int n)
{
    // keep comparing till n is 0 or hit end of a or b
    while (n-- && *buf && *str) {
        if (*(buf++) != *(str++))
            return 0; // not equal return 0
    }
    // n < 0 -> n chars equal
    if (n < 0)
    {
        // n chars are equal, str must end in null
        return *str == 0;
    }

    // *a == *b  -> hit end of a or b check that both a AND b end
    return *buf == *str;
}

/**
 * Prints character c to the screen at specified row and column with
 * given color.
 */
void putChar(char c, char color, int row, int col) 
{
    int offset = ((row * 80 + col) << 1);
    PUTVMEM(offset, c);
    PUTVMEM(offset+1, color);
}

/**
 * Prints character array str with specified color starting at row and col.
 * maxlen gives the maximum length of the char arra (will stop if NULL isn't
 * encountered before then).
 */
void putStr(char *str, int maxlen, char color, int row, int col)
{
    int i = 0;
    while(*str && i < maxlen)
    {
        if (*str == '\n')
        {
            row += 1;
            col = 0;
        }
        else if (*str == '\r')
        {
            col = 0;
        }
        else 
        {
            putChar(*str, color, row, col);
            if ((++col) >= WIDTH)
            {
                ++row;
                col = 0;
            }
        }

        ++str;
        ++i;
    }
}


// returns length of null-terminated string
int strlen(char *str)
{
    int n = 0;
    if (!str) return n;

    while (*str++) n++;
    return n;
}
