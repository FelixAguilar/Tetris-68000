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
            MOVE.W  .COLOR,D5               ; D5 = GETS THE COLOR
            
            MOVE.B  SCRCYCCT,D0
            ANDI.B  #%00001111,D0           ; AFTER X TIME UPDATE COLOR
            BNE     .SKIP
            ADDQ.W  #1,D5                   ; ADD 1 TO INDEX
            DIVU.W  #7,D5                   ; STOPS FROM GOING OUT OF THE ARRAY
            SWAP.W  D5                      ; GETS THE REMAINDER
            ANDI.L  #$0000FFFF,D5           ; CLEARS HIGER WORD      
            MOVE.W  D5,.COLOR               ; SAVES IT TO MEMORY
.SKIP       MULU.W  #4,D5                   ; D5 = LONG WORD POINTER
            
            ; WRITE TITLE "TETRIS"
            
            LEA.L   .TETRISY,A0             ; A0 = Y COORDINATES FOR TITLE
            LEA.L   .TETRISX,A1             ; A1 = X COORDINATES FOR TITLE
            LEA.L   .TETRIS,A2              ; A2 = LOOP ARRAY
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
            
            LEA.L   .TEXTXY,A0              ; A0 = TEXT COORDINATES ARRAY
            MOVE.W  (A0)+,D1                ; D1 = X TEXT COORDINATE
            MOVE.W  (A0)+,D2                ; D2 = Y TEXT COORDINATE
            LEA     .TEXTI,A1               ; A1 = TEXTI POINTER
            TRAP    #15                     ; WRITE THE TEXT
            MOVE.W  (A0)+,D1
            MOVE.W  (A0)+,D2
            LEA     .TEXTS,A1
            TRAP    #15
            MOVE.W  (A0)+,D1
            MOVE.W  (A0)+,D2
            LEA     .TEXTA,A1
            TRAP    #15
            
            ; DRAW BOX FOR MENU
            
            LEA.L   .CONTAINER,A0           ; A0 = CONTAINER POINTER
            MOVE.W  (A0)+,D1                ; D1 = LX CONTAINER
            MOVE.W  (A0)+,D2                ; D2 = UY CONTAINER
            MOVE.W  (A0)+,D3                ; D3 = RX CONTAINER
            MOVE.W  (A0)+,D4                ; D4 = LY CONTAINER
            MOVE.B  #90,D0
            TRAP    #15                     ; DRAW THE CONTAINER
       
            MOVEM.L (A7)+,D0-D5/A0-A3
            RTS         
        
            ; TITLE VARIABLES
            
.COLOR      DC.W    1 
                
.TETRIS     DC.W    7,11,7,8,3,3,11

.TETRISX    DC.W    235,325,325,295,295,265,265,235,235                      ;T
            DC.W    335,425,425,365,365,395,395,365,365,425,425,335,335      ;E
            DC.W    435,525,525,495,495,465,465,435,435                      ;T
            DC.W    535,625,625,595,625,595,565,565,535,535                  ;R
            DC.W    565,595,595,565,565                                      ;R
            DC.W    635,665,665,635,635                                      ;I
            DC.W    675,765,765,705,705,765,765,675,675,735,735,675,675      ;S
       
.TETRISY    DC.W    065,065,095,095,185,185,095,095,065                      ;T
            DC.W    065,065,095,095,110,110,140,140,155,155,185,185,065      ;E
            DC.W    065,065,095,095,185,185,095,095,065                      ;T
            DC.W    065,065,135,135,185,185,135,185,185,065                  ;R
            DC.W    095,095,105,105,095                                      ;R
            DC.W    065,065,185,185,065                                      ;I
            DC.W    065,065,095,095,110,110,185,185,155,155,140,140,065      ;S
            
            ; MENU VARIABLES
      
.CONTAINER  DC.W    365,330,645,405
      
.TEXTXY     DC.W     370,340,370,360,370,380
   
.TEXTI      DC.B    'PRESS "P" TO SHOW THE INSTRUCTIONS',0
.TEXTS      DC.B    'PRESS "SPACE" TO START THE GAME',0
.TEXTA      DC.B    'MADE BY FELIX LLUIS AGUILAR FERRER',0
            DS.W    0

*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
