       CALL $INROM
       JR   OBHOD
kolfu  EQU  20
       DEFB "U","n","C","o",6
mcol   DEFB %1101000
ccol   DEFB %1000101
mecol  DEFB %1111000
tecol  DEFB %0000111
sccol  DEFB %1110000
grcol  DEFB %1110000
OBHOD  CALL $BUF

       LD   HL,6*41+$BUF
       CALL $INITC
       CALL CLBUF

       LD   (STACK),SP
       CALL $MAKEM
CLOOP
       LD   HL,FULL
       LD   DE,$WINDG
       PUSH DE
       LD   BC,4
       LDIR
       POP  IX
       CALL $IX678
       CALL $CLERK
$MLOOP LD   SP,(STACK)
       LD   HL,MENTEX
       CALL $UPPRN
       XOR  A
       LD   ($DIREC),A
2$     LD   A,(ccol)
       CALL CURS
       LD   C,7
       RST  16
       PUSH AF
       LD   A,(mcol)
       CALL CURS
       POP  AF
       LD   HL,MTAB
       LD   C,#7E
       RST  16
       JR   2$
MTAB   DEFB "o"
       DEFW LEFT
       DEFB 8
       DEFW LEFT
       DEFB "p"
       DEFW RIGHT
       DEFB 9
       DEFW RIGHT
       DEFB #D
       DEFW DD
       DEFB #A
       DEFW DD
       DEFB "a"
       DEFW DD
       DEFB #FF
       DEFW ret
DD
       POP  HL
       LD   A,7
       CALL CURS
       LD   HL,MENT2
       LD   A,(POSIT)
       LD   D,0
       DEC  A
       ADD  A,A
       ADD  A,A
       LD   E,A
       ADD  HL,DE
       LD   E,(HL)
       INC  HL
       LD   D,(HL)
       INC  HL
       PUSH DE
       POP  IX
       LD   E,(HL)
       INC  HL
       LD   D,(HL)
       LD   L,E
       LD   H,D
       CP   4
       CALL NZ,NEWIN
       JP   (HL)
NEWIN
       CALL $GETW
       INC  (IX+1)
       DEC  (IX+2)
       LD   C,#61
       LD   A,1
       RST  16
       LD   C,#62
       LD   DE,0
       LD   A,%00001011
       RST  16
       DEC  (IX+1)
       INC  (IX+2)
       RET
LEFT   LD   A,(POSIT)
       DEC  A
       JR   NZ,POK
       LD   A,PUNKTS
POK    LD   (POSIT),A
ret    RET
RIGHT  LD   A,(POSIT)
       INC  A
       CP   PUNKTS+1
       JR   NZ,POK
       LD   A,1
       JR   POK

CURS   PUSH AF
       LD   DE,CURTAB
       LD   A,(POSIT)
       DEC  A
       ADD  A,A
       LD   L,A
       LD   H,0
       ADD  HL,DE
       LD   A,(HL)
       INC  HL
       LD   B,(HL)
       LD   L,A
       LD   H,#58
       POP  AF
1$     LD   (HL),A
       INC  HL
       DJNZ 1$
       RET

MENT2  DEFW FIWI,UNIP,FUWI,FUNCTI
       DEFW RUWI,UNIP,$OKWI,UNIP,CONWI,UNIP
CURTAB DEFB 0,3,4,6,11,5,17,4,21,5
POSIT  DEFB 1  ;ПОЗИЦИЯ КУРСОРА
PUNKTS EQU  5  ;КОЛ-ВО ПУНКТОВ

;УНИВЕРСАЛЬНАЯ ОБРАБОТКА ПУНКТОВ ОСН.МЕНЮ
UNIP
       LD   C,#91
       RST  16
       CALL $PUTW
       JP   $MLOOP

FUNCTI LD   (FUSP),SP
FUNC   LD   HL,(STF)
       LD   C,0
1$     LD   A,(HL)
       CP   3
       JR   Z,2$
       INC  HL
       CP   #D
       JR   NZ,1$
       INC  C
       JR   1$
2$     LD   (FUTOP),HL
       DEC  HL
       LD   A,(HL)
       CP   #D
       JR   Z,3$
       INC  C
3$     LD   A,C
       CP   kolfu
       JR   C,4$
       LD   A,kolfu
4$     LD   (PUF),A
       LD   (BBB+1),A
       ADD  A,3
       LD   (IX+2),A
       CALL NEWIN
       LD   C,#91
       RST  16

       CALL $PUTW
       JP   $MLOOP

       DEFB 7,2,#47,1
       DEFW INITFU,0,HOTWI,FUEN
FUWI   DEFB 4,0,5,10,#78,#FF,6,12
       DEFW CSRF-1,FUTXT
