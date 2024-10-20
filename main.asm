; --- Mapeamento de Hardware (8051) ---
    RS      equ     P1.3    ;Reg Select ligado em P1.3
    EN      equ     P1.2    ;Enable ligado em P1.2
    LED1    equ     P1.7    ; LED ligado no P1.7
    LED2    equ     P1.6    ; LED ligado no P1.6
    LED3    equ     P1.5    ; LED ligado no P1.5
    LED4    equ     P1.4    ; LED ligado no P1.4

; Variáveis
    ORG 0H
    MOV SP, #60H           ; Inicializa stack pointer
    MOV R0, #00H           ; Contador para sequência
    MOV DPTR, #SEQUENCE    ; Ponteiro para sequência de LEDs
    MOV A, #0              ; Zera o acumulador

START:
    ; Sequência de LEDs gerada (pode ser aleatória ou fixa para simplificar)
    MOV A, #1
    ACALL mostraSequencia

    ; Espera entrada do usuário
    MOV R0, #00H           ; Reseta contador de entrada
    ACALL lerEntrada

    ; Verifica se a entrada é correta
    ACALL verificaSequencia

    ; Repete o ciclo
    SJMP START

; --- Função para mostrar a sequência de LEDs ---
mostraSequencia:
    MOV R0, #00H           ; Reseta contador
    MOV DPTR, #SEQUENCE    ; Ponteiro para sequência de LEDs

MOSTRAR:
    MOVC A, @A+DPTR    
	MOV R4, A      ; Carrega o próximo valor da sequência
    ACALL acendeLED        ; Acende o LED correspondente
    ACALL delay            ; Delay entre os LEDs
    INC DPTR               ; Próximo LED na sequência
    INC R0                 ; Incrementa contador
    CJNE R0, #04, MOSTRAR  ; Mostra 4 LEDs (ou quantos quiser)
    RET

; --- Função para ler a entrada do jogador ---
leituraTeclado:
 MOV A, P1              ; Lê o valor da porta P1
    ANL A, #0F0H          ; Máscara para considerar apenas os LEDs (P1.4 a P1.7)
    
    ; Agora vamos verificar qual tecla foi pressionada
    CJNE A, #80H, TECLA1   ; Verifica se a tecla 1 foi pressionada (P1.7 = 1)
    MOV R0, #01H           ; Tecla 1 pressionada
    RET
    
TECLA1:
    CJNE A, #40H, TECLA2   ; Verifica se a tecla 2 foi pressionada (P1.6 = 1)
    MOV R0, #02H           ; Tecla 2 pressionada
    RET

TECLA2:
    CJNE A, #20H, TECLA3   ; Verifica se a tecla 3 foi pressionada (P1.5 = 1)
    MOV R0, #03H           ; Tecla 3 pressionada
    RET

TECLA3:
    CJNE A, #10H, NENHUMA  ; Verifica se a tecla 4 foi pressionada (P1.4 = 1)
    MOV R0, #04H           ; Tecla 4 pressionada
    RET

NENHUMA:
    MOV R0, #00H           ; Nenhuma tecla pressionada
    RET

;------------------------------------
lerEntrada:
    MOV R0, #00H           ; Reseta contador de entrada
LER:
    ACALL leituraTeclado   ; Lê o teclado numérico
    MOV A, R0              ; Carrega o valor de R0 no acumulador
    CJNE A, #00H, STORE_R0 ; Se R0 não for zero, pula para STORE_R0
    MOV R0, A              ; Se R0 for zero, armazena valor de A

STORE_R0:
    MOVX A, @DPTR     
	MOV B, A   
	MOV A, R1   ; Carrega o valor da memória apontada por DPTR
    CJNE A, B, ERRO      ; Compara valor de A com o valor armazenado em R1 (RAM)
    SJMP NEXT

STORE_R1:
    CJNE R0, #02H, STORE_R2
    MOV R2, A              ; Armazena valor em R2
    SJMP NEXT

STORE_R2:
    MOV R3, A              ; Armazena valor em R3

NEXT:
    INC R0                 ; Incrementa contador
    CJNE R0, #04, LER      ; Continua a leitura até 4 entradas
    RET





;----------------

; --- Função para verificar a sequência ---
verificaSequencia:
    MOV R0, #00H           ; Reseta contador
    MOV DPTR, #SEQUENCE    ; Ponteiro para sequência correta

VERIFICAR:
    MOVX A, @DPTR          ; Carrega valor da sequência
    CJNE R0, #00H, CHECK_R0
   
    SJMP NEXT_CHECK

CHECK_R0:
    CJNE R0, #01H, CHECK_R1
	MOV B, A              
    MOV A, R1
    CJNE A, B, ERRO
    SJMP NEXT_CHECK

CHECK_R1:
    CJNE R0, #02H, CHECK_R2
	MOV B,A
	MOV A, R2
    CJNE A, B, ERRO
    SJMP NEXT_CHECK

CHECK_R2:
	MOV B, A
	MOV A, R3
    CJNE A, B, ERRO

NEXT_CHECK:
    INC DPTR               ; Próximo valor da sequência
    INC R0                 ; Próximo valor da entrada
    CJNE R0, #04, VERIFICAR ; Verifica 4 valores
    JMP ACERTO             ; Se a sequência estiver correta, pula para acerto

ERRO:
	ACALL EXIBE_MSG_PERDEU
    JMP START

ACERTO:
    ACALL EXIBE_MSG_GANHOU
    RET

