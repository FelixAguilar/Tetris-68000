; =============================================================================
; STATES
; =============================================================================

; ----------------------------------------------------------------------------
STAINIT
; INITALIZES STATE MANAGER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D2/A1,-(A7)
            
            LEA.L   STATES,A0               ; A0 = STATES LIST
            MOVE.L  1*4(A0),STATE          ; STATE = STANMME
            
            MOVE.B  #71,D0
            MOVE.B  #1,D1
            LEA.L   .MUSIC,A1
            TRAP    #15

            MOVE.B  #76,D0
            MOVE.L  #1,D2
            TRAP    #15
   
            MOVEM.L (A7)+,D0-D2/A1
            RTS
            
.MUSIC      DC.B    'SOUND/MAIN.WAV',0
            DS.W    1
; -----------------------------------------------------------------------------
STANMME
; OPERATIONS WHEN IS THE MAIN MENU
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            
            
            JSR     DRAWMENU                ; DRAWS THE MENU PLOT
            
            BTST.B  #4,KBDEDGE              ; IF "SPACE" IS PRESED
            BEQ     .END
            LEA.L   STATES,A0               ; A0 = STATES LIST
            MOVE.L  2*4(A0),STATE           ; UPDATES NEXT STATE
            
                
.END        RTS


; -----------------------------------------------------------------------------
STANWGM
; OPERATIONS WHEN THE GAME STARTS
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D3,-(A7)
            JSR     INITMATRIX              ; CLEAR THE MATRIX
            CLR.B   FIGROTA                 ; DEFAULT ROTATION
            CLR.B   FIGPOSI                 ; DEFAULT POSITION
            CLR.B   GAMEOVER                ; DEFAULT GAMEOVER STATUS
            CLR.B   FIGNEXT
            
            LEA.L   STATES,A0               ; A0 = STATES LIST
            MOVE.L  3*4(A0),STATE          ; STATE = STAUPDA
            
            JSR     INITTETROMINO

            MOVEM.L (A7)+,D0-D3
            RTS

; -----------------------------------------------------------------------------
STAUPDA
; OPERATIONS FOR THE GAME WHEN IT IS RUNNING
; INPUT    - KBDVAL, KBDEDGE
; OUTPUT   - NONE
; MODIFIES - MATRIX
; -----------------------------------------------------------------------------
            
            JSR     DRAWGAME                ; DRAWS THE GAME PLOT
            
            MOVE.L  D0,-(A7)
            
            ; CHECKS IF THE FIGURE CAN BE MOVED DOWNWARDS IF TRUE THEN KEYS
            BTST.B  #0,FIGLDOW                        
            BEQ     .LEFT
       
            ; CHECK IF IT IS GAME OVER
            JSR     ISGAMEOVER
            BTST.B  #0,GAMEOVER
            BNE     .GAMEOVER
            
            ; CHECK IF IT IS TETRIS AND CLEARS IT
            JSR     ISTETRIS
            
            ; CREATES A NEW FIGURE
            JSR     INITTETROMINO
            
            ; ACTIONS IF ANY KEY IS PRESED (LEFT, RIGHT, DOWN, UP, SPACE)
.LEFT       BTST.B  #0,KBDEDGE
            BEQ     .RIGHT
            JSR     LEFTTETROMINO
            
.RIGHT      BTST.B  #2,KBDEDGE
            BEQ     .DOWN
            JSR     RIGHTTETROMINO

.DOWN       BTST.B  #3,KBDVAL
            BEQ     .UP
            JSR     DOWNTETROMINO

.UP         BTST.B  #1,KBDEDGE
            BEQ     .SPACE
            JSR     ROTATETETROMINO

            
.SPACE      BTST.B #4,KBDEDGE
            BEQ     .TEMPMOVE
            JSR     DOWNTETROMINO
            BTST.B  #0,FIGLDOW                        
            BEQ     .SPACE
            
            ; MOVE FIGURE DOWN EACH 50 SEC APROX
            
.TEMPMOVE   MOVE.B  SCRCYCCT,D0
            ANDI.B  #%00001111,D0
            BNE     .END
            JSR     DOWNTETROMINO
            BRA     .END

            ; IF IS A GAME OVER CHANGE STATE
            
.GAMEOVER   MOVE.L  A0,-(A7)
            LEA.L   STATES,A0
            MOVE.L  4*4(A0),STATE
            MOVE.L  (A7)+,A0

.END        MOVE.L  (A7)+,D0
            RTS
            
; -----------------------------------------------------------------------------
STAGMOV
; OPERATIONS WHEN THE GAME REACHES A GAME OVER STATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            JSR     DRAWGAMEOVER            ; DRAWS THE GAME OVER PLOT
            
            RTS














*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