CSRF   DEFB 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
FUTXT  EQU  $BUF
NEW    DEFM "  <New>"
       DEFB 3
KORNI  DEFM "√√√√√√√√√√√√√√√√√√√√"
FUEN   DEFW FU,FU,FU,FU,FU,FU,FU,FU,FU,FU,FU
       DEFW FU,FU,FU,FU,FU,FU,FU,FU,FU,FU
HOTWI  DEFB " "
       DEFW KOR
       DEFB "8"
       DEFW DELFU
$MHOT  DEFB "o"
       DEFW mLEF
       DEFB "p"
       DEFW mRIG
       DEFB 9
       DEFW mRIG
       DEFB 8
       DEFW mLEF
       DEFB #FF

KOR    PUSH HL
       LD   HL,KORNI
       LD   E,(IX-9)
       DEC  E
       LD   D,0
       ADD  HL,DE
       LD   A,(HL)
       XOR  "√"!32
       LD   (HL),A
       LD   A,1
       CP   0
       POP  HL
       RET
INITFU
       LD   IX,FUTXT
       LD   HL,(STF)
       LD   DE,KORNI
BBB    LD   B,0
       INC  B
       DEC  B
       JR   Z,5$
4$     PUSH BC
       LD   A,(DE)
       LD   (IX),A
       INC  IX
       LD   A,32
       LD   (IX),A
       INC  IX
       INC  DE
       LD   B,10
7$     LD   A,(HL)
       INC  HL
       CP   #D
       JR   Z,6$
       CP   20
       JR   C,7$
       LD   (IX),A
       INC  IX
       DJNZ 7$
       LD   BC,1000
       LD   A,#0D
       CPIR
6$     POP  BC
       LD   (IX),#D
       INC  IX
       DJNZ 4$
5$
       PUSH IX
       POP  DE
       LD   HL,NEW
       LD   BC,8
       LDIR
       RET

CCL    LD   HL,(STF)
       AND  A
       JR   Z,1$
       LD   E,A
       LD   A,#D
       LD   BC,1000
2$     CPIR
       DEC  E
       JR   NZ,2$
1$     LD   (BEGC),HL
       LD   BC,0
       LD   DE,$BUF
3$     LD   A,(HL)
       LD   (DE),A
       INC  HL
       INC  DE
       INC  BC
       CP   13
       JR   Z,4$
       CP   3
       JR   NZ,3$
4$     LD   (ENDC),HL
       LD   (LENC),BC
       DEC  DE
       LD   A,32
       LD   (DE),A
       RET

DELFU
       LD   A,(IX-9)
       DEC  A
       LD   HL,PUF
       CP   (HL)
       RET  Z
       PUSH AF
       CALL $PUTW 
       POP  AF
       CALL CCL
       LD   HL,(FUTOP)
       LD   DE,(ENDC)
       PUSH DE
       CP   A
       SBC  HL,DE
       LD   B,H
       LD   C,L
       POP  HL
       LD   DE,(BEGC)
       INC  BC
       LDIR
       LD   HL,KORNI
       LD   DE,KORNI+1
       LD   (HL),"√"
       LD   BC,kolfu-1 ;КОЛ-ВО ФУНКЦИЙ
       LDIR
       LD   SP,(STACK)
       CALL DD
       JP   $MLOOP
FU
       LD   A,(IX-9)
       DEC  A
       LD   HL,PUF
       CP   (HL)
       JP   Z,NNEW
       PUSH AF
       CALL $PUTW
       CALL CLBUF
       POP  AF
       CALL CCL
       LD   IX,WIND
       CALL $GETW 
       CALL INPUT
       JP   C,func
       INC  A
       LD   HL,(FTOP)
       LD   DE,(FUTOP)
       SBC  HL,DE
       LD   DE,(LENC)
       ADD  HL,DE
       LD   E,A
       LD   A,H
       AND  A
       JR   NZ,10$
       LD   A,E
       CP   L
       JP   NC,func ;TOOBIG
10$
       LD   D,0
       LD   (LENED),DE
       LD   HL,(LENC)
       CP   A
       SBC  HL,DE
       JR   Z,200$
       PUSH AF
       CP   A
       LD   HL,(FUTOP)
       LD   DE,(ENDC)
       SBC  HL,DE
       JR   Z,200$
       LD   B,H
       LD   C,L
       INC  BC
       POP  AF
       JR   C,11$
       PUSH DE
       LD   HL,(BEGC)
       LD   DE,(LENED)
       ADD  HL,DE
       EX   DE,HL
       POP  HL
       LDIR
       JR   200$
