;Рисование осей координат
$DR_AX CALL $ROM
       LD   A,($PLOPR)
       LD   (DREX+1),A
       LD   A,#AE
       LD   ($PLOPR),A
       LD   A,1
       LD   (OS_XX+1),A
       LD   HL,$YC
       CALL $INTO
       CALL #2DA2
       JP   M,XOUTN
       LD   A,C
       OR   A
       JR   Z,XOUTN
       DEC  A
       LD   (OS_XX+1),A
       LD   A,(IX+9)
       DEC  A
       DEC  A
       CP   C
       JR   C,XOUTW
       LD   E,A
       LD   A,B
       AND  A
       LD   A,E
       JR   NZ,XOUTW
XNOUT
       LD   B,C
       LD   C,0
       CALL $REFOR
       CALL $REFAD
       LD   B,(IX+3)
1$     LD   A,(HL)
       CPL
       LD   (HL),A
       INC  HL
       DJNZ 1$
       JR   XOUTN
XOUTW  LD   (OS_XX+1),A
XOUTN  CALL OS_X

YAX
       LD   A,1
       LD   (OS_YY+1),A
       LD   HL,$XC
       CALL $INTO
       CALL #2DA2
       JP   M,YOUTL
       LD   A,(IX+8)
       DEC  A
       CP   C
       JR   C,YOUTL
       LD   A,B
       AND  A
       JR   NZ,YOUTL
       LD   A,C
       INC  A
       LD   (OS_YY+1),A
       LD   B,0
       CALL $REFOR
       CALL $REFAD
       LD   A,1
       INC  B
1$     RRCA
       DJNZ 1$
       LD   E,A
       LD   C,(IX+2)
2$     LD   B,8
3$     LD   A,(HL)
       XOR  E
       LD   (HL),A
       CALL $P_LIN
       DJNZ 3$
       DEC  C
       JR   NZ,2$
YOUTL  CALL OS_Y
DREX   LD   A,0
       LD   ($PLOPR),A
       JP   $CHIC

;ЦИФИРИ
OS_X   LD   A,($DIG01)
       CP   "√"
       RET  NZ
       LD   A,($ROTAT)
       LD   HL,#073E ;LD A,7
       CP   "√"
       JR   NZ,2$
       LD   A,1
       LD   ($DIREC),A
       LD   HL,0
2$     LD   (DLI),HL
       CALL $INVAR
       LD   HL,$XC
       CALL $INTO
       RST  #28
       DEFB #31,#38
       LD   A,($LENS)
       LD   (OSI2+1),A
       CALL OSI1
       LD   HL,$DLX
       CALL $INTO
       RST  #28
       DEFB #31,#38
       LD   HL,XYH
       CALL $INTO
       RST  #28
       DEFB #4,#0F,#1B,#38
       LD   HL,PROM
       CALL $OUTFR
       LD   A,(XS1)
       LD   C,A
OS_XX  LD   B,0
       CALL $REFOR
       LD   A,(IX+6)
       LD   D,A
       LD   A,(IX+3)
       DEC  A
       ADD  A,A
       ADD  A,A
       ADD  A,A
       ADD  A,D
       LD   (X101+1),A
       LD   A,($XC+2)
       ADD  A,D
       LD   (X102+1),A
       LD   A,C
       JR   X101
OX1
       PUSH BC
       CALL $INVAR
       LD   HL,$DLX
       CALL OSI3
       POP  BC
X102   LD   A,0
       CP   C
       JR   Z,OX2
       PUSH BC
       CALL $PLOTX
       CALL BFNUM
       ADD  A,A
       ADD  A,A
DLI    NOP
       NOP
       ADD  A,B
       LD   B,A
       LD   A,(IX+9)
       LD   E,A
       LD   A,(IX+7)
       ADD  A,E
       SUB  4
       CP   B
       JR   NC,1$
       LD   B,A
1$     CALL $WORD
       POP  BC
OX2
       LD   A,($LENS)
       ADD  A,C
       JR   C,OX4
       LD   C,A
X101   CP   0
       JR   C,OX1
OX4    CALL $OUTFR
       XOR  A
       LD   ($DIREC),A
       RET
PROM   DEFS 6
OSI1   CALL #2D28
       RST  #28
       DEFB #5,#27,#31,#38
       LD   HL,XYH
       CALL $OUTFR
OSI2   LD   A,0
       CALL #2D28
       RST  #28
       DEFB #4,#3,#27,#38
       CALL #2DD5
       LD   (XS1),A
       RET
OSI3   CALL $INTO
       LD   HL,PROM
       CALL $INTO
       RST  #28
       DEFB #0F,#38
       LD   HL,(23653)
       DEC  HL
       DEC  HL
       DEC  HL
       DEC  HL
       DEC  HL
       LD   DE,PROM
       LD   BC,5
       LDIR
       RET
OS_Y   LD   A,($DIG01)
       CP   "√"
       RET  NZ
       CALL $INVAR
       LD   HL,$YC
       CALL $INTO
       RST  #28
       DEFB #31,#38
       LD   A,($LENS+1)
       LD   (OSI2+1),A
       CALL OSI1
       LD   HL,$DLY
       CALL $INTO
       RST  #28
       DEFB #31,#38
       LD   HL,XYH
       CALL $INTO
       RST  #28
       DEFB #4,#0F,#1B,#38
       LD   HL,PROM
       CALL $OUTFR
       LD   A,(XS1)
       LD   B,A
OS_YY  LD   C,0
       CALL $REFOR
       LD   A,(IX+7)
       LD   D,A
       ADD  A,5
       LD   (Y101+1),A
       LD   A,(IX+9)
       ADD  A,D
       LD   E,A
       LD   A,($YC+2)
       SUB  E
       NEG
       DEC  A
       LD   (Y102+1),A
       LD   A,B
       JR   Y101
YO1
       PUSH BC
       CALL $INVAR
       LD   HL,$DLY
       CALL OSI3
       POP  BC
Y102   LD   A,0
       CP   B
       JR   Z,YO2
       PUSH BC
       CALL $PLOTX
       LD   A,C
       ADD  A,5
       LD   C,A
       CALL BFNUM
       CALL $WORD
       POP  BC
YO2
       LD   A,($LENS+1)
       LD   E,A
       LD   A,B
       SUB  E
       JR   C,YO4
       LD   B,A
Y101   CP   0
       JR   NC,YO1
YO4    CALL $OUTFR
ret    RET

;ЧИСЛO ИЗ СТЕКА КАЛЬК. В $BUF В СИМВ. ВИДЕ
;ВЫХОД А-ДЛИНА В СИМВОЛАХ. HL-BUFFER
BFNUM  PUSH BC
       RST  #28
       DEFB #2E,#38
       CALL #2BF1
       LD   HL,$BUF
       PUSH HL
       LD   A,C
       PUSH AF
       EX   DE,HL
       LDIR
       LD   A,#D
       LD   (DE),A
       POP  AF
       POP  HL
       POP  BC
       RET

XS1    DEFB 0
$DLX   DEFB 0,0,1,0,0 ;ДЛИНЫ ДЕЛЕНИЙ
$DLY   DEFB 0,0,1,0,0   ;В ЕДИНИЦАХ
$LENS  DEFW #1414 ;ДЛИНЫ ДЕЛЕНИЙ В ПИКС.

XYH    DEFS 5

$MX    DEFB #7D,#4C,#CC,#CC,#CC ;МАСШТАБЫ
$MY    DEFB #7D,#4C,#CC,#CC,#CC
$XC    DEFB 0,0,124,0,0    ;КООРД (0,0)
$YC    DEFB 0,0,88,0,0
