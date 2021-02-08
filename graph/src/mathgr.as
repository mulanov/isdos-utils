VARS   EQU  23627
STKBOT EQU  23651
STKEND EQU  23653
RAMTOP EQU  23730
E_LINE EQU  23641
WORKSP EQU  23649

;подготовка среды
;HL-последний допустимый адрес выр-ия +1
$INITC LD   IY,23610
       LD   (MADD+1),HL
$INVAR LD   HL,vars
       LD   (VARS),HL
       LD   HL,ERSP
       LD   (23613),HL
       LD   BC,ESP
       LD   (HL),C
       INC  HL
       LD   (HL),B
       LD   HL,e_line
       LD   (E_LINE),HL
GOTOW  LD HL,ramtop
       LD (23730),HL
       LD HL,stkbot
       LD (23651),HL
       LD HL,stkend
       LD (23653),HL
       LD HL,worksp
       LD (23649),HL
       RET

$CALC  ;вх: DE-начало выр-ия
       ;    BC-длина с ВК
       ;вых:ответ в кальк. стеке
       ;  флаг C -ошибка, код-1 в A
       CALL GOTOW
       POP  HL
       LD   (ADRET),HL
       LD   (STACK1),SP
       PUSH HL
CALC   XOR A
       CALL #2AB1
       LD B,#1D
       RST #28
       DEFB #3B,#38
       OR A
       RET