11$
       LD   HL,(LENED)
       LD   DE,(LENC)
       CP   A
       SBC  HL,DE
       LD   DE,(FUTOP)
       ADD  HL,DE
       EX   DE,HL
       LDDR

200$
       LD   BC,(LENED)
       LD   HL,$BUF
       LD   DE,(BEGC)
       LDIR
       LD   HL,FUWI-9
       LD   A,(HL)
       LD   HL,PUF
       CP   (HL)
       JR   NZ,func
       LD   A,#3
       LD   (DE),A
       JR   func

NNEW
       LD   A,kolfu ;КОЛ-ВО ФУНКЦИЙ
       CP   (HL)
       RET  Z
       CALL $PUTW 
       LD   IX,WIND
       CALL $GETW 
       CALL INPC
       JP   C,func
       LD   HL,(FTOP)
       LD   DE,(FUTOP)
       SBC  HL,DE
       LD   E,A
       LD   A,H
       AND  A
       JR   NZ,1$
       LD   A,E
       CP   L
       JR   NC,func ;TOOBIG
1$     LD   B,0
       LD   C,E
       INC  C
       LD   DE,(FUTOP)
       LD   HL,$BUF
       LDIR
       EX   DE,HL
       LD   (HL),3
       LD   (FUTOP),HL
func   CALL $PUTW
       LD   IX,FUWI
       LD   SP,(FUSP)
       JP   FUNC
;--------------------------


;ПЕРЕМЕЩЕНИЕ ВЫПАВШЕГО ОКНА
mRIG
       CALL $PUTW
       LD   A,(mcol)
       CALL CURS
       LD   A,(POSIT)
       CP   PUNKTS
       JR   NZ,1$
       XOR  A
1$     INC  A
mrig   LD   (POSIT),A
       LD   A,(ccol)
       CALL CURS
       LD   SP,(STACK)
       CALL DD
       JP   $MLOOP
mLEF   CALL $PUTW
       LD   A,(mcol)
       CALL CURS
       LD   A,(POSIT)
       DEC  A
       JR   NZ,mrig
       LD   A,PUNKTS
       JR   mrig
;-----------------------

;РАБОТА С ТЕКСТОМ
TEXT1
       CALL $GETW
       LD   C,#61
       XOR  A
       RST  16
       CALL SWAPD
       CALL INPUT
       JR   TEXT2
TEXT   CALL $PUTW
       LD   IX,FINAME
       CALL $GETW
       LD   C,#61
       XOR  A
       RST  16
       CALL INPC
TEXT2  PUSH AF
       CALL $PUTW
       POP  AF
       JP   C,$MLOOP
       ADD  A,A
       ADD  A,A
       LD   (MAXS),A
       LD   HL,$BUF
       LD   BC,#6000
21$    CALL $WORD
20$    PUSH BC
       LD   C,7
       RST  16
       CP   #0D
       JP   Z,$MLOOP
       CP   #16
       JR   Z,TEXT1
       POP  BC
       PUSH AF
       CALL $WORD
       POP  AF
       CP   #20
       JP   Z,111$
       CP   #10
       JR   Z,TEXT1
       CP   "o"
       JR   Z,1$
       CP   8
       JR   Z,1$
       CP   "p"
       JR   Z,2$
       CP   9
       JR   Z,2$
       CP   #B
       JR   Z,3$
       CP   "q"
       JR   Z,3$
       CP   #A
       JR   Z,4$
       CP   "a"
       JR   NZ,21$
4$     INC  B
       LD   A,#BF
       CP   B
       JR   NC,21$
       DEC  B
       JR   21$
3$
       DEC  B
       LD   A,($DIREC)
       AND  A
       LD   A,6
       JR   Z,30$
       LD   A,(MAXS)
30$    ADD  A,7
       CP   B
       JR   C,21$
       INC  B
       JR   21$
1$
       LD   A,C
       SUB  4
       LD   C,A
       JR   NC,21$
       INC  C
       INC  C
       INC  C
       INC  C
       JR   21$
2$
       LD   A,C
       ADD  A,4
       JR   C,21$
       LD   C,A
       LD   A,($DIREC)
       AND  A
       JR   NZ,21$
       LD   A,(MAXS)
       NEG
       CP   C
       JR   NC,21$
       LD   A,C
       SUB  4
       LD   C,A
       JP   21$
111$   LD   A,($DIREC)
       XOR  1
       LD   ($DIREC),A
       JP   21$
;-----------------------------


;ВЫХОД ИЗ MENU "OKNO"
$EXOP1 LD   HL,MENTEX
       CALL $UPPRN
       LD   A,(ccol)
       CALL CURS
       LD   SP,(STACK)
       CALL DD
       JP   $MLOOP
;----------------------------


