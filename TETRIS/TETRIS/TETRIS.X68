; =============================================================================
; TETRIS
; =============================================================================

; -----------------------------------------------------------------------------
INITTETRIS
; PREPARES VARIABLES FOR NEW GAME
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - MATRIX,TETROROT,TETROPOS,TETRONXT,SCORE
; -----------------------------------------------------------------------------
            
            MOVEM.L D0/A0,-(A7)
            
            ; CLEAR VARIABLES
            
            CLR.B   TETROROT
            CLR.B   TETROPOS
            CLR.B   TETRONXT
            CLR.L   SCORE
            
            ; CLEAR MATRIX
            
            LEA.L   HMATRIX,A0
            MOVE.L  #MROW*MCOLUMN-1,D0
.LOOP2      CLR.B   (A0,D0)
            DBRA    D0,.LOOP2

            ; DEFINE MATRIX LIMIT
            
            LEA.L   LIMIT,A0
            MOVE.L  #MCOLUMN-1,D0 
.LOOP3      MOVE.B  #$F1,(A0,D0)
            DBRA    D0,.LOOP3            
            
            MOVEM.L (A7)+,D0/A0
            RTS

; -----------------------------------------------------------------------------
ISGAMEOVER
; CHECKS IF THE GAME MUST END
; INPUT    - NONE
; OUTPUT   - D0.B = IS GAME OVER
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVE.L  A0,-(A7)         
            
            ; DATA PREPARATIOM
            
            LEA.L   MATRIX,A0               ; A0 = MATRIX LIST
            SUB.L   #MCOLUMN,A0             ; A0 = FIRST HIDEN MATRIX COLUMN
            MOVE.L  #MCOLUMN-1,D0           ; D0 = NUMBER OF SQUARE TO CHECK
            
            ; CHECK LINE
            
.LOOP       BTST.B  #0,(A0,D0)              ; CHECK IF THE SQUARE IS FILLED
            BNE     .GAMEOVER               ; IF TRUE THEN GAME OVER
            DBRA    D0,.LOOP                ; NEXT CELL TO CHECK
            MOVE.B  #0,D0                   ; IF THE COLUMN IF EMPTY D0 = 0
            BRA     .EXIT                   ; EXIT
            
            ; SET GAME OVER
            
.GAMEOVER   MOVE.B  #1,D0                   ; IF IS GAME OVER D0 = 1;
            
.EXIT       MOVE.L  (A7)+,A0
            RTS

; -----------------------------------------------------------------------------
ISTETRIS
; CHECKS IF THERE IS AT LEAST ONE FULL ROW AND MAX FOR FULL ROWS AND UPDATES 
; MATRIX BY CLEANING THEM AND MOVEING MATRIX CONTENT DOWN
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - MATRIX, SCORE
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D4/A0,-(A7)         
            
            ; CLEAR REGISTERS
            
            CLR.L   D0   
            CLR.L   D1
            CLR.L   D3
            CLR.L   D4
            
            ; LIST POINTERS
            
            LEA.L   MATRIX,A0               ; A0 = MATRIX LIST         
            BRA     .START                  ; JUMP TO START LABEL
            
            ; NEXT LINE
 
.NEXT       ADDQ.B  #1,D1                   ; ADDS ONE TO D1
            ADD.B   D1,D0                   ; ADDS THE REMAINING SQUARES TO D0
            CMP.B   #(MROW-4)*MCOLUMN,D0    ; CHECKS IF D0 IS OUT OF MATRIX
            BEQ     .EXIT                   ; IF TRUE THEN EXIT
            
            ; CHECK IF THE LINE IS FULL
            
