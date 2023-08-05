

INCLUDE 'EMU8086.INC'
.MODEL SMALL
.STACK 100h
.DATA        
    ARR DB 37h, 36h, 39h, 35h, 34h, 32h, 31h, 31h, 37h, 38h ;Elementi niza u hex obliku

.CODE
    MAIN PROC
       
        MOV AX, @DATA
        MOV DS,AX
       
        XOR CX,CX    ; cx = 0
        MOV CL,10    ; postavljanje nizih 8 bita cx registra
        PUSH CX  
        PUSH CX

        ADD CX, SI    ; inicijalizacija Source Index registra
            
        PRINT "Pocetni niz: "    
   INITIAL:
        MOV DL,ARR[SI] ; smestanje trenutnog elementa u nizih 8 bita DX registra
        MOV AH,2
        INT 21h        ; prekid za ispisivane vrednosti iz DL
        INC SI         ; SI++
        LOOP INITIAL 
        
        LEA SI,ARR     ; resetoavanje vrednosti SI registra na prvi element niza
        POP CX
        
        PRINTN
        PRINTN
             
     SORT:            
          SUB CX,1     ; CX--
          LEA SI,ARR   ; cuvanje adrese prvog elementa niza
          CMP CX,SI    ; uporedjvanje pozicije CX registra prema poziciji prvog elementa niza
          JLE EXIT
         
          SWAP:
            CMP SI,CX  
            JGE SORT
                       
            MOV BL,ARR[SI]   ; cuva vrednosti susednih elemenata
            MOV BH,ARR[SI+1]
            CMP BL,BH        ; poredi elemente
            JLE INCREMENT
           
            MOV ARR[SI],BH   ; menja pozicije susednih vrednosti 
            MOV ARR[SI+1],BL
            INC SI

            JMP SWAP  
         

      INCREMENT:
           INC SI
           JMP SWAP
      EXIT:
           LEA SI,ARR   ; resetovanje SI registra na adresu prvog 
           POP CX
           PRINT "Sortiran niz: "
         
      OUTPUT:               ; ispisuje elementa novo sortiranog niza
            MOV DL,ARR[SI]  
            MOV AH,2
            INT 21h
            INC SI
            LOOP OUTPUT
       
     MAIN ENDP
END MAIN