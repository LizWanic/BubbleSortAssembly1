; Elizabeth Wanic
; 22 January 2017
; CS 3140 - Assignment 2
; Command line for assembly : 
;    nasm -f elf32 -g assign2.asm
; Command line for linker :
;    ld -o assign2 -m elf_i386 assign2.o
; 
; User must enter ./assign2 to run the program
; There is no output to the console


bits 32
section .text   ; section declaration
global _start

_start:
        mov     edx, 19                         ; set up counter for array length

outerloop:
        mov     ecx, 0                          ; set up array position counter

innerloop:
        mov     eax, [array + ecx * 4]          ; value of array at current position
        mov     ebx, [array + 4 + ecx * 4]      ; value of array at next position
        cmp     eax, ebx                        ; compare their values
        jle     next                            ; if less than or equal leave it
        mov     [array + ecx * 4], ebx          ; if not, do the swap
        mov     [array + 4 + ecx * 4], eax
        mov     eax, [swapcount]                ; current swapcount value
        inc     eax                             ; increment swapcount
        mov     [swapcount], eax                ; return value to swapcount

next:
        inc     ecx                             ; move up one array position
        cmp     ecx, edx                        ; go to endinner once finished 
        jl      innerloop                       ; continue inner until the end

endinner:
        mov     eax, [passes]                   ; current passes value
        inc     eax                             ; increment passes
        mov     [passes], eax                   ; return value to passes
        mov     eax, [swapcount]                ; move the swapcount into eax
        cmp     eax, 0
        je      indexsetforcopy                 ; go to the copy section if 0 swaps
        mov     [swapcount], dword 0            ; reset swapcount
        dec     edx                             ; decrease length by one each time
        jnz     outerloop
        
indexsetforcopy:
        mov     edx, 19
        mov     ecx, 0

copyarray:
        mov     eax, [array + ecx * 4]
        mov     [output + ecx * 4], eax
        inc     ecx
        cmp     ecx, edx
        jle     copyarray

done:
        mov     ebx, [passes]       ; first syscall argument: exit code
        mov     eax,1               ; system call number (sys_exit)
        int     0x80                ; "trap" to kernel

section .data   ; section declaration

; This variable must remain named exactly 'array'
array   dd     7, 11, 4, 5, 19, 20, 8, 10, 9, 15, 6, 16, 12, 3, 2, 17, 14, 13, 1, 18

section .bss    ; section declaration

; These variable values are not known at the start, so in the .bss section
output: resd 20
passes: resd 1
swapcount: resd 1 