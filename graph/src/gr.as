;   Построение графика функции

;$BUF - стартовый адрес текста функции
;($EXP1) - длина текста с ВК
;IX - вектор окна
;$MX - 5 байтов масштаб по x: кол-во еди-
; ниц в одном пикселе
;$MY - 5 байтов масштаб по y
;$XC - 5 байтов координата x начала коор-
; динат в условных единицах относительно
; левого нижнего угла окна
;$YC - 5 байтов координата y нач. коорд.
; формат функции:
;   sin x,[0;100)
;   cos x,(-&,10] ,где &-бесконечность

; требуются модули gfx.obj и mathgr.obj

$GR    LD   A,3
       LD   (FLAG2),A

       LD   HL,0
       LD   ($X),HL
       LD   ($X+2),HL
       LD   ($INTEG),HL
       LD   ($INTEG+2),HL
       LD   ($COORD),HL
       XOR  A
       LD   ($X+4),A
       LD   ($INTEG+4),A
       LD   HL,$BUF
       LD   BC,($EXP1)
       LD   A,#2C
200$   CPIR
       JP   NZ,P1
       LD   A,(HL)
       INC  HL
       CP   #D
       JP   Z,P1
       CP   "("
       JR   Z,25$
       CP   "]"
       JR   Z,25$
       CP   "["
       JR   NZ,200$
20$    PUSH HL
       CALL 222$
       PUSH HL
       JR   C,41$
       LD   HL,FLAG2
       RES  0,(HL)
       JR   41$
25$    PUSH HL
       CALL 222$
       PUSH HL
       JR   C,41$
       LD   HL,FLAG2
       RES  0,(HL)
        CALL $ROM
       LD   HL,$MX
       CALL $INTO
       RST  #28
       DEFB #0F,#38
        CALL $CHIC
41$    LD   HL,$X
       CALL $OUTFR
       POP  HL
       LD   DE,$PTOP+#600
       LD   BC,0
42$    LD   A,(HL)
       LD   (DE),A
       INC  HL
       INC  DE
       INC  BC
       CP   "]"
       JR   Z,43$
       CP   ")"
       JR   Z,44$
       CP   "["
       JR   NZ,42$
44$    CALL 111$
       JR   C,49$
       LD   HL,FLAG2
       RES  1,(HL)
49$    LD   HL,$X2
       CALL $OUTFR
       POP  HL
       DEC  HL
       DEC  HL
       LD   (HL),#D
       LD   DE,$BUF-2
       SBC  HL,DE
       LD   ($EXP1),HL
       JR   P1
43$    CALL 111$
       JR   C,49$
       LD   HL,FLAG2
       RES  1,(HL)
        CALL $ROM
       LD   HL,$MX
       CALL $INTO
       RST  #28
       DEFB #0F,#38
        CALL $CHIC
       JR   49$
111$   DEC  DE
       LD   A,#D
       LD   (DE),A
       LD   DE,$PTOP+#600
        CALL $ROM
       CALL $CALC
        CALL $CHIC
       RET
222$   LD   DE,$PTOP+#600
       LD   BC,0
32$    LD   A,(HL)
       LD   (DE),A
       INC  HL
       INC  DE
       INC  BC
       CP   ","
       JR   Z,31$
       CP   ";"
       JR   Z,31$
       JR   32$
31$    PUSH HL
       CALL 111$
       POP  HL
       RET
P1
;1)
       CALL $INVAR
       LD   A,%0010
       LD   HL,FLAG
       LD   (HL),A

       INC  HL
       LD   (HL),0
       LD   A,(IX+8)
       DEC  A
       INC  HL
       INC  HL
       LD   (HL),A
       INC  HL
       LD   A,(IX+9)
       LD   (HL),A
       CALL $ROM
       LD   A,(FLAG2)
       AND  1
       JR   NZ,1$

       LD   HL,$X
       CALL XR2X
       JP   M,1$
       LD   A,B
       AND  A
       RET  NZ
       LD   HL,XMAX
       LD   A,C
       CP   (HL)
       RET  NC
       LD   (X),A
       JR   2$
1$
       LD   HL,$XC
       CALL $INTO
       LD   HL,$MX
       CALL $INTO
       LD   HL,3$
       CALL $INIER
       RST  #28
       DEFB 4,#1B,#38
       LD   HL,$X
       CALL $OUTFR
2$     LD   A,(FLAG2)
       AND  2
       JR   NZ,3$
       LD   HL,$X2
       CALL XR2X
       RET  M
       LD   A,B
       AND  A
       JR   NZ,3$
       LD   HL,XMAX
       LD   A,(HL)
       CP   C
       JR   C,3$
       LD   (HL),C
