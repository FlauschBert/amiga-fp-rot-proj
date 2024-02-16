;***********************************************
;*                                             *
;*               REAL - TIME                   *
;*                                             *
;*              3D - GRAPHICS                  *
;*                                             *
;*       (C) 1989 BY LUTZ GROßHENNIG           *
;*                                             *
;***********************************************

;---------- includes ----------
       INCDIR        "include"
       include       "funcdef.i"
       include       "hw.i"

       include       "exec/exec_lib.i"

; OFFSETS INTUITION

OPENSCREEN     = -198
CLOSESCREEN    = -066
SCREENTOFRONT  = -252

; OFFSETS GRAPHICS

LOADRGB4       = -192
DRAWTO         = -246
MOVEPEN        = -240
BLITCLEAR      = -300
SETAPEN        = -342
WRITEPIX       = -324
CLEARSCREEN    = -048

; KONSTANTEN

EXECBASE       = $4
MOUSEBUTTON    = $BFE001
PUNKTE         = 55
LINIEN         = 27

;----------------------------------------------------------

OPENLIB:MACRO *\NAME,*\BASE

       MOVE.L  EXECBASE,A6
       LEA     \1,A1
       JSR     _LVOOldOpenLibrary(A6)     ; use this on Amiga OS 2.0 (Old)
       MOVE.L  D0,\2

 ENDM

CLOSELIB:MACRO *\BASE

       MOVE.L  EXECBASE,A6
       MOVE.L  \1,A1
       JSR     _LVOCloseLibrary(A6)

 ENDM

SETCOLORS:MACRO *\PALETTE,%\COUNT

       MOVE.L  GFXBASE,A6
       MOVE.L  VIEWPORT,A0
       LEA     \1,A1
       MOVEQ   #\2,D0
       JSR     LOADRGB4(A6)

 ENDM

;------------  M A I N  -  P R O G R A M  -----------------

START:

       OPENLIB       INTNAME,INTBASE
       OPENLIB       GFXNAME,GFXBASE
       BSR           OPENSCR
       SETCOLORS     PALETTE,2

       MOVE.L        EXECBASE,A6
       JSR           _LVODisable(A6)

       BSR           TURN                 ; prepare BUFFER
       BSR           INIT_IRQ
       
MAIN_LOOP:

       BTST    #6,MOUSEBUTTON
       BNE     MAIN_LOOP

ENDE:
       BSR     EXIT_IRQ

       MOVE.L  EXECBASE,A6
       JSR     _LVOEnable(A6)

       BSR     CLOSESCR
       CLOSELIB    INTBASE
       CLOSELIB    GFXBASE

       RTS

;----------------------------------------------------------

TURN:

       LEA     STRUKTUR,A0
       LEA     BUFFER,A1
       MOVEQ   #PUNKTE,D0

TURN_LOOP:

       MOVE.W  (A0)+,D1       ; X
       MOVE.W  (A0)+,D2       ; Y
       MOVE.W  (A0)+,D3       ; Z

       BSR     DREHUNG        ; UM ACHSEN

       MOVE.W  D1,(A1)+
       MOVE.W  D2,(A1)+
       MOVE.W  D3,(A1)+

       DBRA    D0,TURN_LOOP
       ADDQ.W  #1,WINKEL              ; X ACHSE
       ADDQ.W  #3,WINKEL1             ; Y   "
       ADDQ.W  #2,WINKEL2             ; Z   "
       RTS

DREHUNG:                       ; X

       MOVE.W  WINKEL,D7       ; WINKEL IN D7
       BSR     COS             ; X IN D1
       MULS    D2,D6           ; Y IN D2
       MOVE.L  D6,D4           ; Z IN D3

       MOVE.W  WINKEL,D7
       BSR     SIN
       MULS    D3,D6
       ADD.L   D6,D4
       ASL.L   #2,D4
       SWAP    D4

       MOVE.W  WINKEL,D7
       BSR     COS
       MULS    D3,D6
       MOVE.L  D6,D5

       MOVE.W  WINKEL,D7
       BSR     SIN
       MULS    D2,D6
       SUB.L   D6,D5
       ASL.L   #2,D5
       SWAP    D5

       MOVE.W  D4,D2
       MOVE.W  D5,D3
                                                ; Y
       MOVE.W  WINKEL1,D7       ; WINKEL IN D7
       BSR     COS             ; X IN D1
       MULS    D1,D6           ; Y IN D2
       MOVE.L  D6,D4           ; Z IN D3

       MOVE.W  WINKEL1,D7
       BSR     SIN
       MULS    D3,D6
       ADD.L   D6,D4
       ASL.L   #2,D4
       SWAP    D4

       MOVE.W  WINKEL1,D7
       BSR     COS
       MULS    D3,D6
       MOVE.L  D6,D5

       MOVE.W  WINKEL1,D7
       BSR     SIN
       MULS    D1,D6
       SUB.L   D6,D5
       ASL.L   #2,D5
       SWAP    D5

       MOVE.W  D4,D1
       MOVE.W  D5,D3

       MOVE.W  WINKEL2,D7       ; WINKEL IN D7       ; Z
       BSR     COS             ; X IN D1
       MULS    D1,D6           ; Y IN D2
       MOVE.L  D6,D4           ; Z IN D3

       MOVE.W  WINKEL2,D7
       BSR     SIN
       MULS    D2,D6
       ADD.L   D6,D4
       ASL.L   #2,D4
       SWAP    D4

       MOVE.W  WINKEL2,D7
       BSR     COS
       MULS    D2,D6
       MOVE.L  D6,D5

       MOVE.W  WINKEL2,D7
       BSR     SIN
       MULS    D1,D6
       SUB.L   D6,D5
       ASL.L   #2,D5
       SWAP    D5

       MOVE.W  D4,D1
       MOVE.W  D5,D2

       RTS

 ALIGN 2

