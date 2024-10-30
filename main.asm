
RS      equ     P1.3    ;Reg Select ligado em P1.3
EN      equ     P1.2    ;Enable ligado em P1.2

LED1    equ     P3.7    ; LED1 em P1.7
LED2    equ     P3.6    ; LED2 em P1.6
LED3    equ     P3.5    ; LED3 em P1.5
LED4    equ     P3.4    ; LED4 em P1.4
LED5    equ     P3.3    ; LED5 PARA P1.3

;INCIA CÓDIGO
ACALL lcd_init

;------------------
INICIAR_JOGO: ;main
	;chamei game1 e 2 para printar no lcd
	ACALL GAME1
	ACALL GAME2
    ACALL SEQ_1
	ACALL Escreve_MSGM_INTRA_GAME
	ACALL Escreve_MSGM_INTRA_GAME_LN2
	ACALL MOSTRA_SEQ1
	ACALL ESPERA_ENTRADA
	ACALL COMPARA_SEQ
	SJMP $
   
;--------------------------------------
GAME1:
	;usa a lógica já utilizada em aula
	ACALL Escreve_MSGM_INICIOGAME1
	MOV R4, #1H	
	ACALL DELAY_LOOP ;delay de 100
	RET
	
GAME2:
	ACALL Escreve_MSGM_INICIOGAME2
	ACALL clearDisplay
	RET
	

COMPARA_SEQ:
	;compara o #30 com o #40
	MOV R0, #30H
	MOV R1, #40H
	MOV R7, #5 ;limitar em apenas 5 comparações
	
LOOP_COMPARA:
	MOV A, @R0 ;movo para a os valores de #30 que estão em r0
	MOV B, @R1 ;movo para r1 os valores de #40 que estão em r1
	INC R0 ;pula pro próximo
	INC R1
	CJNE A, B, ERROU ;se igual continua se não error
	DJNZ R7, LOOP_COMPARA ;continua até o x5
	ACALL ACERTOU ; chama o display acertou
	RET
	


ERROU:
	ACALL ESCREVE_MSGM_ERROU
	MOV R4, #10H	;delay maior
	ACALL DELAY_LOOP
	ACALL clearDisplay
	MOV R4, #10
	ACALL DELAY_LOOP
	LJMP INICIAR_JOGO

ACERTOU:
	ACALL ESCREVE_MSGM_GANHOU
	MOV R4, #10H	;delay maior
	ACALL DELAY_LOOP
	ACALL clearDisplay
	MOV R4, #10
	ACALL DELAY_LOOP
	RET
;----------------------------
pisca_LED1:
    CLR LED1            ; Acende LED 1
	MOV R4, #05			;loop simples x5
	ACALL DELAY_LOOP
	SETB LED1
	RET

pisca_LED2:
    CLR LED2            ; Acende LED 2
	MOV R4, #05			;loop simples x5
	ACALL DELAY_LOOP
	SETB LED2
	RET

pisca_LED3:
    CLR LED3            ; Acende LED 3
	MOV R4, #05 		;loop simples x5
	ACALL DELAY_LOOP
	SETB LED3
	RET

pisca_LED4:
    CLR LED4            ; Acende LED 4
	MOV R4, #05 	;loop simples x5
	ACALL DELAY_LOOP ;loop simples
	SETB LED4
	RET
	
pisca_LED5:
    CLR LED5            ; Acende LED 4
	MOV R4, #05 	;loop simples x5
	ACALL DELAY_LOOP ;loop simples
	SETB LED5
	RET

;estamos jogando no endereço 30. para fazer a comparação com o 40.
;por meio de uma sequencia fixa.
SEQ_1:
	MOV 30H, #03 
	MOV 31H, #04
	MOV 32H, #02
	MOV 33H, #01
	MOV 34H, #05
	RET

SEQ_2:
	MOV 30H, #01
	MOV 31H, #04
	MOV 32H, #02
	MOV 33H, #03
	MOV 34H, #05
	RET
	
MSGM_INICIAR_GAME1:
  DB "ACERTE!"
  DB 00h