;РАБОТА С ФАЙЛАМИ

       DEFB 7,0,#47,1,0,0,0,0
       DEFW $MHOT
       DEFW FIEN
FIWI   DEFB 0,0,6,8,%1111000,#FF,1,9,1,1,1,1 ;,1
       DEFM "Загрузить"
       DEFM "Сохранить"
       DEFM "Информ."
       DEFB 13
       DEFM "ВЫХОД"
       DEFB 3

FIEN   DEFW LOAD,SAVE,INFO,EXIT1
FIEN2  DEFW SVV,SVV

       DEFB 7,0,#47,1
       DEFW 0,0,0,FIEN2
FIWI1  DEFB 4,4,4,6,#78,#FF,6,7,1,1
       DEFM "Функции"
       DEFB 13        ;СМЕНИТЬ 4*6*9
       DEFM "Экран"
       DEFB 3

SAVE   LD   HL,$PTOP+<6*8*9>
       LD   ($GETW+1),HL
       LD   IX,FIWI1
       CALL $GETW
       LD   C,#61
       XOR  A
       RST  16
       LD   C,#91
       RST  16
       CALL $PUTW
       LD   HL,$PTOP
       LD   ($GETW+1),HL
       LD   IX,FIWI
       RET

SVV    LD   A,(IX-9)
       LD   (sv_op+1),A
       LD   IX,FINAME
       LD   HL,$PTOP+<6*8*9>+<4*6*9>
       LD   ($GETW+1),HL
       CALL $GETW
       CALL INPC
       CALL $PUTW
       LD   HL,$PTOP+<6*8*9>
       LD   ($GETW+1),HL
       LD   IX,FIWI1
       CALL $PUTW
       LD   HL,$PTOP
       LD   ($GETW+1),HL
       LD   IX,FIWI
       CALL $PUTW

       LD   HL,$BUF
       LD   C,#42
       RST  16
       JP   C,WYLET
       RET  NZ
       AND  A
       RET  NZ
       EXX
       LD   DE,FIBUF
       LD   BC,8
       LDIR
sv_op  LD   B,0
       LD   DE,3
1$     ADD  A,E
       DJNZ 1$
       LD   C,E
       LD   E,A
       LD   HL,EXTS-3
       ADD  HL,DE
       LD   DE,FIBUF+8
       LDIR
       LD   C,#45
       RST  16
       EXX
       DEC  HL
       DEC  HL
       LD   D,(HL)
       DEC  HL
       LD   E,(HL)
       LD   (FIBUF+30),DE
       LD   HL,#1B00
       LD   (FIBUF+14),HL
       LD   A,(sv_op+1)
       CP   2
       JR   Z,2$
       LD   HL,(STF)
       LD   E,L
       LD   D,H
       LD   BC,0
       LD   A,3
       CPIR
       SBC  HL,DE
       LD   (FIBUF+14),HL
2$     LD   HL,FIBUF
       LD   C,#25
       RST  16
       JR   NC,3$
       CP   81
       JR   NZ,WYLET
5$     LD   HL,FIBUF
       LD   C,#23
       RST  16
       JR   C,WYLET
       LD   HL,MEGA
       CALL $UPPRN
       LD   A,(sv_op+1)
       LD   IX,#4000
       CP   2
       JR   Z,4$
       LD   IX,(STF)
4$     LD   HL,0
       XOR  A
       LD   DE,(FIBUF+14)
       LD   C,#2A
       RST  16
       JR   C,WYLET
       LD   C,2
       RST  16
       JR   C,WYLET
       JP   $MLOOP
3$     LD   IX,OVER
       CALL $GETW
       LD   C,#61
       XOR  A
       RST  16
       LD   C,#66
       RST  16
       LD   C,8
       RST  16
       DEC  C
       RST  16
       PUSH AF
       CALL $PUTW
       POP  AF
       CP   "n"
       JR   Z,WYL
       LD   C,#3C
       RST  16
       JR   NC,5$

WYLET  LD   IX,ERRWIN
       LD   E,A
       LD   A,3
       CP   A
       LD   D,0
       LD   BC,#A7C
       LD   HL,ERRNUM
       RST  16
       CALL $GETW
       LD   C,#61
       XOR  A
       RST  16
       LD   C,#66
       RST  16
       LD   C,7
       RST  16
WYL1   CALL $PUTW
WYL    LD   HL,MENTEX
       CALL $UPPRN
       LD   SP,(STACK)
       CALL DD
       JP   $MLOOP

LOAD   CALL $PUTW
       LD   C,#8A
       RST  16
       EXX
       PUSH HL
       POP  IX
       CALL $GETW

2$     LD   C,#8E
       LD   A,#F0
       RST  16
