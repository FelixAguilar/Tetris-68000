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
            
            LEA.L   STATES,A0               ; A0 = STATES LIST
            CLR.L   DSTATE
            MOVE.L  1*4(A0),NSTATE          ; NSTATE = STANMME
            RTS
            
; -----------------------------------------------------------------------------
STANMME
; OPERATIONS WHEN IS THE MAIN MENU
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            LEA.L   STATES,A0               ; A0 = STATES LIST
            MOVE.L  6*4(A0),DSTATE          ; DSTATE = STADWMM
            
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
            CLR.B   GAMEOVER                ; DEFAULT GAMEOVER STATUS
            
            LEA.L   STATES,A0               ; A0 = STATES LIST
            MOVE.L  3*4(A0),NSTATE          ; NSTATE = STAUPDA
            MOVE.L  5*4(A0),DSTATE          ; DSTATE = STADWGM
            
            JSR     INITFIGURE
            
            RTS

; -----------------------------------------------------------------------------
STAUPDA
; OPERATIONS FOR THE GAME WHEN IT IS RUNNING
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            BTST.B  #0,FIGLDOW              ; IF NOT SKIP
            BEQ     .SKIP1
            JSR     ISGAMEOVER
            BTST.B  #0,GAMEOVER              ; IF NOT SKIP
            BNE     .SKIP4
            JSR     INITFIGURE              ; INTRODUCES NEXT FIGURE
.SKIP1      BTST.B  #0,KBDVAL
            BNE     .SKIP2
            JSR     LEFTFIGURE
.SKIP2      BTST.B  #2,KBDVAL
            BNE     .SKIP3
            JSR     RIGHTFIGURE
.SKIP3      JSR     DOWNFIGURE              ; MOVE THE FIGURE DOWNWARDS
            BRA     .END
.SKIP4      LEA.L   STATES,A0               ; A0 = STATES LIST
            MOVE.L  4*4(A0),NSTATE          ; NSTATE = STAGMOV
.END        RTS
            
; -----------------------------------------------------------------------------
STAGMOV
; OPERATIONS WHEN THE GAME REACHES A GAME OVER STATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            LEA.L   STATES,A0               ; A0 = STATES LIST
            MOVE.L  7*4(A0),DSTATE          ; DSTATE = STADWGO
            
            
            RTS
            
; -----------------------------------------------------------------------------
STADWGM
; PRINTS THE PLOT FOR THE GAME SCREEN
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
;STADWGO
; PRINTS THE PLOT FOR THE GAME OVER SCREEN
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
STADWGO            MOVEM.L D1-D2/A0,-(A7)
            
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
            
.TEXT1      DC.B    'GAME OVER',0
.TEXT2      DC.B    'PRESS "SPACE" TO START THE GAME',0     
































*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
