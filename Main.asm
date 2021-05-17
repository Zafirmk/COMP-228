ORG 00 ; Instruction for Assembler: Start Code in Memory
MOV P3, #16d ; Moves 16d to P3 (USER INPUT)
MOV A, P3 ; Saves P3 in accumulator
MOV DPTR, #DelayLookup ; Set DPTR to DelayLookup
MOVC A, @A+DPTR ; Indexes to corresponding frequency entered by user
CLR P3.4 ; Clear P3.4
CLR P3.5 ; Clear P3.5
SETB P3.4 ;Set P3.4 to 1 (USER INPUT)

JNB P3.4, CHECKOTHERFALSE ; Jump to CHECKOTHERFALSE if P3.4 = 0
JB P3.4, CHECKOTHERTRUE ; Jump to CHECKOTHERTRUE if P3.4 = 1

CHECKOTHERFALSE:
JB P3.5, RECTANGULAR ; Jump to RECTANGULAR if P3.5 = 1
JNB P3.5, LOGICZERO ; Jump to LOGICZERO if P3.5 = 0

CHECKOTHERTRUE:
JB P3.5, TRIANGULAR ; Jump to TRIANGULAR if P3.5 = 1
JNB P3.5, SAWTOOTH ; Jump to SAWTOOTH if P3.5 = 0

RECTANGULAR:
CONTINUE:
MOV R1, #0FFH ; Moves 0FFH to R1
MOV P1, R1 ; Saves R1 in P1
ACALL DELAY ; Calling Delay
MOV R1, #00H ; Move 00H to R1
MOV P1, R1 ; Saves R1 in P1
ACALL DELAY ; Calling DELAY
SJMP CONTINUE ; Jump to CONTINUE

SAWTOOTH:
OUTERLOOP:
ACALL DELAY ; Calling DELAY
MOV A, #0FFH ; Moves 0FFH to A
INNERLOOP:
MOV P1, A ; Saves A in P1
DEC A ; Decrementing A by 1
CJNE A, #00H, INNERLOOP ; Jump to INNERLOOP if A != 00H
SJMP OUTERLOOP ; Jump to OUTERLOOP

TRIANGULAR:
MOV A, #00H ; Moves 00H to A
REPEAT:
INCREMENT:
MOV P1, A ; Saves A in P1
INC A ; Incrementing A by 1
CJNE A, #0FFH, INCREMENT ; Jump to INCREMENT if A != 0FFH
ACALL DELAY ; Calling DELAY
DECREMENT:
MOV P1, A ; Saves A in P1
DEC A ; Decrementing A by 1
CJNE A, #00H, DECREMENT ; Jump to DECREMENT if A != 00H
ACALL DELAY ;Calling DELAY
SJMP REPEAT ; Jump to REPEAT

LOGICZERO:
MOV A, #00H ; Move 00H to A
MOV P1, A ; Saves A in P1
SJMP LOGICZERO ; Jump to LOGICZERO

DELAY:
MOV TH1, A ; Timer is Initialized with accumulator value
MOV TMOD, #00100000b ; Timer 1 is set for mode 2
SETB TR1 ; Start Timer 1

LOOP:
JNB TF1, LOOP ; Jump to LOOP if TF1 is 0
CLR TF1 ; Clear Overflow Flag

;Stores all the hexadecimal equivalent delays for various frequencies in the range of 1KHz to 16KHz
DelayLookup:
DB 0, 0xFF31, 0x19, 0x66, 0x8C, 0xA3, 0xB3, 0xBE, 0xC6, 0xCC, 0xD2, 0xD6, 0xD9, 0xDC, 0xDF,
0xE1, 0xE3

END