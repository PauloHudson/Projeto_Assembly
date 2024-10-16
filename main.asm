; --- Mapeamento de Hardware (8051) ---
    RS      equ     P1.3    ;Reg Select ligado em P1.3
    EN      equ     P1.2    ;Enable ligado em P1.2



; Liga o led 7
MOV P1.7, C

; Da um Delay
ACALL delay

; Desliga o LED
SETB P1.7      ; Desliga o LED 7




delay:
	MOV R0, #50
	DJNZ R0, $
	RET
