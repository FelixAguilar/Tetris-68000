; =============================================================================
; MENU
; =============================================================================

; -----------------------------------------------------------------------------
DRAWMENU
; OPERATIONS TO DRAW THE MENU
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D1-D2/A0,-(A7)
            
            MOVE.B  #125,D1
            MOVE.B  #64,D2
            JSR     SETCURSOR
            LEA     .TEXT1,A0
            JSR     DRAWTEXT
            MOVE.B  #140,D1
            MOVE.B  #64,D2 
            JSR     SETCURSOR
            LEA     .TEXT2,A0
            JSR     DRAWTEXT 

            MOVEM.L (A7)+,D1-D2/A0       
            RTS
            
.TEXT1      DC.B    'TETRIS',0
.TEXT2      DC.B    'PRESS "SPACE" TO START THE GAME',0
            DS.W    0
*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