WINKEL:        DC.W    0
WINKEL1:       DC.W    0
WINKEL2:       DC.W    0
;----------------------------------------------------------

PROJEKTION:

       LEA     BUFFER,A0
       LEA     SCREEN_KOORDS,A1
       MOVEQ   #PUNKTE,D7

PROJEKTION_LOOP:

       MOVE.W  (A0)+,D0        ; X
       MOVE.W  (A0)+,D1        ; Y
       MOVE.W  (A0)+,D2        ; Z

       SUB.W   AUGE,D2         ; Z - AUGE
       MULS    AUGE,D0         ; X * AUGE
       MULS    AUGE,D1         ; Y * AUGE
       DIVS    D2,D0           ; X*AUGE/Z-AUGE
       DIVS    D2,D1           ; Y*AUGE/Z-AUGE
       NEG     D0              ; X = -X
       ADD.W   #160,D0         ; MITTE X
       ADD.W   #128,D1         ; MITTE Y

       MOVE.W  D0,(A1)+
       MOVE.W  D1,(A1)+

       DBRA    D7,PROJEKTION_LOOP
       RTS


;----------------------------------------------------------

MALEN:

       MOVE.L  GFXBASE,A6
       LEA     SCREEN_KOORDS,A4
       MOVEQ   #LINIEN,D7
       MOVE.L  RASTPORT,A1

MALEN_LOOP:
       MOVE.W  (A4)+,D0
       MOVE.W  (A4)+,D1
       JSR     MOVEPEN(A6)

       MOVE.W  (A4)+,D0
       MOVE.W  (A4)+,D1
       JSR     DRAWTO(A6)

       DBRA    D7,MALEN_LOOP
       RTS

;----------------------------------------------------------

OPENSCR:

       MOVE.L  INTBASE,A6
       LEA     SCREENDEVS,A0
       JSR     OPENSCREEN(A6)
       MOVE.L  D0,SCREENHD
       ADD.L   #44,D0
       MOVE.L  D0,VIEWPORT
       ADD.L   #40,D0
       MOVE.L  D0,RASTPORT
       RTS

CLOSESCR:

       MOVE.L  INTBASE,A6
       MOVE.L  SCREENHD,A0
       JSR     CLOSESCREEN(A6)
       RTS

;----------------------------------------------------------

CLS:

       MOVE.L  GFXBASE,A6
       MOVE.L  RASTPORT,A5
       MOVEQ   #108,D0
       ADD.L   D0,A5
       MOVE.L  (A5),A1
       MOVE.W  #10240,D0
       MOVEQ   #0,D1
       JSR     BLITCLEAR(A6)
       RTS

;----------------------------------------------------------

COS:
       ADD.B   #64,D7
SIN:
       MOVE.W  D7,D6
       LSL.W   #1,D6
       AND.W   #255,D6
       LEA     SINDAT,A6
       MOVE.W  (A6,D6.W),D6
       BTST    #7,D7
       BEQ.S   SIN1
       NEG.W   D6
SIN1:
       RTS

;----------------------------------------------------------

WAIT_FOR_FLOPPY:
       move.l #600000,d0

WAIT_FOR_FLOPPY_LOOP:
       dbne d0,WAIT_FOR_FLOPPY_LOOP

       rts

;----------------------------------------------------------

INIT_IRQ:
       bsr           WAIT_FOR_FLOPPY

       lea           CUSTOM,a6

       move.l        $6c,OLDIRQ                  ; save old jump address / interrupt lvl 3
       move.w        intenar(a6),OLDINTENA       ; save old interrupt bit mask

       move.l        #NEWIRQ,$6c                 ; set new jump address / interrupt lvl 3

       move.w        #$7fff,intena(a6)           ; clear all interrupts
       move.w        #$c020,intena(a6)           ; enable interrupt VERTB (bit 5, 14 and 15)

       rts

EXIT_IRQ:
       lea           CUSTOM,a6

       ori.w         #$8000,OLDINTENA            ; add clear bit to saved interrupt bit mask
       move.w        #$7fff,intena(a6)           ; clear all interrupts
       move.w        OLDINTENA,intena(a6)        ; restore old interrupt bit mask

       move.l        OLDIRQ,$6c                  ; install old subroutine

       rts

