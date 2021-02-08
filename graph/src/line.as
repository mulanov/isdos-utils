;РИСОВАНИЕ ОТРЕЗКА В ОКНЕ
;DE -Y-COORD
;BC -X-COORD
;ПРОВЕРЯЕТСЯ ВЫХОД ЗА ПРЕДЕЛЫ ОКНА

$LINE

$POUT  LD   A,0
       AND  A
       LD   HL,($COORY)   ;HL=OLD Y
       LD   ($COORY),DE   ;DE=NEW Y
       PUSH BC            ;NEW X
       JR   Z,1$ ;ПЕРВАЯ ТОЧКА В ОКНE
       EX   DE,HL         ;HL=NEW Y
       LD   B,D
       LD   C,E           ;BC=OLD Y
       LD   A,H
       AND  A
       JR   NZ,2$
       LD   A,L           ;new Yl
       EXX          ;HL'=NEW Y;BC'=OLD Y
       POP  HL            ;HL=NEW X
       INC  H
       DEC  H
       JR   NZ,3$
       LD   B,A
       LD   C,L
       PUSH HL
       CALL $PLOT
       POP  HL
       JR   C,3$
       LD   BC,($COORX)   ;BC=OLD X
       LD   ($COORX),HL
       XOR  A
       LD   (EXITC+1),A
       JR   RIS
2$     POP  HL
3$     LD   ($COORX),HL
       JP   EXITC
1$     LD   C,E
       LD   B,D            ;BC=NEW Y
       EXX           ;BC'=NEW Y,HL'=OLD Y
       POP  BC             ;BC=NEW X
       LD   HL,($COORX)    ;HL=OLD X
       LD   ($COORX),BC
RIS
;RISOWANIE
       ;BC-X COORD OF END
       ;HL-X OF BEGIN
       ;BC',HL' -Y
       LD   DE,#0318
8$     LD   (XY),DE
       LD   A,C
       LD   (XEND+1),A
       CP   A
       PUSH HL
       SBC  HL,BC
       INC  H
       DEC  H
       JR   NZ,3$      ;NAPRAWO
       LD   A,H
       AND  A
       LD   E,L       ;DX
       LD   A,#0D     ;DEC C
5$     POP  HL
       JP   NZ,EXITC
       LD   (XDIR),A
       LD   A,E
       EXX
       LD   E,A
       PUSH HL
       CP   A
       SBC  HL,BC
       INC  H
       DEC  H
       JR   NZ,4$      ;WWERH
       LD   A,H
       AND  A
       LD   D,L
       LD   A,#05     ;DEC B
6$     POP  HL
       JR   NZ,EXITC
       LD   (YDIR),A
       JR   7$
3$     LD   A,L
       NEG
       LD   E,A
       DEC  HL
       LD   A,H
       INC  A
       LD   A,#0C     ;INC C
       JR   5$
4$     LD   A,L
       NEG
       LD   D,A
       DEC  HL
       LD   A,H
       INC  A
       LD   A,#04     ;INC B
       JR   6$

;DE-dYdX
;HL,BC- Y1,Y2; HL',BC'-X
7$     LD   (10$+1),DE
       LD   A,E
       SUB  D
       LD   DE,0
       JR   C,8$   ;ОБМЕН X И Y
9$     PUSH AF
       LD   A,L ;Y1
       EXX
       LD   C,L ;X1
       LD   B,A
10$    LD   DE,0
       POP  AF
       LD   L,A ;DX-DY
       XOR  A
       LD   ($POUT+1),A
       LD   H,A
       ADD  HL,HL
       LD   (I2_+1),HL

       LD   L,D
       LD   H,A
       ADD  HL,HL
       LD   (I1+1),HL
       LD   L,D
       LD   H,A
       ADD  HL,HL
       LD   D,A
       SBC  HL,DE

XEND   LD   A,200
       CP   C
       RET  Z
XDIR   INC  C
       JR   Z,EXITC
       BIT  7,H
       JR   Z,YDIR
I1     LD   DE,0
       ADD  HL,DE
       JR   L2
YDIR   INC  B
       JR   Z,EXITC
I2_    LD   DE,0   ;I2_=-I2
       SBC  HL,DE
L2     PUSH BC
XY     DEFW 0
       LD   A,B
       LD   B,C
       LD   C,A
       PUSH HL
       CALL $PLOT
       POP  HL
       POP  BC
       JR   NC,XEND
EXITC  LD   A,1
       LD   ($POUT+1),A
       LD   A,1
       LD   (EXITC+1),A
       RET

$COORX DEFW 0
$COORY DEFW 0

