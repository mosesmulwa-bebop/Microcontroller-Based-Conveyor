.model medium 

.stack
 dw 128 dup (0)
  
  
.data

    msg1                 db "Qty: $" 
    msg2                 db "Time: $"   
    msg3                 db "Typ: $"     
    msg4                 db "EMERGENCY$"      
    msg5                 db "Lowest Floor$" 

    initial                 db 048
    initial_Q1              db 048
    initial_Q2              db 048    
    initial_Q3              db 048  
    initial_Q4              db 048  
    
    initial_T1            db 048
    initial_T2            db 048
    initial_T4            db 048
    initial_T5            db 048
    initial_T7            db 048
    
    val9                 db 058
    val5                 db 054   
    
    Motor_Delay            dw   800
         
   

.code

LCD_CUR:
            MOV AL,AH
            CALL LCD_CMD
            
            
	
LCD_CMD:    ;sends commands to LCD
            ;input: AH = command code
            ;output: none
            
            ;set out data pins
            	MOV AL,AH
            	CALL OUT_A
            ;make RS=0,R/W=0,EN=1
            	MOV AL,04h
            	CALL OUT_B
            
            ;make RS=0,R/W=0,EN=0
            	MOV AL,00h
            	CALL OUT_B
            	
            ;delay 1ms
            	MOV CX,100
            	CALL DELAY
            
            	RET

LCD_CHAR:   ;sends character to LCD
            ;input: AH = command code
            ;output: none
            
            ;set out data pins
            	MOV AL,AH
            	CALL OUT_A
            ;make RS=1,R/W=,EN=1
            	MOV AL,06h
            	CALL OUT_B
            
            ;make RS=1,R/W=0,EN=0
            	MOV AL,02h
            	CALL OUT_B
            
            ;delay 1ms
            	MOV CX,50
            	CALL DELAY
            		
            	RET   
            	
LCD_STR:    ;prints a string on current cursor position
            ;input: SI=string address, string should end with '$'
            ;output: none
            
            ;save registers
            ;read and write character
            	@LCD_PRINTSTR_LT:
            		LODSB
            		CMP AL,'$'
            		JE @LCD_PRINTSTR_EXIT
            		MOV AH,AL
            		CALL LCD_CHAR	
            	JMP @LCD_PRINTSTR_LT
            	
            ;return
            	@LCD_PRINTSTR_EXIT:
            	RET            	      
            	
LCD_CLEAR:  ;clear display and return cursor to home position
            MOV AH,1
        	CALL LCD_CMD
        	RET	
            	

DELAY:  ;input: CX, this value controls the delay. CX=50 means 1ms
        ;output: none
    	JCXZ @DELAY_END
    	@DEL_LOOP:
    	LOOP @DEL_LOOP	
    	@DELAY_END:
    	RET           
    	




Motor_Conv:        
            STI 
             
             
             
            MOV AL,3h      ;01
            CALL OUT_C 
            
            mov cx,Motor_Delay 
            CALL DELAY

            MOV AL,2h       ;1
            CALL OUT_C
           
            mov cx,Motor_Delay 
            CALL DELAY  
            
           ; INT 03H         
            
            MOV AL,06h     ;12
            CALL OUT_C
            
            mov cx,Motor_Delay 
            CALL DELAY                                    

            MOV AL,4h   ;2
            CALL OUT_C 
            
            mov cx,Motor_Delay 
            CALL DELAY  

            MOV AL,0Ch     ;23
            CALL OUT_C 
            
            mov cx,Motor_Delay 
            CALL DELAY
            
            MOV AL,8h        ;3
            CALL OUT_C
           
            mov cx,Motor_Delay 
            CALL DELAY           
            
            MOV AL,9h         ;30
            CALL OUT_C
            
            mov cx,Motor_Delay 
            CALL DELAY                                    

            MOV AL,1h          ;0
            CALL OUT_C 
            
            mov cx,Motor_Delay 
            CALL DELAY 
            
            MOV AL,3h          ;01
            CALL OUT_C             


            jmp Motor_Conv          
            ;
;            mov al,20H             ;EOI OCW 2
;            OUT 18H,AL
;
                       
            iret



