! 1 
! 1 # 1 "./src/kernel.c"
! 1 # 6 "./include/proc.h"
! 6  
! 7 # 16
! 16 #define FREE 0
! 17 # 21
! 21 #define DEFUNCT 0
! 22 # 29
! 29 struct sleep_info_t {
! 30     int full;
!BCC_EOS
! 31     int current;
!BCC_EOS
! 32 };
!BCC_EOS
! 33 
! 34 
! 35 struct block_info_t {
! 36     int wait_pseg; 
!BCC_EOS
! 37 };
!BCC_EOS
! 38 
! 39 
! 40 union state_info_t {
! 41     struct sleep_info_t sleep_info;
!BCC_EOS
! 42     struct block_info_t block_info;
!BCC_EOS
! 43 };
!BCC_EOS
! 44 
! 45 
! 46 
! 47  
! 48 struct PCB {
! 49 	char name[7];  		
!BCC_EOS
! 50 	int state;		
!BCC_EOS
! 51 	int segment;		
!BCC_EOS
! 52 	int stackPointer;	
!BCC_EOS
! 53         union state_info_t state_info; 
!BCC_EOS
! 54 	
! 55 
! 56 
! 57 	 
! 58 	struct PCB *next;
!BCC_EOS
! 59 	struct PCB *prev;
!BCC_EOS
! 60 };
!BCC_EOS
! 61 # 68
! 68  
! 69 
! 70   struct PCB *running;		
!BCC_EOS
! 71   struct PCB idleProc;		
!BCC_EOS
! 72   struct PCB *readyHead; 	
!BCC_EOS
! 73   struct PCB *readyTail;	
!BCC_EOS
! 74   struct PCB pcbPool[8];	
!BCC_EOS
! 75 
! 76   int memoryMap[8];		
!BCC_EOS
! 77 				
! 78 				
! 79 				
! 80 				
! 81 # 91
! 91  
! 92 # 103
! 103    
! 104 void initializeProcStructures();
!BCC_EOS
! 105 # 110
! 110  
! 111 int getFreeMemorySegment();
!BCC_EOS
! 112 # 116
! 116  
! 117 void releaseMemorySegment();
!BCC_EOS
! 118 # 123
! 123  
! 124 struct PCB *getFreePCB();
!BCC_EOS
! 125 # 130
! 130  
! 131 void releasePCB();
!BCC_EOS
! 132 
! 133 
! 134 
! 135  
! 136 void addToReady();
!BCC_EOS
! 137 # 141
! 141  
! 142 struct PCB *removeFromReady();
!BCC_EOS
! 143 # 151
! 151  
! 152 struct PCB *removeFromQueue();
!BCC_EOS
! 153 # 8 "./src/kernel.c"
! 8 #define VMEM_HIGH 0xB000
! 9 # 17
! 17 #define PUT_CHAR(CHAR) interrupt(0x10, ((0x0E) << 8) | (( CHAR) &  0xff) , 0, 0, 0)
! 18 
! 19 
! 20 
! 21 #define MAX_FILE           13312
! 22 
! 23 #define EXEC_MAGIC_NUM     "420"
! 24 
! 25 #define EXEC_MAGIC_OFFSET  3
! 26 
! 27 #define SEGMENT_INDEX(addr) (((addr >> 12) & 0xf)-2)
! 28 
! 29 #define INDEX_SEGMENT(index) ((index+2) << 12)
! 30 
! 31 
! 32 #define SLEEP_TIME 1
! 33 
! 34 
! 35 int writeSector();
!BCC_EOS
! 36 int readFile();
!BCC_EOS
! 37 int strcmpn();
!BCC_EOS
! 38 int bstrcmpn();
!BCC_EOS
! 39 int strcmp();
!BCC_EOS
! 40 int memcpyn();
!BCC_EOS
! 41 int strcpyn();
!BCC_EOS
! 42 int strlen();
!BCC_EOS
! 43 void putChar();
!BCC_EOS
! 44 void putStr();
!BCC_EOS
! 45 void printw();
!BCC_EOS
! 46 void printintw();
!BCC_EOS
! 47 int printStringn();
!BCC_EOS
! 48 int printInt();
!BCC_EOS
! 49 int sprintInt();
!BCC_EOS
! 50 void kStrCopy();
!BCC_EOS
! 51 void update_proc_sleep();
!BCC_EOS
! 52 void update_proc_blocked();
!BCC_EOS
! 53 
! 54 
! 55 void terminate();
!BCC_EOS
! 56 int writeFile();
!BCC_EOS
! 57 int deleteFile();
!BCC_EOS
! 58 int executeProgram();
!BCC_EOS
! 59 int printString();
!BCC_EOS
! 60 int readString();
!BCC_EOS
! 61 int readSector();
!BCC_EOS
! 62 int handleInterrupt21();
!BCC_EOS
! 63 int handleTimerInterrupt();
!BCC_EOS
! 64 void showProcesses();
!BCC_EOS
! 65 void yield();
!BCC_EOS
! 66 int kill();
!BCC_EOS
! 67 int sleep();
!BCC_EOS
! 68 int block();
!BCC_EOS
! 69 
! 70 
! 71 extern int loadWordKernel();
!BCC_EOS
! 72 extern int loadCharKernel();
!BCC_EOS
! 73 extern void setKernelDataSegment();
!BCC_EOS
! 74 extern void restoreDataSegment();
!BCC_EOS
! 75 extern void makeInterrupt21();
!BCC_EOS
! 76 extern void makeTi
! 76 merInterrupt();
!BCC_EOS
! 77 extern void returnFromTimer();
!BCC_EOS
! 78 extern void resetSegments();
!BCC_EOS
! 79 extern void launchProgram();
!BCC_EOS
! 80 extern void putInMemory();
!BCC_EOS
! 81 extern void disableInterrupts();
!BCC_EOS
! 82 extern void enableInterrupts();
!BCC_EOS
! 83 extern int interrupt();
!BCC_EOS
! 84 
! 85 int main()
! 86 {
export	_main
_main:
! 87     
! 88     
! 89     
! 90     
! 91     makeInterrupt21(); 
push	bp
mov	bp,sp
push	di
push	si
! Debug: func () void = makeInterrupt21+0 (used reg = )
call	_makeInterrupt21
!BCC_EOS
! 92     
! 93     makeTimerInterrupt();
! Debug: func () void = makeTimerInterrupt+0 (used reg = )
call	_makeTimerInterrupt
!BCC_EOS
! 94 
! 95     initializeProcStructures();
! Debug: func () void = initializeProcStructures+0 (used reg = )
call	_initializeProcStructures
!BCC_EOS
! 96 
! 97     
! 98     
! 99     
! 100     
! 101     
! 102     executeProgram("shell");
! Debug: list * char = .1+0 (used reg = )
mov	bx,#.1
push	bx
! Debug: func () int = executeProgram+0 (used reg = )
call	_executeProgram
inc	sp
inc	sp
!BCC_EOS
! 103 
! 104     while(1) {};
.4:
.3:
jmp	.4
.5:
.2:
!BCC_EOS
! 105 }
pop	si
pop	di
pop	bp
ret
! 106 
! 107 
! 108 
! 109 int kill(segi)
! Register BX used in function main
! 110 # 109 "./src/kernel.c"
! 109 int segi;
export	_kill
_kill:
!BCC_EOS
! 110 {
! 111 
! 112     struct PCB *pcb;
!BCC_EOS
! 113     int ret = -1;
push	bp
mov	bp,sp
push	di
push	si
add	sp,*-4
! Debug: eq int = const -1 to int ret = [S+$A-$A] (used reg = )
mov	ax,*-1
mov	-8[bp],ax
!BCC_EOS
! 114 
! 115     if (segi < 0 || segi > 7)
! Debug: lt int = const 0 to int segi = [S+$A+2] (used reg = )
mov	ax,4[bp]
test	ax,ax
jl  	.7
.8:
! Debug: gt int = const 7 to int segi = [S+$A+2] (used reg = )
mov	ax,4[bp]
cmp	ax,*7
jle 	.6
.7:
! 116     {
! 117         setKernelDataSegment();
! Debug: func () void = setKernelDataSegment+0 (used reg = )
call	_setKernelDataSegment
!BCC_EOS
! 118         printString("error: no process with segment index ");
! Debug: list * char = .9+0 (used reg = )
mov	bx,#.9
push	bx
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 119         printInt(segi);
! Debug: list int segi = [S+$A+2] (used reg = )
push	4[bp]
! Debug: func () int = printInt+0 (used reg = )
call	_printInt
inc	sp
inc	sp
!BCC_EOS
! 120         printString("\n\r");
! Debug: list * char = .A+0 (used reg = )
mov	bx,#.A
push	bx
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 121         restoreDataSegment();
! Debug: func () void = restoreDataSegment+0 (used reg = )
call	_restoreDataSegment
!BCC_EOS
! 122         return -1;
mov	ax,*-1
add	sp,*4
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 123     }
! 124 
! 125 
! 126     
! 127     setKernelDataSegment();
.6:
! Debug: func () void = setKernelDataSegment+0 (used reg = )
call	_setKernelDataSegment
!BCC_EOS
! 128     pcb = pcbPool;
! Debug: eq [8] struct PCB = pcbPool+0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,#_pcbPool
mov	-6[bp],bx
!BCC_EOS
! 129     for (pcb = pcbPool; pcb < pcbPool+8; ++pcb)
! Debug: eq [8] struct PCB = pcbPool+0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,#_pcbPool
mov	-6[bp],bx
!BCC_EOS
!BCC_EOS
! 130     {
jmp .D
.E:
! 131         if (pcb->state == DEFUNCT) continue;
mov	bx,-6[bp]
! Debug: logeq int = const 0 to int = [bx+8] (used reg = )
mov	ax,8[bx]
test	ax,ax
jne 	.F
.10:
jmp .C
!BCC_EOS
! 132         if (SEGMENT_INDEX(pcb->segment)== segi)
.F:
mov	bx,-6[bp]
! Debug: sr int = const $C to int = [bx+$A] (used reg = )
mov	ax,$A[bx]
mov	al,ah
cbw
mov	cl,*4
sar	ax,cl
! Debug: and int = const $F to int = ax+0 (used reg = )
and	al,*$F
! Debug: sub int = const 2 to char = al+0 (used reg = )
xor	ah,ah
! Debug: logeq int segi = [S+$A+2] to int = ax-2 (used reg = )
dec	ax
dec	ax
cmp	ax,4[bp]
jne 	.11
.12:
! 133         {
! 134             ret = 1;
! Debug: eq int = const 1 to int ret = [S+$A-$A] (used reg = )
mov	ax,*1
mov	-8[bp],ax
!BCC_EOS
! 135             break;
jmp .B
!BCC_EOS
! 136         }
! 137     }
.11:
! 138     restoreDataSegment();
.C:
! Debug: preinc * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,-6[bp]
add	bx,*$16
mov	-6[bp],bx
.D:
! Debug: lt * struct PCB = pcbPool+$B0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,#_pcbPool+$B0
cmp	bx,-6[bp]
ja 	.E
.13:
.B:
! Debug: func () void = restoreDataSegment+0 (used reg = )
call	_restoreDataSegment
!BCC_EOS
! 139 
! 140     if (ret == -1)
! Debug: logeq int = const -1 to int ret = [S+$A-$A] (used reg = )
mov	ax,-8[bp]
cmp	ax,*-1
jne 	.14
.15:
! 141     {
! 142         setKernelDataSegment();
! Debug: func () void = setKernelDataSegment+0 (used reg = )
call	_setKernelDataSegment
!BCC_EOS
! 143         printString("error: no process with segment index ");
! Debug: list * char = .16+0 (used reg = )
mov	bx,#.16
push	bx
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 144         printInt(segi);
! Debug: list int segi = [S+$A+2] (used reg = )
push	4[bp]
! Debug: func () int = printInt+0 (used reg = )
call	_printInt
inc	sp
inc	sp
!BCC_EOS
! 145         printString("\n\r");
! Debug: list * char = .17+0 (used reg = )
mov	bx,#.17
push	bx
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 146         restoreDataSegment();
! Debug: func () void = restoreDataSegment+0 (used reg = )
call	_restoreDataSegment
!BCC_EOS
! 147         return -1;
mov	ax,*-1
add	sp,*4
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 148     }
! 149 
! 150     setKernelDataSegment();
.14:
! Debug: func () void = setKernelDataSegment+0 (used reg = )
call	_setKernelDataSegment
!BCC_EOS
! 151 
! 152     
! 153     disableInterrupts();
! Debug: func () void = disableInterrupts+0 (used reg = )
call	_disableInterrupts
!BCC_EOS
! 154     removeFromQueue(pcb);
! Debug: list * struct PCB pcb = [S+$A-8] (used reg = )
push	-6[bp]
! Debug: func () * struct PCB = removeFromQueue+0 (used reg = )
call	_removeFromQueue
inc	sp
inc	sp
!BCC_EOS
! 155     restoreInterrupts();
! Debug: func () int = restoreInterrupts+0 (used reg = )
call	_restoreInterrupts
!BCC_EOS
! 156     releaseMemorySegment(segi);
! Debug: list int segi = [S+$A+2] (used reg = )
push	4[bp]
! Debug: func () void = releaseMemorySegment+0 (used reg = )
call	_releaseMemorySegment
inc	sp
inc	sp
!BCC_EOS
! 157 
! 158     
! 159     printString("killed ");
! Debug: list * char = .18+0 (used reg = )
mov	bx,#.18
push	bx
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 160     printString(pcb->name);
! Debug: cast * char = const 0 to [7] char pcb = [S+$A-8] (used reg = )
! Debug: list * char pcb = [S+$A-8] (used reg = )
push	-6[bp]
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 161     printString("\n\r");
! Debug: list * char = .19+0 (used reg = )
mov	bx,#.19
push	bx
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 162 
! 163     
! 164     releasePCB(pcb);
! Debug: list * struct PCB pcb = [S+$A-8] (used reg = )
push	-6[bp]
! Debug: func () void = releasePCB+0 (used reg = )
call	_releasePCB
inc	sp
inc	sp
!BCC_EOS
! 165 
! 166     
! 167     update_proc_blocked(segi);
! Debug: list int segi = [S+$A+2] (used reg = )
push	4[bp]
! Debug: func () void = update_proc_blocked+0 (used reg = )
call	_update_proc_blocked
inc	sp
inc	sp
!BCC_EOS
! 168 
! 169     
! 170     if (running == pcb) {
! Debug: logeq * struct PCB pcb = [S+$A-8] to * struct PCB = [running+0] (used reg = )
mov	bx,[_running]
cmp	bx,-6[bp]
jne 	.1A
.1B:
! 171         yield();
! Debug: func () void = yield+0 (used reg = )
call	_yield
!BCC_EOS
! 172     }
! 173 
! 174     restoreDataSegment();
.1A:
! Debug: func () void = restoreDataSegment+0 (used reg = )
call	_restoreDataSegment
!BCC_EOS
! 175 
! 176     return ret;
mov	ax,-8[bp]
add	sp,*4
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 177 }
! 178 # 182
! 182 int sleep(time)
! Register BX used in function kill
! 183 # 182 "./src/kernel.c"
! 182 int time;
export	_sleep
_sleep:
!BCC_EOS
! 183 {
! 184     union  state_info_t  *state_info;
!BCC_EOS
! 185     struct sleep_info_t  *sleep_info;
!BCC_EOS
! 186 
! 187     setKernelDataSegment();
push	bp
mov	bp,sp
push	di
push	si
add	sp,*-4
! Debug: func () void = setKernelDataSegment+0 (used reg = )
call	_setKernelDataSegment
!BCC_EOS
! 188     if (running == 0x00 ) 
! Debug: logeq int = const 0 to * struct PCB = [running+0] (used reg = )
mov	ax,[_running]
test	ax,ax
jne 	.1C
.1D:
! 189         return 0; 
xor	ax,ax
add	sp,*4
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 190 
! 191     
! 192     state_info = &(running->state_info);
.1C:
mov	bx,[_running]
! Debug: address struct state_info_t = [bx+$E] (used reg = )
! Debug: eq * struct state_info_t = bx+$E to * struct state_info_t state_info = [S+$A-8] (used reg = )
add	bx,*$E
mov	-6[bp],bx
!BCC_EOS
! 193     sleep_info = &(state_info->sleep_info);
mov	bx,-6[bp]
! Debug: address struct sleep_info_t = [bx+0] (used reg = )
! Debug: eq * struct sleep_info_t = bx+0 to * struct sleep_info_t sleep_info = [S+$A-$A] (used reg = )
mov	-8[bp],bx
!BCC_EOS
! 194 
! 195     sleep_info->full    = time*12;
! Debug: mul int = const $C to int time = [S+$A+2] (used reg = )
mov	ax,4[bp]
mov	dx,ax
shl	ax,*1
add	ax,dx
shl	ax,*1
shl	ax,*1
mov	bx,-8[bp]
! Debug: eq int = ax+0 to int = [bx+0] (used reg = )
mov	[bx],ax
!BCC_EOS
! 196     sleep_info->current = 0;
mov	bx,-8[bp]
! Debug: eq int = const 0 to int = [bx+2] (used reg = )
xor	ax,ax
mov	2[bx],ax
!BCC_EOS
! 197 
! 198     
! 199     
! 200     
! 201   
! 201   running->state = 5 ;
mov	bx,[_running]
! Debug: eq int = const 5 to int = [bx+8] (used reg = )
mov	ax,*5
mov	8[bx],ax
!BCC_EOS
! 202     restoreDataSegment();
! Debug: func () void = restoreDataSegment+0 (used reg = )
call	_restoreDataSegment
!BCC_EOS
! 203 
! 204     yield();
! Debug: func () void = yield+0 (used reg = )
call	_yield
!BCC_EOS
! 205 
! 206     return 1;
mov	ax,*1
add	sp,*4
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 207 }
! 208 # 217
! 217  
! 218 int block(segi)
! Register BX used in function sleep
! 219 # 218 "./src/kernel.c"
! 218 int segi;
export	_block
_block:
!BCC_EOS
! 219 {
! 220     union  state_info_t  *state_info;
!BCC_EOS
! 221     struct block_info_t  *block_info;
!BCC_EOS
! 222 
! 223     if (segi < 0 || segi > 7)
push	bp
mov	bp,sp
push	di
push	si
add	sp,*-4
! Debug: lt int = const 0 to int segi = [S+$A+2] (used reg = )
mov	ax,4[bp]
test	ax,ax
jl  	.1F
.20:
! Debug: gt int = const 7 to int segi = [S+$A+2] (used reg = )
mov	ax,4[bp]
cmp	ax,*7
jle 	.1E
.1F:
! 224     {
! 225         return 1;
mov	ax,*1
add	sp,*4
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 226     }
! 227 
! 228     state_info = &(running->state_info);
.1E:
mov	bx,[_running]
! Debug: address struct state_info_t = [bx+$E] (used reg = )
! Debug: eq * struct state_info_t = bx+$E to * struct state_info_t state_info = [S+$A-8] (used reg = )
add	bx,*$E
mov	-6[bp],bx
!BCC_EOS
! 229     block_info = &(state_info->block_info);
mov	bx,-6[bp]
! Debug: address struct block_info_t = [bx+0] (used reg = )
! Debug: eq * struct block_info_t = bx+0 to * struct block_info_t block_info = [S+$A-$A] (used reg = )
mov	-8[bp],bx
!BCC_EOS
! 230 
! 231     block_info->wait_pseg = segi;
mov	bx,-8[bp]
! Debug: eq int segi = [S+$A+2] to int = [bx+0] (used reg = )
mov	ax,4[bp]
mov	[bx],ax
!BCC_EOS
! 232     running->state = 3 ;
mov	bx,[_running]
! Debug: eq int = const 3 to int = [bx+8] (used reg = )
mov	ax,*3
mov	8[bx],ax
!BCC_EOS
! 233 
! 234     return 0;
xor	ax,ax
add	sp,*4
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 235 }
! 236 # 242
! 242  
! 243 void update_proc_blocked(segi)
! Register BX used in function block
! 244 # 243 "./src/kernel.c"
! 243 int segi;
export	_update_proc_blocked
_update_proc_blocked:
!BCC_EOS
! 244 {
! 245     union  state_info_t  *state_info;
!BCC_EOS
! 246     struct block_info_t  *block_info;
!BCC_EOS
! 247     struct PCB           *pcb;
!BCC_EOS
! 248 
! 249     if (segi < 0 || segi > 7)
push	bp
mov	bp,sp
push	di
push	si
add	sp,*-6
! Debug: lt int = const 0 to int segi = [S+$C+2] (used reg = )
mov	ax,4[bp]
test	ax,ax
jl  	.22
.23:
! Debug: gt int = const 7 to int segi = [S+$C+2] (used reg = )
mov	ax,4[bp]
cmp	ax,*7
jle 	.21
.22:
! 250         return;
add	sp,*6
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 251 
! 252     setKernelDataSegment();
.21:
! Debug: func () void = setKernelDataSegment+0 (used reg = )
call	_setKernelDataSegment
!BCC_EOS
! 253     
! 254     pcb = pcbPool;
! Debug: eq [8] struct PCB = pcbPool+0 to * struct PCB pcb = [S+$C-$C] (used reg = )
mov	bx,#_pcbPool
mov	-$A[bp],bx
!BCC_EOS
! 255     for (pcb = pcbPool; pcb < pcbPool+8; ++pcb)
! Debug: eq [8] struct PCB = pcbPool+0 to * struct PCB pcb = [S+$C-$C] (used reg = )
mov	bx,#_pcbPool
mov	-$A[bp],bx
!BCC_EOS
!BCC_EOS
! 256     {
jmp .26
.27:
! 257         
! 258         
! 259         if (pcb->state != 3  )
mov	bx,-$A[bp]
! Debug: ne int = const 3 to int = [bx+8] (used reg = )
mov	bx,8[bx]
cmp	bx,*3
je  	.28
.29:
! 260             continue;
jmp .25
!BCC_EOS
! 261         if (pcb->state_info.block_info.wait_pseg != segi)
.28:
mov	bx,-$A[bp]
! Debug: ne int segi = [S+$C+2] to int = [bx+$E] (used reg = )
mov	bx,$E[bx]
cmp	bx,4[bp]
je  	.2A
.2B:
! 262             continue;
jmp .25
!BCC_EOS
! 263         
! 264         pcb->state = 2 ;
.2A:
mov	bx,-$A[bp]
! Debug: eq int = const 2 to int = [bx+8] (used reg = )
mov	ax,*2
mov	8[bx],ax
!BCC_EOS
! 265         addToReady(pcb);
! Debug: list * struct PCB pcb = [S+$C-$C] (used reg = )
push	-$A[bp]
! Debug: func () void = addToReady+0 (used reg = )
call	_addToReady
inc	sp
inc	sp
!BCC_EOS
! 266     }
! 267     restoreDataSegment();
.25:
! Debug: preinc * struct PCB pcb = [S+$C-$C] (used reg = )
mov	bx,-$A[bp]
add	bx,*$16
mov	-$A[bp],bx
.26:
! Debug: lt * struct PCB = pcbPool+$B0 to * struct PCB pcb = [S+$C-$C] (used reg = )
mov	bx,#_pcbPool+$B0
cmp	bx,-$A[bp]
ja 	.27
.2C:
.24:
! Debug: func () void = restoreDataSegment+0 (used reg = )
call	_restoreDataSegment
!BCC_EOS
! 268 }
add	sp,*6
pop	si
pop	di
pop	bp
ret
! 269 # 275
! 275  
! 276 void update_proc_sleep()
! Register BX used in function update_proc_blocked
! 277 {
export	_update_proc_sleep
_update_proc_sleep:
! 278     struct PCB *pcb;
!BCC_EOS
! 279     struct sleep_info_t *sleep_info;
!BCC_EOS
! 280 
! 281     
! 282     pcb = pcbPool;
push	bp
mov	bp,sp
push	di
push	si
add	sp,*-4
! Debug: eq [8] struct PCB = pcbPool+0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,#_pcbPool
mov	-6[bp],bx
!BCC_EOS
! 283     for (pcb = pcbPool; pcb < pcbPool+8; ++pcb)
! Debug: eq [8] struct PCB = pcbPool+0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,#_pcbPool
mov	-6[bp],bx
!BCC_EOS
!BCC_EOS
! 284     {
jmp .2F
.30:
! 285         if (pcb->state != 5 ) continue;
mov	bx,-6[bp]
! Debug: ne int = const 5 to int = [bx+8] (used reg = )
mov	bx,8[bx]
cmp	bx,*5
je  	.31
.32:
jmp .2E
!BCC_EOS
! 286         sleep_info = &(pcb->state_info.sleep_info);
.31:
mov	bx,-6[bp]
! Debug: address struct sleep_info_t = [bx+$E] (used reg = )
! Debug: eq * struct sleep_info_t = bx+$E to * struct sleep_info_t sleep_info = [S+$A-$A] (used reg = )
add	bx,*$E
mov	-8[bp],bx
!BCC_EOS
! 287 
! 288         
! 289         sleep_info->current += SLEEP_TIME;
mov	bx,-8[bp]
! Debug: addab int = const 1 to int = [bx+2] (used reg = )
mov	ax,2[bx]
inc	ax
mov	2[bx],ax
!BCC_EOS
! 290 
! 291         
! 292         if (sleep_info->current >= sleep_info->full)
mov	bx,-8[bp]
mov	si,-8[bp]
! Debug: ge int = [bx+0] to int = [si+2] (used reg = )
mov	si,2[si]
cmp	si,[bx]
jl  	.33
.34:
! 293         {
! 294             
! 295             pcb->state = 2 ;
mov	bx,-6[bp]
! Debug: eq int = const 2 to int = [bx+8] (used reg = )
mov	ax,*2
mov	8[bx],ax
!BCC_EOS
! 296             addToReady(pcb);
! Debug: list * struct PCB pcb = [S+$A-8] (used reg = )
push	-6[bp]
! Debug: func () void = addToReady+0 (used reg = )
call	_addToReady
inc	sp
inc	sp
!BCC_EOS
! 297         }
! 298     }
.33:
! 299 }
.2E:
! Debug: preinc * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,-6[bp]
add	bx,*$16
mov	-6[bp],bx
.2F:
! Debug: lt * struct PCB = pcbPool+$B0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,#_pcbPool+$B0
cmp	bx,-6[bp]
ja 	.30
.35:
.2D:
add	sp,*4
pop	si
pop	di
pop	bp
ret
! 300 # 307
! 307  
! 308 int handleTimerInterrupt(ds,ss)
! Register BX SI used in function update_proc_sleep
! 309 # 308 "./src/kernel.c"
! 308 int ds;
export	_handleTimerInterrupt
_handleTimerInterrupt:
!BCC_EOS
! 309 # 308 "./src/kernel.c"
! 308 int ss;
!BCC_EOS
! 309 {
! 310     struct PCB *pcb;
!BCC_EOS
! 311     int add_to_queue = 0;
push	bp
mov	bp,sp
push	di
push	si
add	sp,*-4
! Debug: eq int = const 0 to int add_to_queue = [S+$A-$A] (used reg = )
xor	ax,ax
mov	-8[bp],ax
!BCC_EOS
! 312 
! 313     
! 314     update_proc_sleep();
! Debug: func () void = update_proc_sleep+0 (used reg = )
call	_update_proc_sleep
!BCC_EOS
! 315 
! 316     if (running->state != DEFUNCT)
mov	bx,[_running]
! Debug: ne int = const 0 to int = [bx+8] (used reg = )
mov	ax,8[bx]
test	ax,ax
je  	.36
.37:
! 317     {
! 318         running->segment = ds;
mov	bx,[_running]
! Debug: eq int ds = [S+$A+2] to int = [bx+$A] (used reg = )
mov	ax,4[bp]
mov	$A[bx],ax
!BCC_EOS
! 319         running->stackPointer = ss;
mov	bx,[_running]
! Debug: eq int ss = [S+$A+4] to int = [bx+$C] (used reg = )
mov	ax,6[bp]
mov	$C[bx],ax
!BCC_EOS
! 320         add_to_queue = (running->state != 5  && running->state != 3 );
mov	bx,[_running]
! Debug: ne int = const 5 to int = [bx+8] (used reg = )
mov	bx,8[bx]
cmp	bx,*5
je  	.38
.3A:
mov	bx,[_running]
! Debug: ne int = const 3 to int = [bx+8] (used reg = )
mov	bx,8[bx]
cmp	bx,*3
je  	.38
.39:
mov	al,*1
jmp	.3B
.38:
xor	al,al
.3B:
! Debug: eq char = al+0 to int add_to_queue = [S+$A-$A] (used reg = )
xor	ah,ah
mov	-8[bp],ax
!BCC_EOS
! 321 
! 322         
! 323         if (add_to_queue)
mov	ax,-8[bp]
test	ax,ax
je  	.3C
.3D:
! 324             running->state = 2 ;
mov	bx,[_running]
! Debug: eq int = const 2 to int = [bx+8] (used reg = )
mov	ax,*2
mov	8[bx],ax
!BCC_EOS
! 325 
! 326         
! 327         if (add_to_queue && !strcmp(running->name,"IDLE"))
.3C:
mov	ax,-8[bp]
test	ax,ax
je  	.3E
.41:
! Debug: list * char = .3F+0 (used reg = )
mov	bx,#.3F
push	bx
! Debug: cast * char = const 0 to [7] char = [running+0] (used reg = )
! Debug: list * char = [running+0] (used reg = )
push	[_running]
! Debug: func () int = strcmp+0 (used reg = )
call	_strcmp
add	sp,*4
test	ax,ax
jne 	.3E
.40:
! 328             addToReady(running);
! Debug: list * struct PCB = [running+0] (used reg = )
push	[_running]
! Debug: func () void = addToReady+0 (used reg = )
call	_addToReady
inc	sp
inc	sp
!BCC_EOS
! 329     }
.3E:
! 330 
! 331     
! 332     pc
! 332 b = removeFromReady();
.36:
! Debug: func () * struct PCB = removeFromReady+0 (used reg = )
call	_removeFromReady
! Debug: eq * struct PCB = ax+0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	-6[bp],ax
!BCC_EOS
! 333 
! 334     
! 335     if (pcb == 0x00 )
! Debug: logeq int = const 0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	ax,-6[bp]
test	ax,ax
jne 	.42
.43:
! 336     {
! 337         pcb = &idleProc;
! Debug: eq * struct PCB = idleProc+0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,#_idleProc
mov	-6[bp],bx
!BCC_EOS
! 338     }
! 339 
! 340     
! 341     pcb->state = 1 ;
.42:
mov	bx,-6[bp]
! Debug: eq int = const 1 to int = [bx+8] (used reg = )
mov	ax,*1
mov	8[bx],ax
!BCC_EOS
! 342     running = pcb;
! Debug: eq * struct PCB pcb = [S+$A-8] to * struct PCB = [running+0] (used reg = )
mov	bx,-6[bp]
mov	[_running],bx
!BCC_EOS
! 343     returnFromTimer(pcb->segment,pcb->stackPointer);
mov	bx,-6[bp]
! Debug: list int = [bx+$C] (used reg = )
push	$C[bx]
mov	bx,-6[bp]
! Debug: list int = [bx+$A] (used reg = )
push	$A[bx]
! Debug: func () void = returnFromTimer+0 (used reg = )
call	_returnFromTimer
add	sp,*4
!BCC_EOS
! 344 
! 345     return 0;
xor	ax,ax
add	sp,*4
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 346 }
! 347 # 351
! 351  
! 352 void showProcesses()
! Register BX used in function handleTimerInterrupt
! 353 {
export	_showProcesses
_showProcesses:
! 354     struct PCB *pcb;
!BCC_EOS
! 355     int n;
!BCC_EOS
! 356     setKernelDataSegment();
push	bp
mov	bp,sp
push	di
push	si
add	sp,*-4
! Debug: func () void = setKernelDataSegment+0 (used reg = )
call	_setKernelDataSegment
!BCC_EOS
! 357 
! 358     
! 359     pcb = pcbPool;
! Debug: eq [8] struct PCB = pcbPool+0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,#_pcbPool
mov	-6[bp],bx
!BCC_EOS
! 360     for (pcb = pcbPool; pcb < pcbPool+8; ++pcb)
! Debug: eq [8] struct PCB = pcbPool+0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,#_pcbPool
mov	-6[bp],bx
!BCC_EOS
!BCC_EOS
! 361     {
br 	.46
.47:
! 362         if (pcb->state == DEFUNCT) continue;
mov	bx,-6[bp]
! Debug: logeq int = const 0 to int = [bx+8] (used reg = )
mov	ax,8[bx]
test	ax,ax
jne 	.48
.49:
br 	.45
!BCC_EOS
! 363         printw(pcb->name,10);
.48:
! Debug: list int = const $A (used reg = )
mov	ax,*$A
push	ax
! Debug: cast * char = const 0 to [7] char pcb = [S+$C-8] (used reg = )
! Debug: list * char pcb = [S+$C-8] (used reg = )
push	-6[bp]
! Debug: func () void = printw+0 (used reg = )
call	_printw
add	sp,*4
!BCC_EOS
! 364         printintw(SEGMENT_INDEX(pcb->segment),3);
! Debug: list int = const 3 (used reg = )
mov	ax,*3
push	ax
mov	bx,-6[bp]
! Debug: sr int = const $C to int = [bx+$A] (used reg = )
mov	ax,$A[bx]
mov	al,ah
cbw
mov	cl,*4
sar	ax,cl
! Debug: and int = const $F to int = ax+0 (used reg = )
and	al,*$F
! Debug: sub int = const 2 to char = al+0 (used reg = )
xor	ah,ah
! Debug: list int = ax-2 (used reg = )
dec	ax
dec	ax
push	ax
! Debug: func () void = printintw+0 (used reg = )
call	_printintw
add	sp,*4
!BCC_EOS
! 365         printw("",3);
! Debug: list int = const 3 (used reg = )
mov	ax,*3
push	ax
! Debug: list * char = .4A+0 (used reg = )
mov	bx,#.4A
push	bx
! Debug: func () void = printw+0 (used reg = )
call	_printw
add	sp,*4
!BCC_EOS
! 366 
! 367         switch(pcb->state)
mov	bx,-6[bp]
mov	ax,8[bx]
! 368         {
jmp .4D
! 369             case 1 :
! 370                 printw("RUNNING",10);
.4E:
! Debug: list int = const $A (used reg = )
mov	ax,*$A
push	ax
! Debug: list * char = .4F+0 (used reg = )
mov	bx,#.4F
push	bx
! Debug: func () void = printw+0 (used reg = )
call	_printw
add	sp,*4
!BCC_EOS
! 371                 break;
jmp .4B
!BCC_EOS
! 372             case 2 :
! 373                 printw("READY",10);
.50:
! Debug: list int = const $A (used reg = )
mov	ax,*$A
push	ax
! Debug: list * char = .51+0 (used reg = )
mov	bx,#.51
push	bx
! Debug: func () void = printw+0 (used reg = )
call	_printw
add	sp,*4
!BCC_EOS
! 374                 break;
jmp .4B
!BCC_EOS
! 375             case 3 :
! 376                 printw("BLOCKED",10);
.52:
! Debug: list int = const $A (used reg = )
mov	ax,*$A
push	ax
! Debug: list * char = .53+0 (used reg = )
mov	bx,#.53
push	bx
! Debug: func () void = printw+0 (used reg = )
call	_printw
add	sp,*4
!BCC_EOS
! 377                 break;
jmp .4B
!BCC_EOS
! 378             case 5 :
! 379                 printw("SLEEPING",10);
.54:
! Debug: list int = const $A (used reg = )
mov	ax,*$A
push	ax
! Debug: list * char = .55+0 (used reg = )
mov	bx,#.55
push	bx
! Debug: func () void = printw+0 (used reg = )
call	_printw
add	sp,*4
!BCC_EOS
! 380                 break;
jmp .4B
!BCC_EOS
! 381             case 4 :
! 382                 printw("STARTING",10);
.56:
! Debug: list int = const $A (used reg = )
mov	ax,*$A
push	ax
! Debug: list * char = .57+0 (used reg = )
mov	bx,#.57
push	bx
! Debug: func () void = printw+0 (used reg = )
call	_printw
add	sp,*4
!BCC_EOS
! 383                 break;
jmp .4B
!BCC_EOS
! 384             default:
! 385                 printw("UNKOWN",10);
.58:
! Debug: list int = const $A (used reg = )
mov	ax,*$A
push	ax
! Debug: list * char = .59+0 (used reg = )
mov	bx,#.59
push	bx
! Debug: func () void = printw+0 (used reg = )
call	_printw
add	sp,*4
!BCC_EOS
! 386                 break;
jmp .4B
!BCC_EOS
! 387         }
! 388         printString("\n\r");
jmp .4B
.4D:
sub	ax,*1
je 	.4E
sub	ax,*1
je 	.50
sub	ax,*1
je 	.52
sub	ax,*1
je 	.56
sub	ax,*1
je 	.54
jmp	.58
.4B:
..FFFF	=	-$A
! Debug: list * char = .5A+0 (used reg = )
mov	bx,#.5A
push	bx
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 389     }
! 390     restoreDataSegment();
.45:
! Debug: preinc * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,-6[bp]
add	bx,*$16
mov	-6[bp],bx
.46:
! Debug: lt * struct PCB = pcbPool+$B0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,#_pcbPool+$B0
cmp	bx,-6[bp]
bhi 	.47
.5B:
.44:
! Debug: func () void = restoreDataSegment+0 (used reg = )
call	_restoreDataSegment
!BCC_EOS
! 391 }
add	sp,*4
pop	si
pop	di
pop	bp
ret
! 392 
! 393 
! 394 void printw(ptr,w)
! Register BX used in function showProcesses
! 395 # 394 "./src/kernel.c"
! 394 char *ptr;
export	_printw
_printw:
!BCC_EOS
! 395 # 394 "./src/kernel.c"
! 394 int w;
!BCC_EOS
! 395 {
! 396     int n = printString(ptr);
push	bp
mov	bp,sp
push	di
push	si
dec	sp
dec	sp
! Debug: list * char ptr = [S+8+2] (used reg = )
push	4[bp]
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
! Debug: eq int = ax+0 to int n = [S+8-8] (used reg = )
mov	-6[bp],ax
!BCC_EOS
! 397     int diff;
!BCC_EOS
! 398     if (n < w) {
dec	sp
dec	sp
! Debug: lt int w = [S+$A+4] to int n = [S+$A-8] (used reg = )
mov	ax,-6[bp]
cmp	ax,6[bp]
jge 	.5C
.5D:
! 399         diff = w - n;
! Debug: sub int n = [S+$A-8] to int w = [S+$A+4] (used reg = )
mov	ax,6[bp]
sub	ax,-6[bp]
! Debug: eq int = ax+0 to int diff = [S+$A-$A] (used reg = )
mov	-8[bp],ax
!BCC_EOS
! 400         while (diff-- > 0)
! 401             PUT_CHAR(' ');
jmp .5F
.60:
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const $E20 (used reg = )
mov	ax,#$E20
push	ax
! Debug: list int = const $10 (used reg = )
mov	ax,*$10
push	ax
! Debug: func () int = interrupt+0 (used reg = )
call	_interrupt
add	sp,*$A
!BCC_EOS
! 402     }
.5F:
! Debug: postdec int diff = [S+$A-$A] (used reg = )
mov	ax,-8[bp]
dec	ax
mov	-8[bp],ax
! Debug: gt int = const 0 to int = ax+1 (used reg = )
inc	ax
test	ax,ax
jg 	.60
.61:
.5E:
! 403 }
.5C:
add	sp,*4
pop	si
pop	di
pop	bp
ret
! 404 
! 405 
! 406 void printintw(x,w)
! 407 # 406 "./src/kernel.c"
! 406 int x;
export	_printintw
_printintw:
!BCC_EOS
! 407 # 406 "./src/kernel.c"
! 406 int w;
!BCC_EOS
! 407 {
! 408     char buf[13];
!BCC_EOS
! 409     int diff;
!BCC_EOS
! 410     int n = sprintInt(x,buf,13);
push	bp
mov	bp,sp
push	di
push	si
add	sp,*-$12
! Debug: list int = const $D (used reg = )
mov	ax,*$D
push	ax
! Debug: list * char buf = S+$1A-$13 (used reg = )
lea	bx,-$11[bp]
push	bx
! Debug: list int x = [S+$1C+2] (used reg = )
push	4[bp]
! Debug: func () int = sprintInt+0 (used reg = )
call	_sprintInt
add	sp,*6
! Debug: eq int = ax+0 to int n = [S+$18-$18] (used reg = )
mov	-$16[bp],ax
!BCC_EOS
! 411 
! 412     if (n < w) {
! Debug: lt int w = [S+$18+4] to int n = [S+$18-$18] (used reg = )
mov	ax,-$16[bp]
cmp	ax,6[bp]
jge 	.62
.63:
! 413         diff = w - n;
! Debug: sub int n = [S+$18-$18] to int w = [S+$18+4] (used reg = )
mov	ax,6[bp]
sub	ax,-$16[bp]
! Debug: eq int = ax+0 to int diff = [S+$18-$16] (used reg = )
mov	-$14[bp],ax
!BCC_EOS
! 414         while (diff-- > 0)
! 415             PUT_CHAR(' ');
jmp .65
.66:
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const $E20 (used reg = )
mov	ax,#$E20
push	ax
! Debug: list int = const $10 (used reg = )
mov	ax,*$10
push	ax
! Debug: func () int = interrupt+0 (used reg = )
call	_interrupt
add	sp,*$A
!BCC_EOS
! 416     }
.65:
! Debug: postdec int diff = [S+$18-$16] (used reg = )
mov	ax,-$14[bp]
dec	ax
mov	-$14[bp],ax
! Debug: gt int = const 0 to int = ax+1 (used reg = )
inc	ax
test	ax,ax
jg 	.66
.67:
.64:
! 417     printString(buf);
.62:
! Debug: list * char buf = S+$18-$13 (used reg = )
lea	bx,-$11[bp]
push	bx
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 418 }
add	sp,*$12
pop	si
pop	di
pop	bp
ret
! 419 # 426
! 426   
! 427 void kStrCopy(src,dest,len)
! Register BX used in function printintw
! 428 # 427 "./src/kernel.c"
! 427 char *src;
export	_kStrCopy
_kStrCopy:
!BCC_EOS
! 428 # 427 "./src/kernel.c"
! 427 char *dest;
!BCC_EOS
! 428 # 427 "./src/kernel.c"
! 427 int len;
!BCC_EOS
! 428 # 427 "./src/kernel.c"
! 427 { 
! 428    int i=0; 
push	bp
mov	bp,sp
push	di
push	si
dec	sp
dec	sp
! Debug: eq int = const 0 to int i = [S+8-8] (used reg = )
xor	ax,ax
mov	-6[bp],ax
!BCC_EOS
! 429    for (i=0; i < len; i++) { 
! Debug: eq int = const 0 to int i = [S+8-8] (used reg = )
xor	ax,ax
mov	-6[bp],ax
!BCC_EOS
!BCC_EOS
jmp .6A
.6B:
! 430         putInMemory(0x1000,dest+i,src[i]); 
! Debug: ptradd int i = [S+8-8] to * char src = [S+8+2] (used reg = )
mov	ax,-6[bp]
add	ax,4[bp]
mov	bx,ax
! Debug: list char = [bx+0] (used reg = )
mov	al,[bx]
xor	ah,ah
push	ax
! Debug: ptradd int i = [S+$A-8] to * char dest = [S+$A+4] (used reg = )
mov	ax,-6[bp]
add	ax,6[bp]
! Debug: list * char = ax+0 (used reg = )
push	ax
! Debug: list int = const $1000 (used reg = )
mov	ax,#$1000
push	ax
! Debug: func () void = putInMemory+0 (used reg = )
call	_putInMemory
add	sp,*6
!BCC_EOS
! 431         if (src[i] == 0x00) { 
! Debug: ptradd int i = [S+8-8] to * char src = [S+8+2] (used reg = )
mov	ax,-6[bp]
add	ax,4[bp]
mov	bx,ax
! Debug: logeq int = const 0 to char = [bx+0] (used reg = )
mov	al,[bx]
test	al,al
jne 	.6C
.6D:
! 432             return; 
inc	sp
inc	sp
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 433         } 
! 434    } 
.6C:
! 435 }
.69:
! Debug: postinc int i = [S+8-8] (used reg = )
mov	ax,-6[bp]
inc	ax
mov	-6[bp],ax
.6A:
! Debug: lt int len = [S+8+6] to int i = [S+8-8] (used reg = )
mov	ax,-6[bp]
cmp	ax,8[bp]
jl 	.6B
.6E:
.68:
inc	sp
inc	sp
pop	si
pop	di
pop	bp
ret
! 436 # 440
! 440  
! 441 void terminate()
! Register BX used in function kStrCopy
! 442 {
export	_terminate
_terminate:
! 443     int segi;
!BCC_EOS
! 444 
! 445     setKernelDataSegment();
push	bp
mov	bp,sp
push	di
push	si
dec	sp
dec	sp
! Debug: func () void = setKernelDataSegment+0 (used reg = )
call	_setKernelDataSegment
!BCC_EOS
! 446     segi = SEGMENT_INDEX(run
! 446 ning->segment);
mov	bx,[_running]
! Debug: sr int = const $C to int = [bx+$A] (used reg = )
mov	ax,$A[bx]
mov	al,ah
cbw
mov	cl,*4
sar	ax,cl
! Debug: and int = const $F to int = ax+0 (used reg = )
and	al,*$F
! Debug: sub int = const 2 to char = al+0 (used reg = )
xor	ah,ah
! Debug: eq int = ax-2 to int segi = [S+8-8] (used reg = )
dec	ax
dec	ax
mov	-6[bp],ax
!BCC_EOS
! 447     
! 448     releaseMemorySegment(segi);
! Debug: list int segi = [S+8-8] (used reg = )
push	-6[bp]
! Debug: func () void = releaseMemorySegment+0 (used reg = )
call	_releaseMemorySegment
inc	sp
inc	sp
!BCC_EOS
! 449     
! 450     releasePCB(running);
! Debug: list * struct PCB = [running+0] (used reg = )
push	[_running]
! Debug: func () void = releasePCB+0 (used reg = )
call	_releasePCB
inc	sp
inc	sp
!BCC_EOS
! 451     restoreDataSegment();
! Debug: func () void = restoreDataSegment+0 (used reg = )
call	_restoreDataSegment
!BCC_EOS
! 452     
! 453     update_proc_blocked(segi);
! Debug: list int segi = [S+8-8] (used reg = )
push	-6[bp]
! Debug: func () void = update_proc_blocked+0 (used reg = )
call	_update_proc_blocked
inc	sp
inc	sp
!BCC_EOS
! 454 
! 455     yield();
! Debug: func () void = yield+0 (used reg = )
call	_yield
!BCC_EOS
! 456 }
inc	sp
inc	sp
pop	si
pop	di
pop	bp
ret
! 457 # 464
! 464  
! 465 int executeProgram(name,blockopt)
! Register BX used in function terminate
! 466 # 465 "./src/kernel.c"
! 465 char *name;
export	_executeProgram
_executeProgram:
!BCC_EOS
! 466 # 465 "./src/kernel.c"
! 465 int blockopt;
!BCC_EOS
! 466 {
! 467     char buffer[MAX_FILE];   
!BCC_EOS
! 468     char magic_num[EXEC_MAGIC_OFFSET+1];
!BCC_EOS
! 469     int k = 0, i = 0;
push	bp
mov	bp,sp
push	di
push	si
add	sp,#-$3406
! Debug: eq int = const 0 to int k = [S+$340C-$340C] (used reg = )
xor	ax,ax
mov	-$340A[bp],ax
dec	sp
dec	sp
! Debug: eq int = const 0 to int i = [S+$340E-$340E] (used reg = )
xor	ax,ax
mov	-$340C[bp],ax
!BCC_EOS
! 470     int ret = 0;
dec	sp
dec	sp
! Debug: eq int = const 0 to int ret = [S+$3410-$3410] (used reg = )
xor	ax,ax
mov	-$340E[bp],ax
!BCC_EOS
! 471     int segi;
!BCC_EOS
! 472     int segment;
!BCC_EOS
! 473     struct PCB *pcb;
!BCC_EOS
! 474 
! 475     k = readFile(name,buffer,MAX_FILE);
add	sp,*-6
! Debug: list int = const $3400 (used reg = )
mov	ax,#$3400
push	ax
! Debug: list * char buffer = S+$3418-$3406 (used reg = )
lea	bx,-$3404[bp]
push	bx
! Debug: list * char name = [S+$341A+2] (used reg = )
push	4[bp]
! Debug: func () int = readFile+0 (used reg = )
call	_readFile
add	sp,*6
! Debug: eq int = ax+0 to int k = [S+$3416-$340C] (used reg = )
mov	-$340A[bp],ax
!BCC_EOS
! 476     if (k < 0)
! Debug: lt int = const 0 to int k = [S+$3416-$340C] (used reg = )
mov	ax,-$340A[bp]
test	ax,ax
jge 	.6F
.70:
! 477         return -1;
mov	ax,*-1
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 478 
! 479     
! 480     for (i = 0; i < EXEC_MAGIC_OFFSET; ++i)
.6F:
! Debug: eq int = const 0 to int i = [S+$3416-$340E] (used reg = )
xor	ax,ax
mov	-$340C[bp],ax
!BCC_EOS
!BCC_EOS
! 481         magic_num[i] = loadCharKernel(EXEC_MAGIC_NUM+i);
jmp .73
.74:
! Debug: ptradd int i = [S+$3416-$340E] to [4] char = .75+0 (used reg = )
mov	bx,-$340C[bp]
! Debug: cast * char = const 0 to [4] char = bx+.75+0 (used reg = )
! Debug: list * char = bx+.75+0 (used reg = )
add	bx,#.75
push	bx
! Debug: func () int = loadCharKernel+0 (used reg = )
call	_loadCharKernel
inc	sp
inc	sp
push	ax
! Debug: ptradd int i = [S+$3418-$340E] to [4] char magic_num = S+$3418-$340A (used reg = )
mov	ax,-$340C[bp]
mov	bx,bp
add	bx,ax
! Debug: eq int (temp) = [S+$3418-$3418] to char = [bx-$3408] (used reg = )
mov	ax,-$3416[bp]
mov	-$3408[bx],al
inc	sp
inc	sp
!BCC_EOS
! 482     magic_num[i] = 0;
.72:
! Debug: preinc int i = [S+$3416-$340E] (used reg = )
mov	ax,-$340C[bp]
inc	ax
mov	-$340C[bp],ax
.73:
! Debug: lt int = const 3 to int i = [S+$3416-$340E] (used reg = )
mov	ax,-$340C[bp]
cmp	ax,*3
jl 	.74
.76:
.71:
! Debug: ptradd int i = [S+$3416-$340E] to [4] char magic_num = S+$3416-$340A (used reg = )
mov	ax,-$340C[bp]
mov	bx,bp
add	bx,ax
! Debug: eq int = const 0 to char = [bx-$3408] (used reg = )
xor	al,al
mov	-$3408[bx],al
!BCC_EOS
! 483 
! 484     
! 485     ret = strcmpn(magic_num,buffer,EXEC_MAGIC_OFFSET);
! Debug: list int = const 3 (used reg = )
mov	ax,*3
push	ax
! Debug: list * char buffer = S+$3418-$3406 (used reg = )
lea	bx,-$3404[bp]
push	bx
! Debug: list * char magic_num = S+$341A-$340A (used reg = )
lea	bx,-$3408[bp]
push	bx
! Debug: func () int = strcmpn+0 (used reg = )
call	_strcmpn
add	sp,*6
! Debug: eq int = ax+0 to int ret = [S+$3416-$3410] (used reg = )
mov	-$340E[bp],ax
!BCC_EOS
! 486     if (!ret)
mov	ax,-$340E[bp]
test	ax,ax
jne 	.77
.78:
! 487     {
! 488         return -3;
mov	ax,*-3
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 489     }
! 490 
! 491     
! 492     setKernelDataSegment();
.77:
! Debug: func () void = setKernelDataSegment+0 (used reg = )
call	_setKernelDataSegment
!BCC_EOS
! 493     segi = getFreeMemorySegment();
! Debug: func () int = getFreeMemorySegment+0 (used reg = )
call	_getFreeMemorySegment
! Debug: eq int = ax+0 to int segi = [S+$3416-$3412] (used reg = )
mov	-$3410[bp],ax
!BCC_EOS
! 494     restoreDataSegment();
! Debug: func () void = restoreDataSegment+0 (used reg = )
call	_restoreDataSegment
!BCC_EOS
! 495 
! 496     
! 497     segment = INDEX_SEGMENT(segi);
! Debug: add int = const 2 to int segi = [S+$3416-$3412] (used reg = )
mov	ax,-$3410[bp]
! Debug: sl int = const $C to int = ax+2 (used reg = )
inc	ax
inc	ax
mov	ah,al
xor	al,al
mov	cl,*4
shl	ax,cl
! Debug: eq int = ax+0 to int segment = [S+$3416-$3414] (used reg = )
mov	-$3412[bp],ax
!BCC_EOS
! 498 
! 499     if (segi == -1 )
! Debug: logeq int = const -1 to int segi = [S+$3416-$3412] (used reg = )
mov	ax,-$3410[bp]
cmp	ax,*-1
jne 	.79
.7A:
! 500         return -2;
mov	ax,*-2
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 501 
! 502 
! 503     k = (k << 9);
.79:
! Debug: sl int = const 9 to int k = [S+$3416-$340C] (used reg = )
mov	ax,-$340A[bp]
mov	ah,al
xor	al,al
shl	ax,*1
! Debug: eq int = ax+0 to int k = [S+$3416-$340C] (used reg = )
mov	-$340A[bp],ax
!BCC_EOS
! 504     for (i = EXEC_MAGIC_OFFSET; i < k; ++i)
! Debug: eq int = const 3 to int i = [S+$3416-$340E] (used reg = )
mov	ax,*3
mov	-$340C[bp],ax
!BCC_EOS
!BCC_EOS
! 505     {
jmp .7D
.7E:
! 506         putInMemory(segment,i-EXEC_MAGIC_OFFSET,*(buffer+i));
! Debug: ptradd int i = [S+$3416-$340E] to [$3400] char buffer = S+$3416-$3406 (used reg = )
mov	ax,-$340C[bp]
mov	bx,bp
add	bx,ax
! Debug: list char = [bx-$3404] (used reg = )
mov	al,-$3404[bx]
xor	ah,ah
push	ax
! Debug: sub int = const 3 to int i = [S+$3418-$340E] (used reg = )
mov	ax,-$340C[bp]
! Debug: list int = ax-3 (used reg = )
add	ax,*-3
push	ax
! Debug: list int segment = [S+$341A-$3414] (used reg = )
push	-$3412[bp]
! Debug: func () void = putInMemory+0 (used reg = )
call	_putInMemory
add	sp,*6
!BCC_EOS
! 507     }
! 508 
! 509     
! 510     setKernelDataSegment();
.7C:
! Debug: preinc int i = [S+$3416-$340E] (used reg = )
mov	ax,-$340C[bp]
inc	ax
mov	-$340C[bp],ax
.7D:
! Debug: lt int k = [S+$3416-$340C] to int i = [S+$3416-$340E] (used reg = )
mov	ax,-$340C[bp]
cmp	ax,-$340A[bp]
jl 	.7E
.7F:
.7B:
! Debug: func () void = setKernelDataSegment+0 (used reg = )
call	_setKernelDataSegment
!BCC_EOS
! 511     pcb = getFreePCB();
! Debug: func () * struct PCB = getFreePCB+0 (used reg = )
call	_getFreePCB
! Debug: eq * struct PCB = ax+0 to * struct PCB pcb = [S+$3416-$3416] (used reg = )
mov	-$3414[bp],ax
!BCC_EOS
! 512     restoreDataSegment();
! Debug: func () void = restoreDataSegment+0 (used reg = )
call	_restoreDataSegment
!BCC_EOS
! 513 
! 514     if (pcb == 0x00 )
! Debug: logeq int = const 0 to * struct PCB pcb = [S+$3416-$3416] (used reg = )
mov	ax,-$3414[bp]
test	ax,ax
jne 	.80
.81:
! 515         return -4;
mov	ax,*-4
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 516     
! 517     kStrCopy(name,pcb->name,7);
.80:
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: cast * char = const 0 to [7] char pcb = [S+$3418-$3416] (used reg = )
! Debug: list * char pcb = [S+$3418-$3416] (used reg = )
push	-$3414[bp]
! Debug: list * char name = [S+$341A+2] (used reg = )
push	4[bp]
! Debug: func () void = kStrCopy+0 (used reg = )
call	_kStrCopy
add	sp,*6
!BCC_EOS
! 518 
! 519     setKernelDataSegment();
! Debug: func () void = setKernelDataSegment+0 (used reg = )
call	_setKernelDataSegment
!BCC_EOS
! 520     pcb->state = 4 ;
mov	bx,-$3414[bp]
! Debug: eq int = const 4 to int = [bx+8] (used reg = )
mov	ax,*4
mov	8[bx],ax
!BCC_EOS
! 521     pcb->segment = segment;
mov	bx,-$3414[bp]
! Debug: eq int segment = [S+$3416-$3414] to int = [bx+$A] (used reg = )
mov	ax,-$3412[bp]
mov	$A[bx],ax
!BCC_EOS
! 522     pcb->stackPointer = 0xff00;
mov	bx,-$3414[bp]
! Debug: eq unsigned int = const $FF00 to int = [bx+$C] (used reg = )
mov	ax,#$FF00
mov	$C[bx],ax
!BCC_EOS
! 523 
! 524     
! 525     initializeProgram(segment);
! Debug: list int segment = [S+$3416-$3414] (used reg = )
push	-$3412[bp]
! Debug: func () int = initializeProgram+0 (used reg = )
call	_initializeProgram
inc	sp
inc	sp
!BCC_EOS
! 526 
! 527     
! 528     disableInterrupts(); 
! Debug: func () void = disableInterrupts+0 (used reg = )
call	_disableInterrupts
!BCC_EOS
! 529     if (blockopt)
mov	ax,6[bp]
test	ax,ax
je  	.82
.83:
! 530     {
! 531         block(segi);
! Debug: list int segi = [S+$3416-$3412] (used reg = )
push	-$3410[bp]
! Debug: func () int = block+0 (used reg = )
call	_block
inc	sp
inc	sp
!BCC_EOS
! 532     }
! 533     addToReady(pcb);
.82:
! Debug: list * struct PCB pcb = [S+$3416-$3416] (used reg = )
push	-$3414[bp]
! Debug: func () void = addToReady+0 (used reg = )
call	_addToReady
inc	sp
inc	sp
!BCC_EOS
! 534     restoreInterrupts();
! Debug: func () int = restoreInterrupts+0 (used reg = )
call	_restoreInterrupts
!BCC_EOS
! 535 
! 536     restoreDataSegment();
! Debug: func () void = restoreDataSegment+0 (used reg = )
call	_restoreDataSegment
!BCC_EOS
! 537 
! 538     if (blockopt)
mov	ax,6[bp]
test	ax,ax
je  	.84
.85:
! 539         yield();
! Debug: func () void = yield+0 (used reg = )
call	_yield
!BCC_EOS
! 540 
! 541     return 1;
.84:
mov	ax,*1
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 542 }
! 543 
! 544 
! 545 
! 546  
! 547 void yield()
! Register BX used in function executeProgram
! 548 {
export	_yield
_yield:
! 549     
! 550     interrupt(0x08,0,0,0,0);
push	bp
mov	bp,sp
push	di
push	si
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 8 (used reg = )
mov	ax,*8
push	ax
! Debug: func () int = interrupt+0 (used reg = )
call	_interrupt
add	sp,*$A
!BCC_EOS
! 551 }
pop	si
pop	di
pop	bp
ret
! 552 # 652
! 652  
! 653 int handleInterrupt21(ax,bx,cx,dx)
! 654 # 653 "./src/kernel.c"
! 653 int ax;
export	_handleInterrupt21
_handleInterrupt21:
!BCC_EOS
! 654 # 653 "./src/kernel.c"
! 653 int bx;
!BCC_EOS
! 654 # 653 "./src/kernel.c"
! 653 int cx;
!BCC_EOS
! 654 # 653 "./src/kernel.c"
! 653 int dx;
!BCC_EOS
! 654 {
! 655     int ret = -1;
push	bp
mov	bp,sp
push	di
push	si
dec	sp
dec	sp
! Debug: eq int = const -1 to int ret = [S+8-8] (used reg = )
mov	ax,*-1
mov	-6[bp],ax
!BCC_EOS
! 656     int i = 0;
dec	sp
dec	sp
! Debug: eq int = const 0 to int i = [S+$A-$A] (used reg = )
xor	ax,ax
mov	-8[bp],ax
!BCC_EOS
! 657     char buffer[20];
!BCC_EOS
! 658 
! 659     switch(ax)
add	sp,*-$14
mov	ax,4[bp]
! 660     {
br 	.88
! 661         case 0x00:
! 662             
! 663             ret = printString((char*)bx);
.89:
! Debug: list * char bx = [S+$1E+4] (used reg = )
push	6[bp]
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
! Debug: eq int = ax+0 to int ret = [S+$1E-8] (used reg = )
mov	-6[bp],ax
!BCC_EOS
! 664             break;
br 	.86
!BCC_EOS
! 665 
! 666         case 0xff:
! 667             
! 668             putStr((char*)bx,strlen((
.8A:
! 668 char*)bx),cx,(dx >> 8)& 0xff,dx & 0xff);
! Debug: and int = const $FF to int dx = [S+$1E+8] (used reg = )
mov	al,$A[bp]
! Debug: list char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: sr int = const 8 to int dx = [S+$20+8] (used reg = )
mov	ax,$A[bp]
mov	al,ah
cbw
! Debug: and int = const $FF to int = ax+0 (used reg = )
! Debug: list char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: list int cx = [S+$22+6] (used reg = )
push	8[bp]
! Debug: list * char bx = [S+$24+4] (used reg = )
push	6[bp]
! Debug: func () int = strlen+0 (used reg = )
call	_strlen
inc	sp
inc	sp
! Debug: list int = ax+0 (used reg = )
push	ax
! Debug: list * char bx = [S+$26+4] (used reg = )
push	6[bp]
! Debug: func () void = putStr+0 (used reg = )
call	_putStr
add	sp,*$A
!BCC_EOS
! 669             ret = 1;
! Debug: eq int = const 1 to int ret = [S+$1E-8] (used reg = )
mov	ax,*1
mov	-6[bp],ax
!BCC_EOS
! 670             break;
br 	.86
!BCC_EOS
! 671 
! 672         case 0xa1:
! 673             
! 674             ret = sleep(bx);
.8B:
! Debug: list int bx = [S+$1E+4] (used reg = )
push	6[bp]
! Debug: func () int = sleep+0 (used reg = )
call	_sleep
inc	sp
inc	sp
! Debug: eq int = ax+0 to int ret = [S+$1E-8] (used reg = )
mov	-6[bp],ax
!BCC_EOS
! 675             break;
br 	.86
!BCC_EOS
! 676 
! 677         case 0x0b:
! 678             
! 679             ret = kill(bx);
.8C:
! Debug: list int bx = [S+$1E+4] (used reg = )
push	6[bp]
! Debug: func () int = kill+0 (used reg = )
call	_kill
inc	sp
inc	sp
! Debug: eq int = ax+0 to int ret = [S+$1E-8] (used reg = )
mov	-6[bp],ax
!BCC_EOS
! 680             break;
br 	.86
!BCC_EOS
! 681 
! 682         case 0x0a:
! 683             
! 684             showProcesses();
.8D:
! Debug: func () void = showProcesses+0 (used reg = )
call	_showProcesses
!BCC_EOS
! 685             ret = 1;
! Debug: eq int = const 1 to int ret = [S+$1E-8] (used reg = )
mov	ax,*1
mov	-6[bp],ax
!BCC_EOS
! 686             break;
br 	.86
!BCC_EOS
! 687 
! 688         case 0x09:
! 689             
! 690             yield();
.8E:
! Debug: func () void = yield+0 (used reg = )
call	_yield
!BCC_EOS
! 691             ret = 1;
! Debug: eq int = const 1 to int ret = [S+$1E-8] (used reg = )
mov	ax,*1
mov	-6[bp],ax
!BCC_EOS
! 692             break;
br 	.86
!BCC_EOS
! 693 
! 694         case 0x03:
! 695             
! 696             
! 697             
! 698             for (i = 0; i < 17; ++i)
.8F:
! Debug: eq int = const 0 to int i = [S+$1E-$A] (used reg = )
xor	ax,ax
mov	-8[bp],ax
!BCC_EOS
!BCC_EOS
! 699                 buffer[i] = loadCharKernel("__DISK_DIRECTORY"+i);
jmp .92
.93:
! Debug: ptradd int i = [S+$1E-$A] to [$11] char = .94+0 (used reg = )
mov	bx,-8[bp]
! Debug: cast * char = const 0 to [$11] char = bx+.94+0 (used reg = )
! Debug: list * char = bx+.94+0 (used reg = )
add	bx,#.94
push	bx
! Debug: func () int = loadCharKernel+0 (used reg = )
call	_loadCharKernel
inc	sp
inc	sp
push	ax
! Debug: ptradd int i = [S+$20-$A] to [$14] char buffer = S+$20-$1E (used reg = )
mov	ax,-8[bp]
mov	bx,bp
add	bx,ax
! Debug: eq int (temp) = [S+$20-$20] to char = [bx-$1C] (used reg = )
mov	ax,0+..FFFE[bp]
mov	-$1C[bx],al
inc	sp
inc	sp
!BCC_EOS
! 700 
! 701             if (strcmp((char*)bx,buffer)) {
.91:
! Debug: preinc int i = [S+$1E-$A] (used reg = )
mov	ax,-8[bp]
inc	ax
mov	-8[bp],ax
.92:
! Debug: lt int = const $11 to int i = [S+$1E-$A] (used reg = )
mov	ax,-8[bp]
cmp	ax,*$11
jl 	.93
.95:
.90:
! Debug: list * char buffer = S+$1E-$1E (used reg = )
lea	bx,-$1C[bp]
push	bx
! Debug: list * char bx = [S+$20+4] (used reg = )
push	6[bp]
! Debug: func () int = strcmp+0 (used reg = )
call	_strcmp
add	sp,*4
test	ax,ax
je  	.96
.97:
! 702                 ret = readSector((char*)cx,2);
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: list * char cx = [S+$20+6] (used reg = )
push	8[bp]
! Debug: func () int = readSector+0 (used reg = )
call	_readSector
add	sp,*4
! Debug: eq int = ax+0 to int ret = [S+$1E-8] (used reg = )
mov	-6[bp],ax
!BCC_EOS
! 703             } else {
jmp .98
.96:
! 704                 ret = readFile((char*)bx,(char*)cx,(int)dx);
! Debug: list int dx = [S+$1E+8] (used reg = )
push	$A[bp]
! Debug: list * char cx = [S+$20+6] (used reg = )
push	8[bp]
! Debug: list * char bx = [S+$22+4] (used reg = )
push	6[bp]
! Debug: func () int = readFile+0 (used reg = )
call	_readFile
add	sp,*6
! Debug: eq int = ax+0 to int ret = [S+$1E-8] (used reg = )
mov	-6[bp],ax
!BCC_EOS
! 705             }
! 706             break;
.98:
br 	.86
!BCC_EOS
! 707 
! 708         case 0x04:
! 709             
! 710             ret = executeProgram((char*)bx,cx);
.99:
! Debug: list int cx = [S+$1E+6] (used reg = )
push	8[bp]
! Debug: list * char bx = [S+$20+4] (used reg = )
push	6[bp]
! Debug: func () int = executeProgram+0 (used reg = )
call	_executeProgram
add	sp,*4
! Debug: eq int = ax+0 to int ret = [S+$1E-8] (used reg = )
mov	-6[bp],ax
!BCC_EOS
! 711             break;
br 	.86
!BCC_EOS
! 712 
! 713         case 0x05:
! 714             
! 715             terminate(); 
.9A:
! Debug: func () void = terminate+0 (used reg = )
call	_terminate
!BCC_EOS
! 716             break;
br 	.86
!BCC_EOS
! 717 
! 718         case 0x07:
! 719             
! 720             ret = deleteFile((char*)bx);
.9B:
! Debug: list * char bx = [S+$1E+4] (used reg = )
push	6[bp]
! Debug: func () int = deleteFile+0 (used reg = )
call	_deleteFile
inc	sp
inc	sp
! Debug: eq int = ax+0 to int ret = [S+$1E-8] (used reg = )
mov	-6[bp],ax
!BCC_EOS
! 721             break;
br 	.86
!BCC_EOS
! 722 
! 723         case 0x08:
! 724             
! 725             ret = writeFile((char*)bx,(char*)cx,(int)dx);
.9C:
! Debug: list int dx = [S+$1E+8] (used reg = )
push	$A[bp]
! Debug: list * char cx = [S+$20+6] (used reg = )
push	8[bp]
! Debug: list * char bx = [S+$22+4] (used reg = )
push	6[bp]
! Debug: func () int = writeFile+0 (used reg = )
call	_writeFile
add	sp,*6
! Debug: eq int = ax+0 to int ret = [S+$1E-8] (used reg = )
mov	-6[bp],ax
!BCC_EOS
! 726             break;
jmp .86
!BCC_EOS
! 727 
! 728         case 0x11:
! 729             
! 730             *((char*)bx) = (char) (interrupt(0x16,0,0,0,0)& 0xFF) ;
.9D:
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const $16 (used reg = )
mov	ax,*$16
push	ax
! Debug: func () int = interrupt+0 (used reg = )
call	_interrupt
add	sp,*$A
! Debug: and int = const $FF to int = ax+0 (used reg = )
! Debug: cast char = const 0 to char = al+0 (used reg = )
mov	bx,6[bp]
! Debug: eq char = al+0 to char = [bx+0] (used reg = )
mov	[bx],al
!BCC_EOS
! 731             ret = 1;
! Debug: eq int = const 1 to int ret = [S+$1E-8] (used reg = )
mov	ax,*1
mov	-6[bp],ax
!BCC_EOS
! 732             break;
jmp .86
!BCC_EOS
! 733 
! 734         case 0x01:
! 735             
! 736             ret = readString((char*)bx,cx);
.9E:
! Debug: list int cx = [S+$1E+6] (used reg = )
push	8[bp]
! Debug: list * char bx = [S+$20+4] (used reg = )
push	6[bp]
! Debug: func () int = readString+0 (used reg = )
call	_readString
add	sp,*4
! Debug: eq int = ax+0 to int ret = [S+$1E-8] (used reg = )
mov	-6[bp],ax
!BCC_EOS
! 737             break;
jmp .86
!BCC_EOS
! 738     }
! 739 
! 740     return ret;
jmp .86
.88:
sub	ax,*0
jl  	.86
cmp	ax,*$11
ja  	.9F
shl	ax,*1
mov	bx,ax
seg	cs
br	.A0[bx]
.A0:
.word	.89
.word	.9E
.word	.86
.word	.8F
.word	.99
.word	.9A
.word	.86
.word	.9B
.word	.9C
.word	.8E
.word	.8D
.word	.8C
.word	.86
.word	.86
.word	.86
.word	.86
.word	.86
.word	.9D
.9F:
sub	ax,#$A1
beq 	.8B
sub	ax,*$5E
beq 	.8A
.86:
..FFFE	=	-$1E
mov	ax,-6[bp]
add	sp,*$18
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 741 }
! 742 # 748
! 748  
! 749 # 763
! 763  
! 764 int writeFile(fname,buffer,sectors)
! Register BX used in function handleInterrupt21
! 765 # 764 "./src/kernel.c"
! 764 char *fname;
export	_writeFile
_writeFile:
!BCC_EOS
! 765 # 764 "./src/kernel.c"
! 764 char *buffer;
!BCC_EOS
! 765 # 764 "./src/kernel.c"
! 764 int sectors;
!BCC_EOS
! 765 {
! 766     
! 767     char disk_map[512];
!BCC_EOS
! 768     
! 769     char disk_dir[512];
!BCC_EOS
! 770     
! 771     char file_sectors[26];
!BCC_EOS
! 772     
! 773     char *ptr;
!BCC_EOS
! 774     char *mptr;
!BCC_EOS
! 775     
! 776     int   j  = 0;
push	bp
mov	bp,sp
push	di
push	si
add	sp,#-$420
! Debug: eq int = const 0 to int j = [S+$426-$426] (used reg = )
xor	ax,ax
mov	-$424[bp],ax
!BCC_EOS
! 777     
! 778     int byte = 0;
dec	sp
dec	sp
! Debug: eq int = const 0 to int byte = [S+$428-$428] (used reg = )
xor	ax,ax
mov	-$426[bp],ax
!BCC_EOS
! 779     
! 780     int free_entry = -1;
dec	sp
dec	sp
! Debug: eq int = const -1 to int free_entry = [S+$42A-$42A] (used reg = )
mov	ax,*-1
mov	-$428[bp],ax
!BCC_EOS
! 781 
! 782     
! 783     readSector(disk_map,1);
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: list * char disk_map = S+$42C-$206 (used reg = )
lea	bx,-$204[bp]
push	bx
! Debug: func () int = readSector+0 (used reg = )
call	_readSector
add	sp,*4
!BCC_EOS
! 784     readSector(disk_dir,2);
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: list * char disk_dir = S+$42C-$406 (used reg = )
lea	bx,-$404[bp]
push	bx
! Debug: func () int = readSector+0 (used reg = )
call	_readSector
add	sp,*4
!BCC_EOS
! 785 
! 786     
! 787     sectors = (sectors < 26 ? sectors : 26);
! Debug: lt int = const $1A to int sectors = [S+$42A+6] (used reg = )
mov	ax,8[bp]
cmp	ax,*$1A
jge 	.A1
.A2:
mov	ax,8[bp]
jmp .A3
.A1:
mov	ax,*$1A
.A3:
! Debug: eq int = ax+0 to int sectors = [S+$42A+6] (used reg = )
mov	8[bp],ax
!BCC_EOS
! 788 
! 789     
! 790     
! 791     
! 792     
! 793 
! 794     
! 795     for(; byte < 512; byte += 32)
!BCC_EOS
!BCC_EOS
! 796     {
jmp .A6
.A7:
! 797         if (free_entry < 0 && !*(disk_dir+byte))
! Debug: lt int = const 0 to int free_entry = [S+$42A-$42A] (used reg = )
mov	ax,-$428[bp]
test	ax,ax
jge 	.A8
.AA:
! Debug: ptradd int byte = [S+$42A-$428] to [$200] char disk_dir = S+$42A-$406 (used reg = )
mov	ax,-$426[bp]
mov	bx,bp
add	bx,ax
mov	al,-$404[bx]
test	al,al
jne 	.A8
.A9:
! 798     
! 798         free_entry = byte;
! Debug: eq int byte = [S+$42A-$428] to int free_entry = [S+$42A-$42A] (used reg = )
mov	ax,-$426[bp]
mov	-$428[bp],ax
!BCC_EOS
! 799         if (bstrcmpn(fname,disk_dir + byte,6))
.A8:
! Debug: list int = const 6 (used reg = )
mov	ax,*6
push	ax
! Debug: ptradd int byte = [S+$42C-$428] to [$200] char disk_dir = S+$42C-$406 (used reg = )
mov	ax,-$426[bp]
mov	bx,bp
add	bx,ax
! Debug: cast * char = const 0 to [$200] char = bx-$404 (used reg = )
! Debug: list * char = bx-$404 (used reg = )
add	bx,#-$404
push	bx
! Debug: list * char fname = [S+$42E+2] (used reg = )
push	4[bp]
! Debug: func () int = bstrcmpn+0 (used reg = )
call	_bstrcmpn
add	sp,*6
test	ax,ax
je  	.AB
.AC:
! 800             break;
jmp .A4
!BCC_EOS
! 801     }
.AB:
! 802 
! 803     if (byte < 512)
.A5:
! Debug: addab int = const $20 to int byte = [S+$42A-$428] (used reg = )
mov	ax,-$426[bp]
add	ax,*$20
mov	-$426[bp],ax
.A6:
! Debug: lt int = const $200 to int byte = [S+$42A-$428] (used reg = )
mov	ax,-$426[bp]
cmp	ax,#$200
jl 	.A7
.AD:
.A4:
! Debug: lt int = const $200 to int byte = [S+$42A-$428] (used reg = )
mov	ax,-$426[bp]
cmp	ax,#$200
bge 	.AE
.AF:
! 804     {
! 805         
! 806         
! 807         ptr  = disk_dir + byte + 6;;
! Debug: ptradd int byte = [S+$42A-$428] to [$200] char disk_dir = S+$42A-$406 (used reg = )
mov	ax,-$426[bp]
mov	bx,bp
add	bx,ax
! Debug: ptradd int = const 6 to [$200] char = bx-$404 (used reg = )
! Debug: eq [$200] char = bx-$3FE to * char ptr = [S+$42A-$422] (used reg = )
add	bx,#-$3FE
mov	-$420[bp],bx
!BCC_EOS
!BCC_EOS
! 808         j = 0;
! Debug: eq int = const 0 to int j = [S+$42A-$426] (used reg = )
xor	ax,ax
mov	-$424[bp],ax
!BCC_EOS
! 809         while (j < sectors && *ptr)
! 810         {
jmp .B1
.B2:
! 811             
! 812             
! 813             
! 814             
! 815             
! 816             writeSector(buffer + (j++<<9),*(ptr++));
! Debug: postinc * char ptr = [S+$42A-$422] (used reg = )
mov	bx,-$420[bp]
inc	bx
mov	-$420[bp],bx
! Debug: list char = [bx-1] (used reg = )
mov	al,-1[bx]
xor	ah,ah
push	ax
! Debug: postinc int j = [S+$42C-$426] (used reg = )
mov	ax,-$424[bp]
inc	ax
mov	-$424[bp],ax
! Debug: sl int = const 9 to int = ax-1 (used reg = )
dec	ax
mov	ah,al
xor	al,al
shl	ax,*1
! Debug: ptradd int = ax+0 to * char buffer = [S+$42C+4] (used reg = )
add	ax,6[bp]
! Debug: list * char = ax+0 (used reg = )
push	ax
! Debug: func () int = writeSector+0 (used reg = )
call	_writeSector
add	sp,*4
!BCC_EOS
! 817         }
! 818 
! 819         if (j == sectors)
.B1:
! Debug: lt int sectors = [S+$42A+6] to int j = [S+$42A-$426] (used reg = )
mov	ax,-$424[bp]
cmp	ax,8[bp]
jge 	.B3
.B4:
mov	bx,-$420[bp]
mov	al,[bx]
test	al,al
jne	.B2
.B3:
.B0:
! Debug: logeq int sectors = [S+$42A+6] to int j = [S+$42A-$426] (used reg = )
mov	ax,-$424[bp]
cmp	ax,8[bp]
jne 	.B5
.B6:
! 820         {
! 821             
! 822             while (j < 26 && *ptr) {
jmp .B8
.B9:
! 823                 
! 824                 
! 825                 
! 826                 
! 827                 
! 828 
! 829                 disk_map[*ptr] = 0; 
mov	bx,-$420[bp]
! Debug: ptradd char = [bx+0] to [$200] char disk_map = S+$42A-$206 (used reg = )
mov	al,[bx]
xor	ah,ah
mov	bx,bp
add	bx,ax
! Debug: eq int = const 0 to char = [bx-$204] (used reg = )
xor	al,al
mov	-$204[bx],al
!BCC_EOS
! 830                 *(ptr++) = 0;       
! Debug: postinc * char ptr = [S+$42A-$422] (used reg = )
mov	bx,-$420[bp]
inc	bx
mov	-$420[bp],bx
! Debug: eq int = const 0 to char = [bx-1] (used reg = )
xor	al,al
mov	-1[bx],al
!BCC_EOS
! 831                 ++j;
! Debug: preinc int j = [S+$42A-$426] (used reg = )
mov	ax,-$424[bp]
inc	ax
mov	-$424[bp],ax
!BCC_EOS
! 832             }
! 833         }
.B8:
! Debug: lt int = const $1A to int j = [S+$42A-$426] (used reg = )
mov	ax,-$424[bp]
cmp	ax,*$1A
jge 	.BA
.BB:
mov	bx,-$420[bp]
mov	al,[bx]
test	al,al
jne	.B9
.BA:
.B7:
! 834     }
.B5:
! 835     else if (free_entry < 0)
jmp .BC
.AE:
! Debug: lt int = const 0 to int free_entry = [S+$42A-$42A] (used reg = )
mov	ax,-$428[bp]
test	ax,ax
jge 	.BD
.BE:
! 836     {
! 837         
! 838         return -1;
mov	ax,*-1
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 839     }
! 840     else
! 841     {
jmp .BF
.BD:
! 842         
! 843         
! 844         strcpyn(disk_dir+free_entry,7,fname);
! Debug: list * char fname = [S+$42A+2] (used reg = )
push	4[bp]
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: ptradd int free_entry = [S+$42E-$42A] to [$200] char disk_dir = S+$42E-$406 (used reg = )
mov	ax,-$428[bp]
mov	bx,bp
add	bx,ax
! Debug: cast * char = const 0 to [$200] char = bx-$404 (used reg = )
! Debug: list * char = bx-$404 (used reg = )
add	bx,#-$404
push	bx
! Debug: func () int = strcpyn+0 (used reg = )
call	_strcpyn
add	sp,*6
!BCC_EOS
! 845         ptr = disk_dir+free_entry+6;
! Debug: ptradd int free_entry = [S+$42A-$42A] to [$200] char disk_dir = S+$42A-$406 (used reg = )
mov	ax,-$428[bp]
mov	bx,bp
add	bx,ax
! Debug: ptradd int = const 6 to [$200] char = bx-$404 (used reg = )
! Debug: eq [$200] char = bx-$3FE to * char ptr = [S+$42A-$422] (used reg = )
add	bx,#-$3FE
mov	-$420[bp],bx
!BCC_EOS
! 846     }
! 847 
! 848 
! 849     
! 850     mptr = disk_map;
.BF:
.BC:
! Debug: eq [$200] char disk_map = S+$42A-$206 to * char mptr = [S+$42A-$424] (used reg = )
lea	bx,-$204[bp]
mov	-$422[bp],bx
!BCC_EOS
! 851 
! 852     while (mptr != disk_map + 512 && j < sectors)
! 853     {
jmp .C1
.C2:
! 854         if (!*mptr)
mov	bx,-$422[bp]
mov	al,[bx]
test	al,al
jne 	.C3
.C4:
! 855         {
! 856             writeSector(buffer + (j++ << 9),mptr-disk_map);
! Debug: ptrsub [$200] char disk_map = S+$42A-$206 to * char mptr = [S+$42A-$424] (used reg = )
lea	bx,-$204[bp]
push	bx
mov	ax,-$422[bp]
sub	ax,-$42A[bp]
inc	sp
inc	sp
! Debug: list int = ax+0 (used reg = )
push	ax
! Debug: postinc int j = [S+$42C-$426] (used reg = )
mov	ax,-$424[bp]
inc	ax
mov	-$424[bp],ax
! Debug: sl int = const 9 to int = ax-1 (used reg = )
dec	ax
mov	ah,al
xor	al,al
shl	ax,*1
! Debug: ptradd int = ax+0 to * char buffer = [S+$42C+4] (used reg = )
add	ax,6[bp]
! Debug: list * char = ax+0 (used reg = )
push	ax
! Debug: func () int = writeSector+0 (used reg = )
call	_writeSector
add	sp,*4
!BCC_EOS
! 857             *mptr = 0xff;
mov	bx,-$422[bp]
! Debug: eq int = const $FF to char = [bx+0] (used reg = )
mov	al,#$FF
mov	[bx],al
!BCC_EOS
! 858             *(ptr++) = mptr - disk_map;
! Debug: ptrsub [$200] char disk_map = S+$42A-$206 to * char mptr = [S+$42A-$424] (used reg = )
lea	bx,-$204[bp]
push	bx
mov	ax,-$422[bp]
sub	ax,-$42A[bp]
inc	sp
inc	sp
push	ax
! Debug: postinc * char ptr = [S+$42C-$422] (used reg = )
mov	bx,-$420[bp]
inc	bx
mov	-$420[bp],bx
! Debug: eq int (temp) = [S+$42C-$42C] to char = [bx-1] (used reg = )
mov	ax,-$42A[bp]
mov	-1[bx],al
inc	sp
inc	sp
!BCC_EOS
! 859         }
! 860         ++mptr;
.C3:
! Debug: preinc * char mptr = [S+$42A-$424] (used reg = )
mov	bx,-$422[bp]
inc	bx
mov	-$422[bp],bx
!BCC_EOS
! 861     }
! 862 
! 863     
! 864     if (j < 26)
.C1:
! Debug: ne * char disk_map = S+$42A-6 to * char mptr = [S+$42A-$424] (used reg = )
lea	bx,-4[bp]
cmp	bx,-$422[bp]
je  	.C5
.C6:
! Debug: lt int sectors = [S+$42A+6] to int j = [S+$42A-$426] (used reg = )
mov	ax,-$424[bp]
cmp	ax,8[bp]
jl 	.C2
.C5:
.C0:
! Debug: lt int = const $1A to int j = [S+$42A-$426] (used reg = )
mov	ax,-$424[bp]
cmp	ax,*$1A
jge 	.C7
.C8:
! 865         *ptr = 0;
mov	bx,-$420[bp]
! Debug: eq int = const 0 to char = [bx+0] (used reg = )
xor	al,al
mov	[bx],al
!BCC_EOS
! 866 
! 867     
! 868     writeSector(disk_map,1);
.C7:
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: list * char disk_map = S+$42C-$206 (used reg = )
lea	bx,-$204[bp]
push	bx
! Debug: func () int = writeSector+0 (used reg = )
call	_writeSector
add	sp,*4
!BCC_EOS
! 869     writeSector(disk_dir,2);
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: list * char disk_dir = S+$42C-$406 (used reg = )
lea	bx,-$404[bp]
push	bx
! Debug: func () int = writeSector+0 (used reg = )
call	_writeSector
add	sp,*4
!BCC_EOS
! 870 
! 871    return j == sectors ? j : -2;
! Debug: logeq int sectors = [S+$42A+6] to int j = [S+$42A-$426] (used reg = )
mov	ax,-$424[bp]
cmp	ax,8[bp]
jne 	.C9
.CA:
mov	ax,-$424[bp]
jmp .CB
.C9:
mov	ax,*-2
.CB:
! Debug: cast int = const 0 to int = ax+0 (used reg = )
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 872 }
! 873 
! 874 
! 875 
! 876 int deleteFile(fname)
! Register BX used in function writeFile
! 877 # 876 "./src/kernel.c"
! 876 char *fname;
export	_deleteFile
_deleteFile:
!BCC_EOS
! 877 {
! 878     
! 879     char disk_map[512];
!BCC_EOS
! 880     
! 881     char disk_dir[512];
!BCC_EOS
! 882     
! 883     char *ptr;
!BCC_EOS
! 884     
! 885     int   j  = 0;
push	bp
mov	bp,sp
push	di
push	si
add	sp,#-$404
! Debug: eq int = const 0 to int j = [S+$40A-$40A] (used reg = )
xor	ax,ax
mov	-$408[bp],ax
!BCC_EOS
! 886     
! 887     int byte = 0;
dec	sp
dec	sp
! Debug: eq int = const 0 to int byte = [S+$40C-$40C] (used reg = )
xor	ax,ax
mov	-$40A[bp],ax
!BCC_EOS
! 888 
! 889     
! 890     readSector(disk_map,1);
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: list * char disk_map = S+$40E-$206 (used reg = )
lea	bx,-$204[bp]
push	bx
! Debug: func () int = readSector+0 (used reg = )
call	_readSector
add	sp,*4
!BCC_EOS
! 891     readSector(disk_dir,2);
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: list * char disk_dir = S+$40E-$406 (used reg = )
lea	bx,-$404[bp]
push	bx
! Debug: func () int = readSector+0 (used reg = )
call	_readSector
add	sp,*4
!BCC_EOS
! 892 
! 893     
! 894     for(; byte < 512; byte += 32)
!BCC_EOS
!BCC_EOS
! 895     {
jmp .CE
.CF:
! 896         if (bstrcmpn(fname,disk_dir + byte,6))
! Debug: list int = const 6 (used reg = )
mov	ax,*6
push	ax
! Debug: ptradd int byte = [S+$40E-$40C] to [$200] char disk_dir = S+$40E-$406 (used reg = )
mov	ax,-$40A[bp]
mov	bx,bp
add	bx,ax
! Debug: cast * char = const 0 to [$200] char = bx-$404 (used reg = )
! Debug: list * char = bx-$404 (used reg = )
add	bx,#-$404
push	bx
! Debug: list * char fname = [S+$410+2] (used reg = )
push	4[bp]
! Debug: func () int = bstrcmpn+0 (used reg = )
call	_bstrcmpn
add	sp,*6
test	ax,ax
je  	.D0
.D1:
! 897             break;
jmp .CC
!BCC_EOS
! 898     }
.D0:
! 899 
! 900     
! 901     if (byte >= 512)
.CD:
! Debug: addab int = const $20 to int byte = [S+$40C-$40C] (used reg = )
mov	ax,-$40A[bp]
add	ax,*$20
mov	-$40A[bp],ax
.CE:
! Debug: lt int = const $200 to int byte = [S+$40C-$40C] (used reg = )
mov	ax,-$40A[bp]
cmp	ax,#$200
jl 	.CF
.D2:
.CC:
! Debug: ge int = const $200 to int byte = [S+$40C-$40C] (used reg = )
mov	ax,-$40A[bp]
cmp	ax,#$200
jl  	.D3
.D4:
! 902         return -1;
mov	ax,*-1
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 903 
! 904     
! 905     ptr  = disk_dir + byte + 6;;
.D3:
! Debug: ptradd int byte = [S+$40C-$40C] to [$200] char disk_dir = S+$40C-$406 (used reg = )
mov	ax,-$40A[bp]
mov	bx,bp
add	bx,ax
! Debug: ptradd int = const 6 to [$200] char = bx-$404 (used reg = )
! Debug: eq [$200] char = bx-$3FE to * char ptr = [S+$40C-$408] (used reg = )
add	bx,#-$3FE
mov	-$406[bp],bx
!BCC_EOS
!BCC_EOS
! 906     
! 907     
! 908     while (j < 26 && *ptr) 
! 909     {
jmp .D6
.D7:
! 910         disk_map[*(ptr++)] = 0; 
! Debug: postinc * char ptr = [S+$40C-$408] (used reg = )
mov	bx,-$406[bp]
inc	bx
mov	-$406[bp],bx
! Debug: ptradd char = [bx-1] to [$200] char disk_map = S+$40C-$206 (used reg = )
mov	al,-1[bx]
xor	ah,ah
mov	bx,bp
add	bx,ax
! Debug: eq int = const 0 to char = [bx-$204] (used reg = )
xor	al,al
mov	-$204[bx],al
!BCC_EOS
! 911     }
! 912 
! 913     
! 914     *(disk_dir + byte) = 0;
.D6:
! Debug: lt int = const $1A to int j = [S+$40C-$40A] (used reg = )
mov	ax,-$408[bp]
cmp	ax,*$1A
jge 	.D8
.D9:
mov	bx,-$406[bp]
mov	al,[bx]
test	al,al
jne	.D7
.D8:
.D5:
! Debug: ptradd int byte = [S+$40C-$40C] to [$200] char disk_dir = S+$40C-$406 (used reg = )
mov	ax,-$40A[bp]
mov	bx,bp
add	bx,ax
! Debug: eq int = const 0 to char = [bx-$404] (used reg = )
xor	al,al
mov	-$404[bx],al
!BCC_EOS
! 915 
! 916     
! 917     writeSector(disk_map,1);
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: list * char disk_map = S+$40E-$206 (used reg = )
lea	bx,-$204[bp]
push	bx
! Debug: func () int = writeSector+0 (used reg = )
call	_writeSector
add	sp,*4
!BCC_EOS
! 918     writeSector(disk_dir,2);
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: list * char disk_dir = S+$40E-$406 (used reg = )
lea	bx,-$404[bp]
push	bx
! Debug: func () int = writeSector+0 (used reg = )
call	_writeSector
add	sp,*4
!BCC_EOS
! 919    return j;
mov	ax,-$408[bp]
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 920 
! 921 }
! 922 # 929
! 929  
! 930 int writeSector(buf,sector)
! Register BX used in function deleteFile
! 931 # 930 "./src/kernel.c"
! 930 char *buf;
export	_writeSector
_writeSector:
!BCC_EOS
! 931 # 930 "./src/kernel.c"
! 930 int sector;
!BCC_EOS
! 931 {
! 932 
! 933     int q         =
! 933  sector/18;
push	bp
mov	bp,sp
push	di
push	si
dec	sp
dec	sp
! Debug: div int = const $12 to int sector = [S+8+4] (used reg = )
mov	ax,6[bp]
mov	bx,*$12
cwd
idiv	bx
! Debug: eq int = ax+0 to int q = [S+8-8] (used reg = )
mov	-6[bp],ax
!BCC_EOS
! 934     int relsector = sector - q*18 + 1;
dec	sp
dec	sp
! Debug: mul int = const $12 to int q = [S+$A-8] (used reg = )
mov	ax,-6[bp]
mov	cx,*$12
imul	cx
! Debug: sub int = ax+0 to int sector = [S+$A+4] (used reg = )
push	ax
mov	ax,6[bp]
sub	ax,-$A[bp]
inc	sp
inc	sp
! Debug: add int = const 1 to int = ax+0 (used reg = )
! Debug: eq int = ax+1 to int relsector = [S+$A-$A] (used reg = )
inc	ax
mov	-8[bp],ax
!BCC_EOS
! 935     int head      = q & 1;
dec	sp
dec	sp
! Debug: and int = const 1 to int q = [S+$C-8] (used reg = )
mov	al,-6[bp]
and	al,*1
! Debug: eq char = al+0 to int head = [S+$C-$C] (used reg = )
xor	ah,ah
mov	-$A[bp],ax
!BCC_EOS
! 936     int track     = sector/36;
dec	sp
dec	sp
! Debug: div int = const $24 to int sector = [S+$E+4] (used reg = )
mov	ax,6[bp]
mov	bx,*$24
cwd
idiv	bx
! Debug: eq int = ax+0 to int track = [S+$E-$E] (used reg = )
mov	-$C[bp],ax
!BCC_EOS
! 937 
! 938     interrupt(0x13,((0x03)<< 8)| ((0x01)&  0xff),(int)buf,((track)<< 8)| ((relsector)&  0xff),((head)<< 8)| ((0x00)&  0xff));
! Debug: sl int = const 8 to int head = [S+$E-$C] (used reg = )
mov	ax,-$A[bp]
mov	ah,al
xor	al,al
! Debug: or int = const 0 to int = ax+0 (used reg = )
or	al,*0
! Debug: list int = ax+0 (used reg = )
push	ax
! Debug: and int = const $FF to int relsector = [S+$10-$A] (used reg = )
mov	al,-8[bp]
push	ax
! Debug: sl int = const 8 to int track = [S+$12-$E] (used reg = )
mov	ax,-$C[bp]
mov	ah,al
xor	al,al
! Debug: or char (temp) = [S+$12-$12] to int = ax+0 (used reg = )
or	al,-$10[bp]
inc	sp
inc	sp
! Debug: list int = ax+0 (used reg = )
push	ax
! Debug: list int buf = [S+$12+2] (used reg = )
push	4[bp]
! Debug: list int = const $301 (used reg = )
mov	ax,#$301
push	ax
! Debug: list int = const $13 (used reg = )
mov	ax,*$13
push	ax
! Debug: func () int = interrupt+0 (used reg = )
call	_interrupt
add	sp,*$A
!BCC_EOS
! 939 
! 940     return 1;
mov	ax,*1
add	sp,*8
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 941 }
! 942 # 950
! 950  
! 951 int printStringn(str,n)
! Register BX used in function writeSector
! 952 # 951 "./src/kernel.c"
! 951 char *str;
export	_printStringn
_printStringn:
!BCC_EOS
! 952 # 951 "./src/kernel.c"
! 951 int n;
!BCC_EOS
! 952 {
! 953     char *start = str;
push	bp
mov	bp,sp
push	di
push	si
dec	sp
dec	sp
! Debug: eq * char str = [S+8+2] to * char start = [S+8-8] (used reg = )
mov	bx,4[bp]
mov	-6[bp],bx
!BCC_EOS
! 954     while (*str != 0 && n--)
! 955         PUT_CHAR(*(str++));
jmp .DB
.DC:
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: postinc * char str = [S+$E+2] (used reg = )
mov	bx,4[bp]
inc	bx
mov	4[bp],bx
! Debug: and int = const $FF to char = [bx-1] (used reg = )
mov	al,-1[bx]
! Debug: or char = al+0 to int = const $E00 (used reg = )
! Debug: expression subtree swapping
xor	ah,ah
or	ax,#$E00
! Debug: list int = ax+0 (used reg = )
push	ax
! Debug: list int = const $10 (used reg = )
mov	ax,*$10
push	ax
! Debug: func () int = interrupt+0 (used reg = )
call	_interrupt
add	sp,*$A
!BCC_EOS
! 956     return str - start;
.DB:
mov	bx,4[bp]
! Debug: ne int = const 0 to char = [bx+0] (used reg = )
mov	al,[bx]
test	al,al
je  	.DD
.DE:
! Debug: postdec int n = [S+8+4] (used reg = )
mov	ax,6[bp]
dec	ax
mov	6[bp],ax
cmp	ax,*-1
jne	.DC
.DD:
.DA:
! Debug: ptrsub * char start = [S+8-8] to * char str = [S+8+2] (used reg = )
mov	ax,4[bp]
sub	ax,-6[bp]
! Debug: cast int = const 0 to int = ax+0 (used reg = )
inc	sp
inc	sp
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 957 }
! 958 # 969
! 969  
! 970 int readFile(filename,buf,n)
! Register BX used in function printStringn
! 971 # 970 "./src/kernel.c"
! 970 char *filename;
export	_readFile
_readFile:
!BCC_EOS
! 971 # 970 "./src/kernel.c"
! 970 char *buf;
!BCC_EOS
! 971 # 970 "./src/kernel.c"
! 970 int n;
!BCC_EOS
! 971 {
! 972     
! 973     char disk_dir[512];
!BCC_EOS
! 974     
! 975     char sector_data[512];
!BCC_EOS
! 976     
! 977     char *ptr;
!BCC_EOS
! 978     
! 979     int   j  = 0;
push	bp
mov	bp,sp
push	di
push	si
add	sp,#-$404
! Debug: eq int = const 0 to int j = [S+$40A-$40A] (used reg = )
xor	ax,ax
mov	-$408[bp],ax
!BCC_EOS
! 980     
! 981     int byte = 0;
dec	sp
dec	sp
! Debug: eq int = const 0 to int byte = [S+$40C-$40C] (used reg = )
xor	ax,ax
mov	-$40A[bp],ax
!BCC_EOS
! 982 
! 983     
! 984     readSector(disk_dir,2);
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: list * char disk_dir = S+$40E-$206 (used reg = )
lea	bx,-$204[bp]
push	bx
! Debug: func () int = readSector+0 (used reg = )
call	_readSector
add	sp,*4
!BCC_EOS
! 985 
! 986     
! 987     for(; byte < 512; byte += 32)
!BCC_EOS
!BCC_EOS
! 988     {
jmp .E1
.E2:
! 989         if (bstrcmpn(filename,disk_dir + byte,6))
! Debug: list int = const 6 (used reg = )
mov	ax,*6
push	ax
! Debug: ptradd int byte = [S+$40E-$40C] to [$200] char disk_dir = S+$40E-$206 (used reg = )
mov	ax,-$40A[bp]
mov	bx,bp
add	bx,ax
! Debug: cast * char = const 0 to [$200] char = bx-$204 (used reg = )
! Debug: list * char = bx-$204 (used reg = )
add	bx,#-$204
push	bx
! Debug: list * char filename = [S+$410+2] (used reg = )
push	4[bp]
! Debug: func () int = bstrcmpn+0 (used reg = )
call	_bstrcmpn
add	sp,*6
test	ax,ax
je  	.E3
.E4:
! 990             break;
jmp .DF
!BCC_EOS
! 991     }
.E3:
! 992 
! 993     
! 994     if (byte >= 512)
.E0:
! Debug: addab int = const $20 to int byte = [S+$40C-$40C] (used reg = )
mov	ax,-$40A[bp]
add	ax,*$20
mov	-$40A[bp],ax
.E1:
! Debug: lt int = const $200 to int byte = [S+$40C-$40C] (used reg = )
mov	ax,-$40A[bp]
cmp	ax,#$200
jl 	.E2
.E5:
.DF:
! Debug: ge int = const $200 to int byte = [S+$40C-$40C] (used reg = )
mov	ax,-$40A[bp]
cmp	ax,#$200
jl  	.E6
.E7:
! 995         return -1;
mov	ax,*-1
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 996 
! 997     
! 998     ptr  = disk_dir + byte + 6;;
.E6:
! Debug: ptradd int byte = [S+$40C-$40C] to [$200] char disk_dir = S+$40C-$206 (used reg = )
mov	ax,-$40A[bp]
mov	bx,bp
add	bx,ax
! Debug: ptradd int = const 6 to [$200] char = bx-$204 (used reg = )
! Debug: eq [$200] char = bx-$1FE to * char ptr = [S+$40C-$408] (used reg = )
add	bx,#-$1FE
mov	-$406[bp],bx
!BCC_EOS
!BCC_EOS
! 999     
! 1000     
! 1001     while (n >= 512 && j < 26 && *ptr) 
! 1002     {
jmp .E9
.EA:
! 1003         readSector(buf+512*(j++),*(ptr++));
! Debug: postinc * char ptr = [S+$40C-$408] (used reg = )
mov	bx,-$406[bp]
inc	bx
mov	-$406[bp],bx
! Debug: list char = [bx-1] (used reg = )
mov	al,-1[bx]
xor	ah,ah
push	ax
! Debug: postinc int j = [S+$40E-$40A] (used reg = )
mov	ax,-$408[bp]
inc	ax
mov	-$408[bp],ax
! Debug: mul int = ax-1 to int = const $200 (used reg = )
! Debug: expression subtree swapping
dec	ax
mov	cx,#$200
imul	cx
! Debug: ptradd int = ax+0 to * char buf = [S+$40E+4] (used reg = )
add	ax,6[bp]
! Debug: list * char = ax+0 (used reg = )
push	ax
! Debug: func () int = readSector+0 (used reg = )
call	_readSector
add	sp,*4
!BCC_EOS
! 1004         n -= 512;
! Debug: subab int = const $200 to int n = [S+$40C+6] (used reg = )
mov	ax,8[bp]
add	ax,#-$200
mov	8[bp],ax
!BCC_EOS
! 1005     }
! 1006     
! 1007     if (n > 0 && j < 26 && *ptr)
.E9:
! Debug: ge int = const $200 to int n = [S+$40C+6] (used reg = )
mov	ax,8[bp]
cmp	ax,#$200
jl  	.EB
.ED:
! Debug: lt int = const $1A to int j = [S+$40C-$40A] (used reg = )
mov	ax,-$408[bp]
cmp	ax,*$1A
jge 	.EB
.EC:
mov	bx,-$406[bp]
mov	al,[bx]
test	al,al
jne	.EA
.EB:
.E8:
! Debug: gt int = const 0 to int n = [S+$40C+6] (used reg = )
mov	ax,8[bp]
test	ax,ax
jle 	.EE
.F1:
! Debug: lt int = const $1A to int j = [S+$40C-$40A] (used reg = )
mov	ax,-$408[bp]
cmp	ax,*$1A
jge 	.EE
.F0:
mov	bx,-$406[bp]
mov	al,[bx]
test	al,al
je  	.EE
.EF:
! 1008     {
! 1009         readSector(sector_data,*ptr);
mov	bx,-$406[bp]
! Debug: list char = [bx+0] (used reg = )
mov	al,[bx]
xor	ah,ah
push	ax
! Debug: list * char sector_data = S+$40E-$406 (used reg = )
lea	bx,-$404[bp]
push	bx
! Debug: func () int = readSector+0 (used reg = )
call	_readSector
add	sp,*4
!BCC_EOS
! 1010         memcpyn(buf+512*(j++),n,sector_data,512);
! Debug: list int = const $200 (used reg = )
mov	ax,#$200
push	ax
! Debug: list * char sector_data = S+$40E-$406 (used reg = )
lea	bx,-$404[bp]
push	bx
! Debug: list int n = [S+$410+6] (used reg = )
push	8[bp]
! Debug: postinc int j = [S+$412-$40A] (used reg = )
mov	ax,-$408[bp]
inc	ax
mov	-$408[bp],ax
! Debug: mul int = ax-1 to int = const $200 (used reg = )
! Debug: expression subtree swapping
dec	ax
mov	cx,#$200
imul	cx
! Debug: ptradd int = ax+0 to * char buf = [S+$412+4] (used reg = )
add	ax,6[bp]
! Debug: list * char = ax+0 (used reg = )
push	ax
! Debug: func () int = memcpyn+0 (used reg = )
call	_memcpyn
add	sp,*8
!BCC_EOS
! 1011 
! 1012     }
! 1013     return j;
.EE:
mov	ax,-$408[bp]
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 1014 }
! 1015 # 1023
! 1023  
! 1024 int memcpyn(dst,m,src,n)
! Register BX used in function readFile
! 1025 # 1024 "./src/kernel.c"
! 1024 char *dst;
export	_memcpyn
_memcpyn:
!BCC_EOS
! 1025 # 1024 "./src/kernel.c"
! 1024 int m;
!BCC_EOS
! 1025 # 1024 "./src/kernel.c"
! 1024 char *src;
!BCC_EOS
! 1025 # 1024 "./src/kernel.c"
! 1024 int n;
!BCC_EOS
! 1025 {
! 1026     int k = (m < n ? m : n); 
push	bp
mov	bp,sp
push	di
push	si
dec	sp
dec	sp
! Debug: lt int n = [S+8+8] to int m = [S+8+4] (used reg = )
mov	ax,6[bp]
cmp	ax,$A[bp]
jge 	.F2
.F3:
mov	ax,6[bp]
jmp .F4
.F2:
mov	ax,$A[bp]
.F4:
! Debug: eq int = ax+0 to int k = [S+8-8] (used reg = )
mov	-6[bp],ax
!BCC_EOS
! 1027     n = k;
! Debug: eq int k = [S+8-8] to int n = [S+8+8] (used reg = )
mov	ax,-6[bp]
mov	$A[bp],ax
!BCC_EOS
! 1028     
! 1029     while (n--) 
! 1030         *(dst++) = *(src++);
jmp .F6
.F7:
! Debug: postinc * char src = [S+8+6] (used reg = )
mov	bx,8[bp]
inc	bx
mov	8[bp],bx
! Debug: postinc * char dst = [S+8+2] (used reg = bx)
mov	si,4[bp]
inc	si
mov	4[bp],si
! Debug: eq char = [bx-1] to char = [si-1] (used reg = )
mov	al,-1[bx]
mov	-1[si],al
!BCC_EOS
! 1031 
! 1032     return n;
.F6:
! Debug: postdec int n = [S+8+8] (used reg = )
mov	ax,$A[bp]
dec	ax
mov	$A[bp],ax
cmp	ax,*-1
jne	.F7
.F8:
.F5:
mov	ax,$A[bp]
inc	sp
inc	sp
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 1033 }
! 1034 # 1043
! 1043  
! 1044 int strcpyn(dst,n,src)
! Register BX SI used in function memcpyn
! 1045 # 1044 "./src/kernel.c"
! 1044 char *dst;
export	_strcpyn
_strcpyn:
!BCC_EOS
! 1045 # 1044 "./src/kernel.c"
! 1044 int n;
!BCC_EOS
! 1045 # 1044 "./src/kernel.c"
! 1044 char *src;
!BCC_EOS
! 1045 {
! 1046     char *ptr = dst;
push	bp
mov	bp,sp
push	di
push	si
dec	sp
dec	sp
! Debug: eq * char dst = [S+8+2] to * char ptr = [S+8-8] (used reg = )
mov	bx,4[bp]
mov	-6[bp],bx
!BCC_EOS
! 1047     while (*src && --n)
! 1048         *(ptr++) = *(src++);
jmp .FA
.FB:
! Debug: postinc * char src = [S+8+6] (used reg = )
mov	bx,8[bp]
inc	bx
mov	8[bp],bx
! Debug: postinc * char ptr = [S+8-8] (used reg = bx)
mov	si,-6[bp]
inc	si
mov	-6[bp],si
! Debug: eq char = [bx-1] to char = [si-1] (used reg = )
mov	al,-1[bx]
mov	-1[si],al
!BCC_EOS
! 1049     *ptr = 0;
.FA:
mov	bx,8[bp]
mov	al,[bx]
test	al,al
je  	.FC
.FD:
! Debug: predec int n = [S+8+4] (used reg = )
mov	ax,6[bp]
dec	ax
mov	6[bp],ax
test	ax,ax
jne	.FB
.FC:
.F9:
mov	bx,-6[bp]
! Debug: eq int = const 0 to char = [bx+0] (used reg = )
xor	al,al
mov	[bx],al
!BCC_EOS
! 1050 
! 1051     return ptr - dst;
! Debug: ptrsub * char dst = [S+8+2] to * char ptr = [S+8-8] (used reg = )
mov	ax,-6[bp]
sub	ax,4[bp]
! Debug: cast int = const 0 to int = ax+0 (used reg = )
inc	sp
inc	sp
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 1052 }
! 1053 # 1060
! 1060  
! 1061 int strcmpn(a,b,n)
! Register BX SI used in function strcpyn
! 1062 # 1061 "./src/kernel.c"
! 1061 char *a;
export	_strcmpn
_strcmpn:
!BCC_EOS
! 1062 # 1061 "./src/kernel.c"
! 1061 char *b;
!BCC_EOS
! 1062 # 1061 "./src/kernel.c"
! 1061 int n;
!BCC_EOS
! 1062 # 1061 "./src/kernel.c"
! 1061 {
! 1062     
! 1063     while (n-- && *a && *b) {
push	bp
mov	bp,sp
push	di
push	si
jmp .FF
.100:
! 1064         if (*(a++)!= *(b++))
! Debug: postinc * char b = [S+6+4] (used reg = )
mov	bx,6[bp]
inc	bx
mov	6[bp],bx
! Debug: postinc * char a = [S+6+2] (used reg = bx)
mov	si,4[bp]
inc	si
mov	4[bp],si
! Debug: ne char = [bx-1] to char = [si-1] (used reg = )
mov	al,-1[si]
cmp	al,-1[bx]
je  	.101
.102:
! 1065             return 0; 
xor	ax,ax
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 1066     }
.101:
! 1067     
! 1068     
! 1069     return n < 0 || *a =
.FF:
! Debug: postdec int n = [S+6+6] (used reg = )
mov	ax,8[bp]
dec	ax
mov	8[bp],ax
cmp	ax,*-1
je  	.103
.105:
mov	bx,4[bp]
mov	al,[bx]
test	al,al
je  	.103
.104:
mov	bx,6[bp]
mov	al,[bx]
test	al,al
jne	.100
.103:
.FE:
! 1069 = *b;
! Debug: lt int = const 0 to int n = [S+6+6] (used reg = )
mov	ax,8[bp]
test	ax,ax
jl  	.107
.108:
mov	bx,6[bp]
mov	si,4[bp]
! Debug: logeq char = [bx+0] to char = [si+0] (used reg = )
mov	al,[si]
cmp	al,[bx]
jne 	.106
.107:
mov	al,*1
jmp	.109
.106:
xor	al,al
.109:
! Debug: cast int = const 0 to char = al+0 (used reg = )
xor	ah,ah
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 1070 }
! 1071 # 1077
! 1077  
! 1078 # 1083
! 1083  
! 1084 int printString(str)
! Register BX SI used in function strcmpn
! 1085 # 1084 "./src/kernel.c"
! 1084 char *str;
export	_printString
_printString:
!BCC_EOS
! 1085 {
! 1086     char *start = str;
push	bp
mov	bp,sp
push	di
push	si
dec	sp
dec	sp
! Debug: eq * char str = [S+8+2] to * char start = [S+8-8] (used reg = )
mov	bx,4[bp]
mov	-6[bp],bx
!BCC_EOS
! 1087     while (*str != 0)
! 1088         PUT_CHAR(*(str++));
jmp .10B
.10C:
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: postinc * char str = [S+$E+2] (used reg = )
mov	bx,4[bp]
inc	bx
mov	4[bp],bx
! Debug: and int = const $FF to char = [bx-1] (used reg = )
mov	al,-1[bx]
! Debug: or char = al+0 to int = const $E00 (used reg = )
! Debug: expression subtree swapping
xor	ah,ah
or	ax,#$E00
! Debug: list int = ax+0 (used reg = )
push	ax
! Debug: list int = const $10 (used reg = )
mov	ax,*$10
push	ax
! Debug: func () int = interrupt+0 (used reg = )
call	_interrupt
add	sp,*$A
!BCC_EOS
! 1089     return str - start;
.10B:
mov	bx,4[bp]
! Debug: ne int = const 0 to char = [bx+0] (used reg = )
mov	al,[bx]
test	al,al
jne	.10C
.10D:
.10A:
! Debug: ptrsub * char start = [S+8-8] to * char str = [S+8+2] (used reg = )
mov	ax,4[bp]
sub	ax,-6[bp]
! Debug: cast int = const 0 to int = ax+0 (used reg = )
inc	sp
inc	sp
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 1090 }
! 1091 # 1103
! 1103  
! 1104 int readString(buf,n)
! Register BX used in function printString
! 1105 # 1104 "./src/kernel.c"
! 1104 char *buf;
export	_readString
_readString:
!BCC_EOS
! 1105 # 1104 "./src/kernel.c"
! 1104 int n;
!BCC_EOS
! 1105 {
! 1106     char *start = buf;
push	bp
mov	bp,sp
push	di
push	si
dec	sp
dec	sp
! Debug: eq * char buf = [S+8+2] to * char start = [S+8-8] (used reg = )
mov	bx,4[bp]
mov	-6[bp],bx
!BCC_EOS
! 1107     char *end   = buf + n-1;
dec	sp
dec	sp
! Debug: ptradd int n = [S+$A+4] to * char buf = [S+$A+2] (used reg = )
mov	ax,6[bp]
add	ax,4[bp]
! Debug: ptradd int = const -1 to * char = ax+0 (used reg = )
! Debug: eq * char = ax-1 to * char end = [S+$A-$A] (used reg = )
dec	ax
mov	-8[bp],ax
!BCC_EOS
! 1108     char c;
!BCC_EOS
! 1109 
! 1110     while ((c = (interrupt(0x16,0,0,0,0)& 0xFF))!= '\r')
dec	sp
dec	sp
! 1111     {
br 	.10F
.110:
! 1112         if (c == 0x08)
! Debug: logeq int = const 8 to char c = [S+$C-$B] (used reg = )
mov	al,-9[bp]
cmp	al,*8
jne 	.111
.112:
! 1113         {
! 1114             if (buf != start)
! Debug: ne * char start = [S+$C-8] to * char buf = [S+$C+2] (used reg = )
mov	bx,4[bp]
cmp	bx,-6[bp]
je  	.113
.114:
! 1115             {
! 1116                 --buf;
! Debug: predec * char buf = [S+$C+2] (used reg = )
mov	bx,4[bp]
dec	bx
mov	4[bp],bx
!BCC_EOS
! 1117                 PUT_CHAR(0x08);
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const $E08 (used reg = )
mov	ax,#$E08
push	ax
! Debug: list int = const $10 (used reg = )
mov	ax,*$10
push	ax
! Debug: func () int = interrupt+0 (used reg = )
call	_interrupt
add	sp,*$A
!BCC_EOS
! 1118                 PUT_CHAR(' ');
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const $E20 (used reg = )
mov	ax,#$E20
push	ax
! Debug: list int = const $10 (used reg = )
mov	ax,*$10
push	ax
! Debug: func () int = interrupt+0 (used reg = )
call	_interrupt
add	sp,*$A
!BCC_EOS
! 1119                 PUT_CHAR(0x08);
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const $E08 (used reg = )
mov	ax,#$E08
push	ax
! Debug: list int = const $10 (used reg = )
mov	ax,*$10
push	ax
! Debug: func () int = interrupt+0 (used reg = )
call	_interrupt
add	sp,*$A
!BCC_EOS
! 1120             }
! 1121         }
.113:
! 1122         else if (buf != end)
jmp .115
.111:
! Debug: ne * char end = [S+$C-$A] to * char buf = [S+$C+2] (used reg = )
mov	bx,4[bp]
cmp	bx,-8[bp]
je  	.116
.117:
! 1123         {
! 1124             *buf = c;
mov	bx,4[bp]
! Debug: eq char c = [S+$C-$B] to char = [bx+0] (used reg = )
mov	al,-9[bp]
mov	[bx],al
!BCC_EOS
! 1125             PUT_CHAR(c);
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: and int = const $FF to char c = [S+$12-$B] (used reg = )
mov	al,-9[bp]
! Debug: or char = al+0 to int = const $E00 (used reg = )
! Debug: expression subtree swapping
xor	ah,ah
or	ax,#$E00
! Debug: list int = ax+0 (used reg = )
push	ax
! Debug: list int = const $10 (used reg = )
mov	ax,*$10
push	ax
! Debug: func () int = interrupt+0 (used reg = )
call	_interrupt
add	sp,*$A
!BCC_EOS
! 1126             ++buf;
! Debug: preinc * char buf = [S+$C+2] (used reg = )
mov	bx,4[bp]
inc	bx
mov	4[bp],bx
!BCC_EOS
! 1127         }
! 1128     }
.116:
.115:
! 1129     *buf = 0;
.10F:
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const $16 (used reg = )
mov	ax,*$16
push	ax
! Debug: func () int = interrupt+0 (used reg = )
call	_interrupt
add	sp,*$A
! Debug: and int = const $FF to int = ax+0 (used reg = )
! Debug: eq char = al+0 to char c = [S+$C-$B] (used reg = )
mov	-9[bp],al
! Debug: ne int = const $D to char = al+0 (used reg = )
cmp	al,*$D
bne 	.110
.118:
.10E:
mov	bx,4[bp]
! Debug: eq int = const 0 to char = [bx+0] (used reg = )
xor	al,al
mov	[bx],al
!BCC_EOS
! 1130     return buf - start;
! Debug: ptrsub * char start = [S+$C-8] to * char buf = [S+$C+2] (used reg = )
mov	ax,4[bp]
sub	ax,-6[bp]
! Debug: cast int = const 0 to int = ax+0 (used reg = )
add	sp,*6
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 1131 }
! 1132 # 1137
! 1137  
! 1138 int printInt(x)
! Register BX used in function readString
! 1139 # 1138 "./src/kernel.c"
! 1138 int x;
export	_printInt
_printInt:
!BCC_EOS
! 1139 {
! 1140     
! 1141     char buf[12];
!BCC_EOS
! 1142     char *ptr = buf+11; 
push	bp
mov	bp,sp
push	di
push	si
add	sp,*-$E
! Debug: eq [$C] char buf = S+$14-7 to * char ptr = [S+$14-$14] (used reg = )
lea	bx,-5[bp]
mov	-$12[bp],bx
!BCC_EOS
! 1143     int q, r; 
!BCC_EOS
! 1144     int sign = 1; 
add	sp,*-6
! Debug: eq int = const 1 to int sign = [S+$1A-$1A] (used reg = )
mov	ax,*1
mov	-$18[bp],ax
!BCC_EOS
! 1145 
! 1146     
! 1147     *ptr = 0;
mov	bx,-$12[bp]
! Debug: eq int = const 0 to char = [bx+0] (used reg = )
xor	al,al
mov	[bx],al
!BCC_EOS
! 1148     
! 1149     if (x < 0)
! Debug: lt int = const 0 to int x = [S+$1A+2] (used reg = )
mov	ax,4[bp]
test	ax,ax
jge 	.119
.11A:
! 1150     {
! 1151         
! 1152         sign = -1;
! Debug: eq int = const -1 to int sign = [S+$1A-$1A] (used reg = )
mov	ax,*-1
mov	-$18[bp],ax
!BCC_EOS
! 1153         x = -x;
! Debug: neg int x = [S+$1A+2] (used reg = )
xor	ax,ax
sub	ax,4[bp]
! Debug: eq int = ax+0 to int x = [S+$1A+2] (used reg = )
mov	4[bp],ax
!BCC_EOS
! 1154     }
! 1155     else if (x == 0)
jmp .11B
.119:
! Debug: logeq int = const 0 to int x = [S+$1A+2] (used reg = )
mov	ax,4[bp]
test	ax,ax
jne 	.11C
.11D:
! 1156     {
! 1157         
! 1158         *(--ptr) = '0';
! Debug: predec * char ptr = [S+$1A-$14] (used reg = )
mov	bx,-$12[bp]
dec	bx
mov	-$12[bp],bx
! Debug: eq int = const $30 to char = [bx+0] (used reg = )
mov	al,*$30
mov	[bx],al
!BCC_EOS
! 1159     }
! 1160 
! 1161     
! 1162     while (x > 0)
.11C:
.11B:
! 1163     {
jmp .11F
.120:
! 1164         
! 1165         q = x/10;
! Debug: div int = const $A to int x = [S+$1A+2] (used reg = )
mov	ax,4[bp]
mov	bx,*$A
cwd
idiv	bx
! Debug: eq int = ax+0 to int q = [S+$1A-$16] (used reg = )
mov	-$14[bp],ax
!BCC_EOS
! 1166         r = x - q*10;
! Debug: mul int = const $A to int q = [S+$1A-$16] (used reg = )
mov	ax,-$14[bp]
mov	dx,ax
shl	ax,*1
shl	ax,*1
add	ax,dx
shl	ax,*1
! Debug: sub int = ax+0 to int x = [S+$1A+2] (used reg = )
push	ax
mov	ax,4[bp]
sub	ax,-$1A[bp]
inc	sp
inc	sp
! Debug: eq int = ax+0 to int r = [S+$1A-$18] (used reg = )
mov	-$16[bp],ax
!BCC_EOS
! 1167         
! 1168         *(--ptr) = r + '0';
! Debug: add int = const $30 to int r = [S+$1A-$18] (used reg = )
mov	ax,-$16[bp]
add	ax,*$30
push	ax
! Debug: predec * char ptr = [S+$1C-$14] (used reg = )
mov	bx,-$12[bp]
dec	bx
mov	-$12[bp],bx
! Debug: eq int (temp) = [S+$1C-$1C] to char = [bx+0] (used reg = )
mov	ax,-$1A[bp]
mov	[bx],al
inc	sp
inc	sp
!BCC_EOS
! 1169         x = q;
! Debug: eq int q = [S+$1A-$16] to int x = [S+$1A+2] (used reg = )
mov	ax,-$14[bp]
mov	4[bp],ax
!BCC_EOS
! 1170     }
! 1171 
! 1172     if (sign < 0)
.11F:
! Debug: gt int = const 0 to int x = [S+$1A+2] (used reg = )
mov	ax,4[bp]
test	ax,ax
jg 	.120
.121:
.11E:
! Debug: lt int = const 0 to int sign = [S+$1A-$1A] (used reg = )
mov	ax,-$18[bp]
test	ax,ax
jge 	.122
.123:
! 1173     {
! 1174         
! 1175         *(--ptr) = '-';
! Debug: predec * char ptr = [S+$1A-$14] (used reg = )
mov	bx,-$12[bp]
dec	bx
mov	-$12[bp],bx
! Debug: eq int = const $2D to char = [bx+0] (used reg = )
mov	al,*$2D
mov	[bx],al
!BCC_EOS
! 1176     }
! 1177 
! 1178     
! 1179     return printString(ptr);
.122:
! Debug: list * char ptr = [S+$1A-$14] (used reg = )
push	-$12[bp]
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
! Debug: cast int = const 0 to int = ax+0 (used reg = )
add	sp,*$14
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 1180 }
! 1181 # 1188
! 1188  
! 1189 int sprintInt(x,dst,n)
! Register BX used in function printInt
! 1190 # 1189 "./src/kernel.c"
! 1189 int x;
export	_sprintInt
_sprintInt:
!BCC_EOS
! 1190 # 1189 "./src/kernel.c"
! 1189 char *dst;
!BCC_EOS
! 1190 # 1189 "./src/kernel.c"
! 1189 int n;
!BCC_EOS
! 1190 {
! 1191     
! 1192     char buf[12];
!BCC_EOS
! 1193     char *ptr = buf+11; 
push	bp
mov	bp,sp
push	di
push	si
add	sp,*-$E
! Debug: eq [$C] char buf = S+$14-7 to * char ptr = [S+$14-$14] (used reg = )
lea	bx,-5[bp]
mov	-$12[bp],bx
!BCC_EOS
! 1194     int q, r; 
!BCC_EOS
! 1195     int sign = 1; 
add	sp,*-6
! Debug: eq int = const 1 to int sign = [S+$1A-$1A] (used reg = )
mov	ax,*1
mov	-$18[bp],ax
!BCC_EOS
! 1196 
! 1197     
! 1198     *ptr = 0;
mov	bx,-$12[bp]
! Debug: eq int = const 0 to char = [bx+0] (used reg = )
xor	al,al
mov	[bx],al
!BCC_EOS
! 1199     
! 1200     if (x < 0)
! Debug: lt int = const 0 to int x = [S+$1A+2] (used reg = )
mov	ax,4[bp]
test	ax,ax
jge 	.124
.125:
! 1201     {
! 1202         
! 1203         sign = -1;
! Debug: eq int = const -1 to int sign = [S+$1A-$1A] (used reg = )
mov	ax,*-1
mov	-$18[bp],ax
!BCC_EOS
! 1204         x = -x;
! Debug: neg int x = [S+$1A+2] (used reg = )
xor	ax,ax
sub	ax,4[bp]
! Debug: eq int = ax+0 to int x = [S+$1A+2] (used reg = )
mov	4[bp],ax
!BCC_EOS
! 1205     }
! 1206     else if (x == 0)
jmp .126
.124:
! Debug: logeq int = const 0 to int x = [S+$1A+2] (used reg = )
mov	ax,4[bp]
test	ax,ax
jne 	.127
.128:
! 1207     {
! 1208         
! 1209         *(--ptr) = '0';
! Debug: predec * char ptr = [S+$1A-$14] (used reg = )
mov	bx,-$12[bp]
dec	bx
mov	-$12[bp],bx
! Debug: eq int = const $30 to char = [bx+0] (used reg = )
mov	al,*$30
mov	[bx],al
!BCC_EOS
! 1210     }
! 1211 
! 1212     
! 1213     while (x > 0)
.127:
.126:
! 1214     {
jmp .12A
.12B:
! 1215         
! 1216         q = x/10;
! Debug: div int = const $A to int x = [S+$1A+2] (used reg = )
mov	ax,4[bp]
mov	bx,*$A
cwd
idiv	bx
! Debug: eq int = ax+0 to int q = [S+$1A-$16] (used reg = )
mov	-$14[bp],ax
!BCC_EOS
! 1217         r = x - q*10;
! Debug: mul int = const $A to int q = [S+$1A-$16] (used reg = )
mov	ax,-$14[bp]
mov	dx,ax
shl	ax,*1
shl	ax,*1
add	ax,dx
shl	ax,*1
! Debug: sub int = ax+0 to int x = [S+$1A+2] (used reg = )
push	ax
mov	ax,4[bp]
sub	ax,-$1A[bp]
inc	sp
inc	sp
! Debug: eq int = ax+0 to int r = [S+$1A-$18] (used reg = )
mov	-$16[bp],ax
!BCC_EOS
! 1218         
! 1219         *(--ptr) = r + '0';
! Debug: add int = const $30 to int r = [S+$1A-$18] (used reg = )
mov	ax,-$16[bp]
add	ax,*$30
push	ax
! Debug: predec * char ptr = [S+$1C-$14] (used reg = )
mov	bx,-$12[bp]
dec	bx
mov	-$12[bp],bx
! Debug: eq int (temp) = [S+$1C-$1C] to char = [bx+0] (used reg = )
mov	ax,-$1A[bp]
mov	[bx],al
inc	sp
inc	sp
!BCC_EOS
! 1220         x = q;
! Debug: eq int q = [S+$1A-$16] to int x = [S+$1A+2] (used reg = )
mov	ax,-$14[bp]
mov	4[bp],ax
!BCC_EOS
! 1221     }
! 1222 
! 1223     if (sign < 0)
.12A:
! Debug: gt int = const 0 to int x = [S+$1A+2] (used reg = )
mov	ax,4[bp]
test	ax,ax
jg 	.12B
.12C:
.129:
! Debug: lt int = const 0 to int sign = [S+$1A-$1A] (used reg = )
mov	ax,-$18[bp]
test	ax,ax
jge 	.12D
.12E:
! 1224     {
! 1225         
! 1226         *(--ptr) = '-';
! Debug: predec * char ptr = [S+$1A-$14] (used reg = )
mov	bx,-$12[bp]
dec	bx
mov	-$12[bp],bx
! Debug: eq int = const $2D to char = [bx+0] (used reg = )
mov	al,*$2D
mov	[bx],al
!BCC_EOS
! 1227     }
! 1228 
! 1229     strcpyn(dst,n,ptr);
.12D:
! Debug: list * char ptr = [S+$1A-$14] (used reg = )
push	-$12[bp]
! Debug: list int n = [S+$1C+6] (used reg = )
push	8[bp]
! Debug: list * char dst = [S+$1E+4] (used reg = )
push	6[bp]
! Debug: func () int = strcpyn+0 (used reg = )
call	_strcpyn
add	sp,*6
!BCC_EOS
! 1230     r = (buf+11) - ptr;
! Debug: ptrsub * char ptr = [S+$1A-$14] to [$C] char buf = S+$1A-7 (used reg = )
mov	ax,bp
add	ax,*-5
sub	ax,-$12[bp]
! Debug: eq int = ax+0 to int r = [S+$1A-$18] (used reg = )
mov	-$16[bp],ax
!BCC_EOS
! 1231 
! 1232     return  n-1 < r ? n-1 : r;
! Debug: sub int = const 1 to int n = [S+$1A+6] (used reg = )
mov	ax,8[bp]
! Debug: lt int r = [S+$1A-$18] to int = ax-1 (used reg = )
dec	ax
cmp	ax,-$16[bp]
jge 	.12F
.130:
! Debug: sub int = const 1 to int n = [S+$1A+6] (used reg = )
mov	ax,8[bp]
dec	ax
jmp .131
.12F:
mov	ax,-$16[bp]
.131:
! Debug: cast int = const 0 to int = ax+0 (used reg = )
add	sp,*$14
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 1233 }
! 1234 # 1242
! 1242  
! 1243 int readSector(buf,sector)
! Register BX used in function sprintInt
! 1244 # 1243 "./src/kernel.c"
! 1242 
! 1243 char *buf;
export	_readSector
_readSector:
!BCC_EOS
! 1244 # 1243 "./src/kernel.c"
! 1243 int sector;
!BCC_EOS
! 1244 {
! 1245     int q         = sector/18;
push	bp
mov	bp,sp
push	di
push	si
dec	sp
dec	sp
! Debug: div int = const $12 to int sector = [S+8+4] (used reg = )
mov	ax,6[bp]
mov	bx,*$12
cwd
idiv	bx
! Debug: eq int = ax+0 to int q = [S+8-8] (used reg = )
mov	-6[bp],ax
!BCC_EOS
! 1246     int relsector = sector - q*18 + 1;
dec	sp
dec	sp
! Debug: mul int = const $12 to int q = [S+$A-8] (used reg = )
mov	ax,-6[bp]
mov	cx,*$12
imul	cx
! Debug: sub int = ax+0 to int sector = [S+$A+4] (used reg = )
push	ax
mov	ax,6[bp]
sub	ax,-$A[bp]
inc	sp
inc	sp
! Debug: add int = const 1 to int = ax+0 (used reg = )
! Debug: eq int = ax+1 to int relsector = [S+$A-$A] (used reg = )
inc	ax
mov	-8[bp],ax
!BCC_EOS
! 1247     int head      = q & 1;
dec	sp
dec	sp
! Debug: and int = const 1 to int q = [S+$C-8] (used reg = )
mov	al,-6[bp]
and	al,*1
! Debug: eq char = al+0 to int head = [S+$C-$C] (used reg = )
xor	ah,ah
mov	-$A[bp],ax
!BCC_EOS
! 1248     int track     = sector/36;
dec	sp
dec	sp
! Debug: div int = const $24 to int sector = [S+$E+4] (used reg = )
mov	ax,6[bp]
mov	bx,*$24
cwd
idiv	bx
! Debug: eq int = ax+0 to int track = [S+$E-$E] (used reg = )
mov	-$C[bp],ax
!BCC_EOS
! 1249 
! 1250     interrupt(0x13,((0x02)<< 8)| ((0x01)&  0xff),(int)buf,((track)<< 8)| ((relsector)&  0xff),((head)<< 8)| ((0x00)&  0xff));
! Debug: sl int = const 8 to int head = [S+$E-$C] (used reg = )
mov	ax,-$A[bp]
mov	ah,al
xor	al,al
! Debug: or int = const 0 to int = ax+0 (used reg = )
or	al,*0
! Debug: list int = ax+0 (used reg = )
push	ax
! Debug: and int = const $FF to int relsector = [S+$10-$A] (used reg = )
mov	al,-8[bp]
push	ax
! Debug: sl int = const 8 to int track = [S+$12-$E] (used reg = )
mov	ax,-$C[bp]
mov	ah,al
xor	al,al
! Debug: or char (temp) = [S+$12-$12] to int = ax+0 (used reg = )
or	al,-$10[bp]
inc	sp
inc	sp
! Debug: list int = ax+0 (used reg = )
push	ax
! Debug: list int buf = [S+$12+2] (used reg = )
push	4[bp]
! Debug: list int = const $201 (used reg = )
mov	ax,#$201
push	ax
! Debug: list int = const $13 (used reg = )
mov	ax,*$13
push	ax
! Debug: func () int = interrupt+0 (used reg = )
call	_interrupt
add	sp,*$A
!BCC_EOS
! 1251 
! 1252     return 1;
mov	ax,*1
add	sp,*8
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 1253 }
! 1254 # 1260
! 1260  
! 1261 int strcmp(a,b)
! Register BX used in function readSector
! 1262 # 1261 "./src/kernel.c"
! 1261 char *a;
export	_strcmp
_strcmp:
!BCC_EOS
! 1262 # 1261 "./src/kernel.c"
! 1261 char *b;
!BCC_EOS
! 1262 # 1261 "./src/kernel.c"
! 1261 {
! 1262     
! 1263     while (*a && *b) {
push	bp
mov	bp,sp
push	di
push	si
jmp .133
.134:
! 1264         if (*(a++)!= *(b++))
! Debug: postinc * char b = [S+6+4] (used reg = )
mov	bx,6[bp]
inc	bx
mov	6[bp],bx
! Debug: postinc * char a = [S+6+2] (used reg = bx)
mov	si,4[bp]
inc	si
mov	4[bp],si
! Debug: ne char = [bx-1] to char = [si-1] (used reg = )
mov	al,-1[si]
cmp	al,-1[bx]
je  	.135
.136:
! 1265             return 0; 
xor	ax,ax
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 1266     }
.135:
! 1267     return *a == *b; 
.133:
mov	bx,4[bp]
mov	al,[bx]
test	al,al
je  	.137
.138:
mov	bx,6[bp]
mov	al,[bx]
test	al,al
jne	.134
.137:
.132:
mov	bx,6[bp]
mov	si,4[bp]
! Debug: logeq char = [bx+0] to char = [si+0] (used reg = )
mov	al,[si]
cmp	al,[bx]
jne	.139
mov	al,*1
jmp	.13A
.139:
xor	al,al
.13A:
! Debug: cast int = const 0 to char = al+0 (used reg = )
xor	ah,ah
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 1268 }
! 1269 # 1282
! 1282  
! 1283 int bstrcmpn(str,buf,n)
! Register BX SI used in function strcmp
! 1284 # 1283 "./src/kernel.c"
! 1283 char *str;
export	_bstrcmpn
_bstrcmpn:
!BCC_EOS
! 1284 # 1283 "./src/kernel.c"
! 1283 char *buf;
!BCC_EOS
! 1284 # 1283 "./src/kernel.c"
! 1283 int n;
!BCC_EOS
! 1284 {
! 1285     
! 1286     while (n-- && *buf && *str) {
push	bp
mov	bp,sp
push	di
push	si
jmp .13C
.13D:
! 1287         if (*(buf++)!= *(str++))
! Debug: postinc * char str = [S+6+2] (used reg = )
mov	bx,4[bp]
inc	bx
mov	4[bp],bx
! Debug: postinc * char buf = [S+6+4] (used reg = bx)
mov	si,6[bp]
inc	si
mov	6[bp],si
! Debug: ne char = [bx-1] to char = [si-1] (used reg = )
mov	al,-1[si]
cmp	al,-1[bx]
je  	.13E
.13F:
! 1288             return 0; 
xor	ax,ax
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 1289     }
.13E:
! 1290     
! 1291     if (n < 0)
.13C:
! Debug: postdec int n = [S+6+6] (used reg = )
mov	ax,8[bp]
dec	ax
mov	8[bp],ax
cmp	ax,*-1
je  	.140
.142:
mov	bx,6[bp]
mov	al,[bx]
test	al,al
je  	.140
.141:
mov	bx,4[bp]
mov	al,[bx]
test	al,al
jne	.13D
.140:
.13B:
! Debug: lt int = const 0 to int n = [S+6+6] (used reg = )
mov	ax,8[bp]
test	ax,ax
jge 	.143
.144:
! 1292     {
! 1293         
! 1294         return *str == 0;
mov	bx,4[bp]
! Debug: logeq int = const 0 to char = [bx+0] (used reg = )
mov	al,[bx]
test	al,al
jne	.145
mov	al,*1
jmp	.146
.145:
xor	al,al
.146:
! Debug: cast int = const 0 to char = al+0 (used reg = )
xor	ah,ah
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 1295     }
! 1296 
! 1297     
! 1298     return *buf == *str;
.143:
mov	bx,4[bp]
mov	si,6[bp]
! Debug: logeq char = [bx+0] to char = [si+0] (used reg = )
mov	al,[si]
cmp	al,[bx]
jne	.147
mov	al,*1
jmp	.148
.147:
xor	al,al
.148:
! Debug: cast int = const 0 to char = al+0 (used reg = )
xor	ah,ah
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 1299 }
! 1300 # 1304
! 1304  
! 1305 void putChar(c,color,row,col)
! Register BX SI used in function bstrcmpn
! 1306 # 1305 "./src/kernel.c"
! 1305 char c;
export	_putChar
_putChar:
!BCC_EOS
! 1306 # 1305 "./src/kernel.c"
! 1305 char color;
!BCC_EOS
! 1306 # 1305 "./src/kernel.c"
! 1305 int row;
!BCC_EOS
! 1306 # 1305 "./src/kernel.c"
! 1305 int col;
!BCC_EOS
! 1306 {
! 1307     int offset = ((row * 80 + col)<< 1);
push	bp
mov	bp,sp
push	di
push	si
dec	sp
dec	sp
! Debug: mul int = const $50 to int row = [S+8+6] (used reg = )
mov	ax,8[bp]
mov	cx,*$50
imul	cx
! Debug: add int col = [S+8+8] to int = ax+0 (used reg = )
add	ax,$A[bp]
! Debug: sl int = const 1 to int = ax+0 (used reg = )
shl	ax,*1
! Debug: eq int = ax+0 to int offset = [S+8-8] (used reg = )
mov	-6[bp],ax
!BCC_EOS
! 1308     putInMemory(VMEM_HIGH,0x8000 +offset,c) ;
! Debug: list char c = [S+8+2] (used reg = )
mov	al,4[bp]
xor	ah,ah
push	ax
! Debug: add int offset = [S+$A-8] to unsigned int = const $8000 (used reg = )
! Debug: expression subtree swapping
mov	ax,-6[bp]
! Debug: list unsigned int = ax+$8000 (used reg = )
add	ax,#$8000
push	ax
! Debug: list unsigned int = const $B000 (used reg = )
mov	ax,#$B000
push	ax
! Debug: func () void = putInMemory+0 (used reg = )
call	_putInMemory
add	sp,*6
!BCC_EOS
! 1309     putInMemory(VMEM_HIGH,0x8000 +offset+1,color) ;
! Debug: list char color = [S+8+4] (used reg = )
mov	al,6[bp]
xor	ah,ah
push	ax
! Debug: add int offset = [S+$A-8] to unsigned int = const $8000 (used reg = )
! Debug: expression subtree swapping
mov	ax,-6[bp]
! Debug: add int = const 1 to unsigned int = ax+$8000 (used reg = )
! Debug: list unsigned int = ax+$8001 (used reg = )
add	ax,#$8001
push	ax
! Debug: list unsigned int = const $B000 (used reg = )
mov	ax,#$B000
push	ax
! Debug: func () void = putInMemory+0 (used reg = )
call	_putInMemory
add	sp,*6
!BCC_EOS
! 1310 }
inc	sp
inc	sp
pop	si
pop	di
pop	bp
ret
! 1311 # 1316
! 1316  
! 1317 void putStr(str,maxlen,color,row,col)
! 1318 # 1317 "./src/kernel.c"
! 1317 char *str;
export	_putStr
_putStr:
!BCC_EOS
! 1318 # 1317 "./src/kernel.c"
! 1317 int maxlen;
!BCC_EOS
! 1318 # 1317 "./src/kernel.c"
! 1317 char color;
!BCC_EOS
! 1318 # 1317 "./src/kernel.c"
! 1317 int row;
!BCC_EOS
! 1318 # 1317 "./src/kernel.c"
! 1317 int col;
!BCC_EOS
! 1318 {
! 1319     int i = 0;
push	bp
mov	bp,sp
push	di
push	si
dec	sp
dec	sp
! Debug: eq int = const 0 to int i = [S+8-8] (used reg = )
xor	ax,ax
mov	-6[bp],ax
!BCC_EOS
! 1320     while(*str && i < maxlen)
! 1321     {
jmp .14A
.14B:
! 1322         if (*str == '\n')
mov	bx,4[bp]
! Debug: logeq int = const $A to char = [bx+0] (used reg = )
mov	al,[bx]
cmp	al,*$A
jne 	.14C
.14D:
! 1323         {
! 1324             row += 1;
! Debug: addab int = const 1 to int row = [S+8+8] (used reg = )
mov	ax,$A[bp]
inc	ax
mov	$A[bp],ax
!BCC_EOS
! 1325             col = 0;
! Debug: eq int = const 0 to int col = [S+8+$A] (used reg = )
xor	ax,ax
mov	$C[bp],ax
!BCC_EOS
! 1326         }
! 1327         else if (*str == '\r')
jmp .14E
.14C:
mov	bx,4[bp]
! Debug: logeq int = const $D to char = [bx+0] (used reg = )
mov	al,[bx]
cmp	al,*$D
jne 	.14F
.150:
! 1328         {
! 1329             col = 0;
! Debug: eq int = const 0 to int col = [S+8+$A] (used reg = )
xor	ax,ax
mov	$C[bp],ax
!BCC_EOS
! 1330         }
! 1331         else 
! 1332         {
jmp .151
.14F:
! 1333             putChar(*str,color,row,col);
! Debug: list int col = [S+8+$A] (used reg = )
push	$C[bp]
! Debug: list int row = [S+$A+8] (used reg = )
push	$A[bp]
! Debug: list char color = [S+$C+6] (used reg = )
mov	al,8[bp]
xor	ah,ah
push	ax
mov	bx,4[bp]
! Debug: list char = [bx+0] (used reg = )
mov	al,[bx]
xor	ah,ah
push	ax
! Debug: func () void = putChar+0 (used reg = )
call	_putChar
add	sp,*8
!BCC_EOS
! 1334             if ((++col)>= 80 )
! Debug: preinc int col = [S+8+$A] (used reg = )
mov	ax,$C[bp]
inc	ax
mov	$C[bp],ax
! Debug: ge int = const $50 to int = ax+0 (used reg = )
cmp	ax,*$50
jl  	.152
.153:
! 1335             {
! 1336                 ++row;
! Debug: preinc int row = [S+8+8] (used reg = )
mov	ax,$A[bp]
inc	ax
mov	$A[bp],ax
!BCC_EOS
! 1337                 col = 0;
! Debug: eq int = const 0 to int col = [S+8+$A] (used reg = )
xor	ax,ax
mov	$C[bp],ax
!BCC_EOS
! 1338             }
! 1339         }
.152:
! 1340 
! 1341         ++str;
.151:
.14E:
! Debug: preinc * char str = [S+8+2] (used reg = )
mov	bx,4[bp]
inc	bx
mov	4[bp],bx
!BCC_EOS
! 1342         ++i;
! Debug: preinc int i = [S+8-8] (used reg = )
mov	ax,-6[bp]
inc	ax
mov	-6[bp],ax
!BCC_EOS
! 1343     }
! 1344 }
.14A:
mov	bx,4[bp]
mov	al,[bx]
test	al,al
je  	.154
.155:
! Debug: lt int maxlen = [S+8+4] to int i = [S+8-8] (used reg = )
mov	ax,-6[bp]
cmp	ax,6[bp]
jl 	.14B
.154:
.149:
inc	sp
inc	sp
pop	si
pop	di
pop	bp
ret
! 1345 
! 1346 
! 1347 
! 1348 int strlen(str)
! Register BX used in function putStr
! 1349 # 1348 "./src/kernel.c"
! 1348 char *str;
export	_strlen
_strlen:
!BCC_EOS
! 1349 {
! 1350     int n = 0;
push	bp
mov	bp,sp
push	di
push	si
dec	sp
dec	sp
! Debug: eq int = const 0 to int n = [S+8-8] (used reg = )
xor	ax,ax
mov	-6[bp],ax
!BCC_EOS
! 1351     if (!str) return n;
mov	ax,4[bp]
test	ax,ax
jne 	.156
.157:
mov	ax,-6[bp]
inc	sp
inc	sp
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 1352 
! 1353     while (*str++) n++;
.156:
jmp .159
.15A:
! Debug: postinc int n = [S+8-8] (used reg = )
mov	ax,-6[bp]
inc	ax
mov	-6[bp],ax
!BCC_EOS
! 1354     return n;
.159:
! Debug: postinc * char str = [S+8+2] (used reg = )
mov	bx,4[bp]
inc	bx
mov	4[bp],bx
mov	al,-1[bx]
test	al,al
jne	.15A
.15B:
.158:
mov	ax,-6[bp]
inc	sp
inc	sp
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 1355 }
! 1356 
! Register BX used in function strlen
.data
.94:
.15C:
.ascii	"__DISK_DIRECTORY"
.byte	0
.75:
.15D:
.ascii	"420"
.byte	0
.5A:
.15E:
.byte	$A,$D
.byte	0
.59:
.15F:
.ascii	"UNKOWN"
.byte	0
.57:
.160:
.ascii	"STARTING"
.byte	0
.55:
.161:
.ascii	"SLEEPING"
.byte	0
.53:
.162:
.ascii	"BLOCKED"
.byte	0
.51:
.163:
.ascii	"READY"
.byte	0
.4F:
.164:
.ascii	"RUNNING"
.byte	0
.4A:
.165:
.byte	0
.3F:
.166:
.ascii	"IDLE"
.byte	0
.19:
.167:
.byte	$A,$D
.byte	0
.18:
.168:
.ascii	"killed "
.byte	0
.17:
.169:
.byte	$A,$D
.byte	0
.16:
.16A:
.ascii	"error: no process with segment index "
.byte	0
.A:
.16B:
.byte	$A,$D
.byte	0
.9:
.16C:
.ascii	"error: no process with segment index "
.byte	0
.1:
.16D:
.ascii	"shell"
.byte	0
.bss
.comm	_idleProc,$16
.comm	_running,2
.comm	_readyTail,2
.comm	_pcbPool,$B0
.comm	_readyHead,2
.comm	_memoryMap,$10

! 0 errors detected