; --- Função para acender um LED ---
acendeLED:
    MOV A, R4            ; Carrega valor da sequência de LEDs
    CJNE A, #01H, PROX_LED1
    SETB LED1              ; Acende o LED 1
    SJMP DELAY_LED

PROX_LED1:
    CJNE A, #02H, PROX_LED2
    SETB LED2              ; Acende o LED 2
    SJMP DELAY_LED

PROX_LED2:
    CJNE A, #03H, PROX_LED3
    SETB LED3              ; Acende o LED 3
    SJMP DELAY_LED

PROX_LED3:
    CJNE A, #04H, DELAY_LED
    SETB LED4              ; Acende o LED 4

DELAY_LED:
    ACALL delay
    CLR LED1
    CLR LED2
    CLR LED3
    CLR LED4
    RET

; --- Função de Delay ---
delay:
    MOV R0, #50
    DJNZ R0, $             ; Delay simples
    RET

; --- Sequência fixa (pode ser aleatória) ---
SEQUENCE: DB 01H, 02H, 03H, 04H





;#########################################
;										 ;
;										 ;
;   AQUI INICIA A LOGICA DE USAR O LCD   ;
;										 ;
;										 ;
;#########################################

;CREDITOS DE USO: toda a parte de configuração do LDC foi pega do exemplo passado via MOODLE: "Aula10_01-LCD.asm"


lcd_init:

	CLR RS

	CLR P1.7		
	CLR P1.6		
	SETB P1.5		
	CLR P1.4		

	SETB EN		
	CLR EN		

	CALL delay		
					
	SETB EN		
	CLR EN		
					

	SETB P1.7		

	SETB EN		
	CLR EN		
				
	CALL delay		

	CLR P1.7		
	CLR P1.6		
	CLR P1.5		
	CLR P1.4		

	SETB EN		
	CLR EN		

	SETB P1.6		
	SETB P1.5		

	SETB EN		
	CLR EN		

	CALL delay


; display on/off control
; the display is turned on, the cursor is turned on and blinking is turned on
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
	SETB RS  		
	MOV C, ACC.7	
	MOV P1.7, C		
	MOV C, ACC.6	
	MOV P1.6, C		
	MOV C, ACC.5	
	MOV P1.5, C			
	MOV C, ACC.4		
	MOV P1.4, C			

	SETB EN			
	CLR EN			

	MOV C, ACC.3		
	MOV P1.7, C			
	MOV C, ACC.2		
	MOV P1.6, C			
	MOV C, ACC.1		
	MOV P1.5, C			
	MOV C, ACC.0		
	MOV P1.4, C		

	SETB EN			
	CLR EN			

	CALL delay			
	RET

;Posiciona o cursor na linha e coluna desejada.
;Escreva no Acumulador o valor de endereço da linha e coluna.
;|--------------------------------------------------------------------------------------|
;|linha 1 | 00 | 01 | 02 | 03 | 04 |05 | 06 | 07 | 08 | 09 |0A | 0B | 0C | 0D | 0E | 0F |
;|linha 2 | 40 | 41 | 42 | 43 | 44 |45 | 46 | 47 | 48 | 49 |4A | 4B | 4C | 4D | 4E | 4F |
;|--------------------------------------------------------------------------------------|
posicionaCursor:
	CLR RS	         
	SETB P1.7		    
	MOV C, ACC.6		
	MOV P1.6, C			
	MOV C, ACC.5		
	MOV P1.5, C			
	MOV C, ACC.4		
	MOV P1.4, C			

	SETB EN			
	CLR EN			

	MOV C, ACC.3	
	MOV P1.7, C		
	MOV C, ACC.2	
	MOV P1.6, C		
	MOV C, ACC.1	
	MOV P1.5, C		
	MOV C, ACC.0	
	MOV P1.4, C		

	SETB EN			
	CLR EN			

	CALL delay			
	RET


;Retorna o cursor para primeira posição sem limpar o display
retornaCursor:
	CLR RS	      
	CLR P1.7		
	CLR P1.6		
	CLR P1.5		
	CLR P1.4		

	SETB EN		
	CLR EN		

	CLR P1.7		
	CLR P1.6		
	SETB P1.5		
	SETB P1.4		

	SETB EN		
	CLR EN		

	CALL delay		
	RET


clearDisplay:
	CLR RS	      
	CLR P1.7		
	CLR P1.6		
	CLR P1.5		
	CLR P1.4	

	SETB EN		
	CLR EN		

	CLR P1.7	
	CLR P1.6	
	CLR P1.5	
	SETB P1.4		

	SETB EN		
	CLR EN		

	CALL delay		
	RET



EXIBE_MSG_GANHOU:
	acall lcd_init
	mov A, #06h
	ACALL posicionaCursor 
	MOV A, #'G'
	ACALL sendCharacter	
	MOV A, #'A'
	ACALL sendCharacter	
	MOV A, #'N'
	ACALL sendCharacter	
	MOV A, #'H'
	ACALL sendCharacter	
	MOV A, #'O'
	ACALL sendCharacter	
	MOV A, #'U'
	ACALL sendCharacter	
	ACALL retornaCursor
	JMP $


EXIBE_MSG_PERDEU:
	acall lcd_init
	mov A, #06h
	ACALL posicionaCursor 
	MOV A, #'P'
	ACALL sendCharacter	
	MOV A, #'E'
	ACALL sendCharacter	
	MOV A, #'R'
	ACALL sendCharacter	
	MOV A, #'D'
	ACALL sendCharacter	
	MOV A, #'E'
	ACALL sendCharacter	
	MOV A, #'U'
	ACALL sendCharacter	
	ACALL retornaCursor
	JMP $