TypeA:      
        PUSH BX
        
        inc initial_Q1 
        
        mov bl,val9
        cmp bl,initial_Q1
        jz tens
        
        ;Set LCD Cursor for Typ value
            mov ah,84h
            call LCD_CUR
            
        ;Display Character on LCD             
            mov ah,'A'
            call LCD_CHAR        
        
        ;Set LCD Cursor for Qty value 1
            mov ah,8Fh
            call LCD_CUR
            
        ;Display Character on LCD             
            mov ah,initial_Q1
            call LCD_CHAR
            
        ;Set LCD Cursor for Qty value 2
            mov ah,8Eh
            call LCD_CUR
            
        ;Display Character on LCD             
            mov ah,initial_Q2
            call LCD_CHAR            
            
            
            
              
            
            jmp endlabel   
            
       tens:
            MOV INITIAL_Q1,048
            INC initial_Q2
            
        ;Set LCD Cursor for Typ value
            mov ah,84h
            call LCD_CUR
            
        ;Display Character on LCD             
            mov ah,'A'
            call LCD_CHAR        
        
        ;Set LCD Cursor for Qty value 1
            mov ah,8Fh
            call LCD_CUR
            
        ;Display Character on LCD             
            mov ah,initial_Q1
            call LCD_CHAR            
            
        
        ;Set LCD Cursor for Qty value 2
            mov ah,8Eh
            call LCD_CUR
            
        ;Display Character on LCD             
            mov ah,initial_Q2
            call LCD_CHAR        
            
            
      endlabel:      
      POP BX     
            
            mov al,20H             ;EOI
            OUT 18H,AL

                       
            iret        
            

TypeB:      
        PUSH BX
        
         
        
        mov bl,048
        cmp bl,initial_Q1
        jz tensB        
        
        dec initial_Q1
        ;Set LCD Cursor for Typ value
            mov ah,84h
            call LCD_CUR
            
        ;Display Character on LCD             
            mov ah,'B'
            call LCD_CHAR        
        
        ;Set LCD Cursor for Qty value 1
            mov ah,8Fh
            call LCD_CUR
            
        ;Display Character on LCD             
            mov ah,initial_Q1
            call LCD_CHAR 
            
        ;Set LCD Cursor for Qty value 2
            mov ah,8Eh
            call LCD_CUR
            
        ;Display Character on LCD             
            mov ah,initial_Q2
            call LCD_CHAR            
            
            
        jmp endlabelB
        
        tensB:   
        
            mov bl,048
            cmp bl,initial_Q2
            jz LOWEST 
        
        
            MOV INITIAL_Q1,057
            DEC initial_Q2
            
        ;Set LCD Cursor for Typ value
            mov ah,84h
            call LCD_CUR
            
        ;Display Character on LCD             
            mov ah,'P'
            call LCD_CHAR        
        
        ;Set LCD Cursor for Qty value 1
            mov ah,8Fh
            call LCD_CUR
            
        ;Display Character on LCD             
            mov ah,initial_Q1
            call LCD_CHAR            
            
        
        ;Set LCD Cursor for Qty value 2
            mov ah,8Eh
            call LCD_CUR
            
        ;Display Character on LCD             
            mov ah,initial_Q2
            call LCD_CHAR            
        
        endlabelB:
        
        
        POP BX
            
            mov al,20H             ;EOI
            OUT 18H,AL

                       
            iret        
            

           
TimeS:
push bx
;push ax 

        ;Set LCD Cursor for value time 7 
            mov ah,0cCh
            call LCD_CUR
            
        ;Display Character on LCD                         
            mov ah,initial_T7
            call LCD_CHAR                         

;test if the microsecond bit is 9
inc initial_T7  
mov bl, val9
cmp bl, initial_T7

jz oneS

jmp endlabell

oneS:
mov initial_T7, 048
inc initial_T5
           
        ;Set LCD Cursor for value time 7 
            mov ah,0cCh
            call LCD_CUR
            
        ;Display Character on LCD                         
            mov ah,initial_T7
            call LCD_CHAR
        ;Set LCD cursoor for value time 5
            mov ah, 0CAh
            call LCD_CUR
        ;Display Charaacter on LCD
            mov ah, initial_T5
            call LCD_CHAR

cmp bl, initial_T5
jz teenS

jmp endlabell

teenS:
mov initial_T5, 048
inc initial_T4

        ;Set LCD Cursor for value time 7 
            mov ah,0cCh
            call LCD_CUR
            
        ;Display Character on LCD                         
            mov ah,initial_T7
            call LCD_CHAR
        ;Set LCD cursoor for value time 5
            mov ah, 0CAh
            call LCD_CUR
        ;Display Charaacter on LCD
            mov ah, initial_T5
            call LCD_CHAR
        ;Set LCD cursoor for value time 4
            mov ah, 0C9h
            call LCD_CUR
        ;Display Charaacter on LCD
            mov ah, initial_T4
            call LCD_CHAR
            
