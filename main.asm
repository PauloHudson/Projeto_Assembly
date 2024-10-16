; --- Mapeamento de Hardware (8051) ---
    RS      equ     P1.3    ;Reg Select ligado em P1.3
    EN      equ     P1.2    ;Enable ligado em P1.2
	


; Liga o led 7
MOV P1.7, C
MOV P2.7, C
MOV P1.6, C
MOV P2.6, C
MOV P1.5, C
MOV P2.5, C

; Da um Delay
ACALL delay

; Desliga o LED
SETB P1.7      ; Desliga o LED 7
SETB P2.7
SETB P1.6      ; Desliga o LED 6
SETB P2.6
SETB P1.5      ; Desliga o LED 5
SETB P2.5


delay:
	MOV R0, #50
	DJNZ R0, $
	RET
