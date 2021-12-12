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
! 153 # 7 "./src/kernel.c"
! 7 #define VMEM_HIGH 0xB000
! 8 # 16
! 16 #define PUT_CHAR(CHAR) interrupt(0x10, ((0x0E) << 8) | (( CHAR) &  0xff) , 0, 0, 0)
! 17 
! 18 
! 19 
! 20 #define MAX_FILE           13312
! 21 
! 22 #define EXEC_MAGIC_NUM     "420"
! 23 
! 24 #define EXEC_MAGIC_OFFSET  3
! 25 
! 26 #define SEGMENT_INDEX(addr) (((addr >> 12) & 0xf)-2)
! 27 
! 28 #define INDEX_SEGMENT(index) ((index+2) << 12)
! 29 
! 30 
! 31 #define SLEEP_TIME 1
! 32 
! 33 
! 34 int writeSector();
!BCC_EOS
! 35 int readFile();
!BCC_EOS
! 36 int strcmpn();
!BCC_EOS
! 37 int bstrcmpn();
!BCC_EOS
! 38 int strcmp();
!BCC_EOS
! 39 int memcpyn();
!BCC_EOS
! 40 int strcpyn();
!BCC_EOS
! 41 int strlen();
!BCC_EOS
! 42 void putChar();
!BCC_EOS
! 43 void putStr();
!BCC_EOS
! 44 void printw();
!BCC_EOS
! 45 void printintw();
!BCC_EOS
! 46 int printStringn();
!BCC_EOS
! 47 int printInt();
!BCC_EOS
! 48 int sprintInt();
!BCC_EOS
! 49 void kStrCopy();
!BCC_EOS
! 50 void update_proc_sleep();
!BCC_EOS
! 51 void update_proc_blocked();
!BCC_EOS
! 52 
! 53 
! 54 void terminate();
!BCC_EOS
! 55 int writeFile();
!BCC_EOS
! 56 int deleteFile();
!BCC_EOS
! 57 int executeProgram();
!BCC_EOS
! 58 int printString();
!BCC_EOS
! 59 int readString();
!BCC_EOS
! 60 int readSector();
!BCC_EOS
! 61 int handleInterrupt21();
!BCC_EOS
! 62 int handleTimerInterrupt();
!BCC_EOS
! 63 void showProcesses();
!BCC_EOS
! 64 void yield();
!BCC_EOS
! 65 int kill();
!BCC_EOS
! 66 int sleep();
!BCC_EOS
! 67 int block();
!BCC_EOS
! 68 
! 69 
! 70 extern int loadWordKernel();
!BCC_EOS
! 71 extern int loadCharKernel();
!BCC_EOS
! 72 extern void setKernelDataSegment();
!BCC_EOS
! 73 extern void restoreDataSegment();
!BCC_EOS
! 74 extern void makeInterrupt21();
!BCC_EOS
! 75 extern void makeTi
! 75 merInterrupt();
!BCC_EOS
! 76 extern void returnFromTimer();
!BCC_EOS
! 77 extern void resetSegments();
!BCC_EOS
! 78 extern void launchProgram();
!BCC_EOS
! 79 extern void putInMemory();
!BCC_EOS
! 80 extern void disableInterrupts();
!BCC_EOS
! 81 extern void enableInterrupts();
!BCC_EOS
! 82 extern int interrupt();
!BCC_EOS
! 83 
! 84 int main()
! 85 {
export	_main
_main:
! 86     
! 87     
! 88     
! 89     
! 90     makeInterrupt21(); 
push	bp
mov	bp,sp
push	di
push	si
! Debug: func () void = makeInterrupt21+0 (used reg = )
call	_makeInterrupt21
!BCC_EOS
! 91     
! 92     makeTimerInterrupt();
! Debug: func () void = makeTimerInterrupt+0 (used reg = )
call	_makeTimerInterrupt
!BCC_EOS
! 93 
! 94     initializeProcStructures();
! Debug: func () void = initializeProcStructures+0 (used reg = )
call	_initializeProcStructures
!BCC_EOS
! 95 
! 96     
! 97     
! 98     
! 99     
! 100     
! 101     executeProgram("shell");
! Debug: list * char = .1+0 (used reg = )
mov	bx,#.1
push	bx
! Debug: func () int = executeProgram+0 (used reg = )
call	_executeProgram
inc	sp
inc	sp
!BCC_EOS
! 102 
! 103     while(1) {};
.4:
.3:
jmp	.4
.5:
.2:
!BCC_EOS
! 104 }
pop	si
pop	di
pop	bp
ret
! 105 
! 106 
! 107 
! 108 int kill(segi)
! Register BX used in function main
! 109 # 108 "./src/kernel.c"
! 108 int segi;
export	_kill
_kill:
!BCC_EOS
! 109 {
! 110 
! 111     struct PCB *pcb;
!BCC_EOS
! 112     int ret = -1;
push	bp
mov	bp,sp
push	di
push	si
add	sp,*-4
! Debug: eq int = const -1 to int ret = [S+$A-$A] (used reg = )
mov	ax,*-1
mov	-8[bp],ax
!BCC_EOS
! 113 
! 114     if (segi < 0 || segi > 7)
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
! 115     {
! 116         setKernelDataSegment();
! Debug: func () void = setKernelDataSegment+0 (used reg = )
call	_setKernelDataSegment
!BCC_EOS
! 117         printString("error: no process with segment index ");
! Debug: list * char = .9+0 (used reg = )
mov	bx,#.9
push	bx
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 118         printInt(segi);
! Debug: list int segi = [S+$A+2] (used reg = )
push	4[bp]
! Debug: func () int = printInt+0 (used reg = )
call	_printInt
inc	sp
inc	sp
!BCC_EOS
! 119         printString("\n\r");
! Debug: list * char = .A+0 (used reg = )
mov	bx,#.A
push	bx
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 120         restoreDataSegment();
! Debug: func () void = restoreDataSegment+0 (used reg = )
call	_restoreDataSegment
!BCC_EOS
! 121         return -1;
mov	ax,*-1
add	sp,*4
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 122     }
! 123 
! 124 
! 125     
! 126     setKernelDataSegment();
.6:
! Debug: func () void = setKernelDataSegment+0 (used reg = )
call	_setKernelDataSegment
!BCC_EOS
! 127     pcb = pcbPool;
! Debug: eq [8] struct PCB = pcbPool+0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,#_pcbPool
mov	-6[bp],bx
!BCC_EOS
! 128     for (pcb = pcbPool; pcb < pcbPool+8; ++pcb)
! Debug: eq [8] struct PCB = pcbPool+0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,#_pcbPool
mov	-6[bp],bx
!BCC_EOS
!BCC_EOS
! 129     {
jmp .D
.E:
! 130         if (pcb->state == DEFUNCT) continue;
mov	bx,-6[bp]
! Debug: logeq int = const 0 to int = [bx+8] (used reg = )
mov	ax,8[bx]
test	ax,ax
jne 	.F
.10:
jmp .C
!BCC_EOS
! 131         if (SEGMENT_INDEX(pcb->segment)== segi)
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
! 132         {
! 133             ret = 1;
! Debug: eq int = const 1 to int ret = [S+$A-$A] (used reg = )
mov	ax,*1
mov	-8[bp],ax
!BCC_EOS
! 134             break;
jmp .B
!BCC_EOS
! 135         }
! 136     }
.11:
! 137     restoreDataSegment();
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
! 138 
! 139     if (ret == -1)
! Debug: logeq int = const -1 to int ret = [S+$A-$A] (used reg = )
mov	ax,-8[bp]
cmp	ax,*-1
jne 	.14
.15:
! 140     {
! 141         setKernelDataSegment();
! Debug: func () void = setKernelDataSegment+0 (used reg = )
call	_setKernelDataSegment
!BCC_EOS
! 142         printString("error: no process with segment index ");
! Debug: list * char = .16+0 (used reg = )
mov	bx,#.16
push	bx
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 143         printInt(segi);
! Debug: list int segi = [S+$A+2] (used reg = )
push	4[bp]
! Debug: func () int = printInt+0 (used reg = )
call	_printInt
inc	sp
inc	sp
!BCC_EOS
! 144         printString("\n\r");
! Debug: list * char = .17+0 (used reg = )
mov	bx,#.17
push	bx
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 145         restoreDataSegment();
! Debug: func () void = restoreDataSegment+0 (used reg = )
call	_restoreDataSegment
!BCC_EOS
! 146         return -1;
mov	ax,*-1
add	sp,*4
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 147     }
! 148 
! 149     setKernelDataSegment();
.14:
! Debug: func () void = setKernelDataSegment+0 (used reg = )
call	_setKernelDataSegment
!BCC_EOS
! 150 
! 151     
! 152     disableInterrupts();
! Debug: func () void = disableInterrupts+0 (used reg = )
call	_disableInterrupts
!BCC_EOS
! 153     removeFromQueue(pcb);
! Debug: list * struct PCB pcb = [S+$A-8] (used reg = )
push	-6[bp]
! Debug: func () * struct PCB = removeFromQueue+0 (used reg = )
call	_removeFromQueue
inc	sp
inc	sp
!BCC_EOS
! 154     restoreInterrupts();
! Debug: func () int = restoreInterrupts+0 (used reg = )
call	_restoreInterrupts
!BCC_EOS
! 155     releaseMemorySegment(segi);
! Debug: list int segi = [S+$A+2] (used reg = )
push	4[bp]
! Debug: func () void = releaseMemorySegment+0 (used reg = )
call	_releaseMemorySegment
inc	sp
inc	sp
!BCC_EOS
! 156 
! 157     
! 158     printString("killed ");
! Debug: list * char = .18+0 (used reg = )
mov	bx,#.18
push	bx
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 159     printString(pcb->name);
! Debug: cast * char = const 0 to [7] char pcb = [S+$A-8] (used reg = )
! Debug: list * char pcb = [S+$A-8] (used reg = )
push	-6[bp]
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 160     printString("\n\r");
! Debug: list * char = .19+0 (used reg = )
mov	bx,#.19
push	bx
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 161 
! 162     
! 163     releasePCB(pcb);
! Debug: list * struct PCB pcb = [S+$A-8] (used reg = )
push	-6[bp]
! Debug: func () void = releasePCB+0 (used reg = )
call	_releasePCB
inc	sp
inc	sp
!BCC_EOS
! 164 
! 165     
! 166     update_proc_blocked(segi);
! Debug: list int segi = [S+$A+2] (used reg = )
push	4[bp]
! Debug: func () void = update_proc_blocked+0 (used reg = )
call	_update_proc_blocked
inc	sp
inc	sp
!BCC_EOS
! 167 
! 168     
! 169     if (running == pcb) {
! Debug: logeq * struct PCB pcb = [S+$A-8] to * struct PCB = [running+0] (used reg = )
mov	bx,[_running]
cmp	bx,-6[bp]
jne 	.1A
.1B:
! 170         yield();
! Debug: func () void = yield+0 (used reg = )
call	_yield
!BCC_EOS
! 171     }
! 172 
! 173     restoreDataSegment();
.1A:
! Debug: func () void = restoreDataSegment+0 (used reg = )
call	_restoreDataSegment
!BCC_EOS
! 174 
! 175     return ret;
mov	ax,-8[bp]
add	sp,*4
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 176 }
! 177 # 181
! 181 int sleep(time)
! Register BX used in function kill
! 182 # 181 "./src/kernel.c"
! 181 int time;
export	_sleep
_sleep:
!BCC_EOS
! 182 {
! 183     union  state_info_t  *state_info;
!BCC_EOS
! 184     struct sleep_info_t  *sleep_info;
!BCC_EOS
! 185 
! 186     setKernelDataSegment();
push	bp
mov	bp,sp
push	di
push	si
add	sp,*-4
! Debug: func () void = setKernelDataSegment+0 (used reg = )
call	_setKernelDataSegment
!BCC_EOS
! 187     if (running == 0x00 ) 
! Debug: logeq int = const 0 to * struct PCB = [running+0] (used reg = )
mov	ax,[_running]
test	ax,ax
jne 	.1C
.1D:
! 188         return 0; 
xor	ax,ax
add	sp,*4
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 189 
! 190     
! 191     state_info = &(running->state_info);
.1C:
mov	bx,[_running]
! Debug: address struct state_info_t = [bx+$E] (used reg = )
! Debug: eq * struct state_info_t = bx+$E to * struct state_info_t state_info = [S+$A-8] (used reg = )
add	bx,*$E
mov	-6[bp],bx
!BCC_EOS
! 192     sleep_info = &(state_info->sleep_info);
mov	bx,-6[bp]
! Debug: address struct sleep_info_t = [bx+0] (used reg = )
! Debug: eq * struct sleep_info_t = bx+0 to * struct sleep_info_t sleep_info = [S+$A-$A] (used reg = )
mov	-8[bp],bx
!BCC_EOS
! 193 
! 194     sleep_info->full    = time*12;
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
! 195     sleep_info->current = 0;
mov	bx,-8[bp]
! Debug: eq int = const 0 to int = [bx+2] (used reg = )
xor	ax,ax
mov	2[bx],ax
!BCC_EOS
! 196 
! 197     
! 198     
! 199     
! 200   
! 200   running->state = 5 ;
mov	bx,[_running]
! Debug: eq int = const 5 to int = [bx+8] (used reg = )
mov	ax,*5
mov	8[bx],ax
!BCC_EOS
! 201     restoreDataSegment();
! Debug: func () void = restoreDataSegment+0 (used reg = )
call	_restoreDataSegment
!BCC_EOS
! 202 
! 203     yield();
! Debug: func () void = yield+0 (used reg = )
call	_yield
!BCC_EOS
! 204 
! 205     return 1;
mov	ax,*1
add	sp,*4
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 206 }
! 207 # 216
! 216  
! 217 int block(segi)
! Register BX used in function sleep
! 218 # 217 "./src/kernel.c"
! 217 int segi;
export	_block
_block:
!BCC_EOS
! 218 {
! 219     union  state_info_t  *state_info;
!BCC_EOS
! 220     struct block_info_t  *block_info;
!BCC_EOS
! 221 
! 222     if (segi < 0 || segi > 7)
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
! 223     {
! 224         return 1;
mov	ax,*1
add	sp,*4
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 225     }
! 226 
! 227     state_info = &(running->state_info);
.1E:
mov	bx,[_running]
! Debug: address struct state_info_t = [bx+$E] (used reg = )
! Debug: eq * struct state_info_t = bx+$E to * struct state_info_t state_info = [S+$A-8] (used reg = )
add	bx,*$E
mov	-6[bp],bx
!BCC_EOS
! 228     block_info = &(state_info->block_info);
mov	bx,-6[bp]
! Debug: address struct block_info_t = [bx+0] (used reg = )
! Debug: eq * struct block_info_t = bx+0 to * struct block_info_t block_info = [S+$A-$A] (used reg = )
mov	-8[bp],bx
!BCC_EOS
! 229 
! 230     block_info->wait_pseg = segi;
mov	bx,-8[bp]
! Debug: eq int segi = [S+$A+2] to int = [bx+0] (used reg = )
mov	ax,4[bp]
mov	[bx],ax
!BCC_EOS
! 231     running->state = 3 ;
mov	bx,[_running]
! Debug: eq int = const 3 to int = [bx+8] (used reg = )
mov	ax,*3
mov	8[bx],ax
!BCC_EOS
! 232 
! 233     return 0;
xor	ax,ax
add	sp,*4
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 234 }
! 235 # 241
! 241  
! 242 void update_proc_blocked(segi)
! Register BX used in function block
! 243 # 242 "./src/kernel.c"
! 242 int segi;
export	_update_proc_blocked
_update_proc_blocked:
!BCC_EOS
! 243 {
! 244     union  state_info_t  *state_info;
!BCC_EOS
! 245     struct block_info_t  *block_info;
!BCC_EOS
! 246     struct PCB           *pcb;
!BCC_EOS
! 247 
! 248     if (segi < 0 || segi > 7)
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
! 249         return;
add	sp,*6
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 250 
! 251     setKernelDataSegment();
.21:
! Debug: func () void = setKernelDataSegment+0 (used reg = )
call	_setKernelDataSegment
!BCC_EOS
! 252     
! 253     pcb = pcbPool;
! Debug: eq [8] struct PCB = pcbPool+0 to * struct PCB pcb = [S+$C-$C] (used reg = )
mov	bx,#_pcbPool
mov	-$A[bp],bx
!BCC_EOS
! 254     for (pcb = pcbPool; pcb < pcbPool+8; ++pcb)
! Debug: eq [8] struct PCB = pcbPool+0 to * struct PCB pcb = [S+$C-$C] (used reg = )
mov	bx,#_pcbPool
mov	-$A[bp],bx
!BCC_EOS
!BCC_EOS
! 255     {
jmp .26
.27:
! 256         
! 257         
! 258         if (pcb->state != 3  )
mov	bx,-$A[bp]
! Debug: ne int = const 3 to int = [bx+8] (used reg = )
mov	bx,8[bx]
cmp	bx,*3
je  	.28
.29:
! 259             continue;
jmp .25
!BCC_EOS
! 260         if (pcb->state_info.block_info.wait_pseg != segi)
.28:
mov	bx,-$A[bp]
! Debug: ne int segi = [S+$C+2] to int = [bx+$E] (used reg = )
mov	bx,$E[bx]
cmp	bx,4[bp]
je  	.2A
.2B:
! 261             continue;
jmp .25
!BCC_EOS
! 262         
! 263         pcb->state = 2 ;
.2A:
mov	bx,-$A[bp]
! Debug: eq int = const 2 to int = [bx+8] (used reg = )
mov	ax,*2
mov	8[bx],ax
!BCC_EOS
! 264         addToReady(pcb);
! Debug: list * struct PCB pcb = [S+$C-$C] (used reg = )
push	-$A[bp]
! Debug: func () void = addToReady+0 (used reg = )
call	_addToReady
inc	sp
inc	sp
!BCC_EOS
! 265     }
! 266     restoreDataSegment();
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
! 267 }
add	sp,*6
pop	si
pop	di
pop	bp
ret
! 268 # 274
! 274  
! 275 void update_proc_sleep()
! Register BX used in function update_proc_blocked
! 276 {
export	_update_proc_sleep
_update_proc_sleep:
! 277     struct PCB *pcb;
!BCC_EOS
! 278     struct sleep_info_t *sleep_info;
!BCC_EOS
! 279 
! 280     
! 281     pcb = pcbPool;
push	bp
mov	bp,sp
push	di
push	si
add	sp,*-4
! Debug: eq [8] struct PCB = pcbPool+0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,#_pcbPool
mov	-6[bp],bx
!BCC_EOS
! 282     for (pcb = pcbPool; pcb < pcbPool+8; ++pcb)
! Debug: eq [8] struct PCB = pcbPool+0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,#_pcbPool
mov	-6[bp],bx
!BCC_EOS
!BCC_EOS
! 283     {
jmp .2F
.30:
! 284         if (pcb->state != 5 ) continue;
mov	bx,-6[bp]
! Debug: ne int = const 5 to int = [bx+8] (used reg = )
mov	bx,8[bx]
cmp	bx,*5
je  	.31
.32:
jmp .2E
!BCC_EOS
! 285         sleep_info = &(pcb->state_info.sleep_info);
.31:
mov	bx,-6[bp]
! Debug: address struct sleep_info_t = [bx+$E] (used reg = )
! Debug: eq * struct sleep_info_t = bx+$E to * struct sleep_info_t sleep_info = [S+$A-$A] (used reg = )
add	bx,*$E
mov	-8[bp],bx
!BCC_EOS
! 286 
! 287         
! 288         sleep_info->current += SLEEP_TIME;
mov	bx,-8[bp]
! Debug: addab int = const 1 to int = [bx+2] (used reg = )
mov	ax,2[bx]
inc	ax
mov	2[bx],ax
!BCC_EOS
! 289 
! 290         
! 291         if (sleep_info->current >= sleep_info->full)
mov	bx,-8[bp]
mov	si,-8[bp]
! Debug: ge int = [bx+0] to int = [si+2] (used reg = )
mov	si,2[si]
cmp	si,[bx]
jl  	.33
.34:
! 292         {
! 293             
! 294             pcb->state = 2 ;
mov	bx,-6[bp]
! Debug: eq int = const 2 to int = [bx+8] (used reg = )
mov	ax,*2
mov	8[bx],ax
!BCC_EOS
! 295             addToReady(pcb);
! Debug: list * struct PCB pcb = [S+$A-8] (used reg = )
push	-6[bp]
! Debug: func () void = addToReady+0 (used reg = )
call	_addToReady
inc	sp
inc	sp
!BCC_EOS
! 296         }
! 297     }
.33:
! 298 }
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
! 299 
! 300 
! 301 int handleTimerInterrupt(ds,ss)
! Register BX SI used in function update_proc_sleep
! 302 # 301 "./src/kernel.c"
! 301 int ds;
export	_handleTimerInterrupt
_handleTimerInterrupt:
!BCC_EOS
! 302 # 301 "./src/kernel.c"
! 301 int ss;
!BCC_EOS
! 302 {
! 303     struct PCB *pcb;
!BCC_EOS
! 304     int add_to_queue = 0;
push	bp
mov	bp,sp
push	di
push	si
add	sp,*-4
! Debug: eq int = const 0 to int add_to_queue = [S+$A-$A] (used reg = )
xor	ax,ax
mov	-8[bp],ax
!BCC_EOS
! 305 
! 306     update_proc_sleep();
! Debug: func () void = update_proc_sleep+0 (used reg = )
call	_update_proc_sleep
!BCC_EOS
! 307 
! 308     if (running->state != DEFUNCT)
mov	bx,[_running]
! Debug: ne int = const 0 to int = [bx+8] (used reg = )
mov	ax,8[bx]
test	ax,ax
je  	.36
.37:
! 309     {
! 310         running->segment = ds;
mov	bx,[_running]
! Debug: eq int ds = [S+$A+2] to int = [bx+$A] (used reg = )
mov	ax,4[bp]
mov	$A[bx],ax
!BCC_EOS
! 311         running->stackPointer = ss;
mov	bx,[_running]
! Debug: eq int ss = [S+$A+4] to int = [bx+$C] (used reg = )
mov	ax,6[bp]
mov	$C[bx],ax
!BCC_EOS
! 312         add_to_queue = (running->state != 5  && running->state != 3 );
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
! 313 
! 314         if (add_to_queue)
mov	ax,-8[bp]
test	ax,ax
je  	.3C
.3D:
! 315             running->state = 2 ;
mov	bx,[_running]
! Debug: eq int = const 2 to int = [bx+8] (used reg = )
mov	ax,*2
mov	8[bx],ax
!BCC_EOS
! 316 
! 317         
! 318         if (add_to_queue && !strcmp(running->name,"IDLE"))
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
! 319             addToReady(running);
! Debug: list * struct PCB = [running+0] (used reg = )
push	[_running]
! Debug: func () void = addToReady+0 (used reg = )
call	_addToReady
inc	sp
inc	sp
!BCC_EOS
! 320     }
.3E:
! 321 
! 322     pcb = removeFromReady();
.36:
! Debug: func () * struct PCB = removeFromReady+0 (used reg = )
call	_removeFromReady
! Debug: eq * struct PCB = ax+0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	-6[bp],ax
!BCC_EOS
! 323 
! 324  
! 324    if (pcb == 0x00 )
! Debug: logeq int = const 0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	ax,-6[bp]
test	ax,ax
jne 	.42
.43:
! 325     {
! 326         pcb = &idleProc;
! Debug: eq * struct PCB = idleProc+0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,#_idleProc
mov	-6[bp],bx
!BCC_EOS
! 327     }
! 328 
! 329     pcb->state = 1 ;
.42:
mov	bx,-6[bp]
! Debug: eq int = const 1 to int = [bx+8] (used reg = )
mov	ax,*1
mov	8[bx],ax
!BCC_EOS
! 330     running = pcb;
! Debug: eq * struct PCB pcb = [S+$A-8] to * struct PCB = [running+0] (used reg = )
mov	bx,-6[bp]
mov	[_running],bx
!BCC_EOS
! 331     returnFromTimer(pcb->segment,pcb->stackPointer);
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
! 332 
! 333     return 0;
xor	ax,ax
add	sp,*4
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 334 }
! 335 
! 336 void showProcesses()
! Register BX used in function handleTimerInterrupt
! 337 {
export	_showProcesses
_showProcesses:
! 338     struct PCB *pcb;
!BCC_EOS
! 339     int n;
!BCC_EOS
! 340     setKernelDataSegment();
push	bp
mov	bp,sp
push	di
push	si
add	sp,*-4
! Debug: func () void = setKernelDataSegment+0 (used reg = )
call	_setKernelDataSegment
!BCC_EOS
! 341 
! 342     
! 343     pcb = pcbPool;
! Debug: eq [8] struct PCB = pcbPool+0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,#_pcbPool
mov	-6[bp],bx
!BCC_EOS
! 344     for (pcb = pcbPool; pcb < pcbPool+8; ++pcb)
! Debug: eq [8] struct PCB = pcbPool+0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,#_pcbPool
mov	-6[bp],bx
!BCC_EOS
!BCC_EOS
! 345     {
br 	.46
.47:
! 346         if (pcb->state == DEFUNCT) continue;
mov	bx,-6[bp]
! Debug: logeq int = const 0 to int = [bx+8] (used reg = )
mov	ax,8[bx]
test	ax,ax
jne 	.48
.49:
br 	.45
!BCC_EOS
! 347         printw(pcb->name,10);
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
! 348         printintw(SEGMENT_INDEX(pcb->segment),3);
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
! 349         printw("",3);
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
! 350 
! 351         switch(pcb->state)
mov	bx,-6[bp]
mov	ax,8[bx]
! 352         {
jmp .4D
! 353             case 1 :
! 354                 printw("RUNNING",10);
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
! 355                 break;
jmp .4B
!BCC_EOS
! 356             case 2 :
! 357                 printw("READY",10);
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
! 358                 break;
jmp .4B
!BCC_EOS
! 359             case 3 :
! 360                 printw("BLOCKED",10);
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
! 361                 break;
jmp .4B
!BCC_EOS
! 362             case 5 :
! 363                 printw("SLEEPING",10);
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
! 364                 break;
jmp .4B
!BCC_EOS
! 365             case 4 :
! 366                 printw("STARTING",10);
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
! 367                 break;
jmp .4B
!BCC_EOS
! 368             default:
! 369                 printw("UNKOWN",10);
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
! 370                 break;
jmp .4B
!BCC_EOS
! 371         }
! 372         printString("\n\r");
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
! 373     }
! 374     restoreDataSegment();
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
! 375 }
add	sp,*4
pop	si
pop	di
pop	bp
ret
! 376 
! 377 
! 378 void printw(ptr,w)
! Register BX used in function showProcesses
! 379 # 378 "./src/kernel.c"
! 378 char *ptr;
export	_printw
_printw:
!BCC_EOS
! 379 # 378 "./src/kernel.c"
! 378 int w;
!BCC_EOS
! 379 {
! 380     int n = printString(ptr);
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
! 381     int diff;
!BCC_EOS
! 382     if (n < w) {
dec	sp
dec	sp
! Debug: lt int w = [S+$A+4] to int n = [S+$A-8] (used reg = )
mov	ax,-6[bp]
cmp	ax,6[bp]
jge 	.5C
.5D:
! 383         diff = w - n;
! Debug: sub int n = [S+$A-8] to int w = [S+$A+4] (used reg = )
mov	ax,6[bp]
sub	ax,-6[bp]
! Debug: eq int = ax+0 to int diff = [S+$A-$A] (used reg = )
mov	-8[bp],ax
!BCC_EOS
! 384         while (diff-- > 0)
! 385             PUT_CHAR(' ');
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
! 386     }
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
! 387 }
.5C:
add	sp,*4
pop	si
pop	di
pop	bp
ret
! 388 
! 389 
! 390 void printintw(x,w)
! 391 # 390 "./src/kernel.c"
! 390 int x;
export	_printintw
_printintw:
!BCC_EOS
! 391 # 390 "./src/kernel.c"
! 390 int w;
!BCC_EOS
! 391 {
! 392     char buf[13];
!BCC_EOS
! 393     int diff;
!BCC_EOS
! 394     int n = sprintInt(x,buf,13);
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
! 395 
! 396     if (n < w) {
! Debug: lt int w = [S+$18+4] to int n = [S+$18-$18] (used reg = )
mov	ax,-$16[bp]
cmp	ax,6[bp]
jge 	.62
.63:
! 397         diff = w - n;
! Debug: sub int n = [S+$18-$18] to int w = [S+$18+4] (used reg = )
mov	ax,6[bp]
sub	ax,-$16[bp]
! Debug: eq int = ax+0 to int diff = [S+$18-$16] (used reg = )
mov	-$14[bp],ax
!BCC_EOS
! 398         while (diff-- > 0)
! 399             PUT_CHAR(' ');
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
! 400     }
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
! 401     printString(buf);
.62:
! Debug: list * char buf = S+$18-$13 (used reg = )
lea	bx,-$11[bp]
push	bx
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 402 }
add	sp,*$12
pop	si
pop	di
pop	bp
ret
! 403 # 410
! 410   
! 411 void kStrCopy(src,dest,len)
! Register BX used in function printintw
! 412 # 411 "./src/kernel.c"
! 411 char *src;
export	_kStrCopy
_kStrCopy:
!BCC_EOS
! 412 # 411 "./src/kernel.c"
! 411 char *dest;
!BCC_EOS
! 412 # 411 "./src/kernel.c"
! 411 int len;
!BCC_EOS
! 412 # 411 "./src/kernel.c"
! 411 { 
! 412    int i=0; 
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
! 413    for (i=0; i < len; i++) { 
! Debug: eq int = const 0 to int i = [S+8-8] (used reg = )
xor	ax,ax
mov	-6[bp],ax
!BCC_EOS
!BCC_EOS
jmp .6A
.6B:
! 414         putInMemory(0x1000,dest+i,src[i]); 
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
! 415         if (src[i] == 0x00) { 
! Debug: ptradd int i = [S+8-8] to * char src = [S+8+2] (used reg = )
mov	ax,-6[bp]
add	ax,4[bp]
mov	bx,ax
! Debug: logeq int = const 0 to char = [bx+0] (used reg = )
mov	al,[bx]
test	al,al
jne 	.6C
.6D:
! 416             return; 
inc	sp
inc	sp
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 417         } 
! 418    } 
.6C:
! 419 }
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
! 420 # 424
! 424  
! 425 void terminate()
! Register BX used in function kStrCopy
! 426 {
export	_terminate
_terminate:
! 427     int segi;
!BCC_EOS
! 428 
! 429     setKernelDataSegment();
push	bp
mov	bp,sp
push	di
push	si
dec	sp
dec	sp
! Debug: func () void = setKernelDataSegment+0 (used reg = )
call	_setKernelDataSegment
!BCC_EOS
! 430     segi = SEGMENT_INDEX(running->segment);
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
! 431     
! 432     releaseMemorySegm
! 432 ent(segi);
! Debug: list int segi = [S+8-8] (used reg = )
push	-6[bp]
! Debug: func () void = releaseMemorySegment+0 (used reg = )
call	_releaseMemorySegment
inc	sp
inc	sp
!BCC_EOS
! 433     
! 434     releasePCB(running);
! Debug: list * struct PCB = [running+0] (used reg = )
push	[_running]
! Debug: func () void = releasePCB+0 (used reg = )
call	_releasePCB
inc	sp
inc	sp
!BCC_EOS
! 435     restoreDataSegment();
! Debug: func () void = restoreDataSegment+0 (used reg = )
call	_restoreDataSegment
!BCC_EOS
! 436     
! 437     update_proc_blocked(segi);
! Debug: list int segi = [S+8-8] (used reg = )
push	-6[bp]
! Debug: func () void = update_proc_blocked+0 (used reg = )
call	_update_proc_blocked
inc	sp
inc	sp
!BCC_EOS
! 438 
! 439     yield();
! Debug: func () void = yield+0 (used reg = )
call	_yield
!BCC_EOS
! 440 }
inc	sp
inc	sp
pop	si
pop	di
pop	bp
ret
! 441 # 448
! 448  
! 449 int executeProgram(name,blockopt)
! Register BX used in function terminate
! 450 # 449 "./src/kernel.c"
! 449 char *name;
export	_executeProgram
_executeProgram:
!BCC_EOS
! 450 # 449 "./src/kernel.c"
! 449 int blockopt;
!BCC_EOS
! 450 {
! 451     char buffer[MAX_FILE];   
!BCC_EOS
! 452     char magic_num[EXEC_MAGIC_OFFSET+1];
!BCC_EOS
! 453     int k = 0, i = 0;
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
! 454     int ret = 0;
dec	sp
dec	sp
! Debug: eq int = const 0 to int ret = [S+$3410-$3410] (used reg = )
xor	ax,ax
mov	-$340E[bp],ax
!BCC_EOS
! 455     int segi;
!BCC_EOS
! 456     int segment;
!BCC_EOS
! 457     struct PCB *pcb;
!BCC_EOS
! 458 
! 459     k = readFile(name,buffer,MAX_FILE);
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
! 460     if (k < 0)
! Debug: lt int = const 0 to int k = [S+$3416-$340C] (used reg = )
mov	ax,-$340A[bp]
test	ax,ax
jge 	.6F
.70:
! 461         return -1;
mov	ax,*-1
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 462 
! 463     
! 464     for (i = 0; i < EXEC_MAGIC_OFFSET; ++i)
.6F:
! Debug: eq int = const 0 to int i = [S+$3416-$340E] (used reg = )
xor	ax,ax
mov	-$340C[bp],ax
!BCC_EOS
!BCC_EOS
! 465         magic_num[i] = loadCharKernel(EXEC_MAGIC_NUM+i);
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
! 466     magic_num[i] = 0;
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
! 467 
! 468     
! 469     ret = strcmpn(magic_num,buffer,EXEC_MAGIC_OFFSET);
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
! 470     if (!ret)
mov	ax,-$340E[bp]
test	ax,ax
jne 	.77
.78:
! 471     {
! 472         return -3;
mov	ax,*-3
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 473     }
! 474 
! 475     
! 476     setKernelDataSegment();
.77:
! Debug: func () void = setKernelDataSegment+0 (used reg = )
call	_setKernelDataSegment
!BCC_EOS
! 477     segi = getFreeMemorySegment();
! Debug: func () int = getFreeMemorySegment+0 (used reg = )
call	_getFreeMemorySegment
! Debug: eq int = ax+0 to int segi = [S+$3416-$3412] (used reg = )
mov	-$3410[bp],ax
!BCC_EOS
! 478     restoreDataSegment();
! Debug: func () void = restoreDataSegment+0 (used reg = )
call	_restoreDataSegment
!BCC_EOS
! 479 
! 480     
! 481     segment = INDEX_SEGMENT(segi);
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
! 482 
! 483     if (segi == -1 )
! Debug: logeq int = const -1 to int segi = [S+$3416-$3412] (used reg = )
mov	ax,-$3410[bp]
cmp	ax,*-1
jne 	.79
.7A:
! 484         return -2;
mov	ax,*-2
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 485 
! 486 
! 487     k = (k << 9);
.79:
! Debug: sl int = const 9 to int k = [S+$3416-$340C] (used reg = )
mov	ax,-$340A[bp]
mov	ah,al
xor	al,al
shl	ax,*1
! Debug: eq int = ax+0 to int k = [S+$3416-$340C] (used reg = )
mov	-$340A[bp],ax
!BCC_EOS
! 488     for (i = EXEC_MAGIC_OFFSET; i < k; ++i)
! Debug: eq int = const 3 to int i = [S+$3416-$340E] (used reg = )
mov	ax,*3
mov	-$340C[bp],ax
!BCC_EOS
!BCC_EOS
! 489     {
jmp .7D
.7E:
! 490         putInMemory(segment,i-EXEC_MAGIC_OFFSET,*(buffer+i));
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
! 491     }
! 492 
! 493     
! 494     setKernelDataSegment();
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
! 495     pcb = getFreePCB();
! Debug: func () * struct PCB = getFreePCB+0 (used reg = )
call	_getFreePCB
! Debug: eq * struct PCB = ax+0 to * struct PCB pcb = [S+$3416-$3416] (used reg = )
mov	-$3414[bp],ax
!BCC_EOS
! 496     restoreDataSegment();
! Debug: func () void = restoreDataSegment+0 (used reg = )
call	_restoreDataSegment
!BCC_EOS
! 497 
! 498     if (pcb == 0x00 )
! Debug: logeq int = const 0 to * struct PCB pcb = [S+$3416-$3416] (used reg = )
mov	ax,-$3414[bp]
test	ax,ax
jne 	.80
.81:
! 499         return -4;
mov	ax,*-4
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 500     
! 501     kStrCopy(name,pcb->name,7);
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
! 502 
! 503     setKernelDataSegment();
! Debug: func () void = setKernelDataSegment+0 (used reg = )
call	_setKernelDataSegment
!BCC_EOS
! 504     pcb->state = 4 ;
mov	bx,-$3414[bp]
! Debug: eq int = const 4 to int = [bx+8] (used reg = )
mov	ax,*4
mov	8[bx],ax
!BCC_EOS
! 505     pcb->segment = segment;
mov	bx,-$3414[bp]
! Debug: eq int segment = [S+$3416-$3414] to int = [bx+$A] (used reg = )
mov	ax,-$3412[bp]
mov	$A[bx],ax
!BCC_EOS
! 506     pcb->stackPointer = 0xff00;
mov	bx,-$3414[bp]
! Debug: eq unsigned int = const $FF00 to int = [bx+$C] (used reg = )
mov	ax,#$FF00
mov	$C[bx],ax
!BCC_EOS
! 507 
! 508     
! 509     initializeProgram(segment);
! Debug: list int segment = [S+$3416-$3414] (used reg = )
push	-$3412[bp]
! Debug: func () int = initializeProgram+0 (used reg = )
call	_initializeProgram
inc	sp
inc	sp
!BCC_EOS
! 510 
! 511     
! 512     disableInterrupts(); 
! Debug: func () void = disableInterrupts+0 (used reg = )
call	_disableInterrupts
!BCC_EOS
! 513     if (blockopt)
mov	ax,6[bp]
test	ax,ax
je  	.82
.83:
! 514     {
! 515         block(segi);
! Debug: list int segi = [S+$3416-$3412] (used reg = )
push	-$3410[bp]
! Debug: func () int = block+0 (used reg = )
call	_block
inc	sp
inc	sp
!BCC_EOS
! 516     }
! 517     addToReady(pcb);
.82:
! Debug: list * struct PCB pcb = [S+$3416-$3416] (used reg = )
push	-$3414[bp]
! Debug: func () void = addToReady+0 (used reg = )
call	_addToReady
inc	sp
inc	sp
!BCC_EOS
! 518     restoreInterrupts();
! Debug: func () int = restoreInterrupts+0 (used reg = )
call	_restoreInterrupts
!BCC_EOS
! 519 
! 520     restoreDataSegment();
! Debug: func () void = restoreDataSegment+0 (used reg = )
call	_restoreDataSegment
!BCC_EOS
! 521 
! 522     if (blockopt)
mov	ax,6[bp]
test	ax,ax
je  	.84
.85:
! 523         yield();
! Debug: func () void = yield+0 (used reg = )
call	_yield
!BCC_EOS
! 524 
! 525     return 1;
.84:
mov	ax,*1
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 526 }
! 527 
! 528 
! 529 
! 530  
! 531 void yield()
! Register BX used in function executeProgram
! 532 {
export	_yield
_yield:
! 533     
! 534     interrupt(0x08,0,0,0,0);
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
! 535 }
pop	si
pop	di
pop	bp
ret
! 536 # 636
! 636  
! 637 int handleInterrupt21(ax,bx,cx,dx)
! 638 # 637 "./src/kernel.c"
! 637 int ax;
export	_handleInterrupt21
_handleInterrupt21:
!BCC_EOS
! 638 # 637 "./src/kernel.c"
! 637 int bx;
!BCC_EOS
! 638 # 637 "./src/kernel.c"
! 637 int cx;
!BCC_EOS
! 638 # 637 "./src/kernel.c"
! 637 int dx;
!BCC_EOS
! 638 {
! 639     int ret = -1;
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
! 640     int i = 0;
dec	sp
dec	sp
! Debug: eq int = const 0 to int i = [S+$A-$A] (used reg = )
xor	ax,ax
mov	-8[bp],ax
!BCC_EOS
! 641     char buffer[20];
!BCC_EOS
! 642 
! 643     switch(ax)
add	sp,*-$14
mov	ax,4[bp]
! 644     {
br 	.88
! 645         case 0x00:
! 646             
! 647             ret = printString((char*)bx);
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
! 648             break;
br 	.86
!BCC_EOS
! 649 
! 650         case 0xff:
! 651             
! 652             putStr((char*)bx,strlen((char*)bx),cx,(dx >> 8)& 0xff,dx & 0xff);
.8A:
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
! 653  
! 653            ret = 1;
! Debug: eq int = const 1 to int ret = [S+$1E-8] (used reg = )
mov	ax,*1
mov	-6[bp],ax
!BCC_EOS
! 654             break;
br 	.86
!BCC_EOS
! 655 
! 656         case 0xa1:
! 657             
! 658             ret = sleep(bx);
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
! 659             break;
br 	.86
!BCC_EOS
! 660 
! 661         case 0x0b:
! 662             
! 663             ret = kill(bx);
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
! 664             break;
br 	.86
!BCC_EOS
! 665 
! 666         case 0x0a:
! 667             
! 668             showProcesses();
.8D:
! Debug: func () void = showProcesses+0 (used reg = )
call	_showProcesses
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
! 672         case 0x09:
! 673             
! 674             yield();
.8E:
! Debug: func () void = yield+0 (used reg = )
call	_yield
!BCC_EOS
! 675             ret = 1;
! Debug: eq int = const 1 to int ret = [S+$1E-8] (used reg = )
mov	ax,*1
mov	-6[bp],ax
!BCC_EOS
! 676             break;
br 	.86
!BCC_EOS
! 677 
! 678         case 0x03:
! 679             
! 680             
! 681             
! 682             for (i = 0; i < 17; ++i)
.8F:
! Debug: eq int = const 0 to int i = [S+$1E-$A] (used reg = )
xor	ax,ax
mov	-8[bp],ax
!BCC_EOS
!BCC_EOS
! 683                 buffer[i] = loadCharKernel("__DISK_DIRECTORY"+i);
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
! 684 
! 685             if (strcmp((char*)bx,buffer)) {
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
! 686                 ret = readSector((char*)cx,2);
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
! 687             } else {
jmp .98
.96:
! 688                 ret = readFile((char*)bx,(char*)cx,(int)dx);
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
! 689             }
! 690             break;
.98:
br 	.86
!BCC_EOS
! 691 
! 692         case 0x04:
! 693             
! 694             ret = executeProgram((char*)bx,cx);
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
! 695             break;
br 	.86
!BCC_EOS
! 696 
! 697         case 0x05:
! 698             
! 699             terminate(); 
.9A:
! Debug: func () void = terminate+0 (used reg = )
call	_terminate
!BCC_EOS
! 700             break;
br 	.86
!BCC_EOS
! 701 
! 702         case 0x07:
! 703             
! 704             ret = deleteFile((char*)bx);
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
! 705             break;
br 	.86
!BCC_EOS
! 706 
! 707         case 0x08:
! 708             
! 709             ret = writeFile((char*)bx,(char*)cx,(int)dx);
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
! 710             break;
jmp .86
!BCC_EOS
! 711 
! 712         case 0x11:
! 713             
! 714             *((char*)bx) = (char) (interrupt(0x16,0,0,0,0)& 0xFF) ;
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
! 715             ret = 1;
! Debug: eq int = const 1 to int ret = [S+$1E-8] (used reg = )
mov	ax,*1
mov	-6[bp],ax
!BCC_EOS
! 716             break;
jmp .86
!BCC_EOS
! 717 
! 718         case 0x01:
! 719             
! 720             ret = readString((char*)bx,cx);
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
! 721             break;
jmp .86
!BCC_EOS
! 722     }
! 723 
! 724     return ret;
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
! 725 }
! 726 # 732
! 732  
! 733 # 747
! 747  
! 748 int writeFile(fname,buffer,sectors)
! Register BX used in function handleInterrupt21
! 749 # 748 "./src/kernel.c"
! 748 char *fname;
export	_writeFile
_writeFile:
!BCC_EOS
! 749 # 748 "./src/kernel.c"
! 748 char *buffer;
!BCC_EOS
! 749 # 748 "./src/kernel.c"
! 748 int sectors;
!BCC_EOS
! 749 {
! 750     
! 751     char disk_map[512];
!BCC_EOS
! 752     
! 753     char disk_dir[512];
!BCC_EOS
! 754     
! 755     char file_sectors[26];
!BCC_EOS
! 756     
! 757     char *ptr;
!BCC_EOS
! 758     char *mptr;
!BCC_EOS
! 759     
! 760     int   j  = 0;
push	bp
mov	bp,sp
push	di
push	si
add	sp,#-$420
! Debug: eq int = const 0 to int j = [S+$426-$426] (used reg = )
xor	ax,ax
mov	-$424[bp],ax
!BCC_EOS
! 761     
! 762     int byte = 0;
dec	sp
dec	sp
! Debug: eq int = const 0 to int byte = [S+$428-$428] (used reg = )
xor	ax,ax
mov	-$426[bp],ax
!BCC_EOS
! 763     
! 764     int free_entry = -1;
dec	sp
dec	sp
! Debug: eq int = const -1 to int free_entry = [S+$42A-$42A] (used reg = )
mov	ax,*-1
mov	-$428[bp],ax
!BCC_EOS
! 765 
! 766     
! 767     readSector(disk_map,1);
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
! 768     readSector(disk_dir,2);
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
! 769 
! 770     
! 771     sectors = (sectors < 26 ? sectors : 26);
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
! 772 
! 773     
! 774     
! 775     
! 776     
! 777 
! 778     
! 779     for(; byte < 512; byte += 32)
!BCC_EOS
!BCC_EOS
! 780     {
jmp .A6
.A7:
! 781         if (free_entry < 0 && !*(disk_dir+byte))
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
! 782             free_entry = byte;
! Debug: eq int byte = [S+$42A-$428] to int free_entry = [S+$42A-$42A] (used reg = )
mov	ax,-$426[bp]
mov	-$428[bp],ax
!BCC_EOS
! 783         if (bst
.A8:
! 783 rcmpn(fname,disk_dir + byte,6))
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
! 784             break;
jmp .A4
!BCC_EOS
! 785     }
.AB:
! 786 
! 787     if (byte < 512)
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
! 788     {
! 789         
! 790         
! 791         ptr  = disk_dir + byte + 6;;
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
! 792         j = 0;
! Debug: eq int = const 0 to int j = [S+$42A-$426] (used reg = )
xor	ax,ax
mov	-$424[bp],ax
!BCC_EOS
! 793         while (j < sectors && *ptr)
! 794         {
jmp .B1
.B2:
! 795             
! 796             
! 797             
! 798             
! 799             
! 800             writeSector(buffer + (j++<<9),*(ptr++));
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
! 801         }
! 802 
! 803         if (j == sectors)
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
! 804         {
! 805             
! 806             while (j < 26 && *ptr) {
jmp .B8
.B9:
! 807                 
! 808                 
! 809                 
! 810                 
! 811                 
! 812 
! 813                 disk_map[*ptr] = 0; 
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
! 814                 *(ptr++) = 0;       
! Debug: postinc * char ptr = [S+$42A-$422] (used reg = )
mov	bx,-$420[bp]
inc	bx
mov	-$420[bp],bx
! Debug: eq int = const 0 to char = [bx-1] (used reg = )
xor	al,al
mov	-1[bx],al
!BCC_EOS
! 815                 ++j;
! Debug: preinc int j = [S+$42A-$426] (used reg = )
mov	ax,-$424[bp]
inc	ax
mov	-$424[bp],ax
!BCC_EOS
! 816             }
! 817         }
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
! 818     }
.B5:
! 819     else if (free_entry < 0)
jmp .BC
.AE:
! Debug: lt int = const 0 to int free_entry = [S+$42A-$42A] (used reg = )
mov	ax,-$428[bp]
test	ax,ax
jge 	.BD
.BE:
! 820     {
! 821         
! 822         return -1;
mov	ax,*-1
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 823     }
! 824     else
! 825     {
jmp .BF
.BD:
! 826         
! 827         
! 828         strcpyn(disk_dir+free_entry,7,fname);
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
! 829         ptr = disk_dir+free_entry+6;
! Debug: ptradd int free_entry = [S+$42A-$42A] to [$200] char disk_dir = S+$42A-$406 (used reg = )
mov	ax,-$428[bp]
mov	bx,bp
add	bx,ax
! Debug: ptradd int = const 6 to [$200] char = bx-$404 (used reg = )
! Debug: eq [$200] char = bx-$3FE to * char ptr = [S+$42A-$422] (used reg = )
add	bx,#-$3FE
mov	-$420[bp],bx
!BCC_EOS
! 830     }
! 831 
! 832 
! 833     
! 834     mptr = disk_map;
.BF:
.BC:
! Debug: eq [$200] char disk_map = S+$42A-$206 to * char mptr = [S+$42A-$424] (used reg = )
lea	bx,-$204[bp]
mov	-$422[bp],bx
!BCC_EOS
! 835 
! 836     while (mptr != disk_map + 512 && j < sectors)
! 837     {
jmp .C1
.C2:
! 838         if (!*mptr)
mov	bx,-$422[bp]
mov	al,[bx]
test	al,al
jne 	.C3
.C4:
! 839         {
! 840             writeSector(buffer + (j++ << 9),mptr-disk_map);
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
! 841             *mptr = 0xff;
mov	bx,-$422[bp]
! Debug: eq int = const $FF to char = [bx+0] (used reg = )
mov	al,#$FF
mov	[bx],al
!BCC_EOS
! 842             *(ptr++) = mptr - disk_map;
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
! 843         }
! 844         ++mptr;
.C3:
! Debug: preinc * char mptr = [S+$42A-$424] (used reg = )
mov	bx,-$422[bp]
inc	bx
mov	-$422[bp],bx
!BCC_EOS
! 845     }
! 846 
! 847     
! 848     if (j < 26)
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
! 849         *ptr = 0;
mov	bx,-$420[bp]
! Debug: eq int = const 0 to char = [bx+0] (used reg = )
xor	al,al
mov	[bx],al
!BCC_EOS
! 850 
! 851     
! 852     writeSector(disk_map,1);
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
! 853     writeSector(disk_dir,2);
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
! 854 
! 855    return j == sectors ? j : -2;
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
! 856 }
! 857 
! 858 
! 859 
! 860 int deleteFile(fname)
! Register BX used in function writeFile
! 861 # 860 "./src/kernel.c"
! 860 char *fname;
export	_deleteFile
_deleteFile:
!BCC_EOS
! 861 {
! 862     
! 863     char disk_map[512];
!BCC_EOS
! 864     
! 865     char disk_dir[512];
!BCC_EOS
! 866     
! 867     char *ptr;
!BCC_EOS
! 868     
! 869     int   j  = 0;
push	bp
mov	bp,sp
push	di
push	si
add	sp,#-$404
! Debug: eq int = const 0 to int j = [S+$40A-$40A] (used reg = )
xor	ax,ax
mov	-$408[bp],ax
!BCC_EOS
! 870     
! 871     int byte = 0;
dec	sp
dec	sp
! Debug: eq int = const 0 to int byte = [S+$40C-$40C] (used reg = )
xor	ax,ax
mov	-$40A[bp],ax
!BCC_EOS
! 872 
! 873     
! 874     readSector(disk_map,1);
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
! 875     readSector(disk_dir,2);
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
! 876 
! 877     
! 878     for(; byte < 512; byte += 32)
!BCC_EOS
!BCC_EOS
! 879     {
jmp .CE
.CF:
! 880         if (bstrcmpn(fname,disk_dir + byte,6))
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
! 881             break;
jmp .CC
!BCC_EOS
! 882     }
.D0:
! 883 
! 884     
! 885     if (byte >= 512)
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
! 886         return -1;
mov	ax,*-1
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 887 
! 888     
! 889     ptr  = disk_dir + byte + 6;;
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
! 890     
! 891     
! 892     while (j < 26 && *ptr) 
! 893     {
jmp .D6
.D7:
! 894         disk_map[*(ptr++)] = 0; 
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
! 895     }
! 896 
! 897     
! 898     *(disk_dir + byte) = 0;
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
! 899 
! 900     
! 901     writeSector(disk_map,1);
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
! 902     writeSector(disk_dir,2);
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
! 903    return j;
mov	ax,-$408[bp]
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 904 
! 905 }
! 906 # 913
! 913  
! 914 int writeSector(buf,sector)
! Register BX used in function deleteFile
! 915 # 914 "./src/kernel.c"
! 914 char *buf;
export	_writeSector
_writeSector:
!BCC_EOS
! 915 # 914 "./src/kernel.c"
! 914 int sector;
!BCC_EOS
! 915 {
! 916 
! 917     int q         = sector/18;
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
! 918     int relsector = sector - q
dec	sp
dec	sp
! 918 *18 + 1;
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
! 919     int head      = q & 1;
dec	sp
dec	sp
! Debug: and int = const 1 to int q = [S+$C-8] (used reg = )
mov	al,-6[bp]
and	al,*1
! Debug: eq char = al+0 to int head = [S+$C-$C] (used reg = )
xor	ah,ah
mov	-$A[bp],ax
!BCC_EOS
! 920     int track     = sector/36;
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
! 921 
! 922     interrupt(0x13,((0x03)<< 8)| ((0x01)&  0xff),(int)buf,((track)<< 8)| ((relsector)&  0xff),((head)<< 8)| ((0x00)&  0xff));
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
! 923 
! 924     return 1;
mov	ax,*1
add	sp,*8
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 925 }
! 926 # 934
! 934  
! 935 int printStringn(str,n)
! Register BX used in function writeSector
! 936 # 935 "./src/kernel.c"
! 935 char *str;
export	_printStringn
_printStringn:
!BCC_EOS
! 936 # 935 "./src/kernel.c"
! 935 int n;
!BCC_EOS
! 936 {
! 937     char *start = str;
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
! 938     while (*str != 0 && n--)
! 939         PUT_CHAR(*(str++));
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
! 940     return str - start;
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
! 941 }
! 942 # 953
! 953  
! 954 int readFile(filename,buf,n)
! Register BX used in function printStringn
! 955 # 954 "./src/kernel.c"
! 954 char *filename;
export	_readFile
_readFile:
!BCC_EOS
! 955 # 954 "./src/kernel.c"
! 954 char *buf;
!BCC_EOS
! 955 # 954 "./src/kernel.c"
! 954 int n;
!BCC_EOS
! 955 {
! 956     
! 957     char disk_dir[512];
!BCC_EOS
! 958     
! 959     char sector_data[512];
!BCC_EOS
! 960     
! 961     char *ptr;
!BCC_EOS
! 962     
! 963     int   j  = 0;
push	bp
mov	bp,sp
push	di
push	si
add	sp,#-$404
! Debug: eq int = const 0 to int j = [S+$40A-$40A] (used reg = )
xor	ax,ax
mov	-$408[bp],ax
!BCC_EOS
! 964     
! 965     int byte = 0;
dec	sp
dec	sp
! Debug: eq int = const 0 to int byte = [S+$40C-$40C] (used reg = )
xor	ax,ax
mov	-$40A[bp],ax
!BCC_EOS
! 966 
! 967     
! 968     readSector(disk_dir,2);
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
! 969 
! 970     
! 971     for(; byte < 512; byte += 32)
!BCC_EOS
!BCC_EOS
! 972     {
jmp .E1
.E2:
! 973         if (bstrcmpn(filename,disk_dir + byte,6))
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
! 974             break;
jmp .DF
!BCC_EOS
! 975     }
.E3:
! 976 
! 977     
! 978     if (byte >= 512)
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
! 979         return -1;
mov	ax,*-1
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 980 
! 981     
! 982     ptr  = disk_dir + byte + 6;;
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
! 983     
! 984     
! 985     while (n >= 512 && j < 26 && *ptr) 
! 986     {
jmp .E9
.EA:
! 987         readSector(buf+512*(j++),*(ptr++));
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
! 988         n -= 512;
! Debug: subab int = const $200 to int n = [S+$40C+6] (used reg = )
mov	ax,8[bp]
add	ax,#-$200
mov	8[bp],ax
!BCC_EOS
! 989     }
! 990     
! 991     if (n > 0 && j < 26 && *ptr)
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
! 992     {
! 993         readSector(sector_data,*ptr);
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
! 994         memcpyn(buf+512*(j++),n,sector_data,512);
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
! 995 
! 996     }
! 997     return j;
.EE:
mov	ax,-$408[bp]
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 998 }
! 999 # 1007
! 1007  
! 1008 int memcpyn(dst,m,src,n)
! Register BX used in function readFile
! 1009 # 1008 "./src/kernel.c"
! 1008 char *dst;
export	_memcpyn
_memcpyn:
!BCC_EOS
! 1009 # 1008 "./src/kernel.c"
! 1008 int m;
!BCC_EOS
! 1009 # 1008 "./src/kernel.c"
! 1008 char *src;
!BCC_EOS
! 1009 # 1008 "./src/kernel.c"
! 1008 int n;
!BCC_EOS
! 1009 {
! 1010     int k = (m < n ? m : n); 
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
! 1011     n = k;
! Debug: eq int k = [S+8-8] to int n = [S+8+8] (used reg = )
mov	ax,-6[bp]
mov	$A[bp],ax
!BCC_EOS
! 1012     
! 1013     while (n--) 
! 1014         *(dst++) = *(src++);
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
! 1015 
! 1016     return n;
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
! 1017 }
! 1018 # 1027
! 1027  
! 1028 int strcpyn(dst,n,src)
! Register BX SI used in function memcpyn
! 1029 # 1028 "./src/kernel.c"
! 1028 char *dst;
export	_strcpyn
_strcpyn:
!BCC_EOS
! 1029 # 1028 "./src/kernel.c"
! 1028 int n;
!BCC_EOS
! 1029 # 1028 "./src/kernel.c"
! 1028 char *src;
!BCC_EOS
! 1029 {
! 1030     char *ptr = dst;
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
! 1031     while (*src && --n)
! 1032         *(ptr++) = *(src++);
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
! 1033     *ptr = 0;
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
! 1034 
! 1035     return ptr - dst;
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
! 1036 }
! 1037 # 1044
! 1044  
! 1045 int strcmpn(a,b,n)
! Register BX SI used in function strcpyn
! 1046 # 1045 "./src/kernel.c"
! 1045 char *a;
export	_strcmpn
_strcmpn:
!BCC_EOS
! 1046 # 1045 "./src/kernel.c"
! 1045 char *b;
!BCC_EOS
! 1046 # 1045 "./src/kernel.c"
! 1045 int n;
!BCC_EOS
! 1046 # 1045 "./src/kernel.c"
! 1045 {
! 1046     
! 1047     while (n-- && *a && *b) {
push	bp
mov	bp,sp
push	di
push	si
jmp .FF
.100:
! 1048         if (*(a++)!= *(b++))
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
! 1049             return 0; 
xor	ax,ax
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 1050     }
.101:
! 1051     
! 1052     
! 1053     return n < 0 || *a == *b;
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
! 1054 }
! 1055 # 1061
! 1061  
! 1062 # 1067
! 1067  
! 1068 int printString(
! Register BX SI used in function strcmpn
! 1068 str)
! 1069 # 1068 "./src/kernel.c"
! 1068 char *str;
export	_printString
_printString:
!BCC_EOS
! 1069 {
! 1070     char *start = str;
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
! 1071     while (*str != 0)
! 1072         PUT_CHAR(*(str++));
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
! 1073     return str - start;
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
! 1074 }
! 1075 # 1087
! 1087  
! 1088 int readString(buf,n)
! Register BX used in function printString
! 1089 # 1088 "./src/kernel.c"
! 1088 char *buf;
export	_readString
_readString:
!BCC_EOS
! 1089 # 1088 "./src/kernel.c"
! 1088 int n;
!BCC_EOS
! 1089 {
! 1090     char *start = buf;
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
! 1091     char *end   = buf + n-1;
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
! 1092     char c;
!BCC_EOS
! 1093 
! 1094     while ((c = (interrupt(0x16,0,0,0,0)& 0xFF))!= '\r')
dec	sp
dec	sp
! 1095     {
br 	.10F
.110:
! 1096         if (c == 0x08)
! Debug: logeq int = const 8 to char c = [S+$C-$B] (used reg = )
mov	al,-9[bp]
cmp	al,*8
jne 	.111
.112:
! 1097         {
! 1098             if (buf != start)
! Debug: ne * char start = [S+$C-8] to * char buf = [S+$C+2] (used reg = )
mov	bx,4[bp]
cmp	bx,-6[bp]
je  	.113
.114:
! 1099             {
! 1100                 --buf;
! Debug: predec * char buf = [S+$C+2] (used reg = )
mov	bx,4[bp]
dec	bx
mov	4[bp],bx
!BCC_EOS
! 1101                 PUT_CHAR(0x08);
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
! 1102                 PUT_CHAR(' ');
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
! 1103                 PUT_CHAR(0x08);
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
! 1104             }
! 1105         }
.113:
! 1106         else if (buf != end)
jmp .115
.111:
! Debug: ne * char end = [S+$C-$A] to * char buf = [S+$C+2] (used reg = )
mov	bx,4[bp]
cmp	bx,-8[bp]
je  	.116
.117:
! 1107         {
! 1108             *buf = c;
mov	bx,4[bp]
! Debug: eq char c = [S+$C-$B] to char = [bx+0] (used reg = )
mov	al,-9[bp]
mov	[bx],al
!BCC_EOS
! 1109             PUT_CHAR(c);
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
! 1110             ++buf;
! Debug: preinc * char buf = [S+$C+2] (used reg = )
mov	bx,4[bp]
inc	bx
mov	4[bp],bx
!BCC_EOS
! 1111         }
! 1112     }
.116:
.115:
! 1113     *buf = 0;
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
! 1114     return buf - start;
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
! 1115 }
! 1116 # 1121
! 1121  
! 1122 int printInt(x)
! Register BX used in function readString
! 1123 # 1122 "./src/kernel.c"
! 1122 int x;
export	_printInt
_printInt:
!BCC_EOS
! 1123 {
! 1124     
! 1125     char buf[12];
!BCC_EOS
! 1126     char *ptr = buf+11; 
push	bp
mov	bp,sp
push	di
push	si
add	sp,*-$E
! Debug: eq [$C] char buf = S+$14-7 to * char ptr = [S+$14-$14] (used reg = )
lea	bx,-5[bp]
mov	-$12[bp],bx
!BCC_EOS
! 1127     int q, r; 
!BCC_EOS
! 1128     int sign = 1; 
add	sp,*-6
! Debug: eq int = const 1 to int sign = [S+$1A-$1A] (used reg = )
mov	ax,*1
mov	-$18[bp],ax
!BCC_EOS
! 1129 
! 1130     
! 1131     *ptr = 0;
mov	bx,-$12[bp]
! Debug: eq int = const 0 to char = [bx+0] (used reg = )
xor	al,al
mov	[bx],al
!BCC_EOS
! 1132     
! 1133     if (x < 0)
! Debug: lt int = const 0 to int x = [S+$1A+2] (used reg = )
mov	ax,4[bp]
test	ax,ax
jge 	.119
.11A:
! 1134     {
! 1135         
! 1136         sign = -1;
! Debug: eq int = const -1 to int sign = [S+$1A-$1A] (used reg = )
mov	ax,*-1
mov	-$18[bp],ax
!BCC_EOS
! 1137         x = -x;
! Debug: neg int x = [S+$1A+2] (used reg = )
xor	ax,ax
sub	ax,4[bp]
! Debug: eq int = ax+0 to int x = [S+$1A+2] (used reg = )
mov	4[bp],ax
!BCC_EOS
! 1138     }
! 1139     else if (x == 0)
jmp .11B
.119:
! Debug: logeq int = const 0 to int x = [S+$1A+2] (used reg = )
mov	ax,4[bp]
test	ax,ax
jne 	.11C
.11D:
! 1140     {
! 1141         
! 1142         *(--ptr) = '0';
! Debug: predec * char ptr = [S+$1A-$14] (used reg = )
mov	bx,-$12[bp]
dec	bx
mov	-$12[bp],bx
! Debug: eq int = const $30 to char = [bx+0] (used reg = )
mov	al,*$30
mov	[bx],al
!BCC_EOS
! 1143     }
! 1144 
! 1145     
! 1146     while (x > 0)
.11C:
.11B:
! 1147     {
jmp .11F
.120:
! 1148         
! 1149         q = x/10;
! Debug: div int = const $A to int x = [S+$1A+2] (used reg = )
mov	ax,4[bp]
mov	bx,*$A
cwd
idiv	bx
! Debug: eq int = ax+0 to int q = [S+$1A-$16] (used reg = )
mov	-$14[bp],ax
!BCC_EOS
! 1150         r = x - q*10;
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
! 1151         
! 1152         *(--ptr) = r + '0';
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
! 1153         x = q;
! Debug: eq int q = [S+$1A-$16] to int x = [S+$1A+2] (used reg = )
mov	ax,-$14[bp]
mov	4[bp],ax
!BCC_EOS
! 1154     }
! 1155 
! 1156     if (sign < 0)
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
! 1157     {
! 1158         
! 1159         *(--ptr) = '-';
! Debug: predec * char ptr = [S+$1A-$14] (used reg = )
mov	bx,-$12[bp]
dec	bx
mov	-$12[bp],bx
! Debug: eq int = const $2D to char = [bx+0] (used reg = )
mov	al,*$2D
mov	[bx],al
!BCC_EOS
! 1160     }
! 1161 
! 1162     
! 1163     return printString(ptr);
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
! 1164 }
! 1165 # 1172
! 1172  
! 1173 int sprintInt(x,dst,n)
! Register BX used in function printInt
! 1174 # 1173 "./src/kernel.c"
! 1173 int x;
export	_sprintInt
_sprintInt:
!BCC_EOS
! 1174 # 1173 "./src/kernel.c"
! 1173 char *dst;
!BCC_EOS
! 1174 # 1173 "./src/kernel.c"
! 1173 int n;
!BCC_EOS
! 1174 {
! 1175     
! 1176     char buf[12];
!BCC_EOS
! 1177     char *ptr = buf+11; 
push	bp
mov	bp,sp
push	di
push	si
add	sp,*-$E
! Debug: eq [$C] char buf = S+$14-7 to * char ptr = [S+$14-$14] (used reg = )
lea	bx,-5[bp]
mov	-$12[bp],bx
!BCC_EOS
! 1178     int q, r; 
!BCC_EOS
! 1179     int sign = 1; 
add	sp,*-6
! Debug: eq int = const 1 to int sign = [S+$1A-$1A] (used reg = )
mov	ax,*1
mov	-$18[bp],ax
!BCC_EOS
! 1180 
! 1181     
! 1182     *ptr = 0;
mov	bx,-$12[bp]
! Debug: eq int = const 0 to char = [bx+0] (used reg = )
xor	al,al
mov	[bx],al
!BCC_EOS
! 1183     
! 1184     if (x < 0)
! Debug: lt int = const 0 to int x = [S+$1A+2] (used reg = )
mov	ax,4[bp]
test	ax,ax
jge 	.124
.125:
! 1185     {
! 1186         
! 1187         sign = -1;
! Debug: eq int = const -1 to int sign = [S+$1A-$1A] (used reg = )
mov	ax,*-1
mov	-$18[bp],ax
!BCC_EOS
! 1188         x = -x;
! Debug: neg int x = [S+$1A+2] (used reg = )
xor	ax,ax
sub	ax,4[bp]
! Debug: eq int = ax+0 to int x = [S+$1A+2] (used reg = )
mov	4[bp],ax
!BCC_EOS
! 1189     }
! 1190     else if (x == 0)
jmp .126
.124:
! Debug: logeq int = const 0 to int x = [S+$1A+2] (used reg = )
mov	ax,4[bp]
test	ax,ax
jne 	.127
.128:
! 1191     {
! 1192         
! 1193         *(--ptr) = '0';
! Debug: predec * char ptr = [S+$1A-$14] (used reg = )
mov	bx,-$12[bp]
dec	bx
mov	-$12[bp],bx
! Debug: eq int = const $30 to char = [bx+0] (used reg = )
mov	al,*$30
mov	[bx],al
!BCC_EOS
! 1194     }
! 1195 
! 1196     
! 1197     while (x > 0)
.127:
.126:
! 1198     {
jmp .12A
.12B:
! 1199         
! 1200         q = x/10;
! Debug: div int = const $A to int x = [S+$1A+2] (used reg = )
mov	ax,4[bp]
mov	bx,*$A
cwd
idiv	bx
! Debug: eq int = ax+0 to int q = [S+$1A-$16] (used reg = )
mov	-$14[bp],ax
!BCC_EOS
! 1201         r = x - q*10;
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
! 1202         
! 1203         *(--ptr) = r + '0';
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
! 1204         x = q;
! Debug: eq int q = [S+$1A-$16] to int x = [S+$1A+2] (used reg = )
mov	ax,-$14[bp]
mov	4[bp],ax
!BCC_EOS
! 1205     }
! 1206 
! 1207     if (sign < 0)
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
! 1208     {
! 1209         
! 1210         *(--ptr) = '-';
! Debug: predec * char ptr = [S+$1A-$14] (used reg = )
mov	bx,-$12[bp]
dec	bx
mov	-$12[bp],bx
! Debug: eq int = const $2D to char = [bx+0] (used reg = )
mov	al,*$2D
mov	[bx],al
!BCC_EOS
! 1211     }
! 1212 
! 1213     strcpyn(dst,n,ptr);
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
! 1214     r = (buf+11) - ptr;
! Debug: ptrsub * char ptr = [S+$1A-$14] to [$C] char buf = S+$1A-7 (used reg = )
mov	ax,bp
add	ax,*-5
sub	ax,-$12[bp]
! Debug: eq int = ax+0 to int r = [S+$1A-$18] (used reg = )
mov	-$16[bp],ax
!BCC_EOS
! 1215 
! 1216     return  n-1 < r ? n-1 : r;
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
! 1217 }
! 1218 # 1226
! 1226  
! 1227 int readSector(buf,sector)
! Register BX used in function sprintInt
! 1228 # 1227 "./src/kernel.c"
! 1227 char *buf;
export	_readSector
_readSector:
!BCC_EOS
! 1228 # 1227 "./src/kernel.c"
! 1227 int se
! 1227 ctor;
!BCC_EOS
! 1228 {
! 1229     int q         = sector/18;
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
! 1230     int relsector = sector - q*18 + 1;
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
! 1231     int head      = q & 1;
dec	sp
dec	sp
! Debug: and int = const 1 to int q = [S+$C-8] (used reg = )
mov	al,-6[bp]
and	al,*1
! Debug: eq char = al+0 to int head = [S+$C-$C] (used reg = )
xor	ah,ah
mov	-$A[bp],ax
!BCC_EOS
! 1232     int track     = sector/36;
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
! 1233 
! 1234     interrupt(0x13,((0x02)<< 8)| ((0x01)&  0xff),(int)buf,((track)<< 8)| ((relsector)&  0xff),((head)<< 8)| ((0x00)&  0xff));
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
! 1235 
! 1236     return 1;
mov	ax,*1
add	sp,*8
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 1237 }
! 1238 # 1244
! 1244  
! 1245 int strcmp(a,b)
! Register BX used in function readSector
! 1246 # 1245 "./src/kernel.c"
! 1245 char *a;
export	_strcmp
_strcmp:
!BCC_EOS
! 1246 # 1245 "./src/kernel.c"
! 1245 char *b;
!BCC_EOS
! 1246 # 1245 "./src/kernel.c"
! 1245 {
! 1246     
! 1247     while (*a && *b) {
push	bp
mov	bp,sp
push	di
push	si
jmp .133
.134:
! 1248         if (*(a++)!= *(b++))
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
! 1249             return 0; 
xor	ax,ax
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 1250     }
.135:
! 1251     return *a == *b; 
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
! 1252 }
! 1253 # 1266
! 1266  
! 1267 int bstrcmpn(str,buf,n)
! Register BX SI used in function strcmp
! 1268 # 1267 "./src/kernel.c"
! 1267 char *str;
export	_bstrcmpn
_bstrcmpn:
!BCC_EOS
! 1268 # 1267 "./src/kernel.c"
! 1267 char *buf;
!BCC_EOS
! 1268 # 1267 "./src/kernel.c"
! 1267 int n;
!BCC_EOS
! 1268 {
! 1269     
! 1270     while (n-- && *buf && *str) {
push	bp
mov	bp,sp
push	di
push	si
jmp .13C
.13D:
! 1271         if (*(buf++)!= *(str++))
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
! 1272             return 0; 
xor	ax,ax
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 1273     }
.13E:
! 1274     
! 1275     if (n < 0)
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
! 1276     {
! 1277         
! 1278         return *str == 0;
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
! 1279     }
! 1280 
! 1281     
! 1282     return *buf == *str;
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
! 1283 }
! 1284 # 1288
! 1288  
! 1289 void putChar(c,color,row,col)
! Register BX SI used in function bstrcmpn
! 1290 # 1289 "./src/kernel.c"
! 1289 char c;
export	_putChar
_putChar:
!BCC_EOS
! 1290 # 1289 "./src/kernel.c"
! 1289 char color;
!BCC_EOS
! 1290 # 1289 "./src/kernel.c"
! 1289 int row;
!BCC_EOS
! 1290 # 1289 "./src/kernel.c"
! 1289 int col;
!BCC_EOS
! 1290 {
! 1291     int offset = ((row * 80 + col)<< 1);
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
! 1292     putInMemory(VMEM_HIGH,0x8000 +offset,c) ;
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
! 1293     putInMemory(VMEM_HIGH,0x8000 +offset+1,color) ;
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
! 1294 }
inc	sp
inc	sp
pop	si
pop	di
pop	bp
ret
! 1295 # 1300
! 1300  
! 1301 void putStr(str,maxlen,color,row,col)
! 1302 # 1301 "./src/kernel.c"
! 1301 char *str;
export	_putStr
_putStr:
!BCC_EOS
! 1302 # 1301 "./src/kernel.c"
! 1301 int maxlen;
!BCC_EOS
! 1302 # 1301 "./src/kernel.c"
! 1301 char color;
!BCC_EOS
! 1302 # 1301 "./src/kernel.c"
! 1301 int row;
!BCC_EOS
! 1302 # 1301 "./src/kernel.c"
! 1301 int col;
!BCC_EOS
! 1302 {
! 1303     int i = 0;
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
! 1304     while(*str && i < maxlen)
! 1305     {
jmp .14A
.14B:
! 1306         if (*str == '\n')
mov	bx,4[bp]
! Debug: logeq int = const $A to char = [bx+0] (used reg = )
mov	al,[bx]
cmp	al,*$A
jne 	.14C
.14D:
! 1307         {
! 1308             row += 1;
! Debug: addab int = const 1 to int row = [S+8+8] (used reg = )
mov	ax,$A[bp]
inc	ax
mov	$A[bp],ax
!BCC_EOS
! 1309             col = 0;
! Debug: eq int = const 0 to int col = [S+8+$A] (used reg = )
xor	ax,ax
mov	$C[bp],ax
!BCC_EOS
! 1310         }
! 1311         else if (*str == '\r')
jmp .14E
.14C:
mov	bx,4[bp]
! Debug: logeq int = const $D to char = [bx+0] (used reg = )
mov	al,[bx]
cmp	al,*$D
jne 	.14F
.150:
! 1312         {
! 1313             col = 0;
! Debug: eq int = const 0 to int col = [S+8+$A] (used reg = )
xor	ax,ax
mov	$C[bp],ax
!BCC_EOS
! 1314         }
! 1315         else 
! 1316         {
jmp .151
.14F:
! 1317             putChar(*str,color,row,col);
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
! 1318             if ((++col)>= 80 )
! Debug: preinc int col = [S+8+$A] (used reg = )
mov	ax,$C[bp]
inc	ax
mov	$C[bp],ax
! Debug: ge int = const $50 to int = ax+0 (used reg = )
cmp	ax,*$50
jl  	.152
.153:
! 1319             {
! 1320                 ++row;
! Debug: preinc int row = [S+8+8] (used reg = )
mov	ax,$A[bp]
inc	ax
mov	$A[bp],ax
!BCC_EOS
! 1321                 col = 0;
! Debug: eq int = const 0 to int col = [S+8+$A] (used reg = )
xor	ax,ax
mov	$C[bp],ax
!BCC_EOS
! 1322             }
! 1323         }
.152:
! 1324 
! 1325         ++str;
.151:
.14E:
! Debug: preinc * char str = [S+8+2] (used reg = )
mov	bx,4[bp]
inc	bx
mov	4[bp],bx
!BCC_EOS
! 1326         ++i;
! Debug: preinc int i = [S+8-8] (used reg = )
mov	ax,-6[bp]
inc	ax
mov	-6[bp],ax
!BCC_EOS
! 1327     }
! 1328 }
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
! 1329 
! 1330 
! 1331 
! 1332 int strlen(str)
! Register BX used in function putStr
! 1333 # 1332 "./src/kernel.c"
! 1332 char *str;
export	_strlen
_strlen:
!BCC_EOS
! 1333 {
! 1334     int n = 0;
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
! 1335     if (!str) return n;
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
! 1336 
! 1337     while (*str++) n++;
.156:
jmp .159
.15A:
! Debug: postinc int n = [S+8-8] (used reg = )
mov	ax,-6[bp]
inc	ax
mov	-6[bp],ax
!BCC_EOS
! 1338     return n;
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
! 1339 }
! 1340 
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
