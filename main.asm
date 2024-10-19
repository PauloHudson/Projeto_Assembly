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
    ; Aqui você pode colocar o código que lê o teclado numérico
    ; Para simplificação, vamos apenas retornar um valor fixo, como simulação.
    
    MOV A, #01H  ; Simula a entrada de um valor de tecla, como '1'
    RET          ; Retorna para o código chamador

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
    ; Colocar feedback de erro aqui
    JMP START

ACERTO:
    ; Colocar feedback de acerto aqui
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