mov bh, val5
cmp bh, initial_T4
jz oneM            

jmp endlabell

oneM:
mov initial_T4, 048
inc initial_T2
                
        ;Set LCD Cursor for value time 7 
            mov ah,0cCh
            call LCD_CUR
            
        ;Display Character on LCD                         
            mov ah,initial_T7
            call LCD_CHAR
        ;Set LCD cursoor for value time 5
            mov ah, 0CAh
            call LCD_CUR
        ;Display Charaacter on LCD
            mov ah, initial_T5
            call LCD_CHAR
        ;Set LCD cursoor for value time 4
            mov ah, 0C9h
            call LCD_CUR
        ;Display Charaacter on LCD
            mov ah, initial_T4
            call LCD_CHAR
        ;Set LCD cursoor for value time 2
            mov ah, 0C7h
            call LCD_CUR
        ;Display Charaacter on LCD
            mov ah, initial_T2
            call LCD_CHAR
            
cmp al, initial_T2
jz tenM

jmp endlabell

tenM:
mov initial_T2, 048
inc initial_T1

        ;Set LCD Cursor for value time 7 
            mov ah,0cCh
            call LCD_CUR
            
        ;Display Character on LCD                         
            mov ah,initial_T7
            call LCD_CHAR
        ;Set LCD cursoor for value time 5
            mov ah, 0CAh
            call LCD_CUR
        ;Display Charaacter on LCD
            mov ah, initial_T5
            call LCD_CHAR
        ;Set LCD cursoor for value time 4
            mov ah, 0C9h
            call LCD_CUR
        ;Display Charaacter on LCD
            mov ah, initial_T4
            call LCD_CHAR
        ;Set LCD cursoor for value time 2
            mov ah, 0C7h
            call LCD_CUR
        ;Display Charaacter on LCD
            mov ah, initial_T2
            call LCD_CHAR 
        ;Set LCD cursoor for value time 1
            mov ah, 0C6h
            call LCD_CUR
        ;Display Charaacter on LCD
            mov ah, initial_T1
            call LCD_CHAR
                                   


endlabell:
;         pop ax
         pop bx
          
         ;end of interrupt 
         mov al,20h
         out 18h,al  
         
         iret

OUT_A:  ;sends data to output port and saves them in a variable
        ;input: AL
        ;output: PORTA_VAL
        	OUT 30h,AL
        	RET	


OUT_B:  ;output: PORTB_VAL	
        	OUT 32h,AL
        	RET

OUT_C:  ;input: AL
        ;output: PORTC_VAL	
        	OUT 34h,AL
        	RET       
        	
        	
        	
EMERGENCY:
          
            CALL LCD_CLEAR
            
            mov cx,50000            
            CALL DELAY 
            
        ;Set LCD Cursor for EMERGENCY 
            mov ah,80h
            call LCD_CUR
            
        ;Display String on LCD             
            lea SI,msg4
            call LCD_STR
            
            mov cx,50000
            call delay
            
            jmp emergency                   	

            mov al,20H             ;EOI
            OUT 18H,AL
            
            
                       
            iret  
            
        	
LOWEST:
          
            CALL LCD_CLEAR
            
            mov cx,50000            
            CALL DELAY 
            
        ;Set LCD Cursor for EMERGENCY 
            mov ah,80h
            call LCD_CUR
            
        ;Display String on LCD             
            lea SI,msg5
            call LCD_STR
                
            mov cx,50000
            call delay    
          
            
            jmp start                	

            mov al,20H             ;EOI
            OUT 18H,AL
            
            
                       
            ret                  
 
