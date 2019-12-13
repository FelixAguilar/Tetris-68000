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
            
            MOVEM.L D0-D5/A0-A3,-(A7)
            
            ; SET COLOR AND WHITH FOR PEN AND FILL
            
            MOVE.L  #$00FFFFFF,D1           ; D1 = WHITE
            JSR     CHPENCL
            CLR.L   D1                      ; D1 = BLACK
            JSR     CHFILLCL
            MOVE.B  #93,D0
            MOVE.B  #5,D1                   ; D1 = WITH 5 PIXELS
            TRAP    #15
            
            ; GET STARTING COLOR FOR TITLE AND UDATE IT
            
            CLR.L   D5
            MOVE.W  TITLEC,D5               ; D5 = GETS THE COLOR
            
            MOVE.B  SCRCYCCT,D0
            ANDI.B  #%00001111,D0           ; AFTER X TIME UPDATE COLOR
            BNE     .SKIP
            ADDQ.W  #1,D5                   ; ADD 1 TO INDEX
            DIVU.W  #7,D5                   ; STOPS FROM GOING OUT OF THE ARRAY
            SWAP.W  D5                      ; GETS THE REMAINDER
            ANDI.L  #$0000FFFF,D5           ; CLEARS HIGER WORD      
            MOVE.W  D5,TITLEC               ; SAVES IT TO MEMORY
.SKIP       MULU.W  #4,D5                   ; D5 = LONG WORD POINTER
            
            ; WRITE TITLE "TETRIS"
            
            LEA.L   TETRISY,A0              ; A0 = Y COORDINATES FOR TITLE
            LEA.L   TETRISX,A1              ; A1 = X COORDINATES FOR TITLE
            LEA.L   TETRIS,A2               ; A2 = LOOP ARRAY
            LEA.L   COLOR,A3                ; A3 = COLOR ARRAY
             
            MOVE.W  #6,D4                   ; D4 = MAIN LOOP COUNTER
            
            ; GETS COLOR AN UPDATES IT FOR NEXT LETER
            
.NEXT1      MOVE.L  (A3,D5),D1              ; D1 = COLOR POINTER
            JSR     CHPENCL                 ; CHANGE COLOR FOR PEN
            DIVU.W  #4,D5
            ADDQ.W  #1,D5
            DIVU.W  #7,D5 
            SWAP.W  D5
            ANDI.L  #$0000FFFF,D5
            MULU.W  #4,D5
            
            ; MOVES CURSOR AND RESETS THE LOOP COUNTER
            
            MOVE.B  #86,D0
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
            
            ; SET WITH AND COLOR FOR PEN AND FILL
            
            MOVE.L  #$00FFFFFF,D1           ; D1 = WHITE
            JSR     CHPENCL
            CLR.L   D1                      ; D1 = BLACK
            JSR     CHFILLCL
            
            MOVE.B  #93,D0
            MOVE.B  #1,D1                   ; D1 = WHITH OF PEN
            TRAP    #15
            
            ; WRITE MENU TEXT
            
            MOVE.B  #95,D0
            
            LEA.L   MENUXY,A0               ; A0 = TEXT COORDINATES ARRAY
            MOVE.W  (A0)+,D1                ; D1 = X TEXT COORDINATE
            MOVE.W  (A0)+,D2                ; D2 = Y TEXT COORDINATE
            LEA     TEXTINST,A1             ; A1 = TEXTI POINTER
            TRAP    #15                     ; WRITE THE TEXT
            MOVE.W  (A0)+,D1
            MOVE.W  (A0)+,D2
            LEA     TEXTSTRT,A1
            TRAP    #15
            MOVE.W  (A0)+,D1
            MOVE.W  (A0)+,D2
            LEA     TEXTATHR,A1
            TRAP    #15
            
            ; DRAW BOX FOR MENU
            
            LEA.L   MENUCONT,A0           ; A0 = CONTAINER POINTER
            MOVE.W  (A0)+,D1                ; D1 = LX CONTAINER
            MOVE.W  (A0)+,D2                ; D2 = UY CONTAINER
            MOVE.W  (A0)+,D3                ; D3 = RX CONTAINER
            MOVE.W  (A0)+,D4                ; D4 = LY CONTAINER
            MOVE.B  #90,D0
            TRAP    #15                     ; DRAW THE CONTAINER
       
            MOVEM.L (A7)+,D0-D5/A0-A3
            RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
