; =============================================================================
; SYSTEM STATES
; =============================================================================

; ----------------------------------------------------------------------------
STAINIT
; INITALIZES FIRST STATE AND SOUND MEMORY
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - STATE
; -----------------------------------------------------------------------------
            
            MOVE.L  A0,-(A7)
            
            LEA.L   STATES,A0               ; A0 = STATES LIST
            MOVE.L  SNUMMENU*4(A0),STATE    ; STATE = STAMENU
            
            JSR SOUNDINIT                   ; STARTS SOUND MANAGER

            MOVE.L  (A7)+,A0
            RTS

; -----------------------------------------------------------------------------
STAMENU
; OPERATIONS WHEN IS SHOWING THE MENU
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - STATE,SHOWINST
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D1/A0,-(A7)
            
            JSR     DRAWMENU                ; DRAWS THE MENU PLOT
            
            ; IF "SPACE" IS PRESSED
            
            BTST.B  #KBDBITF1,KBDEDGE
            BEQ     .NEXT
            
            LEA.L   STATES,A0               ; A0 = STATES LIST
            MOVE.L  SNUMNEW*4(A0),STATE     ; STATE = STANEW
            
            MOVE.B  #NSELECT,D1                   
            ;JSR     SOUNDPLAY               ; PLAY SELECTION SOUND
            BRA     .END
            
            ; IF "P" IS PRESSED
            
.NEXT       BTST.B  #KBDBITPS,KBDEDGE
            BEQ     .END
            
            NOT.B   SHOWINST
            ANDI.B  #$01,SHOWINST           ; UPDATE SHOW INSTRUCTIONS
            
            MOVE.B  #NSELECT,D1
            JSR     SOUNDPLAY               ; PLAY SELECTION SOUND
                
.END        MOVEM.L (A7)+,D0-D1/A0
            RTS

; -----------------------------------------------------------------------------
STANEW
; REQUIRED OPERATIONS TO RESET AND PREPARE FOR THE NEW GAME
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - STATE
; -----------------------------------------------------------------------------
            
            MOVEM.L D1/A0,-(A7)
            
            JSR     INITTETRIS              ; INITALICES TETRIS             
            
            JSR     INITTETROMINO           ; NEW TETROMINO
            
            LEA.L   STATES,A0               ; A0 = STATES LIST
            MOVE.L  SNUMPLAY*4(A0),STATE    ; STATE = STAPLAY

            MOVE.B  #NSUCCESS,D1
            JSR     SOUNDPLAY               ; NEW GAME SOUND

            MOVEM.L (A7)+,D1/A0
            RTS

; -----------------------------------------------------------------------------
STAPLAY
; OPERATIONS FOR THE GAME WHEN IT IS RUNNING
; INPUT    - NONE
; OUTPUT   - NONE 
; MODIFIES - STATE
; -----------------------------------------------------------------------------
            
            MOVEM.L D1/A0,-(A7)
            
            JSR     DRAWGAME                ; DRAWS THE GAME PLOT
            
            ; CHECKS IF THE TETROMINO CAN BE MOVED DOWNWARDS
            
            BTST.B  #TESTBIT0,TETROLDW                        
            BEQ     .LEFT
            
            MOVE.B  #NFALL,D1
            JSR     SOUNDPLAY               ; PLAY DROP SOUND
            
            ; CHECKS IF IT HAS BEEN FILED ANY ROW AND CLEARS IT
            
            JSR     ISTETRIS
            
            ; CHECKS IF IT HAS BEEN GAME OVER
            
            JSR     ISGAMEOVER
            BTST.B  #TESTBIT0,GAMEOVER
            BNE     .GAMEOVER
            
            ; CREATES A NEW TETROMINO
            
            JSR     INITTETROMINO
            
            ; ACTIONS IF ANY KEY IS PRESED
            
.LEFT       BTST.B  #KBDBITLF,KBDEDGE
            BEQ     .RIGHT
            JSR     LEFTTETROMINO
            
.RIGHT      BTST.B  #KBDBITRT,KBDEDGE
            BEQ     .DOWN
            JSR     RIGHTTETROMINO

.DOWN       BTST.B  #KBDBITDN,KBDVAL
            BEQ     .UP
            JSR     DOWNTETROMINO

.UP         BTST.B  #KBDBITUP,KBDEDGE
            BEQ     .SPACE
            JSR     ROTATETETROMINO
            
.SPACE      BTST.B  #KBDBITF1,KBDEDGE
            BEQ     .TEMPMOVE
            JSR     DOWNTETROMINO
            BTST.B  #TESTBIT0,TETROLDW      ; LOOP UNTIL REACHED A STOP STATUS                
            BEQ     .SPACE
            
            ; MOVE FIGURE DOWN EACH 30 SEC APROX
            
.TEMPMOVE   MOVE.B  SCRCYCCT,D0
            ANDI.B  #%00001111,D0
            BNE     .END
            JSR     DOWNTETROMINO
            BRA     .END

            ; IF IS A GAME OVER
            
.GAMEOVER   LEA.L   STATES,A0               ; A0 = STATE LIST
            MOVE.L  SNUMOVER*4(A0),STATE    ; STATE = STAOVER
            
            MOVE.B  #NOVER,D1
            JSR     SOUNDPLAY               ; PLAY GAME OVER SOUND
            
.END        MOVEM.L (A7)+,D1/A0
            RTS
            
; -----------------------------------------------------------------------------
STAOVER
; OPERATIONS FOR THE GAME WHEN IT HAS REACHED GAME OVER STATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - STATE
; -----------------------------------------------------------------------------
            
            MOVEM.L D1/A0,-(A7)
            
            JSR     DRAWGAMEOVER            ; DRAWS THE GAME OVER PLOT
            
            BTST.B  #KBDBITF1,KBDEDGE       ; IF "SPACE" IS PRESED
            BEQ     .END
            
            LEA.L   STATES,A0               ; A0 = STATES LIST
            MOVE.L  SNUMMENU*4(A0),STATE    ; STATE = MENU STATE
            
            MOVE.B  #NSELECT,D1
            JSR     SOUNDPLAY               ; PLAY SELECTION SOUND
            
.END        MOVEM.L (A7)+,D1/A0
            RTS

































*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
