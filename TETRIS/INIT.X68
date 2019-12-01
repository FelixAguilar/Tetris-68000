; =============================================================================
; INIT
; =============================================================================

; -----------------------------------------------------------------------------
INITMATRIX
; CLEAR MATRIX
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - MATRIS
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D2/A0,-(A7)
            LEA.L   HROW4,A0
            MOVE.L  #MROW,D0
            MULU.W  #MCOLUMN,D0             ; COUNTER OF CELLS TO CLEAN
.LOOP       CLR.B   (A0,D0)
            ;MOVE.B  #$31,(A0,D0)
            DBRA    D0,.LOOP
            MOVEM.L (A7)+,D0-D2/A0
            RTS





*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