.START      MOVE.L  #MCOLUMN-1,D1           ; D1 = LOOP COUNTER                     
.LOOP1      BTST.B  #0,(A0,D0)              ; CHECKS IF THE SQUARE IS FILLED
            BEQ     .NEXT                   ; IF NOT THEN NEXT ROW
            ADDQ.B  #1,D0                   ; NEXT SQUARE TO CHECK
            DBRA    D1,.LOOP1               ; NEXT SQUARE TO CHECK 
            MOVE.B  D0,D4
            SUB.B   #MCOLUMN,D4             ; D4 = FIRST FULL ROW     
            
            ; CLEAR THE ROW IF IT IS FULL
            
.CLEAN      MOVE.W  #MCOLUMN-1,D1           ; D1 = LOOP COUNTER
.LOOP2      SUBQ.B  #1,D0                   ; SUBSTRACT 1 TO D0
            CLR.B   (A0,D0)                 ; CLEAR SQUARE
            DBRA    D1,.LOOP2               ; NEXT SQUARE
            ADD.B   #MCOLUMN,D0             ; RESTORES D0 BEFORE CLEANING
            
            ; UPDATE FULL ROW COUNTER
            
            ADDQ.B  #1,D3                   ; D3 = NUMBER OF FULL ROWS
            BTST.L  #3,D3                   ; CHECKS IF D3 IS EQUAL TO 4
            BNE     .MOVE                   ; IF TRUE THEN MOVE
            CMP     #(MROW-4)*MCOLUMN,D0    ; CHECKS IF D0 IS OUT OF MATRIX
            BEQ     .MOVE                   ; IF TRUE THEN MOVE
            
            ; CHECK NEXT LINE IF IS FULL TOO
            
            MOVE.W  #MCOLUMN-1,D1           ; D1 = LOOP COUNTER
.LOOP3      BTST.B  #0,(A0,D0)              ; CHECKS IF THE CELL IS FULL
            BEQ     .PREMOVE                ; IF NOT THEN PREMOVE
            ADDQ.B  #1,D0                   ; MOVE SQUARE POINTER
            DBRA    D1,.LOOP3               ; CHECK NEXT SQUARE
            BRA     .CLEAN                  ; IF FULL THEN CLEAR ROW

            ; MOVE MATRIX VALUES DOWN

.PREMOVE    SUB.B   #MCOLUMN-1,D0           ; SUBSTRACT TO D0 A COLUMN - 1
            ADD.B   D1,D0                   ; ADDS REMAINING SQUARES TO D0 
            
.MOVE       LEA.L   HMATRIX,A0              ; A0 = HIDEN MATRIX POINTER
            ADD.B   #MCOLUMN*4-1,D4         ; UPDATES D4 FOR NEW MATRIX POINTER
            ADD.B   #MCOLUMN*4-1,D0         ; UPDATES D0 FOR NEW MATRIX POINTER

.LOOP4      MOVE.B  (A0,D4),(A0,D0)         ; MOVE CONTENT FROM D4 TO D3
            SUBQ.B  #1,D0                   ; SUBSTRACT 1 TO D0
            DBRA    D4,.LOOP4               ; NEXT SQUARE TO MOVE
            
            ; REPRODUCE SOUND
            
            BTST.L  #2,D3                   ; IF D3 = 4 PLAY NCLEAR SOUND
            BEQ     .NSOUND
            MOVE.B  #NCLEAR,D1
            BRA     .PLAY
.NSOUND     MOVE.B  #NLINE,D1               ; IF NOT PLAY NLINE SOUND
.PLAY       JSR     SOUNDPLAY 
            
            ; UPDATE SCORE

            SUBQ.B  #1,D3                   ; SUBSTRACT ONE TO D3
            MOVE.L  #BASESCRE,D4            ; D4 = SCORE GAINED
.LOOP5      LSL.L   #BASESCRE/2,D4          ; D4^2
            DBRA    D3,.LOOP5               ; MULTIPLIES BASESCRE D3 TIMES
            ADD.L   D4,SCORE                ; ADDS TP THE SCORE
                       
.EXIT       MOVEM.L (A7)+,D0-D4/A0
            RTS






































*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