MSGM_INICIAR_GAME2:  
  DB "A SEQUENCIA"
  DB 00h
MSGM_INTRA_GAME:
  DB "REPITA A"
  DB 00h
MSGM_INTRA_GAME_LN2:
  DB "SEQUENCIA"
  DB 00h
 

MSGM_ERROU:
  DB "PERDEU!"
  DB 00h 

MSGM_GANHOU:
  DB "GANHOU!"
  DB 00h 
  
;---------------------------
Escreve_MSGM_GANHOU:
	ACALL clearDisplay
	;delayzinho
		MOV R4, #02 	;loop simples 
		ACALL DELAY_LOOP ;loop simples
	;
	MOV A, #04h
	ACALL posicionaCursor
	MOV DPTR,#MSGM_GANHOU           
	ACALL escreveStringROM
	RET

Escreve_MSGM_ERROU:
	ACALL clearDisplay
	;delayzinho
		MOV R4, #02 	;loop simples x5
		ACALL DELAY_LOOP ;loop simples
	;
	MOV A, #04h
	ACALL posicionaCursor
	MOV DPTR,#MSGM_ERROU            
	ACALL escreveStringROM
	RET
;---------------------------

;START CODE
Escreve_MSGM_INICIOGAME1:
	MOV A, #04h ;CIMA 
	ACALL posicionaCursor
	MOV DPTR,#MSGM_INICIAR_GAME1          
	ACALL escreveStringROM
	RET
	
Escreve_MSGM_INICIOGAME2:
	MOV A, #42h ;BAIXO
	ACALL posicionaCursor
	MOV DPTR,#MSGM_INICIAR_GAME2           
	ACALL escreveStringROM
	RET
	
Escreve_MSGM_INTRA_GAME:
	MOV A, #04h ;CIMA 
	ACALL posicionaCursor
	MOV DPTR,#MSGM_INTRA_GAME           	
	ACALL escreveStringROM
	RET
	
Escreve_MSGM_INTRA_GAME_LN2:
	MOV A, #43h ;BAIXO 
	ACALL posicionaCursor
	MOV DPTR,#MSGM_INTRA_GAME_LN2 
	ACALL escreveStringROM
	RET
	


;mostrar no led
;sequencia 1.
MOSTRA_SEQ1:
	ACALL PISCA_LED3
	ACALL PISCA_LED4
	ACALL PISCA_LED2
	ACALL PISCA_LED1
	ACALL PISCA_LED5
    RET
    
MOSTRA_SEQ2:
	ACALL PISCA_LED1
	ACALL PISCA_LED4
	ACALL PISCA_LED2
	ACALL PISCA_LED3
	ACALL PISCA_LED5
    RET
	

ESPERA_ENTRADA:
    MOV R0, #40H         ;Armazena no endereço de memoria 40
    MOV R2, #00H         
ESPERA_LOOP:
    JNB P2.7, CAPTURA_TECLA_7
    JNB P2.6, CAPTURA_TECLA_6
    JNB P2.5, CAPTURA_TECLA_5
    JNB P2.4, CAPTURA_TECLA_4
	JNB P2.3, CAPTURA_TECLA_3
    SJMP ESPERA_LOOP

CAPTURA_TECLA_7:
    MOV A, #01H
	ACALL PISCA_LED1
    SJMP ARMAZENA_TECLA

CAPTURA_TECLA_6:
    MOV A, #02H  
	ACALL PISCA_LED2
    SJMP ARMAZENA_TECLA

CAPTURA_TECLA_5:
    MOV A, #03H          
	ACALL PISCA_LED3
    SJMP ARMAZENA_TECLA

CAPTURA_TECLA_4:
    MOV A, #04H          
	ACALL PISCA_LED4
    SJMP ARMAZENA_TECLA
	
CAPTURA_TECLA_3:
    MOV A, #05H          
	ACALL PISCA_LED5
    SJMP ARMAZENA_TECLA

ARMAZENA_TECLA:
    MOV @R0, A          
    INC R0              ; Incrementa o ponteiro de memÃ³ria
    INC R2              ; Incrementa o contador de entradas
    CJNE R2, #05H, ESPERA_LOOP ; Captura 4 entradas, entao sai do loop
    RET

