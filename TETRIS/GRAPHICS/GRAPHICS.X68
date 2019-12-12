; =============================================================================
; GRAPHICS
; =============================================================================

; --- CODE INCLUDES -----------------------------------------------------------

            INCLUDE "GRAPHICS/MENU.X68"     ; FUNCTION TO DRAW MENU
            INCLUDE "GRAPHICS/GAME.X68"     ; FUNCTION TO DRAW GAME
            INCLUDE "GRAPHICS/GAMEOVER.X68" ; FUNCTION TO DRAW GAME OVER PLOT

; -----------------------------------------------------------------------------
CHPENCL
; CHANGES THE COLOR TO THE PEN
; INPUT    - D1.L   COLOR $00BBGGRR
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVE.L  D0,-(A7)
            MOVE.B  #80,D0
            TRAP    #15
            MOVE.L  (A7)+,D0
            RTS
            
; -----------------------------------------------------------------------------
CHFILLCL
; CHANGES THE COLOR TO THE FILL
; INPUT    - D1.L   COLOR $00BBGGRR
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVE.L  D0,-(A7)
            MOVE.B  #81,D0
            TRAP    #15
            MOVE.L  (A7)+,D0
            RTS
            
; -----------------------------------------------------------------------------
DRAWTEXT
; ALLOWS TO DRAW TEXT IN WHITE IN THE SCREEN WHERE THE POINTER IS
; INPUT    - A0.L POINTER TO THE STRING 
; OUTPUT   - NONE
; MODIFIES - SCREEN
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D1,-(A7)
            MOVE.B  #6,D0
.LOOP:      MOVE.B  (A0)+,D1
            TRAP    #15
            BNE     .LOOP 
            MOVEM.L (A7)+,D0-D1
            RTS
            
; -----------------------------------------------------------------------------
GETCURSOR
; OBTEINS THE POINTER
; INPUT    - NONE
; OUTPUT   - D1 = HIGH BYTE IS COL, LOW BYTE IS ROW 
; MODIFIES - SCREEN
; -----------------------------------------------------------------------------
            
            MOVEM.L D0,-(A7)
            MOVE.W  #$00FF,D1
            MOVE.B  #11,D0
            TRAP    #15
            MOVEM.L (A7)+,D0
            RTS









*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
