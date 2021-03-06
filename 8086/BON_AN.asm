      
        
STACKSG SEGMENT PARA STACK 'STACK'
        DW 64 DUP(?)
STACKSG ENDS

DATASG  SEGMENT PARA 'DATA'
DIZI    DB 100 dup(0)
ELEMAN  DB 100
MSG2	DB	'Entrez la dimension de la liste: ','$'
MSG_neg	DB	'-','$'
MSG_val	DB	'. element: ','$'
MSG_err DB	' -Erreur! Veuillez entrer un nombre entre 1 et 255', '$'
MSG_err1 DB	' -Erreur! Veuillez entrer un nombre entre 1 et 20', '$'
MSG4 	DB	'-- Liste originale: --', '$'
MSG5 	DB	'-- Liste trie: --', '$'
MSG6 	DB	'-- Liste nombres pairs (ordre croissant): --', '$'  
MSG7 	DB	'-- Liste nombres impairs multiples de 3 (ordre decroissant): --', '$'  
MSG8	DB	'-- Liste nombres des autres nombres (ordre croissant): --', '$'

MSG_voi	DB	'  ','$'
the_string db 26         
           db ?          
           db 26 dup (?) 
size DW 0       ;dimension de la liste
DATASG ENDS

CODESG  SEGMENT PARA 'CODE'
        ASSUME CS:CODESG, DS:DATASG, SS:STACKSG

BASLA   PROC FAR
        PUSH DS
        XOR AX,AX
        PUSH AX
        MOV AX, DATASG
        MOV DS, AX
		;----------;
		
		ask_again:
        LEA DX,MSG2	 ; Demande la dimension de la liste a analyser
		MOV AH,9
		INT 21H
		
		CALL read_number ; Place l'input dans BX 
		CMP BX,21
		JGE	hata0    ; borne superieur 20
		CMP BX,1
		JL hata0	; borne inferieur 0
		
        JMP ok:

		hata0:
        LEA DX,MSG_err1 ; Message d'erreur
		MOV AH,9
		INT 21H		
		CALL new_line
		JMP ask_again

        ok:
		CALL new_line
        PUSH BX 
		
		XOR CX,CX
		MOV CL,BL 
		
		XOR SI,SI 

getElement:             ;Recoit les entrees de l'utilisateur
		MOV BX,SI
		INC BL
		CALL print	

		LEA DX,MSG_val	;demande le ieme element
		MOV AH,9
		
		INT 21H

		CALL read_number 
		
		CMP BX,256
		JGE	hata1    ;Borne superieur 255
		CMP BX,1
		JL hata1	; Borne inferieur 1
		JMP hatayok
		hata1:
			LEA DX,MSG_err ; Message d'erreur
			MOV AH,9
			INT 21H
			DEC SI 
			INC CX 
			JMP hataDevam
		hatayok:
		
		MOV dizi[SI],BL 
		hataDevam:
		CALL new_line
		INC SI
		LOOP getElement
		
		CALL new_line	; Saut de ligne
		LEA DX,MSG4	;
		MOV AH,9
		INT 21H
		CALL new_line	
		
		POP CX
		PUSH CX ; Sauvegarde de CX
		XOR SI,SI

showArray: ;affichage de la liste initiale
		XOR BH,BH
		MOV BL, dizi[SI]
		CALL print	
		
		LEA DX,MSG_voi	
		MOV AH,9
		INT 21H
		
		INC SI
		LOOP showArray
		;;;;;;;;;;;;;;;;;;;  algorithme QuickSort ;;;;;;;;;;;;;;;;;;;;;;
		CALL new_line
		CALL new_line
		LEA DX,MSG5	
		MOV AH,9
		INT 21H
		
		
		XOR AX,AX ; left = 0
		POP BX ; right = BX = n
		PUSH BX ;
		DEC BX ; right = n-1
		CALL  quicksort
		
		CALL new_line
		
		
		POP CX  ; cx = n
        MOV size,cx
		XOR SI,SI

showArray2:     ;affichage de la liste trie
		XOR BH,BH
		MOV BL, dizi[SI]
		CALL print	
		
		LEA DX,MSG_voi
		MOV AH,9
		INT 21H
		
		INC SI
		LOOP showArray2   
		
                                     ;liste nombres pairs 
        CALL new_line
        CALL new_line
		LEA DX,MSG6	; list even numbers.
		MOV AH,9
		
		INT 21H
        CALL new_line
        mov cx,size
        XOR SI,SI

showArray3:         ;affichage de la liste des nombres pairs
		XOR BH,BH
        XOR AH,AH
		
        MOV AL,dizi[SI]
        MOV AH,0
        MOV DL,2
        DIV DL
        CMP AH,0
        JNE DONE
        EVEN:
        MOV BL, dizi[SI]
		CALL print		
		LEA DX,MSG_voi	
		MOV AH,9
		INT 21H
		DONE:
		INC SI
		LOOP showArray3
                               ;   Liste nombres impairs multiples de 3  

        CALL new_line
        CALL new_line
		LEA DX,MSG7	; list odd numbers.
		MOV AH,9
		
		INT 21H
        CALL new_line
        mov cx,size
        XOR SI,SI
        add SI,size
        dec SI

