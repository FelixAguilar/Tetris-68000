; =============================================================================
; GAME
; =============================================================================

; -----------------------------------------------------------------------------
INITMATRIX
; CLEAR MATRIX
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - MATRIS
; -----------------------------------------------------------------------------
            
            MOVEM.L D0/A0,-(A7)
            LEA.L   HROW4,A0
            MOVE.L  #MROW*MCOLUMN-1,D0        ; COUNTER OF CELLS TO CLEAN
.LOOP1      CLR.B   (A0,D0)
            DBRA    D0,.LOOP1
            MOVEM.L (A7)+,D0/A0
            
            LEA.L   ROW20,A0
            MOVE.L  #MCOLUMN-1,D0  
.LOOP2      MOVE.B  #$F1,(A0,D0)
            DBRA    D0,.LOOP2            
            
            RTS

; -----------------------------------------------------------------------------
ISRMOVEDOWN
; CLEAR MATRIX
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - MATRIS
; -----------------------------------------------------------------------------
            
            JSR     DOWNFIGURE
            RTE




*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