4$     LD   BC,#258E
       LD   A,#FF
       RST  16
       CP   #10
       JR   Z,WYL1
       CP   #0D
       JR   Z,3$
       CP   "7"
       JR   Z,5$
       CP   7
       JR   NZ,4$
5$     LD   C,#8E
       RST  16
       JR   2$
3$
       LD   C,#8A
       RST  16
       LD   C,#26
       RST  16
       JR   C,4$
       EXX
       LD   DE,11
       ADD  HL,DE
       BIT  5,(HL)
       LD   A,#0D
       JR   NZ,5$
       LD   C,#35
       RST  16

       EXX
       LD   DE,8
       ADD  HL,DE
       LD   A,(HL)
       INC  HL
       XOR  (HL)
       INC  HL
       XOR  (HL)
       CP   "s"!"c"!"r"
       JR   NZ,7$
       CALL $PUTW
       LD   HL,#4000
       LD   DE,0
       LD   BC,#1B2B
8$     RST  16
       JP   C,WYLET
       JR   WYL
7$     CP   "t"!"x"!"t"
       JR   NZ,4$
       INC  HL
       INC  HL
       INC  HL
       INC  HL
       LD   E,(HL)
       INC  HL
       LD   D,(HL)
       INC  HL
       LD   A,(HL)
       AND  A
       JR   NZ,4$
       LD   HL,1000 ;LENGTH OF FUNCTIONS
       SBC  HL,DE
       JR   C,4$
       PUSH DE
       CALL $PUTW
       POP  DE
       XOR  A
       LD   H,A
       LD   L,A
       LD   IX,(STF)
       LD   C,#29
       JR   8$

FIBUF  DEFS 11
       DEFB %1000001
       DEFS 20
EXTS   DEFM "txtscrsp "


OVER   DEFB 3,8,3,25,#78,#FF,6,29
       DEFM "Существует. Переписать (Y/N)?"
       DEFB 3
ERRWIN DEFB 10,8,3,9,%1010111,#FF,14,10
       DEFM "Ошибка "
ERRNUM DEFB 32,32,32,3


INFO   CALL $PUTW
       LD   IX,INFWIN
       CALL $GETW
       LD   C,#61
       XOR  A
       RST  16
       LD   C,#66
       RST  16
       LD   C,7
       RST  16
       CALL $PUTW
       LD   SP,(STACK)
       CALL DD
       JP   $MLOOP
;----------------------


;ПЕЧАТЬ СТРОКИ (HL) ВВЕРХУ ЭКРАНА
$UPPRN PUSH HL
       LD   HL,#5800
       LD   DE,#5801
       LD   A,(mcol)
       LD   (HL),A
       LD   BC,#1F
       LDIR
       LD   HL,#4000
       LD   DE,#4001
       LD   B,8
1$     PUSH BC
       PUSH DE
       PUSH HL
       LD   BC,#1F
       LD   (HL),0
       LDIR
       POP  HL
       POP  DE
       POP  BC
       INC  H
       INC  D
       DJNZ 1$
       LD   HL,0
       LD   C,#C
       RST  16
       POP  HL
       LD   C,#6C
       RST  16
       RET
;------------------------



;КАЛЬКУЛЯТОР
CALCUL
       CALL $PUTW
       LD   IX,WIND
       CALL $GETW
       CALL CLBUF
       CALL $ROM
      LD    HL,$INTEG
      CALL  $INTO
      LD    HL,$MX
      CALL  $INTO
      RST   #28
      DEFB  #04,#38
NER
       RST  #28
       DEFB #2E,#38
       CALL #2BF1
       EX   DE,HL
       LD   DE,$BUF
       LD   A,C
       OR   A
       JR   Z,1$
       LDIR
1$     CALL $CHIC
CLC    LD   IX,WIND
       CALL INPUT
       JR   C,CL
       LD   DE,$BUF
       CALL CAL
       PUSH AF
       CALL CLBUF
       POP  AF
       JR   NC,NER
       CALL $CHIC
       LD   IX,WINDER
       LD   C,#61
       XOR  A
       RST  16
       LD   C,#66
       RST  16
       LD   C,7
       RST  16
       JR   CLC
CL     CALL $PUTW
       JP   $MLOOP
;------------------------
CAL    CALL $ROM
       LD   C,A
       LD   B,0
       INC  BC
       PUSH DE
       PUSH BC
       CALL $PREOBR
       POP  BC
       POP  DE
       JP   $CALC


;CONST
CNN    CALL $PUTW
       LD   IX,WIND
       CALL $GETW
       CALL INPC
       JP   C,CL1
       LD   DE,$BUF
       CALL CAL
       JP   C,CL2
       LD   A,(CONWI-9)
       CP   6
       LD   HL,$T0
       JR   Z,2$
       LD   HL,$DT
