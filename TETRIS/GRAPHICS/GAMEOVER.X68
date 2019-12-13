; =============================================================================
; GAMEOVER
; =============================================================================

; -----------------------------------------------------------------------------
DRAWGAMEOVER
; OPERATIONS TO DRAW THE GAME OVER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            ; SET COLOR AND WHITH FOR PEN AND FILL
            
            MOVE.L  #$000000FF,D1           ; D1 = RED
            JSR     CHPENCL
            CLR.L   D1                      ; D1 = BLACK
            JSR     CHFILLCL
            MOVE.B  #93,D0
            MOVE.B  #5,D1                   ; D1 = WITH 5 PIXELS
            TRAP    #15
            
             ; WRITE TITLE "GAMEOVER"
            
            LEA.L   GMOVERY,A0              ; A0 = Y COORDINATES FOR TITLE
            LEA.L   GMOVERX,A1              ; A1 = X COORDINATES FOR TITLE
            LEA.L   GMOVER,A2               ; A2 = LOOP ARRAY
             
            MOVE.W  #10,D4                   ; D4 = MAIN LOOP COUNTER
                        
            ; MOVES CURSOR AND RESETS THE LOOP COUNTER
            
.NEXT1      MOVE.B  #86,D0
            MOVE.W  (A1)+,D1                ; D1 = X CURSOR
            MOVE.W  (A0)+,D2                ; D2 = Y CURSOR
            TRAP    #15                     ; MOVER THE CURSOR
            MOVE.W  (A2)+,D3                ; D3 = LOOP COUNTER
            
            ; DRAW LETTER FOR TITLE
            
            MOVE.B  #85,D0
.LOOP1      MOVE.W  (A1)+,D1                ; D1 = X DESTINATION LINE
            MOVE.W  (A0)+,D2                ; D2 = Y DESTINATION LINE
            TRAP    #15                     ; DRAW LINE
            DBRA    D3,.LOOP1               ; DRAW NEXT LINE
            DBRA    D4,.NEXT1               ; ENDED DRAWING LETTER
            
            ; SET COLOR AND WHITH FOR PEN
            
            MOVE.L  #$00FFFFFF,D1           ; D1 = WHITE
            JSR     CHPENCL
            MOVE.B  #93,D0
            MOVE.B  #1,D1                   ; D1 = WITH 5 PIXELS
            TRAP    #15
            
            ; DRAW RETRY TEXT EACH SECOND APROX
            
            MOVE.B  SCRCYCCT,D0
            ANDI.B  #%00011111,D0           ; AFTER X TIME UPDATE COLOR
            BNE     .SKIP
            NOT.B   SHOWTEXT
            
.SKIP       BTST.B  #0,SHOWTEXT
            BEQ     .END
            
            MOVE.B  #95,D0
            LEA.L   GMOVERXY,A0
            MOVE.W  (A0)+,D1
            MOVE.W  (A0)+,D2
            LEA.L   TEXTREST,A1
            TRAP    #15
                   

.END        RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
