; --- Mapeamento de Hardware (8051) ---
RS      equ     P1.3    ; Reg Select para o display LCD
EN      equ     P1.2    ; Enable para o display LCD
LED1    equ     P1.7    ; LED1 em P1.7
LED2    equ     P1.6    ; LED2 em P1.6
LED3    equ     P1.5    ; LED3 em P1.5
LED4    equ     P1.4    ; LED4 em P1.4

; Variáveis e Início
ORG 0H
LJMP CONFIG           ; Salta para a configuração inicial

; Interrupção externa para iniciar o jogo
INT_EXT0:
    AJMP INICIAR_JOGO
    RETI

; Configuração de Timer
ORG 000Bh
INT_TEMP0:  
    MOV TH0, #0 
    MOV TL0, #0 
    RETI

; --- Funções Auxiliares ---
; Função para acender LEDs da sequência gerada
ACENDE_LED:
    MOV A, R1           ; Carrega o valor da sequência gerada
    CJNE A, #01H, PROX_LED1
    SETB LED1            ; Acende LED 1
	ACALL DELAY_LONGO
	CLR LED1

PROX_LED1:
    CJNE A, #02H, PROX_LED2
    SETB LED2            ; Acende LED 2
	ACALL DELAY_LONGO
	CLR LED2

PROX_LED2:
    CJNE A, #03H, PROX_LED3
    SETB LED3            ; Acende LED 3
	ACALL DELAY_LONGO
	CLR LED3

PROX_LED3:
    CJNE A, #04H, FIM_LED
    SETB LED4            ; Acende LED 4
	ACALL DELAY_LONGO
	CLR LED4

FIM_LED:

DELAY_LED:
    ACALL DELAY_LONGO   
    CLR LED1
	ACALL DELAY_MAIOR 
    CLR LED2
	ACALL DELAY_MAIOR 
    CLR LED3
	ACALL DELAY_MAIOR 
    CLR LED4
	ACALL DELAY_MAIOR 
    RET

; Função de delay longo para dar tempo entre os LEDs
DELAY_LONGO:
    MOV R2, #60000     ; Ajusta o delay

DELAY_MAIOR:
    MOV R2, #150000    ; Ajusta o delay

DELAY_LONGO_LOOP:
    DJNZ R2, DELAY_LONGO_LOOP
    RET
	
DELAY:
	MOV R3, #100
    DJNZ R3, $           ; Delay simples
    RET

; Função para exibir "GANHOU" no display LCD
EXIBE_MSG_GANHOU:
    ACALL CLEAR_LCD
    MOV A, #'G'
    ACALL SEND_CHAR_LCD
    MOV A, #'A'
    ACALL SEND_CHAR_LCD
    MOV A, #'N'
    ACALL SEND_CHAR_LCD
    MOV A, #'H'
    ACALL SEND_CHAR_LCD
    MOV A, #'O'
    ACALL SEND_CHAR_LCD
    MOV A, #'U'
    ACALL SEND_CHAR_LCD
    RET

; Função para exibir "ERROU" no display LCD
EXIBE_MSG_ERROU:
    ACALL CLEAR_LCD
    MOV A, #'E'
    ACALL SEND_CHAR_LCD
    MOV A, #'R'
    ACALL SEND_CHAR_LCD
    MOV A, #'R'
    ACALL SEND_CHAR_LCD
    MOV A, #'O'
    ACALL SEND_CHAR_LCD
    MOV A, #'U'
    ACALL SEND_CHAR_LCD
    RET

; --- Funções Principais ---
INICIAR_JOGO:
    ; Gera uma sequência aleatória
    ACALL GERA_SEQUENCIA_ALEATORIA
    ; Exibe a sequência para o jogador
    MOV R0, #00H         ; Reseta contador
	
MOSTRA_SEQ:
	ACALL DELAY_LONGO     ; Delay maior entre a exibição da sequência e a próxima interação
    MOV R1, #30H         ; Inicializa o ponteiro
    MOV A, @R1           ; Carrega o valor da sequência gerada (via @R1)
    ACALL ACENDE_LED     ; Acende o LED correspondente
    INC R1
    CJNE R0, #04H, MOSTRA_SEQ 
	
    ACALL ESPERA_ENTRADA  ; Espera o jogador inserir a sequência
    ACALL COMPARA_SEQ     ; Compara a sequência inserida
    RET

