; Вывод текста (HL) до ВК на щкран с ко-
; ординатами на экране BC  (см. gfx.as)
; требуется модуль gfx.obj
$WORD  PUSH HL
       PUSH BC
       XOR  A
       LD   (CUNT+1),A
       PUSH HL
       CALL $REFAD
       LD   (ADR),HL
       LD   A,($DIREC)
       OR   A
       JR   NZ,41$
       LD   A,B
       CP   4
       LD   A,#20
       CALL NC,PR0
41$    POP  HL
4$     LD   A,(HL)
       INC  HL
       CP   #80
       JR   NC,1$
       CP   #60
       JR   C,2$
       SUB  #20
2$     CP   13
       JR   NZ,3$
       LD   A,(CUNT+1)
       AND  A
       LD   A,#20
       CALL NZ,PR0
       POP  BC
       POP  HL
       RET
1$     LD   A,#20
3$     PUSH HL
       CALL PR0
       JR   41$


PR0    ;ПЕЧАТЬ СИМВОЛА В БУФЕР
       LD   E,A
       LD   D,0
       LD   HL,FONT-<3*32>
       ADD  HL,DE
       ADD  HL,DE
       ADD  HL,DE
       LD   DE,BF
       XOR  A
       LD   B,3
CUNT   LD   A,0
       XOR  1
       LD   (CUNT+1),A
       JR   Z,1$
4$     RLD
       CALL A2DE1
       RLD
       CALL A2DE1
       RLD
       INC  HL
       DJNZ 4$
       RET
1$     RLD
       CALL A2DE2
       RLD
       CALL A2DE2
       RLD
       INC  HL
       DJNZ 1$
PR     ; ПЕЧАТЬ БУФЕРА НА ЭКРАН
       LD   A,($DIREC)
       OR   A
       JR   NZ,1$
       LD   B,6
       LD   HL,(ADR)
       LD   DE,BF+5
       CALL PR1
       LD   HL,ADR
       INC  (HL)
       RET
1$     CALL ROTATE
       LD   B,8
       LD   HL,(ADR)
       LD   DE,BF1+7
       CALL PR1
       LD   (ADR),HL
       RET
PR1    LD   A,(DE)
       XOR  (HL)
       LD   (HL),A
       CALL $P_LIN
       DEC  DE
       DJNZ PR1
       RET

A2DE1  LD   (DE),A
       INC  DE
       RET
A2DE2  PUSH AF
       EX   DE,HL
       RLD
       EX   DE,HL
       INC  DE
       POP  AF
       RET

ROTATE LD   DE,BF1
       LD   C,8
1$     LD   B,8
       XOR  A
       LD   HL,BF
2$     RR   (HL)
       RL   A
       INC  HL
       DJNZ 2$
       LD   (DE),A
       INC  DE
       DEC  C
       JR   NZ,1$
       RET

BF     DEFS 8
BF1    DEFS 8
ADR    DEFW 0
$DIREC DEFB 0
FONT   DEFB 0,0,0
       DEFB %01000100,%01000000,%01000000
       DEFB %10101010,0,0
       DEFB %01101111,%01101111,%01100000
       DEFB %11101100,%11100110,%11100000
       DEFB %10100010,%01001000,%10100000
       DEFB %01101000,%01101000,%01100000
       DEFB %01000100,0,0
       DEFB %00100100,%01000100,%00100000
       DEFB %01000010,%00100010,%01000000
       DEFB 0,%01000000,0
       DEFB %00000100,%11100100,0
       DEFB 0,%0010,%01000000
       DEFB 0,%11100000,0
       DEFB 0,0,%01000000
       DEFB %00100010,%01001000,%10000000
   ;#30
       DEFB %11101010,%10101010,%11100000
       DEFB %11000100,%01000100,%11100000
       DEFB %11100010,%11101000,%11100000
       DEFB %11100010,%11100010,%11100000
       DEFB %10101010,%11100010,%00100000
       DEFB %11101000,%11100010,%11100000
       DEFB %11101000,%11101010,%11100000
       DEFB %11100010,%00100010,%00100000
       DEFB %11101010,%11101010,%11100000
       DEFB %11101010,%11100010,%11100000
       DEFB %00000100,%00000100,0
       DEFB %00000010,%00000010,%01000000
       DEFB %00100100,%10000100,%00100000
       DEFB %00001110,%00001110,0
       DEFB %10000100,%00100100,%10000000
       DEFB %11100010,%01100000,%01000000
   ;#40
       DEFB %11101010,%10001000,%01100000
       DEFB %11101010,%10101110,%10100000
       DEFB %11101010,%11001010,%11100000
       DEFB %11101000,%10001000,%11100000
       DEFB %11001010,#AA,%11000000
       DEFB #E8,#C8,#E0
       DEFB #E8,#C8,#80
       DEFB #E8,#AA,#E0
       DEFB #AA,#EA,#A0
       DEFB #E4,#44,#E0
       DEFB #22,#2A,#40
       DEFB #AA,#CA,#A0
       DEFB #88,#88,#E0
       DEFB #AE,#AA,#A0
       DEFB #EA,#AA,#A0
       DEFB #EA,#AA,#E0
   ;#50
       DEFB #EA,#AE,#80
       DEFB #EA,#AE,#E0
       DEFB #EA,#CA,#A0
       DEFB %01101000,%01000010,%11000000
       DEFB #E4,#44,#40
       DEFB #AA,#AA,#E0
       DEFB #AA,#A4,#40
       DEFB #AA,#AE,#40
       DEFB #AA,#4A,#A0
       DEFB #AA,#E4,#40
       DEFB #E2,#48,#E0
       DEFB #64,#44,#60
       DEFB #88,#42,#20
       DEFB #62,#22,#60
       DEFB #4A,0,0
       DEFB 0,0,#F0
