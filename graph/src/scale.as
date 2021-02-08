;СОЗДАНИЕ $DLX,$DLY,$LENS
$SCALE
       LD   C,#61
       XOR  A
       RST  16
       LD   HL,#0508
       LD   C,#0C
       RST  16
       LD   HL,SCT
       LD   C,#6C
       RST  16
       XOR  A
       LD   C,#63
       LD   B,7
       RST  16
       CALL $INVAR
LAB101
101$   CALL POR
100$   CALL SQR
       CALL $INVAR
       LD   C,7
       RST  16
       PUSH AF
       CALL SQR
       POP  AF
       LD   HL,$LENS
       CP   #D
       RET  Z
       CP   "p"
       JR   Z,1$
       CP   9
       JR   Z,1$
       CP   "o"
       JR   Z,2$
       CP   8
       JR   Z,2$
       INC  HL
       CP   "q"
       JR   Z,3$
       CP   #B
       JR   Z,3$
       CP   "a"
       JR   Z,4$
       CP   #A
       JR   Z,4$
       CP   "P"
       JR   Z,11$
       CP   "O"
       JP   Z,12$
       CP   "Q"
       JP   Z,13$
       CP   "A"
       JP   Z,LAB14
       CP   " "
       JR   NZ,100$
       LD   HL,$DLX
       LD   DE,$DLY
       LD   BC,5
       LDIR
       LD   A,($LENS)
       LD   ($LENS+1),A
       JR   101$
1$     LD   A,(HL)
       CP   94
       JR   NC,31$
41$    INC  (HL)
       CP   20
       JR   C,100$
       INC  (HL)
       CP   50
       JR   C,100$
       INC  (HL)
       INC  (HL)
       INC  (HL)
       JR   100$
31$    LD   (HL),10
       JR   12$
2$     LD   A,(HL)
       CP   11
       JR   C,32$
42$    DEC  (HL)
       CP   21
       JP   C,100$
       DEC  (HL)
       CP   51
       JP   C,100$
       DEC  (HL)
       DEC  (HL)
       DEC  (HL)
       JP   100$
32$    LD   (HL),95
       JR   11$
3$     LD   A,(HL)
       CP   94
       JR   C,41$
       LD   (HL),10
       JP   LAB14
4$     LD   A,(HL)
       CP   11
       JR   NC,42$
       LD   (HL),95
       JR   13$
11$    LD   HL,N10
       LD   (200$+1),HL
202$   LD   HL,$DLX
201$   PUSH HL
       CALL $INTO
200$   LD   HL,N10
       CALL $INTO
       LD   HL,CH101
       CALL $INIER
        CALL $ROM
       RST  #28
       DEFB #04,#38
        CALL $CHIC
       CALL CP0
       POP  HL
       JP   Z,101$
       CALL $OUTFR
       JP   101$
12$    LD   HL,N01
       LD   (200$+1),HL
       JR   202$
13$    LD   HL,N10
6$     LD   (200$+1),HL
       LD   HL,$DLY
       JR   201$
LAB14  LD   HL,N01
       JR   LAB14-8
CH101  CALL $CHIC
       JP   LAB101
CP0    LD   HL,(23653)
       DEC  HL
       XOR  A
       OR   (HL)
       DEC  HL
       OR   (HL)
       DEC  HL
       OR   (HL)
       DEC  HL
       OR   (HL)
       DEC  HL
       OR   (HL)
       AND  A
       RET

SQR    LD   HL,#1008
       LD   ($COORD),HL
       LD   HL,$LENS
       LD   B,(HL)
       INC  HL
       PUSH HL
       CALL $HORIZ
       POP  HL
       LD   B,(HL)
       PUSH HL
       CALL $VERT
       LD   HL,#1008
       LD   ($COORD),HL
       POP  HL
       LD   B,(HL)
       PUSH HL
       CALL $VERT
       POP  HL
       DEC  HL
       LD   B,(HL)
       CALL $HORIZ
       RET
POR
       LD   HL,$DLX
       CALL $INTO
        CALL $ROM
       RST  #28
       DEFB #2E,#38
       CALL #2BF1
        CALL $CHIC
       PUSH DE
       LD   B,C
       LD   C,#C
       LD   HL,#140B
       RST  16
       CALL CLIR
       LD   C,#6D
       POP  HL
       RST  16
       LD   HL,$DLY
       CALL $INTO
        CALL $ROM
       RST  #28
       DEFB #2E,#38
       CALL #2BF1
        CALL $CHIC
       PUSH DE
       LD   B,C
       LD   C,#C
       LD   HL,#0609
       RST  16
       CALL CLIR
       LD   C,#6D
       POP  HL
       RST  16
       RET
CLIR
       PUSH BC
       PUSH HL
       LD   B,13
       LD   C,#A
1$     LD   A," "
       RST  16
       DJNZ 1$
       POP  HL
       LD   C,#C
       RST  16
       POP  BC
       RET
N01    DEFB #7D,#4C,#CC,#CC,#CC
N10    DEFB 0,0,10,0,0

$SCWIN DEFB 6,5,17,14,7*8,#FF,6*8,5*8,14*8,17*8
SCT    DEFM "       Scale       "
       DEFB 13
