;ОКНО
okh    EQU  13
okl    EQU  11
       DEFB 7,0,#47,1,0,0,0,0
       DEFW $MHOT
       DEFW WIEN
$OKWI  DEFB 17,0,okh,okl,%1111000,#FF,23,13,1,1,1,1,1,1,1,1,1,1,1
       DEFM "Очистить окно"
       DEFM "Создать окно"
       DEFB 13
       DEFM "Цвет окна"
       DEFB 13
       DEFM "Масштаб"
       DEFB 13
       DEFM "Двигать (0;0)"
       DEFM "Деления "
$DIG01 DEFM "√"
       DEFB 13
       DEFM "Инверсия "
$TOG01 DEFM "-"
       DEFB 13
       DEFM "Очищать "
$AUT01 DEFM "√"
       DEFB 13
       DEFM "Поворот "
$ROTAT DEFM "-"
       DEFB 13
       DEFM "Инверт. оси"
       DEFB 13
       DEFM "Растянуть"
       DEFB 3
WIEN   DEFW CLEAR,CREATE,COLORm,SCALEm,MOVE0m,DIGITS,TOGGLE,AUTO,ROTATE,IA,RESC

CLEAR  CALL $PUTW
       CALL $CLERK
       JP   $MLOOP
$CLERK LD   IX,$WINDG
       LD   C,#61
       XOR  A
       RST  16
       JP   $DR_AX

CREATE CALL $PUTW
       LD   HL,CRHELP
       CALL $UPPRN
       LD   IX,EDWIN
100$   CALL XORWI
       LD   C,7
       RST  16
       PUSH AF
       CALL XORWI
       POP  AF
       CP   "p"
       JR   NZ,1$
       LD   A,(IX)
       ADD  A,(IX+3)
       CP   32
       JR   Z,100$
       INC  (IX)
       JR   100$
1$     CP   "a"
       JR   NZ,2$
       LD   A,(IX+1)
       ADD  A,(IX+2)
       CP   24
       JR   Z,100$
       INC  (IX+1)
       JR   100$
2$     CP   "q"
       JR   NZ,3$
       LD   A,(IX+1)
       DEC  A
       JR   Z,100$
       DEC  (IX+1)
       JR   100$
3$     CP   "o"
       JR   NZ,4$
       LD   A,(IX)
       AND  A
       JR   Z,100$
       DEC  (IX)
       JR   100$
4$     CP   "P"
       JR   NZ,5$
       LD   A,(IX)
       ADD  A,(IX+3)
       CP   32
       JR   Z,100$
       INC  (IX+3)
       JR   100$
5$     CP   "A"
       JR   NZ,6$
       LD   A,(IX+1)
       ADD  A,(IX+2)
       CP   24
       JR   Z,100$
       INC  (IX+2)
101$   JR   100$
6$     CP   "Q"
       JR   NZ,7$
       LD   A,(IX+2)
       CP   2
       JR   Z,100$
       DEC  (IX+2)
       JR   101$
7$     CP   "O"
       JR   NZ,8$
       LD   A,(IX+3)
       CP   2
       JR   Z,101$
       DEC  (IX+3)
       JR   101$
8$     CP   #16
       JP   Z,$MLOOP
       CP   #10
       JP   Z,$MLOOP
       CP   #D
       JR   NZ,101$
       LD   HL,(EDWIN)
       LD   ($WINDG),HL
       LD   HL,(EDWIN+2)
       LD   ($WINDG+2),HL
       LD   IX,$WINDG
       XOR  A
       LD   C,#61
       RST  16
       CALL $IX678
       CALL COLOR
       LD   IX,$WINDG
       LD   C,#61
       LD   A,#FF
       RST  16
       CALL SCALE
       LD   IX,$WINDG
       CALL $DR_AX
       CALL MOVE00
       JP   $MLOOP
XORWI  LD   BC,(EDWIN)
       CALL $ATAD
       LD   A,(EDWIN+3)
       LD   B,A
       LD   (1$+1),A
       LD   A,32
       SUB  B
       LD   E,A
       LD   D,0
       LD   C,(IX+2)
1$     LD   B,0
2$     LD   A,(HL)
       XOR  #3F
       LD   (HL),A
       INC  HL
       DJNZ 2$
       ADD  HL,DE
       DEC  C
       JR   NZ,1$
       RET
COLOR  LD   HL,$PTOP+<okh*okl*9>
       LD   ($GETW+1),HL
       PUSH IX
       LD   IX,COLWI
       CALL $GETW
       LD   C,#61
       XOR  A
       RST  16
       CALL RFR
       LD   C,#91
       RST  16
       CALL RFR
       CALL $PUTW
       LD   HL,$PTOP
       LD   ($GETW+1),HL
       POP  IX
       RET