start:  ;Initialise Data Segment
            mov ax,@data
            mov ds,ax 
            
        ;Initialise Extra Segment    
            mov ax,00h
            mov es,AX
        
        
        ;Initialise 8255 
            mov al,80h          ;Move I/O command to al register 
            out 36h,al          ;send command to Control Word      
            
            
        ;Initialise 8259
            mov al,13H             ;ICW1 = 00010011 = 13H
            OUT 18H,AL
            
            mov al,30H             ;ICW2 = 00110000 = 30H  vector no. 48
            OUT 1AH,AL 
            
            mov al,01H             ;ICW4 = 00001001 = 9H
            OUT 1AH,AL  
        
        ; Initialise 8253
            mov al,36H          ;Command word sent to 8253
            out 2EH,al
            
            
            mov al,50H
            out 28H,al
            
            mov al,0c3H
            out 28H,al
            
            
        ;Interrupt Vector table initialization
           
            ;Interrupt 1 - TYPE A
            
            lea ax,TypeA
            mov di,00c0h
            stosw 
           
            mov ax,cs
            stosw
            

            ;Interrupt 2 - TYPE B
            
            lea ax,TypeB
            mov di,00c4h
            stosw 
           
            mov ax,cs
            stosw
            
            
           ;Interrupt 3 - TIME    
            lea ax,TimeS
            mov di,00C8h
            stosw
            
            mov ax,cs
            stosw
                    
 
 
            ;Interrupt 4 - START CONVEYOR    
            lea ax,Motor_Conv
            mov di,00CCh
            stosw
            
            mov ax,cs
            stosw

            ;Interrupt 4 - EMERGENCY  
            lea ax,EMERGENCY
            mov di,8h
            stosw
            
            mov ax,cs
            stosw
 
            STI
        
                
            
        ;Initialization LCD
            
            ;delay 20msafter VCC rises to 4.5V
        	MOV CX,1000
        	CALL DELAY
            	
            ;Send function set command to LCD: 2 Line, 8-bit, 5x7 dots
        	MOV AH,38H
        	CALL LCD_CMD
            	
            ;Send display ON/OFF control command to LCD: Display ON, Cursor off, Blink off
        	MOV AH,0CH
        	CALL LCD_CMD 
            	
            ;Send clear display command to LCD: Clear display, Returns cursor to home position (address 0)            	
        	MOV AH,01H
        	CALL LCD_CMD
            	
            ;Send entry mode set command to LCD: Auto Increment bit, No display shift             	
        	MOV AH,06H
        	CALL LCD_CMD                                      
   
   

            
        ;Set LCD Cursor for string Qty
            mov ah,8Ah
            call LCD_CUR
        
        ;Display string on LCD 
            lea SI,msg1
            call LCD_STR 
            
        ;Set LCD Cursor for string Tm
            mov ah,0c0h
            call LCD_CUR   
            
        ;Display string on LCD 
            lea SI,msg2
            call LCD_STR    
            
        ;Set LCD Cursor for string Typ
            mov ah,80h
            call LCD_CUR   
            
        ;Display string on LCD 
            lea SI,msg3
            call LCD_STR                               

        ;Set LCD Cursor for value Typ
            mov ah,84h
            call LCD_CUR
            
        ;Display Character on LCD                        
            mov ah,initial
            call LCD_CHAR   
            
            
        ;Set LCD Cursor for value time 1 
            mov ah,0c6h
            call LCD_CUR
            
        ;Display Character on LCD                         
            mov ah,initial
            call LCD_CHAR  
            
        ;Set LCD Cursor for value time 2 
            mov ah,0c7h
            call LCD_CUR
            
        ;Display Character on LCD             
            mov ah,initial
            call LCD_CHAR
  
        ;Set LCD Cursor for value time 3 
            mov ah,0c8h
            call LCD_CUR
                   
        ;Display Character on LCD             
            mov ah,058
            call LCD_CHAR   
            
        ;Set LCD Cursor for value time 4 
            mov ah,0c9h
            call LCD_CUR
            
        ;Display Character on LCD             
            mov ah,initial
            call LCD_CHAR            

        ;Set LCD Cursor for value time 5 
            mov ah,0cAh
            call LCD_CUR
         
        ;Display Character on LCD             
            mov ah,initial
            call LCD_CHAR        
            
        ;Set LCD Cursor for value time 6 
            mov ah,0cBh
            call LCD_CUR
         
        ;Display Character on LCD             
            mov ah,058
            call LCD_CHAR 
                                  
        ;Set LCD Cursor for value time 7 
            mov ah,0cCh
            call LCD_CUR
         
        ;Display Character on LCD             
            mov ah,initial_T1
            call LCD_CHAR                           
            
        ;Set LCD Cursor for value Qty 1 
            mov ah,8Eh
            call LCD_CUR
            
        ;Display Character on LCD             
            mov ah,initial_Q1
            call LCD_CHAR                      
 
        ;Set LCD Cursor for value Qty 2
            mov ah,8Fh
            call LCD_CUR
            
        ;Display Character on LCD             
            mov ah,initial_Q2
            call LCD_CHAR 
                      
           

  
          

          
          HLT
          
        
end start     

  