2$     CALL $OUTFR
       CALL $INTO
       RST  #28
       DEFB #2E,#38
       CALL $PUTW
       CALL #2BF1
       CALL $CHIC
       EX   DE,HL
       LD   A,(CONWI-9)
       CP   6
       LD   DE,t0
       JR   Z,1$
       LD   DE,dt
1$     LD   A,C
       OR   A
       JP   Z,CL3
       LD   A,13
       CALL CONCOP
       JP   CL3

CN     CALL $PUTW
       LD   A,(IX-9)
       PUSH AF
       LD   IX,WIND
       CALL $GETW
       CALL CLBUF
       POP  AF
       LD   B,A
       LD   HL,0
       LD   DE,6
1$     ADD  HL,DE
       DJNZ 1$
       LD   DE,$CONST-6
       ADD  HL,DE
       LD   (const+1),HL
       DEC  A
       ADD  A,A
       ADD  A,A
       ADD  A,A
       ADD  A,A
       LD   L,A
       LD   H,0
       LD   DE,CONTX
       ADD  HL,DE
       LD   (const1+1),HL
       LD   DE,$BUF
       LD   BC,#10
       LDIR
       CALL INPUT
       JR   C,CL1
       LD   DE,$BUF
       SUB  2
       JR   C,CL1
       INC  DE
       INC  DE
       CALL CAL
       JR   C,CL2
       LD   HL,$BUF+1
       LD   A,(HL)
       CP   "="
       JR   NZ,CL2
       DEC  HL
       LD   A,(HL)
       AND  %0011111
       OR   %1100000
const  LD   DE,0
       LD   (DE),A
       PUSH AF
       INC  DE
       LD   HL,(23653)
       LD   BC,5
       SBC  HL,BC
       LDIR
       RST  #28
       DEFB #2E,#38
       CALL #2BF1
       EX   DE,HL
       POP  AF
const1 LD   DE,0
       LD   (DE),A
       INC  DE
       INC  DE
       LD   A,C
       OR   A
       JR   Z,CL2
       LD   A,14
       CALL CONCOP

CL2    CALL $CHIC
CL1    CALL $PUTW
CL3    LD   SP,(STACK)
       CALL DD
       JP   $MLOOP

CONCOP
       SUB  C
       LDIR
       AND  A
       JR   Z,CL2
       EX   DE,HL
1$     LD   (HL),#20
       INC  HL
       DEC  A
       JR   NZ,1$
       RET

;РАСЧЕТ LEN-ОВ И DL-ОВ ПО MX & MY
;БЕЗ CHIC-A
$TOLEN CALL LD1
       LD   DE,$DLX
       LD   HL,$MX
       CALL TL1
       LD   A,C
       LD   ($LENS),A
       CALL LD1
       LD   DE,$DLY
       LD   HL,$MY
       CALL TL1
       LD   A,C
       LD   ($LENS+1),A
       RET
TL1    PUSH HL
       PUSH DE
       CALL $INTO
       RST  #28
       DEFB #25,#04,#0F,#27,#06,#38
       POP  HL
       PUSH HL
       CALL $OUTFR
       POP  HL
       CALL $INTO
       POP  HL
       CALL $INTO
       RST  #28
       DEFB #05,#27,#38
       CALL #2DA2
       RET
LD1    LD   A,10
       CALL #2D28
       LD   A,2
       CALL #2D28
       LD   HL,$LG_E
       CALL $INTO
       RET
$LG_E  DEFB 127,94,91,216,161

;РАССЧЕТ MX & MY ПО DL & LENS
$MAKEM LD   HL,$DLX
       CALL $INTO
        CALL $ROM
       LD   A,($LENS)
       CALL #2D28
       RST  #28
       DEFB #5,#38
       LD   HL,$MX
       CALL $OUTFR
       LD   HL,$DLY
       CALL $INTO
       LD   A,($LENS+1)
       CALL #2D28
       RST  #28
       DEFB #5,#38
       LD   HL,$MY
       CALL $OUTFR
        JP $CHIC
;----------------------------


;ВЫЗОВ РИСОВАТЕЛЯ ГРАФИКА
DRAW   CALL $PUTW
       LD   IX,$WINDG
       LD   HL,(STF)
       LD   DE,KORNI
1$     LD   A,(DE)
       INC  DE
       CP   "√"
       JR   Z,2$
3$     LD   A,(HL)
       INC  HL
       CP   #D
       JR   Z,1$
       CP   3
       JR   NZ,3$
100$   JP   $MLOOP
2$     LD   A,(HL)
       CP   3
       JR   Z,100$
       PUSH DE
       LD   DE,$BUF
       LD   BC,0
