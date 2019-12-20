; =============================================================================
; GRAPHICS
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
            MOVE.B  #PENWHITH,D1            ; D1 = WITH 5 PIXELS
            TRAP    #15
            
            ; GET STARTING COLOR FOR TITLE AND UDATE IT
            
            CLR.L   D5
            MOVE.W  TITLECOL,D5             ; D5 = GETS THE COLOR
            
            MOVE.B  SCRCYCCT,D0
            ANDI.B  #%00001111,D0           ; AFTER X TIME UPDATE COLOR
            BNE     .SKIP
            ADDQ.W  #1,D5                   ; ADD 1 TO INDEX
            DIVU.W  #7,D5                   ; STOPS FROM GOING OUT OF THE ARRAY
            SWAP.W  D5                      ; GETS THE REMAINDER
            ANDI.L  #$0000FFFF,D5           ; CLEARS HIGHER WORD      
            MOVE.W  D5,TITLECOL             ; SAVES IT TO MEMORY
.SKIP       MULU.W  #4,D5                   ; D5 = LONG WORD POINTER
            
            ; WRITE TITLE "TETRIS"
            
            LEA.L   TITLEY,A0               ; A0 = Y COORDINATES FOR TITLE
            LEA.L   TITLEX,A1               ; A1 = X COORDINATES FOR TITLE
            LEA.L   TITLELOP,A2             ; A2 = LOOP ARRAY
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
            
            ; CHECK IF THE INSTRUCTIONS MUST SHOW UP

            BTST.B  #0,SHOWINST
            BNE     .INSTRUC            
            
            ; WRITE MENU TEXT
            
            MOVE.B  #95,D0
            
            LEA.L   MENUXY,A0               ; A0 = TEXT COORDINATES ARRAY
            MOVE.W  (A0)+,D1                ; D1 = X TEXT COORDINATE
            MOVE.W  (A0)+,D2                ; D2 = Y TEXT COORDINATE
            LEA     MENUINST,A1             ; A1 = TEXTI POINTER
            TRAP    #15                     ; WRITE THE TEXT
            MOVE.W  (A0)+,D1
            MOVE.W  (A0)+,D2
            LEA     MENUSTRT,A1
            TRAP    #15
            MOVE.W  (A0)+,D1
            MOVE.W  (A0)+,D2
            LEA     MENUATHR,A1
            TRAP    #15
            
            ; DRAW BOX FOR MENU
            
            LEA.L   MENUCONT,A0             ; A0 = CONTAINER POINTER
            MOVE.W  (A0)+,D1                ; D1 = LX CONTAINER
            MOVE.W  (A0)+,D2                ; D2 = UY CONTAINER
            MOVE.W  (A0)+,D3                ; D3 = RX CONTAINER
            MOVE.W  (A0)+,D4                ; D4 = LY CONTAINER
            MOVE.B  #90,D0
            TRAP    #15                     ; DRAW THE CONTAINER
            
            BRA     .END
            
.INSTRUC    LEA.L   INSTCONT,A0             ; A0 = CONTAINER POINTER
            MOVE.W  (A0)+,D1                ; D1 = LX CONTAINER
            MOVE.W  (A0)+,D2                ; D2 = UY CONTAINER
            MOVE.W  (A0)+,D3                ; D3 = RX CONTAINER
            MOVE.W  (A0)+,D4                ; D4 = LY CONTAINER
            MOVE.B  #90,D0
            TRAP    #15                     ; DRAW THE CONTAINER

            MOVE.B  #95,D0
            
            MOVE.W  #5,D3
            LEA.L   INSTXY,A0               ; A0 = TEXT COORDINATES ARRAY
            LEA.L   INSTLINK,A2            
            
.LOOP2      MOVE.W  (A0)+,D1                ; D1 = X TEXT COORDINATE
            MOVE.W  (A0)+,D2                ; D2 = Y TEXT COORDINATE
            MOVE.L  (A2)+,A1                ; A1 = TEXT TO PRINT
            TRAP    #15                     ; WRITE THE TEXT
            DBRA    D3,.LOOP2
            
            MOVE.W  #4,D3
.LOOP3      MOVE.W  (A0)+,D1
            MOVE.W  (A0)+,D2
            MOVE.L  (A2),A1
            TRAP    #15
            DBRA    D3,.LOOP3
            
            ADDQ.L  #4,A2            
            MOVE.W  #4,D3
            