showArray4:                 ;Affichage de la liste des nombres impairs %3
		XOR BH,BH
        XOR AH,AH
		
       ;check si impair et divisible par 3
         MOV AL,dizi[SI]
        MOV AH,0
        MOV DL,3
        DIV DL
        CMP AH,0
        JNE de 

        dex:  
        MOV AL,dizi[SI]
        MOV AH,0
        MOV DL,2
        DIV DL
        CMP AH,0
        JE de

        MOV BL, dizi[SI]
		CALL print		
		LEA DX,MSG_voi
		MOV AH,9
		INT 21H
        de: 
        dec SI
        loop showArray4
        
                                ;list of others
        CALL new_line
        CALL new_line
		LEA DX,MSG8	
		MOV AH,9
		
		INT 21H
        CALL new_line
        mov cx,size
        XOR SI,SI


showArray5:                 ;  Affichage des autres nombres
		XOR BH,BH
        XOR AH,AH
		


          ;check si impair et non divisible par 3
        MOV AL,dizi[SI]
        MOV AH,0
        MOV DL,3
        DIV DL
        CMP AH,0
        JE deR 

       MOV AL,dizi[SI]
        MOV AH,0
        MOV DL,2
        DIV DL
        CMP AH,0
        JE deR

        MOV BL, dizi[SI]
		CALL print		
		LEA DX,MSG_voi	
		MOV AH,9
		INT 21H
        deR: 
         inc SI
        loop showArray5

    



        RETF
BASLA   ENDP

quicksort	PROC    ;procedure de QuickSort
	; LEFT:AX, RIGHT:BX
PUSH BX
PUSH AX
	CMP AX,BX
	JGE bitti
	CALL arrange_pivot 
	
POP AX
	MOV BX,DX 
	DEC BX ; right = pivot - 1
	CALL quicksort ; (left:left, right:pivot-1)
POP BX
	MOV AX,DX ; pivotu aktar
	INC AX ; left = pivot + 1
	CALL quicksort ; (left:pivot+1, right:right)
	JMP devamEdiyor
	bitti:
	POP AX
	POP BX
	devamEdiyor:
	RET
quicksort	ENDP

arrange_pivot PROC
	XOR DH,DH
	; DX: pivot, AX: left, BX: right
	MOV DL, dizi[BX] ; DX = dizi[right]
	MOV SI,AX
	DEC SI ; ind = SI = left - 1
	
	MOV CX,BX
	SUB CX,AX ;  right-left
	
	MOV DI,AX ; j = left
dongu1:
	PUSH BX
	XOR BH,BH
	MOV BL, dizi[DI]
	CMP BL,DL
	JG devam2
	INC SI
	
	
	PUSH DX
	XOR DH,DH
	MOV DL,dizi[SI]
	XCHG DL,dizi[DI]
	MOV dizi[SI],DL
	POP DX
	
	devam2:
	POP BX
	INC DI
	LOOP dongu1

	 
	PUSH DX
	XOR DH,DH
	INC SI ; SI+1
	MOV DL,dizi[SI]
	XCHG DL,dizi[BX]
	MOV dizi[SI],DL
	POP DX
	
	MOV DX,SI 

	RET
arrange_pivot ENDP


read_number	PROC  ;Procedure pour recevoir les entrees de l'utilisateur
PUSH SI
	
	MOV AH, 0ah  
	mov dx,offset the_string  
	
	MOV SI, offset the_string 
	CALL string2num	
POP SI
	RET
read_number ENDP


new_line	PROC   ;Saut de ligne
		PUSH DX
		PUSH AX
		
		MOV dl, 10	; \n
		MOV ah, 02h
		INT 21h
		MOV dl, 13
		MOV ah, 02h
		INT 21h
		
		POP AX
		POP DX
		RET
new_line ENDP

print		PROC        ;Procedure d'affichage
push ax
push dx
push cx
push bx
	mov  ax, bx ; 
	CMP bl,0
	JGE devam ;
		LEA DX,MSG_neg 
		MOV AH,9
		INT 21H
		MOV AX,BX 
		NEG Al 	
	devam:
	
   MOV BX, 10     
   XOR DX,DX
   XOR CX,CX
    
          
bol1:  
	XOR DX,DX
    DIV BX      ;AX/BX
    PUSH DX     
    INC CX      
    CMP AX, 0     
    JNE bol1     
    
bol2:  POP DX      
   ADD DX, 30H     
   MOV AH, 02H     
   INT 21H      
   LOOP bol2    

pop bx
pop cx
pop dx
pop ax
  RET
print ENDP

string2num	PROC
push cx 
push si

  inc  si 
  mov  cl, [ si ]                                         
  xor ch,ch 
  add  si, cx 

  xor bx,bx
  mov  bp, 1 ; MULTIPLE OF 10 TO MULTIPLY EVERY DIGIT.

  xor ax,ax
repeat:
                    
  mov  al, [ si ] 
  CMP AL,'-'
  JNE positive
		
		NEG BX
		JMP negative  
  positive:
  sub  al, 48 

  xor ah,ah
  mul  bp ;AX*BP = DX:AX
  add  bx,ax 

  mov  ax, bp
  mov  bp, 10
  mul  bp ;AX*10 = DX:AX
  mov  bp, ax 
t
  dec  si 
  loop repeat
negative:

pop si
pop cx
  RET
string2num ENDP

CODESG  ENDS
        END BASLA