DELAY_LOOP:
	ACALL delay
    DJNZ R4, DELAY_LOOP
    RET

;--------------------------- LCD ------------------------------------------------------------
escreveStringROM:
  MOV R1, #00h

loop:
  MOV A, R1
	MOVC A,@A+DPTR 	 ;lê da memória de programa
	JZ finish		; if A is 0, then end of data has been reached - jump out of loop
	ACALL sendCharacter	; send data in A to LCD module
	INC R1			; point to next piece of data
   MOV A, R1
	JMP loop		; repeat
finish:
	RET

lcd_init:

	CLR RS			
	CLR P1.7		; |
	CLR P1.6		; |
	SETB P1.5		; |
	CLR P1.4		; | high nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CALL delay		

	SETB EN		; |
	CLR EN		; | negative edge on E
					; same function set high nibble sent a second time

	SETB P1.7		; low nibble set (only P1.7 needed to be changed)

	SETB EN		; |
	CLR EN		; | negative edge on E
				; function set low nibble sent
	CALL delay		; wait for BF to clear

	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	CLR P1.4		; | high nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	SETB P1.6		; |
	SETB P1.5		; |low nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CALL delay		; wait for BF to clear

	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	CLR P1.4		; | high nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	SETB P1.7		; |
	SETB P1.6		; |
	SETB P1.5		; |
	SETB P1.4		; | low nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CALL delay		; wait for BF to clear
	RET


sendCharacter:
	SETB RS  		; setb RS - indicates that data is being sent to module
	MOV C, ACC.7		; |
	MOV P1.7, C			; |
	MOV C, ACC.6		; |
	MOV P1.6, C			; |
	MOV C, ACC.5		; |
	MOV P1.5, C			; |
	MOV C, ACC.4		; |
	MOV P1.4, C			; | high nibble set

	SETB EN			; |
	CLR EN			; | negative edge on E

	MOV C, ACC.3		; |
	MOV P1.7, C			; |
	MOV C, ACC.2		; |
	MOV P1.6, C			; |
	MOV C, ACC.1		; |
	MOV P1.5, C			; |
	MOV C, ACC.0		; |
	MOV P1.4, C			; | low nibble set

	SETB EN			; |
	CLR EN			; | negative edge on E

	CALL delay			; wait for BF to clear
	CALL delay			; wait for BF to clear
	RET


;|--------------------------------------------------------------------------------------|
;|linha 1 | 00 | 01 | 02 | 03 | 04 |05 | 06 | 07 | 08 | 09 |0A | 0B | 0C | 0D | 0E | 0F |
;|linha 2 | 40 | 41 | 42 | 43 | 44 |45 | 46 | 47 | 48 | 49 |4A | 4B | 4C | 4D | 4E | 4F |
;|--------------------------------------------------------------------------------------|
posicionaCursor:
	CLR RS	
	SETB P1.7		    ; |
	MOV C, ACC.6		; |
	MOV P1.6, C			; |
	MOV C, ACC.5		; |
	MOV P1.5, C			; |
	MOV C, ACC.4		; |
	MOV P1.4, C			; | high nibble set

	SETB EN			; |
	CLR EN			; | negative edge on E

	MOV C, ACC.3		; |
	MOV P1.7, C			; |
	MOV C, ACC.2		; |
	MOV P1.6, C			; |
	MOV C, ACC.1		; |
	MOV P1.5, C			; |
	MOV C, ACC.0		; |
	MOV P1.4, C			; | low nibble set

	SETB EN			; |
	CLR EN			; | negative edge on E

	CALL delay			; wait for BF to clear
	CALL delay			; wait for BF to clear
	RET


clearDisplay:
	CLR RS	
	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	CLR P1.4		; | high nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	SETB P1.4		; | low nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	MOV R6, #40
	rotC:
	CALL delay		; wait for BF to clear
	DJNZ R6, rotC
	RET

;--------------------------- LCD ------------------------------------------------------------
delay:
	MOV R5, #100
	DJNZ R5, $
	RET
