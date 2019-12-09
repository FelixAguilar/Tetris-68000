; =============================================================================
; STATUS
; =============================================================================

; --- CODE INCLUDES -----------------------------------------------------------

            INCLUDE "GAME/CONST.X68"        ; CONSTANTS
            INCLUDE "GAME/INIT.X68"         ; GAME INIT
            INCLUDE "GAME/STATES.X68"       ; GAME STATES

; -----------------------------------------------------------------------------
ISGAMEOVER
; CHECKS IF THERE IS A GAME OVER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L D0/A0,-(A7)         
            
            LEA.L   HROW1,A0
            MOVE.L  #MCOLUMN-1,D0
            
.LOOP       BTST.B  #0,(A0,D0)           
            BNE     .SKIP
            DBRA    D0,.LOOP 
            BRA     .END
            
.SKIP       MOVE.B  #1,GAMEOVER     
            
.END        MOVEM.L (A7)+,D0/A0
            RTS

; -----------------------------------------------------------------------------
ISTETRIS
; CHECKS IF THERE IS A TETRIS
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D4/A0,-(A7)         
            
            LEA.L   ROW0,A0                 ; A0 = MATRIX BEGIN
            CLR.L   D0                      ; D0 = CELL POINTER
            CLR.L   D1                      ; D1 = COLUMN COUNTER
            CLR.L   D3                      ; D3 = FULL ROWS AFTER D2 POINTER
            CLR.L   D4
            BRA     .START
            
            ; LOOP TO FIND A FULL LINE
 
.NEXT1      ADDQ.B  #1,D1
            ADD.B   D1,D0                      
            CMP     #(MROW-4)*MCOLUMN,D0
            BEQ     .EXIT
.START      MOVE.L  #MCOLUMN-1,D1                        
            
            ; CHECKS THE ROW IF IS FULL
            
.LOOP1      BTST.B  #0,(A0,D0)
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
.LOOP3      BTST.B  #0,(A0,D0)
            BEQ     .PREMOVE
            ADDQ.B  #1,D0
            DBRA    D1,.LOOP3
            BRA     .CLEAN  

            ; MOVE MATRIX CONTENT DOWN

.PREMOVE    ADDQ.B  #1,D1
            ADD.B   D1,D0
            SUB.B   #MCOLUMN,D0
            
.MOVE       LEA.L   HROW4,A0
            ADD.B   #MCOLUMN*4-1,D4
            ADD.B   #MCOLUMN*4-1,D0

.LOOP4      MOVE.B  (A0,D4),(A0,D0)
            SUBQ.B  #1,D0
            DBRA    D4,.LOOP4                      
                       
.EXIT       MOVEM.L (A7)+,D0-D4/A0
            RTS


















*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
