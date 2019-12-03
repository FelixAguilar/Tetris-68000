; =============================================================================
; STATUS
; =============================================================================

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




*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
