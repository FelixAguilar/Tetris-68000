; =============================================================================
; GRAPHICS
; =============================================================================

; ----------------------------------------------------------------------------
STAINIT
; INITALIZES STATE MANAGER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            LEA.L   STATES,A0
            MOVE.L  1*4(A0),NSTATE
            RTS
            
; -----------------------------------------------------------------------------
STANMME
; OPERATIONS WHEN IS THE MAIN MENU
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVE.L  6*4(A0),DSTATE          ; UPDATES DRAW STATE
            
            BTST.B  #4,KBDEDGE              ; IF "SPACE" IS PRESED
            BEQ     .END
            MOVE.L  2*4(A0),NSTATE          ; UPDATES NEXT STATE
.END        RTS

; -----------------------------------------------------------------------------
STANWGM
; OPERATIONS WHEN THE GAME STARTS
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            JSR     INITMATRIX              ; CLEAR THE MATRIX
            
            CLR.B   FIGROTA                 ; DEFAULT ROTATION
            CLR.B   FIGPOSI                 ; DEFAULT POSITION
            
            MOVE.L  3*4(A0),NSTATE
            MOVE.L  5*4(A0),DSTATE
            
            JSR     INITSQUARE
            
            RTS

; -----------------------------------------------------------------------------
STAUPDA
; OPERATIONS FOR THE GAME WHEN IT IS RUNNING
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            JSR     SQUARE
            
            RTS
            
; -----------------------------------------------------------------------------
STAGMOV
; OPERATIONS WHEN THE GAME REACHES A GAME OVER STATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            RTS
            
; -----------------------------------------------------------------------------
STADWGM
; PRINTS THE PLOT FOR THE GAME SCREEN
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            JSR DRAWMATRIX
            
            RTS
            
; -----------------------------------------------------------------------------
STADWMM
; PRINTS THE PLOT FOR THE MAIN MANU SCREEN
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
; -----------------------------------------------------------------------------
STADWGO
; PRINTS THE PLOT FOR THE GAME OVER SCREEN
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            RTS      










*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