4$     LD   A,(HL)
       LD   (DE),A
       INC  HL
       INC  BC
       INC  DE
       CP   3
       JR   Z,5$
       CP   #D
       JR   NZ,4$
       CALL GRF1
       POP  DE
       JR   1$
5$     DEC  DE
       LD   A,#D
       LD   (DE),A
       CALL GRF1
       POP  DE
       JR   100$
GRF1   PUSH HL
       LD   ($EXP1),BC
       CALL $GRAPH
       LD   DE,0
       LD   A,0
       LD   C,#62
       RST  16
       POP  HL
       RET
;-------------------------


;СОХР. И ВОССТ. ПРОСТРАНСТВО ПОД ОКНОМ
$GETW  LD   DE,$PTOP
       PUSH HL
       LD   C,(IX)
       LD   B,(IX+1)
       CALL $ATAD
       PUSH HL
       CALL $SYMAD
       LD   A,(IX+2)
       RLCA
       RLCA
       RLCA
       LD   C,A
1$     LD   B,(IX+3)
       PUSH HL
2$     LD   A,(HL)
       LD   (DE),A
       INC  HL
       INC  DE
       DJNZ 2$
       POP  HL
       CALL $N_LIN
       DEC  C
       JR   NZ,1$
       POP  HL
       LD   C,(IX+2)
3$     LD   B,(IX+3)
       PUSH HL
4$     LD   A,(HL)
       LD   (DE),A
       INC  HL
       INC  DE
       DJNZ 4$
       POP  HL
       PUSH DE
       LD   DE,#20
       ADD  HL,DE
       POP  DE
       DEC  C
       JR   NZ,3$
       POP  HL
       RET
5$     LD   HL,#771A
       LD   (2$),HL
       LD   (4$),HL
       CALL $GETW
       LD   HL,#127E
       LD   (2$),HL
       LD   (4$),HL
       RET
$PUTW  EQU  5$
;--------------------------


;РЕДАКТОР

;ВВОД С ОЧИСТКОЙ БУФЕРА
INPC   CALL CLBUF

;ВВОД СТРОКИ
INPUT
       LD   C,#61
       XOR  A
       RST  16
       LD   HL,#0701
       LD   C,#C
       RST  16
       LD   HL,$BUF
       LD   B,(IX+2)
       DEC  B
       DEC  B
       LD   C,#6E
       LD   A,41
       LD   DE,#0900
       RST  16
       JR   Z,ENTER
       CP   #10
       JR   Z,1$
       CP   #16
       JR   NZ,INPC
1$     SCF
       RET
;------------------------

;ВЫХОД
EXIT1
       XOR  A
       LD   C,#73
       RST  16
       LD   C,2
       RST  16
       LD   C,#8A
       RST  16
       EXX
       INC  HL
       INC  HL
       LD   (HL),#15
       LD   DE,-6
       ADD  HL,DE
DATE3  LD   DE,0
       LD   (HL),E
       INC  HL
       LD   (HL),D

       CALL old
       LD   IX,SREDA
       XOR  A
       LD   C,#37
       RST  16
       LD   A,#F2
       CP   A
       LD   SP,(STACK)
       RET
old    LD   HL,0
old1   LD   BC,0
       LD   (HL),C
       INC  HL
       LD   (HL),B
old2   LD   A,0
       LD   C,0
       RST  16
       RET
ENTER
       LD   L,A
       LD   H,0
       LD   DE,$BUF
       ADD  HL,DE
       LD   (HL),#D
       INC  HL
       INC  HL
       LD   ($EXP1),HL
       RET
CLBUF  LD   HL,$BUF
       LD   DE,$BUF+1
       LD   BC,6*41-1
       LD   (HL),#20
       LDIR
       RET

;УБРАТЬ СИМВОЛ #ОD В БУФЕРЕ
SWAPD  LD   HL,$BUF
       LD   BC,41*6
       LD   A,#D
       CPIR
       DEC  HL
       LD   (HL),#20
       RET

$BUF
       LD   A,(mecol)
       LD   (FIWI+4),A
       LD   (FUWI+4),A
       LD   (RUWI+4),A
       LD   ($OKWI+4),A
       LD   (FIWI1+4),A
       LD   (CONWI+4),A
       LD   E,A
       AND  %11000000
       LD   (MET+1),A
       LD   A,E
       AND  7
       RLCA
       RLCA
       RLCA
       LD   D,A
       LD   A,E
       AND  %00111000
       RRCA
       RRCA
       RRCA
       OR   D
