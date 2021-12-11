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
! 35 struct state_info_t {
! 36     struct sleep_info_t sleep_info;
!BCC_EOS
! 37 };
!BCC_EOS
! 38 
! 39 
! 40 
! 41  
! 42 struct PCB {
! 43 	char name[7];  		
!BCC_EOS
! 44 	int state;		
!BCC_EOS
! 45 	int segment;		
!BCC_EOS
! 46 	int stackPointer;	
!BCC_EOS
! 47         struct state_info_t state_info; 
!BCC_EOS
! 48 	
! 49 
! 50 
! 51 	 
! 52 	struct PCB *next;
!BCC_EOS
! 53 	struct PCB *prev;
!BCC_EOS
! 54 };
!BCC_EOS
! 55 # 62
! 62  
! 63 
! 64   struct PCB *running;		
!BCC_EOS
! 65   struct PCB idleProc;		
!BCC_EOS
! 66   struct PCB *readyHead; 	
!BCC_EOS
! 67   struct PCB *readyTail;	
!BCC_EOS
! 68   struct PCB pcbPool[8];	
!BCC_EOS
! 69 
! 70   int memoryMap[8];		
!BCC_EOS
! 71 				
! 72 				
! 73 				
! 74 				
! 75 # 85
! 85  
! 86 # 97
! 97    
! 98 void initializeProcStructures();
!BCC_EOS
! 99 # 104
! 104  
! 105 int getFreeMemorySegment();
!BCC_EOS
! 106 # 110
! 110  
! 111 void releaseMemorySegment();
!BCC_EOS
! 112 # 117
! 117  
! 118 struct PCB *getFreePCB();
!BCC_EOS
! 119 # 124
! 124  
! 125 void releasePCB();
!BCC_EOS
! 126 
! 127 
! 128 
! 129  
! 130 void addToReady();
!BCC_EOS
! 131 # 135
! 135  
! 136 struct PCB *removeFromReady();
!BCC_EOS
! 137 # 145
! 145  
! 146 struct PCB *removeFromQueue();
!BCC_EOS
! 147 # 6 "./src/kernel.c"
! 6 #define VREG(HIGH,LOW) ((HIGH) << 8) | ((LOW) &  0xff)
! 7 
! 8 #define PUT_CHAR(CHAR) interrupt(0x10, VREG(0x0E, CHAR), 0, 0, 0)
! 9 
! 10 
! 11 
! 12 #define MAX_FILE           13312
! 13 
! 14 #define EXEC_MAGIC_NUM     "420"
! 15 
! 16 #define EXEC_MAGIC_OFFSET  3
! 17 
! 18 #define SEGMENT_INDEX(addr) (((addr >> 12) & 0xf)-2)
! 19 
! 20 #define INDEX_SEGMENT(index) ((index+2) << 12)
! 21 
! 22 
! 23 #define SLEEP_TIME 1
! 24 
! 25 
! 26 int writeSector();
!BCC_EOS
! 27 int readFile();
!BCC_EOS
! 28 int strcmpn();
!BCC_EOS
! 29 int bstrcmpn();
!BCC_EOS
! 30 int strcmp();
!BCC_EOS
! 31 int memcpyn();
!BCC_EOS
! 32 int strcpyn();
!BCC_EOS
! 33 int printStringn();
!BCC_EOS
! 34 int printInt();
!BCC_EOS
! 35 void kStrCopy();
!BCC_EOS
! 36 void update_proc_sleep();
!BCC_EOS
! 37 
! 38 
! 39 void terminate();
!BCC_EOS
! 40 int writeFile();
!BCC_EOS
! 41 int deleteFile();
!BCC_EOS
! 42 int executeProgram();
!BCC_EOS
! 43 int printString();
!BCC_EOS
! 44 int readString();
!BCC_EOS
! 45 int readSector();
!BCC_EOS
! 46 int handleInterrupt21();
!BCC_EOS
! 47 int handleTimerInterrupt();
!BCC_EOS
! 48 void showProcesses();
!BCC_EOS
! 49 void yield();
!BCC_EOS
! 50 int kill();
!BCC_EOS
! 51 int sleep();
!BCC_EOS
! 52 
! 53 
! 54 extern int loadWordKernel();
!BCC_EOS
! 55 extern int loadCharKernel();
!BCC_EOS
! 56 extern void setKernelDataSegment();
!BCC_EOS
! 57 extern void restoreDataSegment();
!BCC_EOS
! 58 extern void makeInterrupt21();
!BCC_EOS
! 59 extern void makeTimerInterrupt();
!BCC_EOS
! 60 extern void returnFromTimer();
!BCC_EOS
! 61 extern void resetSegments();
!BCC_EOS
! 62 extern void launchProgram();
!BCC_EOS
! 63 extern void putInMemory();
!BCC_EOS
! 64 extern int interrupt();
!BCC_EOS
! 65 
! 66 int main()
! 67 {
export	_main
_main:
! 68     
! 69     
! 70     
! 71     
! 72     makeInterrupt21(
push	bp
mov	bp,sp
push	di
push	si
! 72 ); 
! Debug: func () void = makeInterrupt21+0 (used reg = )
call	_makeInterrupt21
!BCC_EOS
! 73     
! 74     makeTimerInterrupt();
! Debug: func () void = makeTimerInterrupt+0 (used reg = )
call	_makeTimerInterrupt
!BCC_EOS
! 75 
! 76     initializeProcStructures();
! Debug: func () void = initializeProcStructures+0 (used reg = )
call	_initializeProcStructures
!BCC_EOS
! 77 
! 78     
! 79     
! 80     
! 81     
! 82     
! 83     printString("running shell form main\r\n");
! Debug: list * char = .1+0 (used reg = )
mov	bx,#.1
push	bx
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 84     executeProgram("shell");
! Debug: list * char = .2+0 (used reg = )
mov	bx,#.2
push	bx
! Debug: func () int = executeProgram+0 (used reg = )
call	_executeProgram
inc	sp
inc	sp
!BCC_EOS
! 85 
! 86     while(1) {};
.5:
.4:
jmp	.5
.6:
.3:
!BCC_EOS
! 87 }
pop	si
pop	di
pop	bp
ret
! 88 
! 89 
! 90 int kill(segment)
! Register BX used in function main
! 91 # 90 "./src/kernel.c"
! 90 int segment;
export	_kill
_kill:
!BCC_EOS
! 91 {
! 92 
! 93     struct PCB *pcb;
!BCC_EOS
! 94     int ret = -1;
push	bp
mov	bp,sp
push	di
push	si
add	sp,*-4
! Debug: eq int = const -1 to int ret = [S+$A-$A] (used reg = )
mov	ax,*-1
mov	-8[bp],ax
!BCC_EOS
! 95     setKernelDataSegment();
! Debug: func () void = setKernelDataSegment+0 (used reg = )
call	_setKernelDataSegment
!BCC_EOS
! 96 
! 97     if (segment < 0 || segment > 7)
! Debug: lt int = const 0 to int segment = [S+$A+2] (used reg = )
mov	ax,4[bp]
test	ax,ax
jl  	.8
.9:
! Debug: gt int = const 7 to int segment = [S+$A+2] (used reg = )
mov	ax,4[bp]
cmp	ax,*7
jle 	.7
.8:
! 98     {
! 99         printString("error: no process with segment index ");
! Debug: list * char = .A+0 (used reg = )
mov	bx,#.A
push	bx
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 100         printInt(segment);
! Debug: list int segment = [S+$A+2] (used reg = )
push	4[bp]
! Debug: func () int = printInt+0 (used reg = )
call	_printInt
inc	sp
inc	sp
!BCC_EOS
! 101         printString("\n\r");
! Debug: list * char = .B+0 (used reg = )
mov	bx,#.B
push	bx
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 102         return -1;
mov	ax,*-1
add	sp,*4
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 103     }
! 104 
! 105 
! 106     
! 107     pcb = pcbPool;
.7:
! Debug: eq [8] struct PCB = pcbPool+0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,#_pcbPool
mov	-6[bp],bx
!BCC_EOS
! 108     for (pcb = pcbPool; pcb < pcbPool+8; ++pcb)
! Debug: eq [8] struct PCB = pcbPool+0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,#_pcbPool
mov	-6[bp],bx
!BCC_EOS
!BCC_EOS
! 109     {
jmp .E
.F:
! 110         if (pcb->state == DEFUNCT) continue;
mov	bx,-6[bp]
! Debug: logeq int = const 0 to int = [bx+8] (used reg = )
mov	ax,8[bx]
test	ax,ax
jne 	.10
.11:
jmp .D
!BCC_EOS
! 111         if (SEGMENT_INDEX(pcb->segment)== segment)
.10:
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
! Debug: logeq int segment = [S+$A+2] to int = ax-2 (used reg = )
dec	ax
dec	ax
cmp	ax,4[bp]
jne 	.12
.13:
! 112         {
! 113             ret = 1;
! Debug: eq int = const 1 to int ret = [S+$A-$A] (used reg = )
mov	ax,*1
mov	-8[bp],ax
!BCC_EOS
! 114             break;
jmp .C
!BCC_EOS
! 115         }
! 116     }
.12:
! 117 
! 118     if (ret == -1)
.D:
! Debug: preinc * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,-6[bp]
add	bx,*$16
mov	-6[bp],bx
.E:
! Debug: lt * struct PCB = pcbPool+$B0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,#_pcbPool+$B0
cmp	bx,-6[bp]
ja 	.F
.14:
.C:
! Debug: logeq int = const -1 to int ret = [S+$A-$A] (used reg = )
mov	ax,-8[bp]
cmp	ax,*-1
jne 	.15
.16:
! 119     {
! 120         printString("error: no process with segment index ");
! Debug: list * char = .17+0 (used reg = )
mov	bx,#.17
push	bx
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 121         printInt(segment);
! Debug: list int segment = [S+$A+2] (used reg = )
push	4[bp]
! Debug: func () int = printInt+0 (used reg = )
call	_printInt
inc	sp
inc	sp
!BCC_EOS
! 122         printString("\n\r");
! Debug: list * char = .18+0 (used reg = )
mov	bx,#.18
push	bx
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 123         return -1;
mov	ax,*-1
add	sp,*4
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 124     }
! 125 
! 126     
! 127     removeFromQueue(pcb);
.15:
! Debug: list * struct PCB pcb = [S+$A-8] (used reg = )
push	-6[bp]
! Debug: func () * struct PCB = removeFromQueue+0 (used reg = )
call	_removeFromQueue
inc	sp
inc	sp
!BCC_EOS
! 128     releaseMemorySegment(SEGMENT_INDEX(pcb->segment));
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
! Debug: func () void = releaseMemorySegment+0 (used reg = )
call	_releaseMemorySegment
inc	sp
inc	sp
!BCC_EOS
! 129 
! 130     
! 131     printString("killed ");
! Debug: list * char = .19+0 (used reg = )
mov	bx,#.19
push	bx
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 132     printString(pcb->name);
! Debug: cast * char = const 0 to [7] char pcb = [S+$A-8] (used reg = )
! Debug: list * char pcb = [S+$A-8] (used reg = )
push	-6[bp]
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 133     printString("\n\r");
! Debug: list * char = .1A+0 (used reg = )
mov	bx,#.1A
push	bx
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 134 
! 135     
! 136     releasePCB(pcb);
! Debug: list * struct PCB pcb = [S+$A-8] (used reg = )
push	-6[bp]
! Debug: func () void = releasePCB+0 (used reg = )
call	_releasePCB
inc	sp
inc	sp
!BCC_EOS
! 137 
! 138     
! 139     if (running == pcb) {
! Debug: logeq * struct PCB pcb = [S+$A-8] to * struct PCB = [running+0] (used reg = )
mov	bx,[_running]
cmp	bx,-6[bp]
jne 	.1B
.1C:
! 140         yield();
! Debug: func () void = yield+0 (used reg = )
call	_yield
!BCC_EOS
! 141     }
! 142     restoreDataSegment();
.1B:
! Debug: func () void = restoreDataSegment+0 (used reg = )
call	_restoreDataSegment
!BCC_EOS
! 143 
! 144     return ret;
mov	ax,-8[bp]
add	sp,*4
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 145 }
! 146 
! 147 
! 148 int sleep(time)
! Register BX used in function kill
! 149 # 148 "./src/kernel.c"
! 148 int time;
export	_sleep
_sleep:
!BCC_EOS
! 149 {
! 150     struct state_info_t  *state_info;
!BCC_EOS
! 151     struct sleep_info_t *sleep_info;
!BCC_EOS
! 152 
! 153     if (running == 0x00 ) 
push	bp
mov	bp,sp
push	di
push	si
add	sp,*-4
! Debug: logeq int = const 0 to * struct PCB = [running+0] (used reg = )
mov	ax,[_running]
test	ax,ax
jne 	.1D
.1E:
! 154         return 0; 
xor	ax,ax
add	sp,*4
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 155 
! 156     
! 157     state_info = &(running->state_info);
.1D:
mov	bx,[_running]
! Debug: address struct state_info_t = [bx+$E] (used reg = )
! Debug: eq * struct state_info_t = bx+$E to * struct state_info_t state_info = [S+$A-8] (used reg = )
add	bx,*$E
mov	-6[bp],bx
!BCC_EOS
! 158     sleep_info = &(state_info->sleep_info);
mov	bx,-6[bp]
! Debug: address struct sleep_info_t = [bx+0] (used reg = )
! Debug: eq * struct sleep_info_t = bx+0 to * struct sleep_info_t sleep_info = [S+$A-$A] (used reg = )
mov	-8[bp],bx
!BCC_EOS
! 159 
! 160     sleep_info->full    = time*12;
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
! 161     sleep_info->current = 0;
mov	bx,-8[bp]
! Debug: eq int = const 0 to int = [bx+2] (used reg = )
xor	ax,ax
mov	2[bx],ax
!BCC_EOS
! 162 
! 163     
! 164     
! 165     
! 166     running->state = 5 ;
mov	bx,[_running]
! Debug: eq int = const 5 to int = [bx+8] (used reg = )
mov	ax,*5
mov	8[bx],ax
!BCC_EOS
! 167     yield();
! Debug: func () void = yield+0 (used reg = )
call	_yield
!BCC_EOS
! 168 
! 169     return 1;
mov	ax,*1
add	sp,*4
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 170 }
! 171 
! 172 void update_proc_sleep()
! Register BX used in function sleep
! 173 {
export	_update_proc_sleep
_update_proc_sleep:
! 174     struct PCB *pcb;
!BCC_EOS
! 175     struct sleep_info_t *sleep_info;
!BCC_EOS
! 176 
! 177     
! 178     pcb = pcbPool;
push	bp
mov	bp,sp
push	di
push	si
add	sp,*-4
! Debug: eq [8] struct PCB = pcbPool+0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,#_pcbPool
mov	-6[bp],bx
!BCC_EOS
! 179     for (pcb = pcbPool; pcb < pcbPool+8; ++pcb)
! Debug: eq [8] struct PCB = pcbPool+0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,#_pcbPool
mov	-6[bp],bx
!BCC_EOS
!BCC_EOS
! 180     {
jmp .21
.22:
! 181         if (pcb->state != 5 ) continue;
mov	bx,-6[bp]
! Debug: ne int = const 5 to int = [bx+8] (used reg = )
mov	bx,8[bx]
cmp	bx,*5
je  	.23
.24:
jmp .20
!BCC_EOS
! 182         sleep_info = &(pcb->state_info.sleep_info);
.23:
mov	bx,-6[bp]
! Debug: address struct sleep_info_t = [bx+$E] (used reg = )
! Debug: eq * struct sleep_info_t = bx+$E to * struct sleep_info_t sleep_info = [S+$A-$A] (used reg = )
add	bx,*$E
mov	-8[bp],bx
!BCC_EOS
! 183         
! 184         sleep_info->current += SLEEP_TIME;
mov	bx,-8[bp]
! Debug: addab int = const 1 to int = [bx+2] (used reg = )
mov	ax,2[bx]
inc	ax
mov	2[bx],ax
!BCC_EOS
! 185         
! 186         if (sleep_info->current >= sleep_info->full)
mov	bx,-8[bp]
mov	si,-8[bp]
! Debug: ge int = [bx+0] to int = [si+2] (used reg = )
mov	si,2[si]
cmp	si,[bx]
jl  	.25
.26:
! 187         {
! 188             
! 189             pcb->state = 2 ;
mov	bx,-6[bp]
! Debug: eq int = const 2 to int = [bx+8] (used reg = )
mov	ax,*2
mov	8[bx],ax
!BCC_EOS
! 190          
! 190    addToReady(pcb);
! Debug: list * struct PCB pcb = [S+$A-8] (used reg = )
push	-6[bp]
! Debug: func () void = addToReady+0 (used reg = )
call	_addToReady
inc	sp
inc	sp
!BCC_EOS
! 191         }
! 192     }
.25:
! 193 }
.20:
! Debug: preinc * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,-6[bp]
add	bx,*$16
mov	-6[bp],bx
.21:
! Debug: lt * struct PCB = pcbPool+$B0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,#_pcbPool+$B0
cmp	bx,-6[bp]
ja 	.22
.27:
.1F:
add	sp,*4
pop	si
pop	di
pop	bp
ret
! 194 
! 195 
! 196 int handleTimerInterrupt(ds,ss)
! Register BX SI used in function update_proc_sleep
! 197 # 196 "./src/kernel.c"
! 196 int ds;
export	_handleTimerInterrupt
_handleTimerInterrupt:
!BCC_EOS
! 197 # 196 "./src/kernel.c"
! 196 int ss;
!BCC_EOS
! 197 {
! 198     struct PCB *pcb;
!BCC_EOS
! 199     int add_to_queue = 0;
push	bp
mov	bp,sp
push	di
push	si
add	sp,*-4
! Debug: eq int = const 0 to int add_to_queue = [S+$A-$A] (used reg = )
xor	ax,ax
mov	-8[bp],ax
!BCC_EOS
! 200 
! 201     update_proc_sleep();
! Debug: func () void = update_proc_sleep+0 (used reg = )
call	_update_proc_sleep
!BCC_EOS
! 202 
! 203     if (running->state != DEFUNCT)
mov	bx,[_running]
! Debug: ne int = const 0 to int = [bx+8] (used reg = )
mov	ax,8[bx]
test	ax,ax
je  	.28
.29:
! 204     {
! 205         running->segment = ds;
mov	bx,[_running]
! Debug: eq int ds = [S+$A+2] to int = [bx+$A] (used reg = )
mov	ax,4[bp]
mov	$A[bx],ax
!BCC_EOS
! 206         running->stackPointer = ss;
mov	bx,[_running]
! Debug: eq int ss = [S+$A+4] to int = [bx+$C] (used reg = )
mov	ax,6[bp]
mov	$C[bx],ax
!BCC_EOS
! 207         add_to_queue = (running->state != 5  && running->state != 3 );
mov	bx,[_running]
! Debug: ne int = const 5 to int = [bx+8] (used reg = )
mov	bx,8[bx]
cmp	bx,*5
je  	.2A
.2C:
mov	bx,[_running]
! Debug: ne int = const 3 to int = [bx+8] (used reg = )
mov	bx,8[bx]
cmp	bx,*3
je  	.2A
.2B:
mov	al,*1
jmp	.2D
.2A:
xor	al,al
.2D:
! Debug: eq char = al+0 to int add_to_queue = [S+$A-$A] (used reg = )
xor	ah,ah
mov	-8[bp],ax
!BCC_EOS
! 208 
! 209         if (add_to_queue)
mov	ax,-8[bp]
test	ax,ax
je  	.2E
.2F:
! 210             running->state = 2 ;
mov	bx,[_running]
! Debug: eq int = const 2 to int = [bx+8] (used reg = )
mov	ax,*2
mov	8[bx],ax
!BCC_EOS
! 211 
! 212         
! 213         if (add_to_queue && !strcmp(running->name,"IDLE"))
.2E:
mov	ax,-8[bp]
test	ax,ax
je  	.30
.33:
! Debug: list * char = .31+0 (used reg = )
mov	bx,#.31
push	bx
! Debug: cast * char = const 0 to [7] char = [running+0] (used reg = )
! Debug: list * char = [running+0] (used reg = )
push	[_running]
! Debug: func () int = strcmp+0 (used reg = )
call	_strcmp
add	sp,*4
test	ax,ax
jne 	.30
.32:
! 214             addToReady(running);
! Debug: list * struct PCB = [running+0] (used reg = )
push	[_running]
! Debug: func () void = addToReady+0 (used reg = )
call	_addToReady
inc	sp
inc	sp
!BCC_EOS
! 215     }
.30:
! 216 
! 217     pcb = removeFromReady();
.28:
! Debug: func () * struct PCB = removeFromReady+0 (used reg = )
call	_removeFromReady
! Debug: eq * struct PCB = ax+0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	-6[bp],ax
!BCC_EOS
! 218 
! 219     if (pcb == 0x00 )
! Debug: logeq int = const 0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	ax,-6[bp]
test	ax,ax
jne 	.34
.35:
! 220     {
! 221         pcb = &idleProc;
! Debug: eq * struct PCB = idleProc+0 to * struct PCB pcb = [S+$A-8] (used reg = )
mov	bx,#_idleProc
mov	-6[bp],bx
!BCC_EOS
! 222     }
! 223 
! 224     pcb->state = 1 ;
.34:
mov	bx,-6[bp]
! Debug: eq int = const 1 to int = [bx+8] (used reg = )
mov	ax,*1
mov	8[bx],ax
!BCC_EOS
! 225     running = pcb;
! Debug: eq * struct PCB pcb = [S+$A-8] to * struct PCB = [running+0] (used reg = )
mov	bx,-6[bp]
mov	[_running],bx
!BCC_EOS
! 226     returnFromTimer(pcb->segment,pcb->stackPointer);
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
! 227 
! 228     return 0;
xor	ax,ax
add	sp,*4
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 229 }
! 230 
! 231 void showProcesses()
! Register BX used in function handleTimerInterrupt
! 232 {
export	_showProcesses
_showProcesses:
! 233     struct PCB *pcb;
!BCC_EOS
! 234     setKernelDataSegment();
push	bp
mov	bp,sp
push	di
push	si
dec	sp
dec	sp
! Debug: func () void = setKernelDataSegment+0 (used reg = )
call	_setKernelDataSegment
!BCC_EOS
! 235 
! 236     
! 237     pcb = pcbPool;
! Debug: eq [8] struct PCB = pcbPool+0 to * struct PCB pcb = [S+8-8] (used reg = )
mov	bx,#_pcbPool
mov	-6[bp],bx
!BCC_EOS
! 238     for (pcb = pcbPool; pcb < pcbPool+8; ++pcb)
! Debug: eq [8] struct PCB = pcbPool+0 to * struct PCB pcb = [S+8-8] (used reg = )
mov	bx,#_pcbPool
mov	-6[bp],bx
!BCC_EOS
!BCC_EOS
! 239     {
jmp .38
.39:
! 240         if (pcb->state == DEFUNCT) continue;
mov	bx,-6[bp]
! Debug: logeq int = const 0 to int = [bx+8] (used reg = )
mov	ax,8[bx]
test	ax,ax
jne 	.3A
.3B:
jmp .37
!BCC_EOS
! 241         printString(pcb->name);
.3A:
! Debug: cast * char = const 0 to [7] char pcb = [S+8-8] (used reg = )
! Debug: list * char pcb = [S+8-8] (used reg = )
push	-6[bp]
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 242         printString("  ");
! Debug: list * char = .3C+0 (used reg = )
mov	bx,#.3C
push	bx
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 243         printInt(SEGMENT_INDEX(pcb->segment));
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
! Debug: func () int = printInt+0 (used reg = )
call	_printInt
inc	sp
inc	sp
!BCC_EOS
! 244         printString("\n\r");
! Debug: list * char = .3D+0 (used reg = )
mov	bx,#.3D
push	bx
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
!BCC_EOS
! 245     }
! 246     restoreDataSegment();
.37:
! Debug: preinc * struct PCB pcb = [S+8-8] (used reg = )
mov	bx,-6[bp]
add	bx,*$16
mov	-6[bp],bx
.38:
! Debug: lt * struct PCB = pcbPool+$B0 to * struct PCB pcb = [S+8-8] (used reg = )
mov	bx,#_pcbPool+$B0
cmp	bx,-6[bp]
ja 	.39
.3E:
.36:
! Debug: func () void = restoreDataSegment+0 (used reg = )
call	_restoreDataSegment
!BCC_EOS
! 247 }
inc	sp
inc	sp
pop	si
pop	di
pop	bp
ret
! 248 # 256
! 256   
! 257 void kStrCopy(src,dest,len)
! Register BX used in function showProcesses
! 258 # 257 "./src/kernel.c"
! 257 char *src;
export	_kStrCopy
_kStrCopy:
!BCC_EOS
! 258 # 257 "./src/kernel.c"
! 257 char *dest;
!BCC_EOS
! 258 # 257 "./src/kernel.c"
! 257 int len;
!BCC_EOS
! 258 # 257 "./src/kernel.c"
! 257 { 
! 258    int i=0; 
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
! 259    for (i=0; i < len; i++) { 
! Debug: eq int = const 0 to int i = [S+8-8] (used reg = )
xor	ax,ax
mov	-6[bp],ax
!BCC_EOS
!BCC_EOS
jmp .41
.42:
! 260         putInMemory(0x1000,dest+i,src[i]); 
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
! 261         if (src[i] == 0x00) { 
! Debug: ptradd int i = [S+8-8] to * char src = [S+8+2] (used reg = )
mov	ax,-6[bp]
add	ax,4[bp]
mov	bx,ax
! Debug: logeq int = const 0 to char = [bx+0] (used reg = )
mov	al,[bx]
test	al,al
jne 	.43
.44:
! 262             return; 
inc	sp
inc	sp
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 263         } 
! 264    } 
.43:
! 265 }
.40:
! Debug: postinc int i = [S+8-8] (used reg = )
mov	ax,-6[bp]
inc	ax
mov	-6[bp],ax
.41:
! Debug: lt int len = [S+8+6] to int i = [S+8-8] (used reg = )
mov	ax,-6[bp]
cmp	ax,8[bp]
jl 	.42
.45:
.3F:
inc	sp
inc	sp
pop	si
pop	di
pop	bp
ret
! 266 # 270
! 270  
! 271 void terminate()
! Register BX used in function kStrCopy
! 272 {
export	_terminate
_terminate:
! 273     setKernelDataSegment();
push	bp
mov	bp,sp
push	di
push	si
! Debug: func () void = setKernelDataSegment+0 (used reg = )
call	_setKernelDataSegment
!BCC_EOS
! 274     
! 275     releaseMemorySegment(SEGMENT_INDEX(running->segment));
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
! Debug: list int = ax-2 (used reg = )
dec	ax
dec	ax
push	ax
! Debug: func () void = releaseMemorySegment+0 (used reg = )
call	_releaseMemorySegment
inc	sp
inc	sp
!BCC_EOS
! 276     
! 277     releasePCB(running);
! Debug: list * struct PCB = [running+0] (used reg = )
push	[_running]
! Debug: func () void = releasePCB+0 (used reg = )
call	_releasePCB
inc	sp
inc	sp
!BCC_EOS
! 278     restoreDataSegment();
! Debug: func () void = restoreDataSegment+0 (used reg = )
call	_restoreDataSegment
!BCC_EOS
! 279 
! 280     
! 281     while (1){}
.48:
! 282 }
.47:
jmp	.48
.49:
.46:
pop	si
pop	di
pop	bp
ret
! 283 # 289
! 289  
! 290 int executeProgram(name)
! Register BX used in function terminate
! 291 # 290 "./src/kernel.c"
! 290 char *name;
export	_executeProgram
_executeProgram:
!BCC_EOS
! 291 {
! 292     char buffer[MAX_FILE];   
!BCC_EOS
! 293     char magic_num[EXEC_MAGIC_OFFSET+1];
!BCC_EOS
! 294     int k = 0, i = 0;
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
! 295     int ret = 0;
dec	sp
dec	sp
! Debug: eq int = const 0 to int ret = [S+$3410-$3410] (used reg = )
xor	ax,ax
mov	-$340E[bp],ax
!BCC_EOS
! 296     int segment;
!BCC_EOS
! 297     struct PCB *pcb;
!BCC_EOS
! 298 
! 299     k = readFile(name,buffer,MAX_FILE);
add	sp,*-4
! Debug: list int = const $3400 (used reg = )
mov	ax,#$3400
push	ax
! Debug: list * char buffer = S+$3416-$3406 (used reg = )
lea	bx,-$3404[bp]
push	bx
! Debug: list * char name = [S+$3418+2] (used reg = )
push	4[bp]
! Debug: func () int = readFile+0 (used reg = )
call	_readFile
add	sp,*6
! Debug: eq int = ax+0 to int k = [S+$3414-$340C] (used reg = )
mov	-$340A[bp],ax
!BCC_EOS
! 300     if (k < 0)
! Debug: lt int = const 0 to int k = [S+$3414-$340C] (used reg = )
mov	ax,-$340A[bp]
test	ax,ax
jge 	.4A
.4B:
! 301         return -1;
mov	ax,*-1
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 302 
! 303     
! 304     for (i = 0; i < EXEC_MAGIC_OFFSET; ++i)
.4A:
! Debug: eq int = const 0 to int i = [S+$3414-$340E] (used reg = )
xor	ax,ax
mov	-$340C[bp],ax
!BCC_EOS
!BCC_EOS
! 305         magic_num[i] = loadCharKernel(EXEC_MAGIC_NUM+i);
jmp .4E
.4F:
! Debug: ptradd int i = [S+$3414-$340E] to [4] char = .50+0 (used reg = )
mov	bx,-$340C[bp]
! Debug: cast * char = const 0 to [4] char = bx+.50+0 (used reg = )
! Debug: list * char = bx+.50+0 (used reg = )
add	bx,#.50
push	bx
! Debug: func () int = loadCharKernel+0 (used reg = )
call	_loadCharKernel
inc	sp
inc	sp
push	ax
! Debug: ptradd int i = [S+$3416-$340E] to [4] char magic_num = S+$3416-$340A (used reg = )
mov	ax,-$340C[bp]
mov	bx,bp
add	bx,ax
! Debug: eq int (temp) = [S+$3416-$3416] to char = [bx-$3408] (used reg = )
mov	ax,-$3414[bp]
mov	-$3408[bx],al
inc	sp
inc	sp
!BCC_EOS
! 306    
! 306  magic_num[i] = 0;
.4D:
! Debug: preinc int i = [S+$3414-$340E] (used reg = )
mov	ax,-$340C[bp]
inc	ax
mov	-$340C[bp],ax
.4E:
! Debug: lt int = const 3 to int i = [S+$3414-$340E] (used reg = )
mov	ax,-$340C[bp]
cmp	ax,*3
jl 	.4F
.51:
.4C:
! Debug: ptradd int i = [S+$3414-$340E] to [4] char magic_num = S+$3414-$340A (used reg = )
mov	ax,-$340C[bp]
mov	bx,bp
add	bx,ax
! Debug: eq int = const 0 to char = [bx-$3408] (used reg = )
xor	al,al
mov	-$3408[bx],al
!BCC_EOS
! 307 
! 308     
! 309     ret = strcmpn(magic_num,buffer,EXEC_MAGIC_OFFSET);
! Debug: list int = const 3 (used reg = )
mov	ax,*3
push	ax
! Debug: list * char buffer = S+$3416-$3406 (used reg = )
lea	bx,-$3404[bp]
push	bx
! Debug: list * char magic_num = S+$3418-$340A (used reg = )
lea	bx,-$3408[bp]
push	bx
! Debug: func () int = strcmpn+0 (used reg = )
call	_strcmpn
add	sp,*6
! Debug: eq int = ax+0 to int ret = [S+$3414-$3410] (used reg = )
mov	-$340E[bp],ax
!BCC_EOS
! 310     if (!ret)
mov	ax,-$340E[bp]
test	ax,ax
jne 	.52
.53:
! 311     {
! 312         return -3;
mov	ax,*-3
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 313     }
! 314 
! 315     
! 316     setKernelDataSegment();
.52:
! Debug: func () void = setKernelDataSegment+0 (used reg = )
call	_setKernelDataSegment
!BCC_EOS
! 317     segment = getFreeMemorySegment();
! Debug: func () int = getFreeMemorySegment+0 (used reg = )
call	_getFreeMemorySegment
! Debug: eq int = ax+0 to int segment = [S+$3414-$3412] (used reg = )
mov	-$3410[bp],ax
!BCC_EOS
! 318     restoreDataSegment();
! Debug: func () void = restoreDataSegment+0 (used reg = )
call	_restoreDataSegment
!BCC_EOS
! 319 
! 320     if (segment == -1 )
! Debug: logeq int = const -1 to int segment = [S+$3414-$3412] (used reg = )
mov	ax,-$3410[bp]
cmp	ax,*-1
jne 	.54
.55:
! 321         return -2;
mov	ax,*-2
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 322 
! 323     
! 324     segment = INDEX_SEGMENT(segment);
.54:
! Debug: add int = const 2 to int segment = [S+$3414-$3412] (used reg = )
mov	ax,-$3410[bp]
! Debug: sl int = const $C to int = ax+2 (used reg = )
inc	ax
inc	ax
mov	ah,al
xor	al,al
mov	cl,*4
shl	ax,cl
! Debug: eq int = ax+0 to int segment = [S+$3414-$3412] (used reg = )
mov	-$3410[bp],ax
!BCC_EOS
! 325 
! 326     k = (k << 9);
! Debug: sl int = const 9 to int k = [S+$3414-$340C] (used reg = )
mov	ax,-$340A[bp]
mov	ah,al
xor	al,al
shl	ax,*1
! Debug: eq int = ax+0 to int k = [S+$3414-$340C] (used reg = )
mov	-$340A[bp],ax
!BCC_EOS
! 327     for (i = EXEC_MAGIC_OFFSET; i < k; ++i)
! Debug: eq int = const 3 to int i = [S+$3414-$340E] (used reg = )
mov	ax,*3
mov	-$340C[bp],ax
!BCC_EOS
!BCC_EOS
! 328     {
jmp .58
.59:
! 329         putInMemory(segment,i-EXEC_MAGIC_OFFSET,*(buffer+i));
! Debug: ptradd int i = [S+$3414-$340E] to [$3400] char buffer = S+$3414-$3406 (used reg = )
mov	ax,-$340C[bp]
mov	bx,bp
add	bx,ax
! Debug: list char = [bx-$3404] (used reg = )
mov	al,-$3404[bx]
xor	ah,ah
push	ax
! Debug: sub int = const 3 to int i = [S+$3416-$340E] (used reg = )
mov	ax,-$340C[bp]
! Debug: list int = ax-3 (used reg = )
add	ax,*-3
push	ax
! Debug: list int segment = [S+$3418-$3412] (used reg = )
push	-$3410[bp]
! Debug: func () void = putInMemory+0 (used reg = )
call	_putInMemory
add	sp,*6
!BCC_EOS
! 330     }
! 331 
! 332     
! 333     setKernelDataSegment();
.57:
! Debug: preinc int i = [S+$3414-$340E] (used reg = )
mov	ax,-$340C[bp]
inc	ax
mov	-$340C[bp],ax
.58:
! Debug: lt int k = [S+$3414-$340C] to int i = [S+$3414-$340E] (used reg = )
mov	ax,-$340C[bp]
cmp	ax,-$340A[bp]
jl 	.59
.5A:
.56:
! Debug: func () void = setKernelDataSegment+0 (used reg = )
call	_setKernelDataSegment
!BCC_EOS
! 334     pcb = getFreePCB();
! Debug: func () * struct PCB = getFreePCB+0 (used reg = )
call	_getFreePCB
! Debug: eq * struct PCB = ax+0 to * struct PCB pcb = [S+$3414-$3414] (used reg = )
mov	-$3412[bp],ax
!BCC_EOS
! 335     restoreDataSegment();
! Debug: func () void = restoreDataSegment+0 (used reg = )
call	_restoreDataSegment
!BCC_EOS
! 336 
! 337     if (pcb == 0x00 )
! Debug: logeq int = const 0 to * struct PCB pcb = [S+$3414-$3414] (used reg = )
mov	ax,-$3412[bp]
test	ax,ax
jne 	.5B
.5C:
! 338         return -4;
mov	ax,*-4
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 339     
! 340     kStrCopy(name,pcb->name,7);
.5B:
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: cast * char = const 0 to [7] char pcb = [S+$3416-$3414] (used reg = )
! Debug: list * char pcb = [S+$3416-$3414] (used reg = )
push	-$3412[bp]
! Debug: list * char name = [S+$3418+2] (used reg = )
push	4[bp]
! Debug: func () void = kStrCopy+0 (used reg = )
call	_kStrCopy
add	sp,*6
!BCC_EOS
! 341 
! 342     setKernelDataSegment();
! Debug: func () void = setKernelDataSegment+0 (used reg = )
call	_setKernelDataSegment
!BCC_EOS
! 343     pcb->state = 4 ;
mov	bx,-$3412[bp]
! Debug: eq int = const 4 to int = [bx+8] (used reg = )
mov	ax,*4
mov	8[bx],ax
!BCC_EOS
! 344     pcb->segment = segment;
mov	bx,-$3412[bp]
! Debug: eq int segment = [S+$3414-$3412] to int = [bx+$A] (used reg = )
mov	ax,-$3410[bp]
mov	$A[bx],ax
!BCC_EOS
! 345     pcb->stackPointer = 0xff00;
mov	bx,-$3412[bp]
! Debug: eq unsigned int = const $FF00 to int = [bx+$C] (used reg = )
mov	ax,#$FF00
mov	$C[bx],ax
!BCC_EOS
! 346     addToReady(pcb);
! Debug: list * struct PCB pcb = [S+$3414-$3414] (used reg = )
push	-$3412[bp]
! Debug: func () void = addToReady+0 (used reg = )
call	_addToReady
inc	sp
inc	sp
!BCC_EOS
! 347     restoreDataSegment();
! Debug: func () void = restoreDataSegment+0 (used reg = )
call	_restoreDataSegment
!BCC_EOS
! 348 
! 349     initializeProgram(segment);
! Debug: list int segment = [S+$3414-$3412] (used reg = )
push	-$3410[bp]
! Debug: func () int = initializeProgram+0 (used reg = )
call	_initializeProgram
inc	sp
inc	sp
!BCC_EOS
! 350 
! 351     return 1;
mov	ax,*1
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 352 }
! 353 
! 354 
! 355 
! 356  
! 357 void yield()
! Register BX used in function executeProgram
! 358 {
export	_yield
_yield:
! 359     
! 360     interrupt(0x08,0,0,0,0);
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
! 361 }
pop	si
pop	di
pop	bp
ret
! 362 # 462
! 462  
! 463 int handleInterrupt21(ax,bx,cx,dx)
! 464 # 463 "./src/kernel.c"
! 463 int ax;
export	_handleInterrupt21
_handleInterrupt21:
!BCC_EOS
! 464 # 463 "./src/kernel.c"
! 463 int bx;
!BCC_EOS
! 464 # 463 "./src/kernel.c"
! 463 int cx;
!BCC_EOS
! 464 # 463 "./src/kernel.c"
! 463 int dx;
!BCC_EOS
! 464 {
! 465     int ret = -1;
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
! 466     int i = 0;
dec	sp
dec	sp
! Debug: eq int = const 0 to int i = [S+$A-$A] (used reg = )
xor	ax,ax
mov	-8[bp],ax
!BCC_EOS
! 467     char buffer[20];
!BCC_EOS
! 468 
! 469     switch(ax)
add	sp,*-$14
mov	ax,4[bp]
! 470     {
br 	.5F
! 471         case 0x00:
! 472             
! 473             ret = printString((char*)bx);
.60:
! Debug: list * char bx = [S+$1E+4] (used reg = )
push	6[bp]
! Debug: func () int = printString+0 (used reg = )
call	_printString
inc	sp
inc	sp
! Debug: eq int = ax+0 to int ret = [S+$1E-8] (used reg = )
mov	-6[bp],ax
!BCC_EOS
! 474             break;
br 	.5D
!BCC_EOS
! 475 
! 476         case 0xa1:
! 477             
! 478             ret = sleep(bx);
.61:
! Debug: list int bx = [S+$1E+4] (used reg = )
push	6[bp]
! Debug: func () int = sleep+0 (used reg = )
call	_sleep
inc	sp
inc	sp
! Debug: eq int = ax+0 to int ret = [S+$1E-8] (used reg = )
mov	-6[bp],ax
!BCC_EOS
! 479             break;
br 	.5D
!BCC_EOS
! 480 
! 481         case 0x0b:
! 482             
! 483             ret = kill(bx);
.62:
! Debug: list int bx = [S+$1E+4] (used reg = )
push	6[bp]
! Debug: func () int = kill+0 (used reg = )
call	_kill
inc	sp
inc	sp
! Debug: eq int = ax+0 to int ret = [S+$1E-8] (used reg = )
mov	-6[bp],ax
!BCC_EOS
! 484             break;
br 	.5D
!BCC_EOS
! 485 
! 486         case 0x0a:
! 487             
! 488             showProcesses();
.63:
! Debug: func () void = showProcesses+0 (used reg = )
call	_showProcesses
!BCC_EOS
! 489             ret = 1;
! Debug: eq int = const 1 to int ret = [S+$1E-8] (used reg = )
mov	ax,*1
mov	-6[bp],ax
!BCC_EOS
! 490             break;
br 	.5D
!BCC_EOS
! 491 
! 492         case 0x09:
! 493             
! 494             yield();
.64:
! Debug: func () void = yield+0 (used reg = )
call	_yield
!BCC_EOS
! 495             ret = 1;
! Debug: eq int = const 1 to int ret = [S+$1E-8] (used reg = )
mov	ax,*1
mov	-6[bp],ax
!BCC_EOS
! 496             break;
br 	.5D
!BCC_EOS
! 497 
! 498         case 0x03:
! 499             
! 500             
! 501             
! 502             for (i = 0; i < 17; ++i)
.65:
! Debug: eq int = const 0 to int i = [S+$1E-$A] (used reg = )
xor	ax,ax
mov	-8[bp],ax
!BCC_EOS
!BCC_EOS
! 503                 buffer[i] = loadCharKernel("__DISK_DIRECTORY"+i);
jmp .68
.69:
! Debug: ptradd int i = [S+$1E-$A] to [$11] char = .6A+0 (used reg = )
mov	bx,-8[bp]
! Debug: cast * char = const 0 to [$11] char = bx+.6A+0 (used reg = )
! Debug: list * char = bx+.6A+0 (used reg = )
add	bx,#.6A
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
mov	ax,0+..FFFF[bp]
mov	-$1C[bx],al
inc	sp
inc	sp
!BCC_EOS
! 504 
! 505             if (strcmp((char*)bx,buffer)) {
.67:
! Debug: preinc int i = [S+$1E-$A] (used reg = )
mov	ax,-8[bp]
inc	ax
mov	-8[bp],ax
.68:
! Debug: lt int = const $11 to int i = [S+$1E-$A] (used reg = )
mov	ax,-8[bp]
cmp	ax,*$11
jl 	.69
.6B:
.66:
! Debug: list * char buffer = S+$1E-$1E (used reg = )
lea	bx,-$1C[bp]
push	bx
! Debug: list * char bx = [S+$20+4] (used reg = )
push	6[bp]
! Debug: func () int = strcmp+0 (used reg = )
call	_strcmp
add	sp,*4
test	ax,ax
je  	.6C
.6D:
! 506                 ret = readSector((char*)cx,2);
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
! 507             } else {
jmp .6E
.6C:
! 508                 ret = readFile((char*)bx,(char*)cx,(int)dx);
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
! 509             }
! 510             break;
.6E:
br 	.5D
!BCC_EOS
! 511 
! 512         case 0x04:
! 513             
! 514             ret = executeProgram((char*)bx);
.6F:
! Debug: list * char bx = [S+$1E+4] (used reg = )
push	6[bp]
! Debug: func () int = executeProgram+0 (used reg = )
call	_executeProgram
inc	sp
inc	sp
! Debug: eq int = ax+0 to int ret = [S+$1E-8] (used reg = )
mov	-6[bp],ax
!BCC_EOS
! 515             break;
br 	.5D
!BCC_EOS
! 516 
! 517         case
! 517  0x05:
! 518             
! 519             terminate(); 
.70:
! Debug: func () void = terminate+0 (used reg = )
call	_terminate
!BCC_EOS
! 520             break;
br 	.5D
!BCC_EOS
! 521 
! 522         case 0x07:
! 523             
! 524             ret = deleteFile((char*)bx);
.71:
! Debug: list * char bx = [S+$1E+4] (used reg = )
push	6[bp]
! Debug: func () int = deleteFile+0 (used reg = )
call	_deleteFile
inc	sp
inc	sp
! Debug: eq int = ax+0 to int ret = [S+$1E-8] (used reg = )
mov	-6[bp],ax
!BCC_EOS
! 525             break;
br 	.5D
!BCC_EOS
! 526 
! 527         case 0x08:
! 528             
! 529             ret = writeFile((char*)bx,(char*)cx,(int)dx);
.72:
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
! 530             break;
jmp .5D
!BCC_EOS
! 531 
! 532         case 0x11:
! 533             
! 534             *((char*)bx) = (char) (interrupt(0x16,0,0,0,0)& 0xFF) ;
.73:
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
! 535             ret = 1;
! Debug: eq int = const 1 to int ret = [S+$1E-8] (used reg = )
mov	ax,*1
mov	-6[bp],ax
!BCC_EOS
! 536             break;
jmp .5D
!BCC_EOS
! 537 
! 538         case 0x01:
! 539             
! 540             ret = readString((char*)bx,cx);
.74:
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
! 541             break;
jmp .5D
!BCC_EOS
! 542     }
! 543 
! 544     return ret;
jmp .5D
.5F:
sub	ax,*0
jl  	.5D
cmp	ax,*$11
ja  	.75
shl	ax,*1
mov	bx,ax
seg	cs
br	.76[bx]
.76:
.word	.60
.word	.74
.word	.5D
.word	.65
.word	.6F
.word	.70
.word	.5D
.word	.71
.word	.72
.word	.64
.word	.63
.word	.62
.word	.5D
.word	.5D
.word	.5D
.word	.5D
.word	.5D
.word	.73
.75:
sub	ax,#$A1
beq 	.61
.5D:
..FFFF	=	-$1E
mov	ax,-6[bp]
add	sp,*$18
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 545 }
! 546 # 552
! 552  
! 553 # 567
! 567  
! 568 int writeFile(fname,buffer,sectors)
! Register BX used in function handleInterrupt21
! 569 # 568 "./src/kernel.c"
! 568 char *fname;
export	_writeFile
_writeFile:
!BCC_EOS
! 569 # 568 "./src/kernel.c"
! 568 char *buffer;
!BCC_EOS
! 569 # 568 "./src/kernel.c"
! 568 int sectors;
!BCC_EOS
! 569 {
! 570     
! 571     char disk_map[512];
!BCC_EOS
! 572     
! 573     char disk_dir[512];
!BCC_EOS
! 574     
! 575     char file_sectors[26];
!BCC_EOS
! 576     
! 577     char *ptr;
!BCC_EOS
! 578     char *mptr;
!BCC_EOS
! 579     
! 580     int   j  = 0;
push	bp
mov	bp,sp
push	di
push	si
add	sp,#-$420
! Debug: eq int = const 0 to int j = [S+$426-$426] (used reg = )
xor	ax,ax
mov	-$424[bp],ax
!BCC_EOS
! 581     
! 582     int byte = 0;
dec	sp
dec	sp
! Debug: eq int = const 0 to int byte = [S+$428-$428] (used reg = )
xor	ax,ax
mov	-$426[bp],ax
!BCC_EOS
! 583     
! 584     int free_entry = -1;
dec	sp
dec	sp
! Debug: eq int = const -1 to int free_entry = [S+$42A-$42A] (used reg = )
mov	ax,*-1
mov	-$428[bp],ax
!BCC_EOS
! 585 
! 586     
! 587     readSector(disk_map,1);
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
! 588     readSector(disk_dir,2);
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
! 589 
! 590     
! 591     sectors = (sectors < 26 ? sectors : 26);
! Debug: lt int = const $1A to int sectors = [S+$42A+6] (used reg = )
mov	ax,8[bp]
cmp	ax,*$1A
jge 	.77
.78:
mov	ax,8[bp]
jmp .79
.77:
mov	ax,*$1A
.79:
! Debug: eq int = ax+0 to int sectors = [S+$42A+6] (used reg = )
mov	8[bp],ax
!BCC_EOS
! 592 
! 593     
! 594     
! 595     
! 596     
! 597 
! 598     
! 599     for(; byte < 512; byte += 32)
!BCC_EOS
!BCC_EOS
! 600     {
jmp .7C
.7D:
! 601         if (free_entry < 0 && !*(disk_dir+byte))
! Debug: lt int = const 0 to int free_entry = [S+$42A-$42A] (used reg = )
mov	ax,-$428[bp]
test	ax,ax
jge 	.7E
.80:
! Debug: ptradd int byte = [S+$42A-$428] to [$200] char disk_dir = S+$42A-$406 (used reg = )
mov	ax,-$426[bp]
mov	bx,bp
add	bx,ax
mov	al,-$404[bx]
test	al,al
jne 	.7E
.7F:
! 602             free_entry = byte;
! Debug: eq int byte = [S+$42A-$428] to int free_entry = [S+$42A-$42A] (used reg = )
mov	ax,-$426[bp]
mov	-$428[bp],ax
!BCC_EOS
! 603         if (bstrcmpn(fname,disk_dir + byte,6))
.7E:
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
je  	.81
.82:
! 604             break;
jmp .7A
!BCC_EOS
! 605     }
.81:
! 606 
! 607     if (byte < 512)
.7B:
! Debug: addab int = const $20 to int byte = [S+$42A-$428] (used reg = )
mov	ax,-$426[bp]
add	ax,*$20
mov	-$426[bp],ax
.7C:
! Debug: lt int = const $200 to int byte = [S+$42A-$428] (used reg = )
mov	ax,-$426[bp]
cmp	ax,#$200
jl 	.7D
.83:
.7A:
! Debug: lt int = const $200 to int byte = [S+$42A-$428] (used reg = )
mov	ax,-$426[bp]
cmp	ax,#$200
bge 	.84
.85:
! 608     {
! 609         
! 610         
! 611         ptr  = disk_dir + byte + 6;;
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
! 612         j = 0;
! Debug: eq int = const 0 to int j = [S+$42A-$426] (used reg = )
xor	ax,ax
mov	-$424[bp],ax
!BCC_EOS
! 613         while (j < sectors && *ptr)
! 614         {
jmp .87
.88:
! 615             
! 616             
! 617             
! 618             
! 619             
! 620             writeSector(buffer + (j++<<9),*(ptr++));
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
! 621         }
! 622 
! 623         if (j == sectors)
.87:
! Debug: lt int sectors = [S+$42A+6] to int j = [S+$42A-$426] (used reg = )
mov	ax,-$424[bp]
cmp	ax,8[bp]
jge 	.89
.8A:
mov	bx,-$420[bp]
mov	al,[bx]
test	al,al
jne	.88
.89:
.86:
! Debug: logeq int sectors = [S+$42A+6] to int j = [S+$42A-$426] (used reg = )
mov	ax,-$424[bp]
cmp	ax,8[bp]
jne 	.8B
.8C:
! 624         {
! 625             
! 626             while (j < 26 && *ptr) {
jmp .8E
.8F:
! 627                 
! 628                 
! 629                 
! 630                 
! 631                 
! 632 
! 633                 disk_map[*ptr] = 0; 
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
! 634                 *(ptr++) = 0;       
! Debug: postinc * char ptr = [S+$42A-$422] (used reg = )
mov	bx,-$420[bp]
inc	bx
mov	-$420[bp],bx
! Debug: eq int = const 0 to char = [bx-1] (used reg = )
xor	al,al
mov	-1[bx],al
!BCC_EOS
! 635                 ++j;
! Debug: preinc int j = [S+$42A-$426] (used reg = )
mov	ax,-$424[bp]
inc	ax
mov	-$424[bp],ax
!BCC_EOS
! 636             }
! 637         }
.8E:
! Debug: lt int = const $1A to int j = [S+$42A-$426] (used reg = )
mov	ax,-$424[bp]
cmp	ax,*$1A
jge 	.90
.91:
mov	bx,-$420[bp]
mov	al,[bx]
test	al,al
jne	.8F
.90:
.8D:
! 638     }
.8B:
! 639     else if (free_entry < 0)
jmp .92
.84:
! Debug: lt int = const 0 to int free_entry = [S+$42A-$42A] (used reg = )
mov	ax,-$428[bp]
test	ax,ax
jge 	.93
.94:
! 640     {
! 641         
! 642         return -1;
mov	ax,*-1
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 643     }
! 644     else
! 645     {
jmp .95
.93:
! 646         
! 647         
! 648         strcpyn(disk_dir+free_entry,7,fname);
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
! 649         ptr = disk_dir+free_entry+6;
! Debug: ptradd int free_entry = [S+$42A-$42A] to [$200] char disk_dir = S+$42A-$406 (used reg = )
mov	ax,-$428[bp]
mov	bx,bp
add	bx,ax
! Debug: ptradd int = const 6 to [$200] char = bx-$404 (used reg = )
! Debug: eq [$200] char = bx-$3FE to * char ptr = [S+$42A-$422] (used reg = )
add	bx,#-$3FE
mov	-$420[bp],bx
!BCC_EOS
! 650     }
! 651 
! 652 
! 653     
! 654     mptr = disk_map;
.95:
.92:
! Debug: eq [$200] char disk_map = S+$42A-$206 to * char mptr = [S+$42A-$424] (used reg = )
lea	bx,-$204[bp]
mov	-$422[bp],bx
!BCC_EOS
! 655 
! 656     while (mptr != disk_map + 51
! 656 2 && j < sectors)
! 657     {
jmp .97
.98:
! 658         if (!*mptr)
mov	bx,-$422[bp]
mov	al,[bx]
test	al,al
jne 	.99
.9A:
! 659         {
! 660             writeSector(buffer + (j++ << 9),mptr-disk_map);
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
! 661             *mptr = 0xff;
mov	bx,-$422[bp]
! Debug: eq int = const $FF to char = [bx+0] (used reg = )
mov	al,#$FF
mov	[bx],al
!BCC_EOS
! 662             *(ptr++) = mptr - disk_map;
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
! 663         }
! 664         ++mptr;
.99:
! Debug: preinc * char mptr = [S+$42A-$424] (used reg = )
mov	bx,-$422[bp]
inc	bx
mov	-$422[bp],bx
!BCC_EOS
! 665     }
! 666 
! 667     
! 668     if (j < 26)
.97:
! Debug: ne * char disk_map = S+$42A-6 to * char mptr = [S+$42A-$424] (used reg = )
lea	bx,-4[bp]
cmp	bx,-$422[bp]
je  	.9B
.9C:
! Debug: lt int sectors = [S+$42A+6] to int j = [S+$42A-$426] (used reg = )
mov	ax,-$424[bp]
cmp	ax,8[bp]
jl 	.98
.9B:
.96:
! Debug: lt int = const $1A to int j = [S+$42A-$426] (used reg = )
mov	ax,-$424[bp]
cmp	ax,*$1A
jge 	.9D
.9E:
! 669         *ptr = 0;
mov	bx,-$420[bp]
! Debug: eq int = const 0 to char = [bx+0] (used reg = )
xor	al,al
mov	[bx],al
!BCC_EOS
! 670 
! 671     
! 672     writeSector(disk_map,1);
.9D:
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
! 673     writeSector(disk_dir,2);
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
! 674 
! 675    return j == sectors ? j : -2;
! Debug: logeq int sectors = [S+$42A+6] to int j = [S+$42A-$426] (used reg = )
mov	ax,-$424[bp]
cmp	ax,8[bp]
jne 	.9F
.A0:
mov	ax,-$424[bp]
jmp .A1
.9F:
mov	ax,*-2
.A1:
! Debug: cast int = const 0 to int = ax+0 (used reg = )
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 676 }
! 677 
! 678 
! 679 
! 680 int deleteFile(fname)
! Register BX used in function writeFile
! 681 # 680 "./src/kernel.c"
! 680 char *fname;
export	_deleteFile
_deleteFile:
!BCC_EOS
! 681 {
! 682     
! 683     char disk_map[512];
!BCC_EOS
! 684     
! 685     char disk_dir[512];
!BCC_EOS
! 686     
! 687     char *ptr;
!BCC_EOS
! 688     
! 689     int   j  = 0;
push	bp
mov	bp,sp
push	di
push	si
add	sp,#-$404
! Debug: eq int = const 0 to int j = [S+$40A-$40A] (used reg = )
xor	ax,ax
mov	-$408[bp],ax
!BCC_EOS
! 690     
! 691     int byte = 0;
dec	sp
dec	sp
! Debug: eq int = const 0 to int byte = [S+$40C-$40C] (used reg = )
xor	ax,ax
mov	-$40A[bp],ax
!BCC_EOS
! 692 
! 693     
! 694     readSector(disk_map,1);
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
! 695     readSector(disk_dir,2);
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
! 696 
! 697     
! 698     for(; byte < 512; byte += 32)
!BCC_EOS
!BCC_EOS
! 699     {
jmp .A4
.A5:
! 700         if (bstrcmpn(fname,disk_dir + byte,6))
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
je  	.A6
.A7:
! 701             break;
jmp .A2
!BCC_EOS
! 702     }
.A6:
! 703 
! 704     
! 705     if (byte >= 512)
.A3:
! Debug: addab int = const $20 to int byte = [S+$40C-$40C] (used reg = )
mov	ax,-$40A[bp]
add	ax,*$20
mov	-$40A[bp],ax
.A4:
! Debug: lt int = const $200 to int byte = [S+$40C-$40C] (used reg = )
mov	ax,-$40A[bp]
cmp	ax,#$200
jl 	.A5
.A8:
.A2:
! Debug: ge int = const $200 to int byte = [S+$40C-$40C] (used reg = )
mov	ax,-$40A[bp]
cmp	ax,#$200
jl  	.A9
.AA:
! 706         return -1;
mov	ax,*-1
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 707 
! 708     
! 709     ptr  = disk_dir + byte + 6;;
.A9:
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
! 710     
! 711     
! 712     while (j < 26 && *ptr) 
! 713     {
jmp .AC
.AD:
! 714         disk_map[*(ptr++)] = 0; 
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
! 715     }
! 716 
! 717     
! 718     *(disk_dir + byte) = 0;
.AC:
! Debug: lt int = const $1A to int j = [S+$40C-$40A] (used reg = )
mov	ax,-$408[bp]
cmp	ax,*$1A
jge 	.AE
.AF:
mov	bx,-$406[bp]
mov	al,[bx]
test	al,al
jne	.AD
.AE:
.AB:
! Debug: ptradd int byte = [S+$40C-$40C] to [$200] char disk_dir = S+$40C-$406 (used reg = )
mov	ax,-$40A[bp]
mov	bx,bp
add	bx,ax
! Debug: eq int = const 0 to char = [bx-$404] (used reg = )
xor	al,al
mov	-$404[bx],al
!BCC_EOS
! 719 
! 720     
! 721     writeSector(disk_map,1);
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
! 722     writeSector(disk_dir,2);
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
! 723    return j;
mov	ax,-$408[bp]
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 724 
! 725 }
! 726 # 733
! 733  
! 734 int writeSector(buf,sector)
! Register BX used in function deleteFile
! 735 # 734 "./src/kernel.c"
! 734 char *buf;
export	_writeSector
_writeSector:
!BCC_EOS
! 735 # 734 "./src/kernel.c"
! 734 int sector;
!BCC_EOS
! 735 {
! 736 
! 737     int q         = sector/18;
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
! 738     int relsector = sector - q*18 + 1;
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
! 739     int head      = q & 1;
dec	sp
dec	sp
! Debug: and int = const 1 to int q = [S+$C-8] (used reg = )
mov	al,-6[bp]
and	al,*1
! Debug: eq char = al+0 to int head = [S+$C-$C] (used reg = )
xor	ah,ah
mov	-$A[bp],ax
!BCC_EOS
! 740     int track     = sector/36;
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
! 741 
! 742     interrupt(0x13,VREG(0x03,0x01),(int)buf,VREG(track,relsector),VREG(head,0x00));
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
! 743 
! 744     return 1;
mov	ax,*1
add	sp,*8
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 745 }
! 746 # 754
! 754  
! 755 int printStringn(str,n)
! Register BX used in function writeSector
! 756 # 755 "./src/kernel.c"
! 755 char *str;
export	_printStringn
_printStringn:
!BCC_EOS
! 756 # 755 "./src/kernel.c"
! 755 int n;
!BCC_EOS
! 756 {
! 757     char *start = str;
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
! 758     while (*str != 0 && n--)
! 759         PUT_CHAR(*(str++));
jmp .B1
.B2:
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
! 760     return str - start;
.B1:
mov	bx,4[bp]
! Debug: ne int = const 0 to char = [bx+0] (used reg = )
mov	al,[bx]
test	al,al
je  	.B3
.B4:
! Debug: postdec int n = [S+8+4] (used reg = )
mov	ax,6[bp]
dec	ax
mov	6[bp],ax
cmp	ax,*-1
jne	.B2
.B3:
.B0:
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
! 761 }
! 762 # 773
! 773  
! 774 int readFile(filename,buf,n)
! Register BX used in function printStringn
! 775 # 774 "./src/kernel.c"
! 774 char *filename;
export	_readFile
_readFile:
!BCC_EOS
! 775 # 774 "./src/kernel.c"
! 774 char *buf;
!BCC_EOS
! 775 # 774 "./src/kernel.c"
! 774 int n;
!BCC_EOS
! 775 {
! 776     
! 777     char disk_dir[512];
!BCC_EOS
! 778     
! 779     char sector_data[512];
!BCC_EOS
! 780     
! 781     char *ptr;
!BCC_EOS
! 782     
! 783     int   j  = 0;
push	bp
mov	bp,sp
push	di
push	si
add	sp,#-$404
! Debug: eq int = const 0 to int j = [S+$40A-$40A] (used reg = )
xor	ax,ax
mov	-$408[bp],ax
!BCC_EOS
! 784     
! 785     int byte = 0;
dec	sp
dec	sp
! Debug: eq int = const 0 to int byte = [S+$40C-$40C] (used reg = )
xor	ax,ax
mov	-$40A[bp],ax
!BCC_EOS
! 786 
! 787     
! 788     readSector(disk_dir,2);
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
! 789 
! 790     
! 791     for(; byte < 512; byte += 32)
!BCC_EOS
!BCC_EOS
! 792     {
jmp .B7
.B8:
! 793         if (bstrcmpn(filename,disk_dir + byte,6))
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
je  	.B9
.BA:
! 794             break;
jmp .B5
!BCC_EOS
! 795     }
.B9:
! 796 
! 797     
! 798     if (byte >= 512)
.B6:
! Debug: addab int = const $20 to int byte = [S+$40C-$40C] (used reg = )
mov	ax,-$40A[bp]
add	ax,*$20
mov	-$40A[bp],ax
.B7:
! Debug: lt int = const $200 to int byte = [S+$40C-$40C] (used reg = )
mov	ax,-$40A[bp]
cmp	ax,#$200
jl 	.B8
.BB:
.B5:
! Debug: ge int = const $200 to int byte = [S+$40C-$40C] (used reg = )
mov	ax,-$40A[bp]
cmp	ax,#$200
jl  	.BC
.BD:
! 799         return -1;
mov	ax,*-1
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 800 
! 801     
! 802     ptr  = disk_dir + byte + 
.BC:
! 802 6;;
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
! 803     
! 804     
! 805     while (n >= 512 && j < 26 && *ptr) 
! 806     {
jmp .BF
.C0:
! 807         readSector(buf+512*(j++),*(ptr++));
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
! 808         n -= 512;
! Debug: subab int = const $200 to int n = [S+$40C+6] (used reg = )
mov	ax,8[bp]
add	ax,#-$200
mov	8[bp],ax
!BCC_EOS
! 809     }
! 810     
! 811     if (n > 0 && j < 26 && *ptr)
.BF:
! Debug: ge int = const $200 to int n = [S+$40C+6] (used reg = )
mov	ax,8[bp]
cmp	ax,#$200
jl  	.C1
.C3:
! Debug: lt int = const $1A to int j = [S+$40C-$40A] (used reg = )
mov	ax,-$408[bp]
cmp	ax,*$1A
jge 	.C1
.C2:
mov	bx,-$406[bp]
mov	al,[bx]
test	al,al
jne	.C0
.C1:
.BE:
! Debug: gt int = const 0 to int n = [S+$40C+6] (used reg = )
mov	ax,8[bp]
test	ax,ax
jle 	.C4
.C7:
! Debug: lt int = const $1A to int j = [S+$40C-$40A] (used reg = )
mov	ax,-$408[bp]
cmp	ax,*$1A
jge 	.C4
.C6:
mov	bx,-$406[bp]
mov	al,[bx]
test	al,al
je  	.C4
.C5:
! 812     {
! 813         readSector(sector_data,*ptr);
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
! 814         memcpyn(buf+512*(j++),n,sector_data,512);
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
! 815 
! 816     }
! 817     return j;
.C4:
mov	ax,-$408[bp]
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 818 }
! 819 # 827
! 827  
! 828 int memcpyn(dst,m,src,n)
! Register BX used in function readFile
! 829 # 828 "./src/kernel.c"
! 828 char *dst;
export	_memcpyn
_memcpyn:
!BCC_EOS
! 829 # 828 "./src/kernel.c"
! 828 int m;
!BCC_EOS
! 829 # 828 "./src/kernel.c"
! 828 char *src;
!BCC_EOS
! 829 # 828 "./src/kernel.c"
! 828 int n;
!BCC_EOS
! 829 {
! 830     int k = (m < n ? m : n); 
push	bp
mov	bp,sp
push	di
push	si
dec	sp
dec	sp
! Debug: lt int n = [S+8+8] to int m = [S+8+4] (used reg = )
mov	ax,6[bp]
cmp	ax,$A[bp]
jge 	.C8
.C9:
mov	ax,6[bp]
jmp .CA
.C8:
mov	ax,$A[bp]
.CA:
! Debug: eq int = ax+0 to int k = [S+8-8] (used reg = )
mov	-6[bp],ax
!BCC_EOS
! 831     n = k;
! Debug: eq int k = [S+8-8] to int n = [S+8+8] (used reg = )
mov	ax,-6[bp]
mov	$A[bp],ax
!BCC_EOS
! 832     
! 833     while (n--) 
! 834         *(dst++) = *(src++);
jmp .CC
.CD:
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
! 835 
! 836     return n;
.CC:
! Debug: postdec int n = [S+8+8] (used reg = )
mov	ax,$A[bp]
dec	ax
mov	$A[bp],ax
cmp	ax,*-1
jne	.CD
.CE:
.CB:
mov	ax,$A[bp]
inc	sp
inc	sp
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 837 }
! 838 # 847
! 847  
! 848 int strcpyn(dst,n,src)
! Register BX SI used in function memcpyn
! 849 # 848 "./src/kernel.c"
! 848 char *dst;
export	_strcpyn
_strcpyn:
!BCC_EOS
! 849 # 848 "./src/kernel.c"
! 848 int n;
!BCC_EOS
! 849 # 848 "./src/kernel.c"
! 848 char *src;
!BCC_EOS
! 849 {
! 850     char *ptr = dst;
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
! 851     while (*src && --n)
! 852         *(ptr++) = *(src++);
jmp .D0
.D1:
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
! 853     *ptr = 0;
.D0:
mov	bx,8[bp]
mov	al,[bx]
test	al,al
je  	.D2
.D3:
! Debug: predec int n = [S+8+4] (used reg = )
mov	ax,6[bp]
dec	ax
mov	6[bp],ax
test	ax,ax
jne	.D1
.D2:
.CF:
mov	bx,-6[bp]
! Debug: eq int = const 0 to char = [bx+0] (used reg = )
xor	al,al
mov	[bx],al
!BCC_EOS
! 854 
! 855     return ptr - dst;
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
! 856 }
! 857 # 864
! 864  
! 865 int strcmpn(a,b,n)
! Register BX SI used in function strcpyn
! 866 # 865 "./src/kernel.c"
! 865 char *a;
export	_strcmpn
_strcmpn:
!BCC_EOS
! 866 # 865 "./src/kernel.c"
! 865 char *b;
!BCC_EOS
! 866 # 865 "./src/kernel.c"
! 865 int n;
!BCC_EOS
! 866 # 865 "./src/kernel.c"
! 865 {
! 866     
! 867     while (n-- && *a && *b) {
push	bp
mov	bp,sp
push	di
push	si
jmp .D5
.D6:
! 868         if (*(a++)!= *(b++))
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
je  	.D7
.D8:
! 869             return 0; 
xor	ax,ax
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 870     }
.D7:
! 871     
! 872     
! 873     return n < 0 || *a == *b;
.D5:
! Debug: postdec int n = [S+6+6] (used reg = )
mov	ax,8[bp]
dec	ax
mov	8[bp],ax
cmp	ax,*-1
je  	.D9
.DB:
mov	bx,4[bp]
mov	al,[bx]
test	al,al
je  	.D9
.DA:
mov	bx,6[bp]
mov	al,[bx]
test	al,al
jne	.D6
.D9:
.D4:
! Debug: lt int = const 0 to int n = [S+6+6] (used reg = )
mov	ax,8[bp]
test	ax,ax
jl  	.DD
.DE:
mov	bx,6[bp]
mov	si,4[bp]
! Debug: logeq char = [bx+0] to char = [si+0] (used reg = )
mov	al,[si]
cmp	al,[bx]
jne 	.DC
.DD:
mov	al,*1
jmp	.DF
.DC:
xor	al,al
.DF:
! Debug: cast int = const 0 to char = al+0 (used reg = )
xor	ah,ah
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 874 }
! 875 # 881
! 881  
! 882 # 887
! 887  
! 888 int printString(str)
! Register BX SI used in function strcmpn
! 889 # 888 "./src/kernel.c"
! 888 char *str;
export	_printString
_printString:
!BCC_EOS
! 889 {
! 890     char *start = str;
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
! 891     while (*str != 0)
! 892         PUT_CHAR(*(str++));
jmp .E1
.E2:
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
! 893     return str - start;
.E1:
mov	bx,4[bp]
! Debug: ne int = const 0 to char = [bx+0] (used reg = )
mov	al,[bx]
test	al,al
jne	.E2
.E3:
.E0:
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
! 894 }
! 895 # 907
! 907  
! 908 int readString(buf,n)
! Register BX used in function printString
! 909 # 908 "./src/kernel.c"
! 908 char *buf;
export	_readString
_readString:
!BCC_EOS
! 909 # 908 "./src/kernel.c"
! 908 int n;
!BCC_EOS
! 909 {
! 910     char *start = buf;
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
! 911     char *end   = buf + n-1;
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
! 912     char c;
!BCC_EOS
! 913 
! 914     while ((c = (interrupt(0x16,0,0,0,0)& 0xFF))!= '\r')
dec	sp
dec	sp
! 915     {
br 	.E5
.E6:
! 916         if (c == 0x08)
! Debug: logeq int = const 8 to char c = [S+$C-$B] (used reg = )
mov	al,-9[bp]
cmp	al,*8
jne 	.E7
.E8:
! 917         {
! 918             if (buf != start)
! Debug: ne * char start = [S+$C-8] to * char buf = [S+$C+2] (used reg = )
mov	bx,4[bp]
cmp	bx,-6[bp]
je  	.E9
.EA:
! 919             {
! 920                 --buf;
! Debug: predec * char buf = [S+$C+2] (used reg = )
mov	bx,4[bp]
dec	bx
mov	4[bp],bx
!BCC_EOS
! 921                 PUT_CHAR(0x08);
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
! 922                 PUT_CHAR(' ');
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
! 923                 PUT_CHAR(0x08);
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
! 924             }
! 925         }
.E9:
! 926         else if (buf != end)
jmp .EB
.E7:
! Debug: ne * char end = [S+$C-$A] to * char buf = [S+$C+2] (used reg = )
mov	bx,4[bp]
cmp	bx,-8[bp]
je  	.EC
.ED:
! 927         {
! 928             *buf = c;
mov	bx,4[bp]
! Debug: eq char c = [S+$C-$B] to char = [bx+0] (used reg = )
mov	al,-9[bp]
mov	[bx],al
!BCC_EOS
! 929             PUT_CHAR(c);
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
! 930             ++buf;
! Debug: preinc * char buf = [S+$C+2] (used reg = )
mov	bx,4[bp]
inc	bx
mov	4[bp],bx
!BCC_EOS
! 931         }
! 932     }
.EC:
.EB:
! 933     *buf = 0;
.E5:
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
bne 	.E6
.EE:
.E4:
mov	bx,4[bp]
! Debug: eq int = const 0 to char = [bx+0] (used reg = )
xor	al,al
mov	[bx],al
!BCC_EOS
! 934     return buf - start;
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
! 935 }
! 936 # 941
! 941  
! 942 int printInt(x)
! Register BX used in function readString
! 943 # 942 "./src/kernel.c"
! 942 int x;
export	_printInt
_printInt:
!BCC_EOS
! 943 {
! 944     
! 945     char buf[12];
!BCC_EOS
! 946     char *ptr = buf+11; 
push	bp
mov	bp,sp
push	di
push	si
add	sp,*-$E
! Debug: eq [$C] char buf = S+$14-7 to * char ptr = [S+$14-$14] (used reg = )
lea	bx,-5[bp]
mov	-$12[bp],bx
!BCC_EOS
! 947     int q, r; 
!BCC_EOS
! 948     int sign = 1; 
add	sp,*-6
! Debug: eq int = const 1 to int sign = [S+$1A-$1A] (used reg = )
mov	ax,*1
mov	-$18[bp],ax
!BCC_EOS
! 949 
! 950     
! 951     *ptr = 0;
mov	bx,-$12[bp]
! Debug: eq int = const 0 to char = [bx+0] (used reg = )
xor	al,al
mov	[bx],al
!BCC_EOS
! 952     
! 953     if (x < 0)
! Debug: lt int = const 0 to int x = [S+$1A+2] (used reg = )
mov	ax,4[bp]
test	ax,ax
jge 	.EF
.F0:
! 954     {
! 955         
! 955 
! 956         sign = -1;
! Debug: eq int = const -1 to int sign = [S+$1A-$1A] (used reg = )
mov	ax,*-1
mov	-$18[bp],ax
!BCC_EOS
! 957         x = -x;
! Debug: neg int x = [S+$1A+2] (used reg = )
xor	ax,ax
sub	ax,4[bp]
! Debug: eq int = ax+0 to int x = [S+$1A+2] (used reg = )
mov	4[bp],ax
!BCC_EOS
! 958     }
! 959     else if (x == 0)
jmp .F1
.EF:
! Debug: logeq int = const 0 to int x = [S+$1A+2] (used reg = )
mov	ax,4[bp]
test	ax,ax
jne 	.F2
.F3:
! 960     {
! 961         
! 962         *(--ptr) = '0';
! Debug: predec * char ptr = [S+$1A-$14] (used reg = )
mov	bx,-$12[bp]
dec	bx
mov	-$12[bp],bx
! Debug: eq int = const $30 to char = [bx+0] (used reg = )
mov	al,*$30
mov	[bx],al
!BCC_EOS
! 963     }
! 964 
! 965     
! 966     while (x > 0)
.F2:
.F1:
! 967     {
jmp .F5
.F6:
! 968         
! 969         q = x/10;
! Debug: div int = const $A to int x = [S+$1A+2] (used reg = )
mov	ax,4[bp]
mov	bx,*$A
cwd
idiv	bx
! Debug: eq int = ax+0 to int q = [S+$1A-$16] (used reg = )
mov	-$14[bp],ax
!BCC_EOS
! 970         r = x - q*10;
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
! 971         
! 972         *(--ptr) = r + '0';
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
! 973         x = q;
! Debug: eq int q = [S+$1A-$16] to int x = [S+$1A+2] (used reg = )
mov	ax,-$14[bp]
mov	4[bp],ax
!BCC_EOS
! 974     }
! 975 
! 976     if (sign < 0)
.F5:
! Debug: gt int = const 0 to int x = [S+$1A+2] (used reg = )
mov	ax,4[bp]
test	ax,ax
jg 	.F6
.F7:
.F4:
! Debug: lt int = const 0 to int sign = [S+$1A-$1A] (used reg = )
mov	ax,-$18[bp]
test	ax,ax
jge 	.F8
.F9:
! 977     {
! 978         
! 979         *(--ptr) = '-';
! Debug: predec * char ptr = [S+$1A-$14] (used reg = )
mov	bx,-$12[bp]
dec	bx
mov	-$12[bp],bx
! Debug: eq int = const $2D to char = [bx+0] (used reg = )
mov	al,*$2D
mov	[bx],al
!BCC_EOS
! 980     }
! 981 
! 982     
! 983     return printString(ptr);
.F8:
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
! 984 }
! 985 # 993
! 993  
! 994 int readSector(buf,sector)
! Register BX used in function printInt
! 995 # 994 "./src/kernel.c"
! 994 char *buf;
export	_readSector
_readSector:
!BCC_EOS
! 995 # 994 "./src/kernel.c"
! 994 int sector;
!BCC_EOS
! 995 {
! 996     int q         = sector/18;
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
! 997     int relsector = sector - q*18 + 1;
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
! 998     int head      = q & 1;
dec	sp
dec	sp
! Debug: and int = const 1 to int q = [S+$C-8] (used reg = )
mov	al,-6[bp]
and	al,*1
! Debug: eq char = al+0 to int head = [S+$C-$C] (used reg = )
xor	ah,ah
mov	-$A[bp],ax
!BCC_EOS
! 999     int track     = sector/36;
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
! 1000 
! 1001     interrupt(0x13,VREG(0x02,0x01),(int)buf,VREG(track,relsector),VREG(head,0x00));
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
! 1002 
! 1003     return 1;
mov	ax,*1
add	sp,*8
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 1004 }
! 1005 # 1011
! 1011  
! 1012 int strcmp(a,b)
! Register BX used in function readSector
! 1013 # 1012 "./src/kernel.c"
! 1012 char *a;
export	_strcmp
_strcmp:
!BCC_EOS
! 1013 # 1012 "./src/kernel.c"
! 1012 char *b;
!BCC_EOS
! 1013 # 1012 "./src/kernel.c"
! 1012 {
! 1013     
! 1014     while (*a && *b) {
push	bp
mov	bp,sp
push	di
push	si
jmp .FB
.FC:
! 1015         if (*(a++)!= *(b++))
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
je  	.FD
.FE:
! 1016             return 0; 
xor	ax,ax
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 1017     }
.FD:
! 1018     return *a == *b; 
.FB:
mov	bx,4[bp]
mov	al,[bx]
test	al,al
je  	.FF
.100:
mov	bx,6[bp]
mov	al,[bx]
test	al,al
jne	.FC
.FF:
.FA:
mov	bx,6[bp]
mov	si,4[bp]
! Debug: logeq char = [bx+0] to char = [si+0] (used reg = )
mov	al,[si]
cmp	al,[bx]
jne	.101
mov	al,*1
jmp	.102
.101:
xor	al,al
.102:
! Debug: cast int = const 0 to char = al+0 (used reg = )
xor	ah,ah
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 1019 }
! 1020 # 1033
! 1033  
! 1034 int bstrcmpn(str,buf,n)
! Register BX SI used in function strcmp
! 1035 # 1034 "./src/kernel.c"
! 1034 char *str;
export	_bstrcmpn
_bstrcmpn:
!BCC_EOS
! 1035 # 1034 "./src/kernel.c"
! 1034 char *buf;
!BCC_EOS
! 1035 # 1034 "./src/kernel.c"
! 1034 int n;
!BCC_EOS
! 1035 {
! 1036     
! 1037     while (n-- && *buf && *str) {
push	bp
mov	bp,sp
push	di
push	si
jmp .104
.105:
! 1038         if (*(buf++)!= *(str++))
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
je  	.106
.107:
! 1039             return 0; 
xor	ax,ax
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 1040     }
.106:
! 1041     
! 1042     if (n < 0)
.104:
! Debug: postdec int n = [S+6+6] (used reg = )
mov	ax,8[bp]
dec	ax
mov	8[bp],ax
cmp	ax,*-1
je  	.108
.10A:
mov	bx,6[bp]
mov	al,[bx]
test	al,al
je  	.108
.109:
mov	bx,4[bp]
mov	al,[bx]
test	al,al
jne	.105
.108:
.103:
! Debug: lt int = const 0 to int n = [S+6+6] (used reg = )
mov	ax,8[bp]
test	ax,ax
jge 	.10B
.10C:
! 1043     {
! 1044         
! 1045         return *str == 0;
mov	bx,4[bp]
! Debug: logeq int = const 0 to char = [bx+0] (used reg = )
mov	al,[bx]
test	al,al
jne	.10D
mov	al,*1
jmp	.10E
.10D:
xor	al,al
.10E:
! Debug: cast int = const 0 to char = al+0 (used reg = )
xor	ah,ah
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 1046     }
! 1047 
! 1048     
! 1049     return *buf == *str;
.10B:
mov	bx,4[bp]
mov	si,6[bp]
! Debug: logeq char = [bx+0] to char = [si+0] (used reg = )
mov	al,[si]
cmp	al,[bx]
jne	.10F
mov	al,*1
jmp	.110
.10F:
xor	al,al
.110:
! Debug: cast int = const 0 to char = al+0 (used reg = )
xor	ah,ah
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 1050 }
! 1051 
! Register BX SI used in function bstrcmpn
.data
.6A:
.111:
.ascii	"__DISK_DIRECTORY"
.byte	0
.50:
.112:
.ascii	"420"
.byte	0
.3D:
.113:
.byte	$A,$D
.byte	0
.3C:
.114:
.ascii	"  "
.byte	0
.31:
.115:
.ascii	"IDLE"
.byte	0
.1A:
.116:
.byte	$A,$D
.byte	0
.19:
.117:
.ascii	"killed "
.byte	0
.18:
.118:
.byte	$A,$D
.byte	0
.17:
.119:
.ascii	"error: no process with segment index "
.byte	0
.B:
.11A:
.byte	$A,$D
.byte	0
.A:
.11B:
.ascii	"error: no process with segment index "
.byte	0
.2:
.11C:
.ascii	"shell"
.byte	0
.1:
.11D:
.ascii	"running shell form main"
.byte	$D,$A
.byte	0
.bss
.comm	_idleProc,$16
.comm	_running,2
.comm	_readyTail,2
.comm	_pcbPool,$B0
.comm	_readyHead,2
.comm	_memoryMap,$10

! 0 errors detected