.LOOP4      MOVE.W  (A0)+,D1
            MOVE.W  (A0)+,D2
            MOVE.L  (A2)+,A1
            TRAP    #15
            DBRA    D3,.LOOP4
       
.END        MOVEM.L (A7)+,D0-D5/A0-A3
            RTS

; -----------------------------------------------------------------------------
DRAWGAME
; OPERATIONS TO DRAW THE GAME
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D5/A0-A1,-(A7)
            
            ; SET PEN AND FILL COLOR
            
            MOVE.L  #$00FFFFFF,D1           ; D1 = WHITE
            JSR     CHPENCL                 ; CHANGE PEN COLOR
            CLR.L   D1                      ; D1 = BLACK
            JSR     CHFILLCL                ; CHANGE FILL COLOR
            
            ; CONTAINERS
            
            MOVE.W  #2,D5
            
            LEA.L   GAMECONX,A0             ; A0 = CONTAINER COORDENATE X
            LEA.L   GAMECONY,A1             ; A1 = CONTAINER COORDENATE Y
.LOOP1      MOVE.W  (A0)+,D1                ; D1 = LX CONTAINER
            MOVE.W  (A1)+,D2                ; D2 = UY CONTAINER
            MOVE.W  (A0)+,D3                ; D3 = RX CONTAINER
            MOVE.W  (A1)+,D4                ; D4 = LY CONTAINER
            MOVE.B  #90,D0
            TRAP    #15                     ; DRAWS THE MATRIX CONTAINER
            DBRA    D5,.LOOP1
            
            ; DRAW TEXT
            
            MOVE.B  #95,D0
            LEA.L   TXTGAMXY,A0             ; A0 = TEXT COORDINATES ARRAY
            
            MOVE.W  (A0)+,D1                ; D1 = X TEXT COORDINATE
            MOVE.W  (A0)+,D2                ; D2 = Y TEXT COORDINATE
            LEA     TEXTSCRE,A1             ; A1 = TEXT1 POINTER
            TRAP    #15                     ; WRITE THE TEXT
            
            MOVE.W  (A0)+,D1
            MOVE.W  (A0)+,D2
            LEA     TEXTNEXT,A1
            TRAP    #15
            
            MOVE.B  #11,D0
            MOVE.W  #$5E0F,D1
            TRAP    #15
            MOVE.B  #3,D0
            MOVE.L  SCORE,D1
            TRAP    #15
      
            ; DRAW NEXT TETROMINO
            
            CLR.L   D0
            LEA.L   COLOR,A1                ; A1 = COLOR ARRAY POINTER
            LEA.L   NEXTLINK,A2
            MOVE.B  TETRONXT,D0
            MULU.W  #4,D0
            MOVEA.L (A2,D0),A2
            MOVE.W  (A2)+,D1
            MULU.W  #4,D1
            MOVE.L  (A1,D1),D1              ; D1 = COLOR
            JSR     CHPENCL                 ; CHANGE PEN COLOR
            JSR     CHFILLCL                ; CHANGE FILL COLOR
            
            MOVE.B  #87,D0
            MOVE.W  (A2)+,D5                ; D5 = LOOP COUNTER
.LOOP2      MOVE.W  (A2)+,D1
            MOVE.W  (A2)+,D2
            MOVE.W  (A2)+,D3
            MOVE.W  (A2)+,D4
            TRAP    #15
            DBRA    D5,.LOOP2
                 
            ; DRAW MATRIX
            
            
            LEA.L   MATRIX,A0               ; A0 = VISIBLE MATRIX
            LEA.L   COLOR,A1                ; A1 = COLOR ARRAY POINTER
            CLR.L   D0                      ; D0 = POINTER TO SQUARE
            CLR.L   D1
            CLR.L   D2                      ; D2 = Y
            CLR.L   D3                      ; D3 = X
            CLR.L   D4
            