;----------------------------------------------------------

NEWIRQ:
       movem.l       d0-d7/a0-a6,-(sp)    ; save environment

       lea           CUSTOM,a6
       move.w        #$0020,intreq(a6)    ; re-enable VERTB interrupt

       bsr           CLS
       bsr           PROJEKTION
       bsr           MALEN
       bsr           TURN

       movem.l       (sp)+,d0-d7/a0-a6    ; restore environment

       rte

;----------------------------------------------------------

SINDAT:

       DC.W    $0000,$0192,$0324,$04B5,$0646,$07D6,$0964,$0AF1
       DC.W    $0C7C,$0E06,$0F8D,$1112,$1294,$1413,$1590,$1709
       DC.W    $187E,$19EF,$1B5D,$1CC6,$1E2B,$1F8C,$20E7,$223D
       DC.W    $238E,$24DA,$2620,$2760,$289A,$29CE,$2AFB,$2C21
       DC.W    $2D41,$2E5A,$2F6C,$3076,$3179,$3274,$3368,$3453
       DC.W    $3537,$3612,$36E5,$37B0,$3871,$392B,$39DB,$3A82
       DC.W    $3B21,$3BB6,$3C42,$3CC5,$3D3F,$3DAF,$3E15,$3E72
       DC.W    $3EC5,$3F0F,$3F4F,$3F85,$3FB1,$3FD4,$3FEC,$3FFB
       DC.W    $4000,$3FFB,$3FEC,$3FD4,$3FB1,$3F85,$3F4F,$3F0F
       DC.W    $3EC5,$3E72,$3E15,$3DAF,$3D3F,$3CC5,$3C42,$3BB6
       DC.W    $3B21,$3A82,$39DB,$392B,$3871,$37B0,$36E5,$3612
       DC.W    $3537,$3453,$3368,$3274,$3179,$3076,$2F6C,$2E5A
       DC.W    $2D41,$2C21,$2AFB,$29CE,$289A,$2760,$2620,$24DA
       DC.W    $238E,$223D,$20E7,$1F8C,$1E2B,$1CC6,$1B5D,$19EF
       DC.W    $187E,$1709,$1590,$1413,$1294,$1112,$0F8D,$0E06
       DC.W    $0C7C,$0AF1,$0964,$07D6,$0646,$04B5,$0324,$0192
       DC.W    0,0


OLDIRQ:       dc.l   0
OLDINTENA:    dc.w   0


SCREENDEVS:

       DC.W    0,0,320,256,1
       DC.B    0,1
       DC.W    2,15
       DC.L    0,0,0,0

PALETTE:

       DC.W    $0000,$0090

AUGE:          DC.W    -1000
GFXBASE:       DC.L    0
INTBASE:       DC.L    0
SCREENHD:      DC.L    0
RASTPORT:      DC.L    0
VIEWPORT:      DC.L    0

GFXNAME:       DC.B    "graphics.library",0
INTNAME:       DC.B    "intuition.library",0

  ALIGN 2

STRUKTUR:
              ; RUMPF

               DC.W      -50,  0,  0, 50,  0, 40
               DC.W      -50,  0,  0, 50,  0,-40
               DC.W       50,  0, 40, 50,  3,  6

               DC.W       50,  0, 40, 50, -3,  6
               DC.W       50,  3,  6, 50, -3,  6

               DC.W      -50,  0,  0, 50,  3,  6
               DC.W      -50,  0,  0, 50, -3,  6

               DC.W      -50,  0,  0, 50,  3, -6
               DC.W      -50,  0,  0, 50, -3, -6

               DC.W       50,  0,-40, 50,  3, -6
               DC.W       50,  0,-40, 50, -3, -6
               DC.W       50,  3, -6, 50, -3, -6
               DC.W       50,  3, -6, 50,  3,  6
               DC.W       50, -3, -6, 50, -3,  6

;              *******   COCKPIT  *******

               DC.W      -36,  2,  0,-18,  1,  2
               DC.W      -36,  2,  0,-18,  4,  0
               DC.W      -36,  2,  0,-18,  1, -2

               DC.W      -18,  1,  2,-18,  4,  0
               DC.W      -18,  1, -2,-18,  4,  0

               DC.W        0,  2,  0,-18,  1,  2
               DC.W        0,  2,  0,-18,  1, -2
               DC.W        0,  2,  0,-18,  4,  0

;              **** LEITWERK ********

               DC.W       14,  1, 20, 50, 11, 28
               DC.W       14,  1, 20, 50,  1, 20
               DC.W       50, 11, 28, 50,  1, 20

               DC.W       14,  1,-20, 50, 11,-28
               DC.W       14,  1,-20, 50,  1,-20
               DC.W       50, 11,-28, 50,  1,-20

   ALIGN 2

BUFFER:        DS.W    300,0
SCREEN_KOORDS:
               DS.W    300,0
 END



