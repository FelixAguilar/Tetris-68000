; =============================================================================
; SQUARE
; =============================================================================

; -----------------------------------------------------------------------------
INITSQUARE
; ADDS A NEW SQUARE IN THE HIDEN ZONE OF THE MATRIX
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - MATRIX
; -----------------------------------------------------------------------------
            
            MOVEM.L D0/A0,-(A7)
            LEA.L   HROW4,A0
            CLR.L   D0
            
            MOVE.B  #4+MCOLUMN*2,D0
            MOVE.B  D0,FIGPOSI
            
            MOVE.B  #$61,(A0,D0)
            ADDQ.L  #1,D0
            MOVE.B  #$61,(A0,D0)
            ADD.B   #MCOLUMN,D0
            MOVE.B  #$61,(A0,D0)
            SUBQ.L  #1,D0
            MOVE.B  #$61,(A0,D0)
            
            MOVEM.L (A7)+,D0/A0
            RTS
 
; -----------------------------------------------------------------------------
SQUARE
; MOVES THE CURRENT SQUATE IN THE MATRIX
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - MATRIX
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D1/A0,-(A7)
            
            CLR.L   D0
            CLR.L   D1
            
            LEA.L   HROW4,A0
            MOVE.B  FIGPOSI,D0
            MOVE.B  D0,D1
            ADD.B   #MCOLUMN*2,D1
            
            MOVE.B  (A0,D0),(A0,D1)
            CLR.B   (A0,D0)
            ADDQ.B  #1,D0
            ADDQ.B  #1,D1
            MOVE.B  (A0,D0),(A0,D1)
            CLR.B   (A0,D0)
            
            ADD.B   #MCOLUMN-1,D0
            MOVE.B  D0,FIGPOSI
            
            MOVEM.L (A7)+,D0-D1/A0
            RTS



*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