ESPCH  LD   SP,(#DD6D)
       POP  HL
       POP  HL
       POP  HL
       INC  SP
       POP  HL
       POP  HL
       LD   A,#10
       LD   BC,#1FFD
       OUT  (C),A
       LD   A,(HL)
       JR   ESP1
ESP    LD A,(23610)
ESP1   LD SP,(STACK1)
       SCF
       LD   HL,(ADRET)
       JP   (HL)
; преобрезование выражения,
;находящегося в буфере выражения
$PREOB
       LD HL,FLAG
       SET ZAP,(HL)
PRE    LD A,(DE)
       CP #D
       RET  Z
       INC DE
       CALL PEREM ;C,если запрещенный
       JR NC,PRE1
       CALL SETZAP ;установка бита ZAP FLAG, если C
       JR PRE
PRE1
       LD   HL,FLAG
       BIT  ZAP,(HL)
       PUSH AF
       OR   A
       CALL SETZAP
       POP  AF
       JR   Z,PRE
       DEC  DE
       PUSH DE
       LD   (LINE),DE
       CALL FIND
       EX DE,HL
       POP DE
       INC DE
       JR NC,PRE
       DEC DE
       LD (DE),A
       INC DE
       PUSH HL
MADD   LD   HL,0
       SBC  HL,DE
       LD   B,H
       LD   C,L
       POP  HL
       LDIR
       LD DE,(LINE)
       INC DE
       JR PRE
PEREM  CP "0"
       JR C,ZZAP
       CP "9"+1
       JR C,NZAP
       CP "A"
       JR C,ZZAP
       CP "Z"+1
       JR C,NZAP
       CP "a"
       JR C,ZZAP
       CP "z"+1
       JR C,NZAP
ZZAP   SCF
       RET
NZAP   OR A
       RET
SETZAP LD HL,FLAG
       RES ZAP,(HL)
       RET NC
       SET ZAP,(HL)
       RET
FIND   LD   HL,#96
       LD   B,#A5
7$     LD   DE,(LINE)
       LD   (8$+1),HL
3$     LD   A,(DE)
       AND  %01011111
1$     LD   C,(HL)
       RES  7,C
       CP   C
       JR   NZ,2$
       INC  HL
       INC  DE
       LD   A,(DE)
       CP   "A"
       JR   NC,3$
       DEC  HL
       LD   A,(HL)
       CP   #80
       JR   C,2$
       SCF
       JR   4$
2$     INC  B
       JR   Z,5$
8$     LD   HL,0
6$     LD   A,(HL)
       AND  #80
       INC  HL
       JR   Z,6$
       JR   7$
5$     OR   A
4$     LD   A,B
       RET

;Настройка возврата по ошибке
; HL-адрес выхода
$INIER
       LD   (ADRET),HL
       POP  HL
       LD   (STACK1),SP
       PUSH HL
       RET

;ПЕРЕСЫЛКА В КАЛК. СТЕК (HL)'А И ОБРАТНО
$INTO  LD   DE,(#5C65)
       PUSH BC
       LD   BC,5
       LDIR
       POP  BC
       LD   (#5C65),DE
       RET
$OUTFR PUSH BC
       LD   BC,4
       ADD  HL,BC
       EX   DE,HL
       LD   HL,(#5C65)
       DEC  HL
       INC  BC
       LDDR
       INC  HL
       LD   (#5C65),HL
       POP  BC
       RET

;НАСТРОЙКА ПРОЦЕДУР $ROM & $CHIC
$INROM LD   HL,0
       LD   E,(HL)
       LD   A,(HL)
       INC  A
       INC  (HL)
       CP   (HL)
       LD   (HL),E
       RET  Z
       LD   A,#C9
       LD   ($ROM),A
       LD   ($CHIC),A
       RET
;ПОДКЛЮЧЕНИЕ ПЗУ БЕЙСИКА, DI
$ROM   DI
       PUSH BC
       PUSH HL
       LD   HL,(#E2B5)
       LD   (Q1+1),HL
       LD   HL,(#DD6D)
       LD   (Q2+1),HL
       LD   HL,(#DDF7)
       LD   (Q3+1),HL
       LD   HL,(#C064)
       LD   (Q4+1),HL
       LD   HL,(#C001)
       LD   (Q5+1),HL
       LD   HL,#FFFF
       LD   (#C064),HL
       LD   HL,ESPCH
       LD   (#C064),HL
       LD   BC,#1FFD
       LD   A,#10
       OUT  (C),A
       LD   (23610),A
       POP  HL
       POP  BC
       RET
;ПОДКЛЮЧЕНИЕ СИСТЕМЫ IS-DOS CHIC, EI
$CHIC  PUSH BC
       LD   BC,#1FFD
       LD   A,#11
       OUT  (C),A
       PUSH HL
Q1     LD   HL,0
       LD   (#E2B5),HL
Q2     LD   HL,0
       LD   (#DD6D),HL
Q3     LD   HL,0
       LD   (#DDF7),HL
Q4     LD   HL,0
       LD   (#C064),HL
Q5     LD   HL,0
       LD   (#C001),HL
       POP  HL
       POP  BC
       EI
       RET

ZAP    EQU  0
STACK1 DEFW 0 ;значение SP при ошибке
ADRET  DEFW 0 ;адрес возврата при ошибке
FLAG   DEFB 0
LINE   DEFW 0
       DEFW 0
ERSP   DEFW 0
       DEFW 0

errsp
       DEFW ESP

vars
       DEFB "X"&%11111@%01100000
$X     DEFB 0,0,0,0,0
       DEFB "Y"&%11111@%01100000
$Y     DEFB 0,0,0,0,0
       DEFB "T"&%11111@%01100000
$T     DEFB 0,0,0,0,0
$CONST DEFB "A"&%11111@%01100000
       DEFB 0,0,0,0,0
       DEFB "B"&%11111@%01100000
       DEFB 0,0,0,0,0
       DEFB "C"&%11111@%01100000
       DEFB 0,0,0,0,0
       DEFB "D"&%11111@%01100000
       DEFB 0,0,0,0,0
       DEFB "E"&%11111@%01100000
       DEFB 0,0,0,0,0

       DEFB #80
e_line
       DEFB #80
worksp EQU  e_line+50
stkbot EQU  worksp+50
stkend EQU  stkbot
ramtop EQU  stkend+200
$PTOP  EQU  ramtop+150
