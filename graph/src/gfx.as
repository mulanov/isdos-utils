;Набор графических процедур

;$PLOT  точка.  BC=YX -координаты в окне.
;Устанавливает $COORD
;$LINEG рисование линии из точки ($COORD)
;в точку ( ($COORD)x+1 ;B)
;$REFOR    перевод   координаты   в  окне
;(BC=YX) в стандартные координаты
;$REFAD  расчет адреса на экране и смеще-
;ния в B по координатам
;$PLOTX точка. BC=YX-координаты на экране
;$IX678 вычисление (IX+6,7,8,9)

$COORD DEFW 0

$PLOT  LD   ($COORD),BC
       CALL $REFOR
       RET  C
$PLOTX PUSH BC
       CALL $REFAD
       LD   A,1
       INC  B
PXY    RRCA
       DJNZ PXY
$PLOPR OR  (HL)
       LD   (HL),A
       POP  BC
       RET

$REFOR LD   A,(IX+8)
       DEC  A
       CP   C
       RET  C
       LD   A,C
       ADD  A,(IX+6)
       LD   C,A
       LD   A,(IX+9)
       DEC  A
       SUB  B
       RET  C
       ADD  A,(IX+7)
       LD   B,A
       RET

$REFAD LD   A,C
       AND  7
       LD   (LDB+1),A
       LD   A,C
       RRCA
       RRCA
       RRCA
       AND  #1F
       LD   C,A
       CALL $PIXAD
LDB    LD   B,0
       RET

$N_LIN INC  H
       LD   A,H
       AND  7
       RET  NZ
       LD   A,L
       ADD  A,#20
       LD   L,A
       SBC  A,A
       CPL
       AND  8
       SUB  H
       NEG
       LD   H,A
       RET

$P_LIN DEC  H
       LD   A,H
       AND  7
       CP   7
       RET  NZ
       LD   A,L
       SUB  #20
       LD   L,A
       SBC  A,A
       AND  8
       SUB  H
       NEG
       ADD  A,8
       LD   H,A
       RET

$PIXAD LD   A,B
       AND  7
       LD   H,A
       LD   A,B
       RRCA
       RRCA
       RRCA
       AND  #18
       XOR  H
       XOR  #40
       LD   H,A
       LD   A,B
       RLCA
       RLCA
       JR   ADDS1
$ATAD  LD   A,B
       RRCA
       RRCA
       RRCA
       AND  #03
       XOR  #58
       LD   H,A
       JR   ADDS2
$SYMAD LD   A,B
       AND  #18
       XOR  #40
       LD   H,A
ADDS2  LD   A,B
       RRCA
       RRCA
       RRCA
ADDS1  AND  #E0
       XOR  C
       LD   L,A
       RET

$VERT  PUSH DE
       LD   E,B
       LD   BC,($COORD)
       LD   D,B
       CALL $REFOR
       CALL $REFAD
       LD   A,D
       ADD  A,E
       LD   ($COORD+1),A
       LD   A,1
       INC  B
1$     RRCA
       DJNZ 1$
       LD   D,A
       LD   B,E
2$     LD   A,D
       XOR  (HL)
       LD   (HL),A
       CALL $P_LIN
       DJNZ 2$
       POP  DE
       RET
$HORIZ
       PUSH DE
       LD   A,($COORD)
       AND  7
       LD   E,0
       LD   D,A
       INC  A
1$     SCF
       RR   E
       DEC  A
       JR   NZ,1$
       RL   E
       LD   A,B
       ADD  A,D
       PUSH AF
       AND  7
       LD   D,0
       INC  A
2$     SCF
       RR   D
       DEC  A
       JR   NZ,2$
       RL   D
       POP  AF
       RRCA
       RRCA
       RRCA
       AND  #1F
       LD   C,A
       PUSH BC
       LD   BC,($COORD)
       CALL $REFOR
       CALL $REFAD
       POP  BC
       LD   A,(HL)
       XOR  E
       LD   (HL),A
       INC  C
       DEC  C
       JR   Z,13$
3$     LD   A,(HL)
       CPL
       LD   (HL),A
       INC  HL
       DEC  C
       JR   NZ,3$
13$    LD   A,(HL)
       XOR  D
       LD   (HL),A
       LD   HL,$COORD
       LD   A,(HL)
       ADD  A,B
       LD   (HL),A
       POP  DE
       RET

$IX678 LD   A,(IX)
       ADD  A,A
       ADD  A,A
       ADD  A,A
       LD   (IX+6),A
       LD   A,(IX+1)
       ADD  A,A
       ADD  A,A
       ADD  A,A
       LD   (IX+7),A
       LD   A,(IX+3)
       ADD  A,A
       ADD  A,A
       ADD  A,A
       LD   (IX+8),A
       LD   A,(IX+2)
       ADD  A,A
       ADD  A,A
       ADD  A,A
       LD   (IX+9),A
       RET
