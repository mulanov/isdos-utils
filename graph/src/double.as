$GRAPH LD   C,#8
       RST  16
       XOR  A
       LD   (FLAG2),A
       INC  A
       LD   ($POUT+1),A
       LD   DE,$BUF
       PUSH DE
       CALL $ROM
       CALL $PREOBR
       CALL $CHIC
       LD   A,($BUF+1)
       CP   "="
       POP  DE
       JP   NZ,$GR
       LD   L,E
       LD   H,D
       LD   (FIR_AD),HL
       INC  DE
       PUSH HL
       CALL XY1
       LD   (FIRST),HL
       POP  HL
       JP   NZ,$GR     ;НЕ X,Y OR R
2$     LD   A,(HL)
       CP   ";"
       JR   Z,1$
       CP   ","
       JR   Z,1$
       CP   #0D
       INC  HL
       JR   NZ,2$

;ОДНА ФОРМУЛА
       DEC  HL
       SBC  HL,DE
       LD   (LEN1),HL
       LD   A,(FLAG2)
       AND  A
       JP   NZ,BEGIN

;ОДНА ФОРМУЛА НЕ R=
       LD   (LEN2),HL
       LD   HL,$BUF
       LD   (SEC_AD),HL
       DEC  HL
       DEC  HL
       LD   (FIR_AD),HL
       LD   HL,2
       LD   (LEN1),HL
       LD   HL,#0D74 ;t
       LD   ($BUF),HL
       LD   HL,(FIRST)
       LD   (SECOND),HL
       LD   A,L
       LD   HL,$Y
       LD   DE,$YC
       LD   BC,$MY
       CP   $X?256
       JR   Z,5$
       LD   HL,$X
       LD   DE,$XC
       LD   BC,$MX
5$     LD   (FIRST),HL
       EX   DE,HL
       CALL $INTO
       LD   H,B
       LD   L,C
       CALL $INTO
       CALL $ROM
       RST  #28
       DEFB #04,#1B,#38
       CALL $CHIC
       LD   HL,$T
       CALL $OUTFR
       JR   BEGIN1


;ДВЕ ФОРМУЛЫ
1$     LD   (HL),#0D
       PUSH HL
       SBC  HL,DE
       LD   (LEN1),HL
       POP  HL

3$     INC  HL
       LD   A,(HL)
       CP   #20
       JR   Z,3$
       PUSH HL
       LD   (SEC_AD),HL
       CALL XY1
       LD   (SECOND),HL
       POP  HL
       JP   NZ,$GR
       INC  HL
       INC  HL
       LD   E,L
       LD   D,H
       LD   A,#0D
       CPIR
       JP   NZ,$GR
       CP   A
       SBC  HL,DE
       LD   (LEN2),HL

BEGIN
       LD   HL,$T0
       LD   DE,$T
       LD   BC,5
       LDIR
BEGIN1
       LD   A,1
       LD   (FLAG),A

LOOP
       CALL CALCUL
        RET C
       JR   Z,LINE
       LD   ($COORX),BC
       LD   ($COORY),DE
       LD   A,B
       AND  A
       JR   NZ,E_LINE
       LD   A,D
       AND  A
       JR   NZ,E_LINE
       LD   B,E
       CALL $PLOT
       XOR  A
       LD   ($POUT+1),A
       JR   E_LINE
LINE   LD   A,(FLAG)
       AND  A
       JR   NZ,E_LINE
       CALL $LINE
E_LINE
       XOR  A
       IN   A,(#FE)
       CPL
       AND  #1F
       RET  NZ

       CALL $ROM
       LD   HL,$T
       CALL $INTO
       LD   HL,$DT
       CALL $INTO
       RST  #28
       DEFB #0F,#38
       LD   HL,$T
       CALL $OUTFR
       CALL $CHIC

       JR   LOOP


XY1    LD   A,(HL)
       RES  5,A
       LD   HL,$X
       CP   "X"
       RET  Z
       LD   HL,$Y
       CP   "Y"
       RET  Z
       CP   "R"
       RET  NZ
       LD   A,1
       LD   (FLAG2),A
       RET

CALCUL ;ВЫЧИСЛЕНИЕ КООРД. X=BC И Y=DE
       ;CY-FATAL ERROR
       ;NZ-ОПРЕДЕЛИЛАСЬ В ДАННЫЙ МОМЕНТ
       CALL $ROM
       LD   DE,(FIR_AD)
       INC  DE
       INC  DE
       LD   BC,(LEN1)
       CALL $CALC
       JP   C,ERROR
       LD   A,(FLAG2)
       AND  A
       JR   Z,1$ ;X,Y
       RST  #28
       DEFB #31,#38
       LD   HL,$T
       CALL $INTO
       RST  #28
       DEFB #20,#04,#38
       LD   HL,$X
       CALL $OUTFR
       LD   HL,$T
       CALL $INTO
       RST  #28
       DEFB #1F,#04,#38
       LD   HL,$Y
       CALL $OUTFR
       JR   FL_COO

1$     LD   HL,(FIRST)
       CALL $OUTFR
       LD   DE,(SEC_AD)
       INC  DE
       INC  DE
       LD   BC,(LEN2)
       CALL $CALC
       JR   C,ERROR
       LD   HL,(SECOND)
       CALL $OUTFR

;FLOAT->COORD
FL_COO
       LD   HL,$YC
       CALL $INTO
       LD   HL,$Y
       CALL $INTO
       LD   HL,$MY
       CALL $INTO
       RST  #28
       DEFB #05,#0F,#27,#38
       CALL TRANS
       PUSH BC
       LD   HL,$XC
       CALL $INTO
       LD   HL,$X
       CALL $INTO
       LD   HL,$MX
       CALL $INTO
       RST  #28
       DEFB #05,#0F,#27,#38
       CALL TRANS
       POP  DE
       CALL $CHIC
       LD   HL,FLAG
       CP   A
       LD   A,(HL)
       AND  A
       LD   (HL),0
       RET

TRANS  CALL #2DA2
       RET  P
       LD   HL,0
       SBC  HL,BC
       LD   B,H
       LD   C,L
       RET

ERROR  PUSH AF
       CALL $CHIC
       LD   A,1
       LD   (FLAG),A
       POP  AF
       CP   6-1
       RET  Z
       CP   #A-1
       RET  Z
       SCF
       RET


FIRST  DEFW 0 ;АДРЕСА ПЕРВОЙ И ВТОРОЙ
SECOND DEFW 0           ;ПЕРЕМЕННЫХ
FIR_AD DEFW 0 ;АДРЕС ПЕРВОЙ ФОРМУЛЫ
SEC_AD DEFW 0 ;АДРЕС ВТОРОЙ ФОРМУЛЫ
LEN1   DEFW 0 ;ДЛИНА ПЕРВОГО ВЫРАЖЕНИЯ
LEN2   DEFW 0 ;ДЛИНА ВТОРОГО ВЫРАЖЕНИЯ
FLAG   DEFB 0 ;0,ЕСЛИ ОПРЕДЕЛЕНА
FLAG2  DEFB 0 ;1,ЕСЛИ R=...
$T0    DEFB 0,0,0,0,0
$DT    DEFB #7D,#4C,#CC,#CC,#CD
