; =============================================================================
; GAME
; =============================================================================

; -----------------------------------------------------------------------------
DRAWGAME
; OPERATIONS TO DRAW THE GAME
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4,-(A7)
            
            MOVE.L  #$00FFFFFF,D1
            JSR     CHPENCL
            
            MOVE.W  #XMATRIX-5,D1
            MOVE.W  #YMATRIX-5,D2
            MOVE.W  D1,D3
            ADD.W   #MCOLUMN*SIDELENGTH+10,D3
            MOVE.W  D2,D4
            ADD.W   #(MROW-4)*SIDELENGTH+10,D4
            MOVE.B  #90,D0
            TRAP    #15
            JSR DRAWMATRIX
            
            MOVEM.L (A7)+,D0-D4
            RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
