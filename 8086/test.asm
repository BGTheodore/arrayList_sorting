org 100h

.data

str db 10,13,"Enter Values:",'$'
str1 db 0dh,0ah,'Bubble Sorted:',' $'
array db 20dup(0) 
array1 db 20dup(0) 
array2 db 20dup(0) 
array3 db 20dup(0)  
autre db 20dup(0)
;array:list of sorted input
;array1:List of even numbers
;array2:list of odd numbers
;array3:List of number %3
;autre :list of other numbers

.code

;splits the list into even and odd
split1 macro 
        mov al,[si] 
        test al,1   ;check if it's even or odd 
        jnz impair 
        mov [di], al  
        inc di 
        inc si
        jmp end

impair : 
        mov [bx], al
        inc bx  
        inc si
        jmp end
end:
endm





mov ah,9
lea dx,str
int 21h

mov cx,8
mov bx,offset array
mov ah,1

inputs:
int 21h
mov [bx],al
inc bx
Loop inputs

mov cx,8
dec cx

nextscan:
mov bx,cx
mov si,0

nextcomp:
mov al,array[si]
mov dl,array[si+1]
cmp al,dl

jc noswap

mov array[si],dl
mov array[si+1],al

noswap:
inc si
dec bx
jnz nextcomp

loop nextscan

 

mov ah,9
lea dx,str1
int 21h

mov cx,8
mov bx,offset array

; this loop to display elements on the screen
print:
mov ah,2
mov dl,[bx]
int 21h
inc bx
loop print 


lea si,array ;address list sorted 
lea di,array1 ; address list even
lea bx ,array2 ; address list odd

xor dx,dx ;clear ax to use it as a counter to know how much odd numbers

mov cx,8
a:
split1
;inc si
LOOP a

;print even numbers
mov cx,8
lea si, array1

l1:
    mov dl, [si]
    mov ah, 2  
    int 21h
    inc si
    loop l1



int 21h


