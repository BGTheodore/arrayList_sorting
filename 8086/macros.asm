


;array:list of sorted input
;array1:List of even numbers
;array2:list of odd numbers
;array3:List of number %3
;autre :list of other numbers

lea si,array ;address list sorted 
lea di,array1 ; address list even
lea bx ,array2 ; address list odd

xor dx,dx ;clear ax to use it as a counter to know how much odd numbers

mov cx,20
a:
split1
inc si
LOOP a

;print even numbers
mov cx,20
lea si, array1

l1:
    mov dl, [si]
    mov ah, 2  
    int 21h
    inc si
    loop l1

;split %3 and others

lea si,array2 ;address list odd
lea di,array3 ; address list %3
lea bx ,autre ; address list autre

mov cx,dx
xor dx,dx ;clear ax to use it as a counter to know how much numbers %3
b:
split2
inc si
LOOP b

;print numbers %3
mov cx,dx
lea si, array3
lea di ,si+dx

l2:
    mov dl, di
    mov ah, 2  
    int 21h
    dec di   ;ordre decroissant
    loop l2

;print numbers others
mov cx,20
lea si, autre

l1:
    mov dl, [si]
    mov ah, 2  
    int 21h
    inc si
    loop l1