; Função para gerar sequência aleatória
GERA_SEQUENCIA_ALEATORIA:
    MOV R0, #04H
    MOV R1, #30H        ; Endereço inicial para armazenar a sequência gerada
	
GERA_LOOP:
	MOV A, TL0
    MOV B, #04H         ; Mod 4 para gerar números aleatórios entre 1 e 4
    DIV AB
	INC B
    MOV @R1, B          ; Armazena o valor gerado
    INC R1
    DJNZ R0, GERA_LOOP
    RET

; Função para comparar a sequência gerada com a entrada do usuário
COMPARA_SEQ:
    MOV R1, #30H        ; Endereço inicial da sequência armazenada
    MOV R0, #40H        ; Endereço inicial da entrada do usuário
COMPARA_LOOP:
    MOV A, @R1
    MOV B, @R0
    CJNE A, B, ERRO     ; Se houver diferença, vai para ERRO
    INC R1
    INC R0
    CJNE R1, #34H, COMPARA_LOOP ; Compara até 4 elementos
    SJMP GANHOU

ERRO:
    ACALL EXIBE_MSG_ERROU
    RET

GANHOU:
    ACALL EXIBE_MSG_GANHOU
    RET

; Função para limpar o display LCD
CLEAR_LCD:
    CLR RS
    CLR P1.7
    CLR P1.6
    CLR P1.5
    CLR P1.4
    SETB EN
    CLR EN
    ACALL DELAY
    RET

; Função para enviar caracteres para o LCD
SEND_CHAR_LCD:
    SETB RS
    MOV P1, A            ; Envia o dado para P1 (display LCD)
    SETB EN
    CLR EN
    ACALL DELAY
    RET

; Função para esperar pela entrada do usuário
ESPERA_ENTRADA:
    MOV R0, #40H         ; Inicializa o ponteiro para a entrada do usuário
    MOV R2, #00H         ; Reseta contador
ESPERA_LOOP:
       ; Aqui você deve implementar a lógica de captura da entrada real do usuário
    JNB P2.7, CAPTURA_TECLA_7
    JNB P2.6, CAPTURA_TECLA_6
    JNB P2.5, CAPTURA_TECLA_5
    JNB P2.4, CAPTURA_TECLA_4
    SJMP ESPERA_LOOP

CAPTURA_TECLA_7:
    MOV A, #01H          ; Valor que representa a tecla P2.7 pressionada (LED 1)
    SJMP ARMAZENA_TECLA

CAPTURA_TECLA_6:
    MOV A, #02H          ; Valor que representa a tecla P2.6 pressionada (LED 2)
    SJMP ARMAZENA_TECLA

CAPTURA_TECLA_5:
    MOV A, #03H          ; Valor que representa a tecla P2.5 pressionada (LED 3)
    SJMP ARMAZENA_TECLA

CAPTURA_TECLA_4:
    MOV A, #04H          ; Valor que representa a tecla P2.4 pressionada (LED 4)
    SJMP ARMAZENA_TECLA

ARMAZENA_TECLA:
    MOV @R0, A          ; Armazena o valor da tecla pressionada em memória
    INC R0              ; Incrementa o ponteiro de memória
    INC R2              ; Incrementa o contador de entradas
    CJNE R2, #04H, ESPERA_LOOP ; Captura 4 entradas, então sai do loop
    RET

; Configuração inicial
CONFIG:
    MOV TMOD, #02H       ; Configura Timer 0 no modo 2
    MOV TH0, #0          ; Inicia o valor do Timer
    MOV TL0, #0
    SETB TR0             ; Inicia o Timer
    SETB EX0             ; Habilita a interrupção externa 0
    SETB ET0             ; Habilita interrupção do Timer 0
    SETB EA              ; Habilita interrupções gerais
    SJMP $


END