RFR    LD   A,(paper)
       AND  7
       RLCA
       RLCA
       RLCA
       LD   E,A
       LD   A,(ink)
       AND  7
       OR   E
       LD   E,A
       LD   A,(bright)
       AND  1
       RRCA
       RRCA
       OR   E
       LD   ($WINDG+4),A
       LD   B,A
       LD   A,5
       LD   C,#64
       RST  16
       RET
       DEFB 7,0,#47,1,0,0,0,0
       DEFW COLSP
       DEFW COLEN
COLWI  DEFB 22,3,7,8,%1111000,#FF,31,8,1,1,1,1,0
       DEFM "INK "
ink    DEFB "0",#D
       DEFM "PAPER "
paper  DEFB "6",#D
       DEFM "BRIGHT "
bright DEFB "1",#D
       DEFM "  O.K."
       DEFB #D
       DEFM " color"
       DEFB 3
COLEN  DEFW IINK,IPAP,IBRI,OKCO
COLSP  DEFB #20
       DEFW COLPR
       DEFB #FF
IINK   LD   A,(ink)
       INC  A
iink   AND  7
       ADD  A,"0"
       LD   (ink),A
CEX    CALL RFR
       RET
IPAP   LD   A,(paper)
       INC  A
ipap   AND  7
       ADD  A,"0"
       LD   (paper),A
       JR   CEX
IBRI   LD   A,(bright)
       XOR  "1"!"0"
       LD   (bright),A
       JR   CEX
OKCO   LD   A,#FF
       CP   1
       RET
COLPR  LD   A,(IX-9)
       DEC  A
       JR   NZ,1$
       LD   A,(ink)
       DEC  A
       JR   iink
1$     DEC  A
       JR   NZ,IBRI
       LD   A,(paper)
       DEC  A
       JR   ipap

COLORm CALL COLOR
       CALL $PUTW
       LD   IX,$WINDG
       LD   C,#61
       LD   A,#FF
       RST  16
       JP   $EXOP1
SCALEm CALL $PUTW
       CALL SCALE
       JR   EXOP
MOVE0m
       CALL $PUTW
       CALL MOVE00
EXOP   LD   A,($AUT01)
       CP   "-"
       CALL NZ,$CLERK
       JP   $EXOP1

SCALE  LD   HL,SCHELP
       CALL $UPPRN
       LD   IX,$SCWIN
       CALL $GETW
       CALL $SCALE
       CALL $PUTW
       JP   $MAKEM

MOVE00 LD   HL,M0HELP
       CALL $UPPRN
       LD   IX,$WINDG
       JR   200$
100$   CALL $DR_AX
200$   LD   C,7
       RST  16
       CP   #0D
       RET  Z
       PUSH AF
       CALL $DR_AX
       LD   A,#A1
       LD   (20$),A
       POP  AF
       CP   "o"
       JR   NZ,1$
23$    LD   HL,$XC
22$    LD   A,3
21$    LD   (20$+1),A
       PUSH HL
       CALL $INTO
        CALL $ROM
       RST  #28
20$    DEFB #A1,#03,#38
        CALL $CHIC
       POP  HL
       CALL $OUTFR
       JR   100$
1$     CP   "p"
       JR   NZ,2$
31$    LD   HL,$XC
       LD   A,#F
       JR   21$
2$     LD   HL,$YC
       CP   "a"
       JR   Z,22$
       CP   "q"
       JR   NZ,3$
32$    LD   A,#F
       JR   21$
3$     PUSH AF
       LD   A,#A4
       LD   (20$),A
       POP  AF
       CP   "O"
       JR   Z,23$
       CP   "P"
       JR   Z,31$
       CP   "A"
       JR   Z,22$
       CP   "Q"
       JR   Z,32$
       CP   "c"
       JR   Z,40$
       CP   " "
       JR   NZ,100$
       CALL DIGITS
       JR   100$
40$    LD   HL,$XC
       LD   DE,$XC+1
       LD   BC,9
       LD   (HL),0
       LDIR
       LD   A,(IX+9)
       RRCA
       LD   ($YC+2),A
       LD   A,(IX+8)
       DEC  A
       DEC  A
       RRCA
       LD   ($XC+2),A
       JP   100$

DIGITS LD   A,($DIG01)
       XOR  "√"!"-"
       LD   ($DIG01),A
       RET

ROTATE CALL $PUTW
       LD   IX,$WINDG
       CALL $DR_AX
       LD   A,($ROTAT)
       XOR  "√"!"-"
       LD   ($ROTAT),A
       CALL $DR_AX
       JP   $EXOP1

