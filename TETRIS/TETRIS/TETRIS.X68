; =============================================================================
; GAME
; =============================================================================

; -----------------------------------------------------------------------------
INITTETRIS
; PREPARES VARIABLES FOR NEW GAME
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - MATRIX
; -----------------------------------------------------------------------------
            
            MOVEM.L D0/A0,-(A7)
            
            ; CLEAR VARIABLES
            
            CLR.B   TETROROT                ; DEFAULT ROTATION
            CLR.B   TETROPOS                ; DEFAULT POSITION
            CLR.B   GAMEOVER                ; DEFAULT GAMEOVER STATUS
            CLR.B   TETRONXT                ; DEFAULT NEXT TETROMINO
            CLR.L   SCORE                   ; DEFAULT SCORE
            
            ; CLEAR MATRIX
            
            LEA.L   HMATRIX,A0
            MOVE.L  #MROW*MCOLUMN-1,D0        ; COUNTER OF CELLS TO CLEAN
.LOOP2      CLR.B   (A0,D0)
            DBRA    D0,.LOOP2

            ; DEFINE MATRIX LIMIT
            
            LEA.L   LIMIT,A0
            MOVE.L  #MCOLUMN-1,D0           ; COUNTER OF CELLS TO SET 
.LOOP3      MOVE.B  #$F1,(A0,D0)
            DBRA    D0,.LOOP3            
            
            MOVEM.L (A7)+,D0/A0
            RTS

; -----------------------------------------------------------------------------
ISGAMEOVER
; CHECKS IF THE GAME MUST END
; INPUT    - NONE
; OUTPUT   - GAMEOVER
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L D0/A0,-(A7)         
            
            LEA.L   MATRIX,A0               ; A0 = VISIBLE MATRIX POINTER
            SUB.L   #MCOLUMN,A0             ; A0 = LAST NON VISIBLE ROW POINTER
            MOVE.L  #MCOLUMN-1,D0           ; D0 = MATRIX CELLS TO CHECK
            
.LOOP       BTST.B  #TESTBIT0,(A0,D0)              ; IF CELL IS FILLED
            BNE     .GAMEOVER               ; IF IS FILLED END GAME
            DBRA    D0,.LOOP                ; CHECK NEXT CELL
            BRA     .END
            
.GAMEOVER   MOVE.B  #1,GAMEOVER             ; SETS GAMEOVER TO 1    
            
.END        MOVEM.L (A7)+,D0/A0
            RTS

; -----------------------------------------------------------------------------
ISTETRIS
; CHECKS IF THERE IS A TETRIS
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - MATRIX, SCORE
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D4/A0,-(A7)         
            
            LEA.L   MATRIX,A0               ; A0 = MATRIX BEGIN
            CLR.L   D0
            CLR.L   D1
            CLR.L   D3
            CLR.L   D4
            BRA     .START
            
            ; LOOP TO FIND A FULL LINE
 
.NEXT1      ADDQ.B  #1,D1
            ADD.B   D1,D0                      
            CMP     #(MROW-4)*MCOLUMN,D0
            BEQ     .EXIT
.START      MOVE.L  #MCOLUMN-1,D1                        
            
            ; CHECKS THE ROW IF IS FULL
            
.LOOP1      BTST.B  #TESTBIT0,(A0,D0)
            BEQ     .NEXT1
            ADDQ.B  #1,D0
            DBRA    D1,.LOOP1
            
            ; IF A ROW IS FULL THEN
            
            MOVE.B  D0,D4                   
            SUB.B   #MCOLUMN,D4             ; STARTING CELL IN FIRST FULL LINE
            
            ; CLEAN THE FULL ROW
            
.CLEAN      MOVE.W  #MCOLUMN-1,D1
.LOOP2      SUBQ.B  #1,D0
            CLR.B   (A0,D0)
            DBRA    D1,.LOOP2
            ADD.B   #MCOLUMN,D0          
            
            ; UPDATE FULL ROW COUNTER
            
            ADDQ.B  #1,D3
            CMP     #4,D3
            BEQ     .MOVE
            CMP     #(MROW-4)*MCOLUMN,D0
            BEQ     .MOVE
            
            ; CHECK NEXT LINE IF IS FULL
            
            MOVE.W  #MCOLUMN-1,D1
.LOOP3      BTST.B  #TESTBIT0,(A0,D0)
            BEQ     .PREMOVE
            ADDQ.B  #1,D0
            DBRA    D1,.LOOP3
            BRA     .CLEAN  

            ; MOVE MATRIX CONTENT DOWN

.PREMOVE    ADDQ.B  #1,D1
            ADD.B   D1,D0
            SUB.B   #MCOLUMN,D0
            
.MOVE       LEA.L   HMATRIX,A0
            ADD.B   #MCOLUMN*4-1,D4
            ADD.B   #MCOLUMN*4-1,D0

.LOOP4      MOVE.B  (A0,D4),(A0,D0)
            SUBQ.B  #1,D0
            DBRA    D4,.LOOP4
            
            ; REPRODUCE SOUND
            
            CMP.B   #4,D3
            BNE     .NSOUND
            MOVE.B  #NCLEAR,D1
            BRA     .PLAY
.NSOUND     MOVE.B  #NLINE,D1
.PLAY       JSR     SOUNDPLAY 
            
            ; UPDATE SCORE

            MOVE.L  #BASESCRE,D4
            SUBQ.W  #1,D3   
.LOOP5      MULU.W  #BASESCRE,D4
            DBRA    D3,.LOOP5
            ADD.L   D4,SCORE          
                       
.EXIT       MOVEM.L (A7)+,D0-D4/A0
            RTS
































*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