MET    OR   0
       LD   (FIWI-10),A
       LD   (FUWI-10),A
       LD   (RUWI-10),A
       LD   ($OKWI-10),A
       LD   (FIWI1-10),A
       LD   (CONWI-10),A
       LD   A,(tecol)
       LD   (WIND+4),A
       LD   (FINAME+4),A
       LD   A,(sccol)
       LD   ($SCWIN+4),A
       LD   A,(grcol)
       LD   ($WINDG+4),A

       LD   IX,SREDA
       LD   C,#36
       XOR  A
       RST  16

       LD   C,#10
       RST  16
       EXX
       INC  HL
       INC  HL
       INC  HL
       LD   DE,$PTOP+#D01
       LD   (old+1),HL
       LD   C,(HL)
       LD   (HL),E
       INC  HL
       LD   B,(HL)
       LD   (HL),D
       LD   (old1+1),BC
       INC  HL
       INC  HL
       INC  HL
       LD   A,(HL)
       LD   (old2+1),A
       LD   C,2
       RST  16
       LD   C,0
       LD   A,20
1$     LD   B,A
       RST  16
       JR   NC,2$
       LD   A,B
       DEC  A
       CP   5
       JR   Z,3$
       JR   1$
3$     CALL old
       LD   A,130
       SCF
       LD   C,#84
       RST  16
2$
       LD   HL,$PTOP+#900
       LD   (HL),#D
       INC  HL
       LD   (STF),HL
       LD   (HL),3
       LD   HL,$PTOP+#D01
       LD   (FTOP),HL

       LD   C,#8A
       RST  16
       EXX
       DEC  B
       JR   NZ,4$
       LD   C,#8E
       LD   A,"o"
       RST  16
4$     INC  HL
       INC  HL
       LD   (HL),#10
       LD   DE,-6
       ADD  HL,DE
       LD   E,(HL)
       LD   (HL),0
       INC  HL
       LD   D,(HL)
       LD   (HL),0
       LD   (DATE3+1),DE
       LD   IX,SREDA
       XOR  A
       LD   C,#37
       RST  16
       RET

       DEFS 41*6-143 ;буфер редактора

MENTEX DEFM "ФАЙЛ  ФУНКЦИИ  ГРАФИК  ОКНО  CONST"
       DEFB #0D
MEGA   DEFM    "        MegaProduct Graph v3.0"
       DEFB #D

       DEFB 7,0,#47,1
       DEFW 0,0,$MHOT,RUEN
RUWI   DEFB 11,0,6,9,#78,#FF,15,11,1,1,1,1
       DEFM "Функции"
       DEFB 13
       DEFM "Весь экран"
       DEFB 13
       DEFM "Калькулятор"
       DEFM "Текст"
       DEFB 3
RUEN   DEFW DRAW,CLOOP,CALCUL,TEXT

       DEFW #0007,#0147,0,0,$MHOT,CONEN
CONWI  DEFB 19,0,9,13,#78,#FF,26,16,1,1,1,1,1,1,1
CONTX  DEFM "a=0             "
       DEFM "b=0             "
       DEFM "c=0             "
       DEFM "d=0             "
       DEFM "e=0             "
       DEFM "t0="
t0     DEFM "0            "
       DEFM "dt="
dt     DEFM "0.1          "
       DEFB 3
CONEN  DEFW CN,CN,CN,CN,CN,CNN,CNN

INFWIN DEFB 7,8,6,18,#4F,#FF,10,22
       DEFM "MegaProduct Graph v3.0"
       DEFB 13,13
       DEFM "   Автор программы:"
       DEFB 13
       DEFM " Михаил Уланов. 1996"
       DEFB 3

WINDER DEFB 13,8,3,6,%1010111,3,18,7
       DEFM "ОШИБКА!"
       DEFB 3

WIND   DEFB 0,6,8,32,7,#FF
FINAME DEFB 0,6,4,32,7,#FF
FULL   DEFB 0,1,23,#20
$WINDG DEFB 1,4,19,30,%1110000,#FF,0,0,0,0
$EXP1  DEFW 0
STACK  DEFW 0 ;адрес стека
FUSP   DEFW 0 ;адрес стека в меню FUNCT
FILEOP DEFB 0 ;операция с файлом
MAXS   DEFB 0 ;максимальная возможная координата печати текста
STF    DEFW 0 ;начало функций
PUF    DEFB 0 ;кол-во функций
FUTOP  DEFW 0 ;конец функций
FTOP   DEFW 0 ;конец области функций
ENDC   DEFW 0 ;конец редактируемой ф-ции
BEGC   DEFW 0 ;начало -"--"--"--
LENC   DEFW 0 ;длина --"--"--"--
LENED  DEFW 0 ;новая длина --"--
SREDA  DEFS 5
