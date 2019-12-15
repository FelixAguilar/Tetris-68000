; =============================================================================
; STATES
; =============================================================================

; ----------------------------------------------------------------------------
STAINIT
; INITALIZES FIRST STATE AND SOUND MEMORY
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - STATE
; -----------------------------------------------------------------------------
            
            LEA.L   STATES,A0               ; A0 = STATES LIST
            MOVE.L  1*4(A0),STATE           ; STATE = STAMENU
            
            JSR SOUNDINIT                   ; STARTS SOUND MANAGER

            RTS

; -----------------------------------------------------------------------------
STAMENU
; OPERATIONS FOR THE MENU
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - STATE
; -----------------------------------------------------------------------------
            
            JSR     DRAWMENU                ; DRAWS THE MENU PLOT
            
.SPACE      BTST.B  #4,KBDEDGE              ; IF "SPACE" IS PRESED
            BEQ     .P
            LEA.L   STATES,A0               ; A0 = STATES LIST
            MOVE.L  2*4(A0),STATE           ; STATE = STASTART
            MOVE.B  #6,D1                   
            JSR     SOUNDPLAY               ; PLAY SELECTION SOUND
            
.P          BTST.B  #7,KBDEDGE              ; IF "P" IS PRESED
            BEQ     .END
            NOT.B   SHOWINST
            ANDI.B  #$01,SHOWINST            ; UPDATE SHOW INSTRUCTIONS
            MOVE.B  #6,D1
            JSR     SOUNDPLAY               ; PLAY SELECTION SOUND
                
.END        RTS

; -----------------------------------------------------------------------------
STANEW
; REQUIRED OPERATIONS TO RESET AND PREPARE FOR THE NEW GAME
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - STATE
; -----------------------------------------------------------------------------
            
            JSR     INITTETRIS              ; INITALICES TETRIS             
            
            JSR     INITTETROMINO           ; NEW TETROMINO
            
            LEA.L   STATES,A0               ; A0 = STATES LIST
            MOVE.L  3*4(A0),STATE           ; STATE = STAPLAY

            MOVE.B  #7,D1
            JSR     SOUNDPLAY               ; NEW GAME SOUND

            RTS

; -----------------------------------------------------------------------------
STAPLAY
; OPERATIONS FOR THE GAME WHEN IT IS RUNNING
; INPUT    - NONE
; OUTPUT   - NONE 
; MODIFIES - MATRIX, STATE
; -----------------------------------------------------------------------------
            
            JSR     DRAWGAME                ; DRAWS THE GAME PLOT
            
            ; CHECKS IF THE TETROMINO CAN BE MOVED DOWNWARDS
            
            BTST.B  #0,TETROLDW                        
            BEQ     .LEFT
            MOVE.B  #3,D1
            JSR     SOUNDPLAY               ; END DROP SOUND
            
            ; CHECKS IF IT HAS BEEN GAME OVER
            
            JSR     ISGAMEOVER
            BTST.B  #0,GAMEOVER
            BNE     .GAMEOVER
            
            ; CHECKS IF IT HAS BEEN FILED ANY ROW AND CLEARS IT
            
            JSR     ISTETRIS
            
            ; CREATES A NEW TETROMINO
            
            JSR     INITTETROMINO
            
            ; ACTIONS IF ANY KEY IS PRESED
            
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
            BTST.B  #0,TETROLDW                        
            BEQ     .SPACE
            
            ; MOVE FIGURE DOWN EACH 50 SEC APROX
            
.TEMPMOVE   MOVE.B  SCRCYCCT,D0
            ANDI.B  #%00011111,D0
            BNE     .END
            JSR     DOWNTETROMINO
            BRA     .END

            ; IF IS A GAME OVER
            
.GAMEOVER   LEA.L   STATES,A0               ; A0 = STATE LIST
            MOVE.L  4*4(A0),STATE           ; STATE = STAOVER
            MOVE.B  #4,D1
            JSR     SOUNDPLAY               ; PLAY GAME OVER SOUND
            
.END        RTS
            
; -----------------------------------------------------------------------------
STAOVER
; OPERATIONS FOR THE GAME WHEN IT HAS REACHED GAME OVER STATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - STATE
; -----------------------------------------------------------------------------
            
            JSR     DRAWGAMEOVER            ; DRAWS THE GAME OVER PLOT
            
            BTST.B  #4,KBDEDGE              ; IF "SPACE" IS PRESED
            BEQ     .END
            LEA.L   STATES,A0               ; A0 = STATES LIST
            MOVE.L  1*4(A0),STATE           ; 1 = MENU STATE
            MOVE.B  #6,D1
            JSR     SOUNDPLAY               ; PLAY SELECTION SOUND
            
.END        RTS




























*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