.LOOP3      CLR.L   D1
            MOVE.B  (A0,D0),D1              ; D1 = CELL CONTENT
            
            ; SQUARE CHECK
            
            BTST.L  #0,D1                   ; CHECK IF SQUARE IS USED
            BEQ     .SKIP1                  ; IF NOT NEXT
            
            ; SQUARE COLOR
            
            LSR.B   #4,D1                   ; D1 = COLOR INDEXS
            MOVE.L  D1,D4
            MULU.W  #4,D1                   ; D1 = COLOR POINTER
            MOVE.L  (A1,D1),D1              ; D1 = COLOR
            JSR     CHFILLCL                ; CHANGE FILL COLOR
            JSR     CHPENCL
            
            ; SQUARE PAINT
            
            MOVE.L  D2,D1                   ; D1 = LX.B,UY.B
            SWAP.W  D1
            ADD.W   D3,D1
            
            JSR     DRAWSQUARE
            
            ; NEXT SQUARE
            
.SKIP1      ADDQ.B  #1,D2                   ; ADDS 1 TO X
            CMP     #MCOLUMN,D2             ; CHECKS IF END OF ROW
            BNE     .SKIP2
            
            ADDQ.B  #1,D3                   ; ADDS 1 TO Y
            CLR.B   D2                      ; CLEAR X
            
.SKIP2      ADDQ.W  #1,D0                   ; ADDS 1 TO CELL TO DRAW
            CMP     #(MROW-4)*MCOLUMN,D0    ; CHECKS IF END OF MATRIX
            BNE     .LOOP3
            
            MOVEM.L (A7)+,D0-D5/A0-A1
            RTS

; -----------------------------------------------------------------------------
DRAWGAMEOVER
; OPERATIONS TO DRAW THE GAME OVER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D4/A0-A2,-(A7)
            
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
            
            ; DRAW TOTAL SCORE
            
            MOVE.B  #11,D0
            MOVE.W  #$3B1D,D1
            TRAP    #15
            MOVE.B  #3,D0
            MOVE.L  SCORE,D1
            TRAP    #15 
            
            LEA.L   GMOVERXY,A0             ; A0 = TEXT COORDENATES
            MOVE.B  #95,D0
            MOVE.W  (A0)+,D1                ; D1 = TEXT X
            MOVE.W  (A0)+,D2                ; D2 = TEXT Y
            LEA.L   TEXTRESL,A1             ; A1 = TEXT TO PRINT
            TRAP    #15
            
            ; DRAW RETRY TEXT EACH SECOND APROX
            
            MOVE.B  SCRCYCCT,D3
            ANDI.B  #%00011111,D3           ; AFTER X TIME UPDATE COLOR
            BNE     .SKIP
            NOT.B   SHOWTEXT                ; CHANGE VALUE OF SHOWTEXT
            ANDI.B  #$01,SHOWTEXT
            
.SKIP       BTST.B  #0,SHOWTEXT             ; IF SHOWTEXT = 1 DRAW TEXT
            BEQ     .END
            MOVE.W  (A0)+,D1                ; D1 = TEXT X
            MOVE.W  (A0)+,D2                ; D2 = TEXT Y
            LEA.L   TEXTREST,A1             ; A1 = TEXT TO PRINT
            TRAP    #15      

.END        MOVEM.L (A7)+,D0-D4/A0-A2
            RTS

; -----------------------------------------------------------------------------
DRAWSQUARE
; DRAW A SQUARE IN THE SCREEN
; INPUT    - D1.L = LOWER BYTE = Y, UPPER BYTE = X
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D4,-(A7)
            
            MOVE.W  D1,D2                   ; D2 = Y
            CLR.W   D1
            SWAP.W  D1                      ; D1 = X
            
            MULU.W  #LENSQU,D1          ; D1 = SQUARE LX INSIDE MATRIX
            MULU.W  #LENSQU,D2          ; D2 = SQUARE UY INSIDE MATRIX
            
            ADD.W   #XMATRIX,D1             ; D1 = LX
            ADD.W   #YMATRIX,D2             ; D2 = UY
            
            MOVE.W  D1,D3
            ADD.W   #LENSQU,D3          ; D3 = RX
            MOVE.W  D2,D4
            ADD.W   #LENSQU,D4          ; D4 = LY
            
            MOVE.B  #87,D0
            TRAP    #15                     ; DRAW SQUARE
            
            MOVEM.L (A7)+,D0-D4

            RTS

; -----------------------------------------------------------------------------
CHPENCL
; CHANGES THE COLOR TO THE PEN
; INPUT    - D1.L = COLOR $00BBGGRR
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
; INPUT    - D1.L = COLOR $00BBGGRR
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVE.L  D0,-(A7)
            MOVE.B  #81,D0
            TRAP    #15
            MOVE.L  (A7)+,D0
            RTS












*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