3$
        CALL $CHIC

;2)
P2
       CALL $INVAR
       LD   BC,#FEFE
       IN   E,(C)
       LD   B,#7F
       IN   A,(C)
       OR   E
       BIT  0,A
       RET  Z
;4)
        CALL $ROM
       LD   DE,$BUF
       LD   BC,($EXP1)
       CALL $CALC
       JR   C,FL1_11
;INTEGRAL
       RST  #28        ;В СТЕКЕ Y (ЕД.)
       DEFB #31,#38
       LD   HL,$INTEG
       CALL $INTO
       RST  #28
       DEFB #0F,#38
       LD   HL,$INTEG
       CALL $OUTFR
;5)
       LD   HL,$MY
       CALL $INTO
       RST  #28
       DEFB #05,#38    ;Y/MY OR Y (PIX.)
       LD   HL,$YC
       CALL $INTO
       RST  #28
       DEFB #0F,#27,#38 ;INT (Y/MY+YC)
       CALL #2DA2    ;BC - ОТСТУП СНИЗУ ОКНА
;6,7,8)
       JP   M,5$
       JR   C,5$
       LD   A,B
       AND  A
       JR   NZ,1$
       LD   HL,HH
       LD   A,C
       CP   (HL)
       JR   C,4$
1$     LD   HL,FLAG
       SET  2,(HL)
       LD   A,(HH)
       DEC  A
       JR   3$
5$      CALL $CHIC
       LD   HL,FLAG
       SET  2,(HL)
       XOR  A
       JR   3$
4$     LD   A,C
3$     LD   (Y),A
;9)
       LD   BC,(X)
       LD   HL,FLAG
       BIT  1,(HL)
       JR   Z,P9A
       CALL $PLOT
       JR   P11
P9A    LD   A,(FLAG)
       DEFB #64
       CPL
       AND  %1100
       JR   NZ,P10
       LD   ($COORD),BC
       JR   P11

FL1_11 PUSH AF
        CALL $CHIC
       POP  AF
       CP   11
       RET  Z
       CP   1
       RET  Z
       LD   HL,$COORD
       INC  (HL)
       LD   HL,FLAG
       SET  0,(HL)
       JR   P11
;10)
P10    LD   HL,FLAG
       RES  0,(HL)
       LD   BC,(X)
       CALL $LINEG

;11)
P11    LD   HL,$X
       CALL $INTO
       LD   HL,$MX
       CALL $INTO
        CALL $ROM
       RST  #28
       DEFB #0F,#38
        CALL $CHIC
       LD   HL,$X          ;FLAG
       CALL $OUTFR         ;X
       LD   HL,X           ;Y
       LD   A,(HL)         ;XMAX
       LD   ($COORD),A     ;HH
       INC  (HL)           ;FLAG2
;12)
       PUSH HL
       LD   HL,FLAG
       RLC  (HL)
       RES  2,(HL)
       RES  0,(HL)
       POP  HL
       LD   A,(HL)
       INC  HL
       INC  HL
       CP   (HL)
       JP   C,P2
       RET

XR2X   CALL $INTO
       LD   HL,$MX
       CALL $INTO
       RST  #28
       DEFB #05,#38
       LD   HL,$XC
       CALL $INTO
       RST  #28
       DEFB #0F,#27,#38
       CALL #2DA2
       RET

FLAG   DEFB 0
X      DEFB 0
Y      DEFB 0
XMAX   DEFB 0
HH     DEFB 0
FLAG2  DEFB 0

$X2    DEFB 0,0,40,3,0
$INTEG DEFS 5


$LINEG LD   A,B
       LD   (LIEX+1),A
       LD   HL,$N_LIN
       LD   (PROC+1),HL
       LD   A,($COORD+1)
       SUB  B
       JR   NC,DOWN
       LD   HL,$P_LIN
       LD   (PROC+1),HL
       NEG
DOWN   LD   (PREVL),A
       LD   HL,$COORD
       INC  (HL)
       LD   C,(HL)
       INC  HL
       LD   A,(HL)
       PUSH AF
       CALL $PLOT
       POP  AF
       LD   BC,($COORD)
       LD   B,A
       DEC  C
       CALL $REFOR
       CALL $REFAD
       LD   A,(PREVL)
       OR   A
       RET  Z
       DEC  A
       JR   Z,LIEX
R_L    LD   D,A
       LD   A,1
       INC  B
PRC    RRCA
       DJNZ PRC
       LD   E,A
       LD   B,D
PROC   CALL 0
       LD   A,E
$LIOPR OR  (HL)
       LD   (HL),A
       DJNZ PROC
LIEX   LD   A,0
       LD   ($COORD+1),A
       RET
PREVL  DEFB 0