AUTO   LD   A,($AUT01)
       XOR  "√"!"-"
       LD   ($AUT01),A
       RET

TOGGLE LD   A,($TOG01)
       XOR  "√"!"-"
       LD   ($TOG01),A
       LD   A,($PLOPR)
       XOR  #AE!#B6
       LD   ($PLOPR),A
       LD   A,($LIOPR)
       XOR  #AE!#B6
       LD   ($LIOPR),A
       RET

;ИНВ. ОСИ
IA     CALL $PUTW
       LD   IX,$WINDG
       CALL $DR_AX
       JP   $MLOOP

;РАСТЯНУТЬ
RESC   CALL $PUTW
       LD   IX,$WINDG
       LD   BC,#0101
       LD   DE,#1010
101$   LD   ($COORD),BC
       LD   (LN),DE
100$   CALL SQR
       LD   C,7
       RST  16
       PUSH AF
       CALL SQR
       POP  AF
       LD   BC,($COORD)
       LD   DE,(LN)
       CP   "p"
       JR   NZ,1$
       INC  C
       LD   A,(IX+8)
       SUB  E
       DEC  A
       CP   C
20$    JR   Z,100$
       JR   101$
1$     CP   "o"
       JR   NZ,2$
       DEC  C
       JR   20$
2$     CP   "q"
       JR   NZ,3$
       INC  B
       LD   A,(IX+9)
       SUB  D
       DEC  A
       CP   B
       JR   20$
3$     CP   "a"
       JR   NZ,4$
       DEC  B
       JR   20$
4$
       CP   "P"
       JR   NZ,11$
       INC  E
       LD   A,(IX+8)
       DEC  A
       SUB  C
       CP   E
       JR   20$
11$    CP   "O"
       JR   NZ,12$
       DEC  E
       JR   20$
12$    CP   "A"
       JR   NZ,13$
       DEC  D
       JR   20$
13$    CP   "Q"
       JR   NZ,14$
       INC  D
       LD   A,(IX+9)
       DEC  A
       SUB  B
       CP   D
       JR   20$

14$    CP   #10
       JP   Z,$MLOOP
       CP   #0D
       JR   NZ,100$
       CALL $ROM
       LD   HL,$MX
       PUSH HL
       LD   DE,MX
       LD   BC,10
       LDIR
       POP  HL
       PUSH HL
       CALL $INTO
       LD   A,(LN)
       CALL #2D28
       LD   A,(IX+8)
       DEC  A
       CALL #2D28
       RST  #28
       DEFB 5,4,#38
       POP  HL
       CALL $OUTFR
       LD   HL,$MY
       PUSH HL
       CALL $INTO
       LD   A,(HI)
       CALL #2D28
       LD   A,(IX+9)
       DEC  A
       CALL #2D28
       RST  #28
       DEFB 5,4,#38
       POP  HL
       CALL $OUTFR
       CALL $TOLEN
       CALL $CHIC
       CALL $MAKEM

       CALL $ROM
       LD   HL,MX
       CALL $INTO
       LD   DE,$MX
       LD   HL,$XC
       LD   A,($COORD)
       CALL CC
       LD   HL,MY
       CALL $INTO
       LD   DE,$MY
       LD   HL,$YC
       LD   A,($COORD+1)
       CALL CC

       CALL $CHIC
       CALL $CLERK
       JP   $MLOOP

CC     PUSH HL
       PUSH DE
       CALL $INTO
       CALL #2D28
       RST  #28
       DEFB 3,4,#38
       POP  HL
       CALL $INTO
       RST  #28
       DEFB 5,#27,#38
       POP  HL
       CALL $OUTFR
       RET

MX     DEFS 5
MY     DEFS 5
LN     DEFB 10
HI     DEFB 10
SQR    LD   HL,($COORD)
       PUSH HL
       LD   DE,(LN)
       LD   B,E
       CALL $HORIZ
       LD   B,D
       CALL $VERT
       POP  HL
       PUSH HL
       LD   ($COORD),HL
       LD   B,D
       CALL $VERT
       LD   B,E
       CALL $HORIZ
       POP  HL
       LD   ($COORD),HL
       RET


EDWIN  DEFB 5,5,5,5,7,#FF
CRHELP DEFM "OPQA - движение, CS+OPQA - размер"
       DEFB #D
M0HELP DEFM "OPQA,+CS-движение, SPACE-цифры, C-центр"
       DEFB #D
SCHELP DEFM "OPQA-масштаб, +CS-быстро, SPACE-коррекция"
       DEFB #D
