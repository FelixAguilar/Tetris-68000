; =============================================================================
; GRAPHICS
; =============================================================================

; -----------------------------------------------------------------------------
DRAWMENU
; OPERATIONS TO DRAW THE MENU PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - SCREEN BUFFER
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D5/A0-A3,-(A7)
            
            ; SET COLOR AND WHITH FOR PEN AND FILL
            
            MOVE.L  #$00FFFFFF,D1           ; D1 = WHITE
            JSR     CHPENCL                 ; CHANGE PEN COLOR
            CLR.L   D1                      ; D1 = BLACK
            JSR     CHFILLCL                ; CHANGE FILL COLOR
            MOVE.B  #93,D0
            MOVE.B  #PENWHITH,D1            ; D1 = PEN WHITH
            TRAP    #15                     ; CHANGE PEN WHITH
            
            ; GET STARTING COLOR FOR TITLE AND UDATE IT
            
            CLR.L   D5
            MOVE.W  TITLECOL,D5             ; D5 = CURRENT COLOR INDEX
            MOVE.B  SCRCYCCT,D0             ; D0 = CYCLE COUNTER
            ANDI.B  #TIMERF,D0              ; AFTER X TIME UPDATE COLOR
            BNE     .SKIP
            ADDQ.W  #1,D5                   ; MOVE POINTER BY ONE
            DIVU.W  #7,D5                   ; CHECKS IF IS NOT OUT OF THE LIST
            SWAP.W  D5                      ; GETS THE REMAINDER
            ANDI.L  #$0000FFFF,D5           ; CLEAR UPPER WORD
            MOVE.W  D5,TITLECOL             ; SAVES IT TO MEMORY
.SKIP       LSL.L   #2,D5                   ; D5 = LONG WORD POINTER
            
            ; WRITE TITLE "TETRIS"
            
            LEA.L   TITLEY,A0               ; A0 = Y COORDINATES FOR TITLE
            LEA.L   TITLEX,A1               ; A1 = X COORDINATES FOR TITLE
            LEA.L   TITLELOP,A2             ; A2 = LOOP COUNTERS LIST
            LEA.L   COLOR,A3                ; A3 = COLOR LIST 
            MOVE.W  #6,D4                   ; D4 = MAIN LOOP COUNTER
            
            JSR     DRAWTITLE               ; DRAW THE TITLE
            
            ; SET COLOR AND WHITH FOR PEN AND FILL
            
            MOVE.L  #$00FFFFFF,D1           ; D1 = WHITE
            JSR     CHPENCL                 ; CHANGE PEN COLOR
            CLR.L   D1                      ; D1 = BLACK
            JSR     CHFILLCL                ; CHANGE FILL COLOR
            MOVE.B  #93,D0
            MOVE.B  #1,D1                   ; D1 = WHITH OF PEN
            TRAP    #15                     ; CHANGE PEN WHITH
            
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
            
            MOVE.W  #5,D3                   ; D3 = LOOP COUNTER
            LEA.L   INSTXY,A0               ; A0 = TEXT COORDINATES LIST
            LEA.L   INSTLINK,A2             ; A2 = INSTRUCTION TEXT LIST
            
.LOOP2      MOVE.W  (A0)+,D1                ; D1 = X TEXT COORDINATE
            MOVE.W  (A0)+,D2                ; D2 = Y TEXT COORDINATE
            MOVE.L  (A2)+,A1                ; A1 = TEXT TO PRINT
            TRAP    #15                     ; WRITE THE TEXT
            DBRA    D3,.LOOP2               ; NEXT LINE
            
            MOVE.W  #4,D3
            LEA.L   INS2,A1
.LOOP3      MOVE.W  (A0)+,D1
            MOVE.W  (A0)+,D2
            TRAP    #15
            DBRA    D3,.LOOP3
     
            MOVE.W  #4,D3 
.LOOP4      MOVE.W  (A0)+,D1
            MOVE.W  (A0)+,D2
            MOVE.L  (A2)+,A1
            TRAP    #15
            DBRA    D3,.LOOP4

            LEA.L   MENUSTRT,A1
            MOVE.W  (A0)+,D1
            MOVE.W  (A0)+,D2
            TRAP    #15
       
.END        MOVEM.L (A7)+,D0-D5/A0-A3
            RTS

; -----------------------------------------------------------------------------
DRAWGAME
; OPERATIONS TO DRAW THE GAME PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - SCREEN BUFFER
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D5/A0-A1,-(A7)
            
            ; SET PEN AND FILL COLOR
            
            MOVE.L  #$00FFFFFF,D1           ; D1 = WHITE
            JSR     CHPENCL                 ; CHANGE PEN COLOR
            CLR.L   D1                      ; D1 = BLACK
            JSR     CHFILLCL                ; CHANGE FILL COLOR
            
            ; CONTAINERS
            
            LEA.L   GAMECONX,A0             ; A0 = CONTAINER COORDENATE X
            LEA.L   GAMECONY,A1             ; A1 = CONTAINER COORDENATE Y
            MOVE.W  #2,D5                   ; D5 = LOOP COUNTER
            MOVE.B  #90,D0
            
.LOOP1      MOVE.W  (A0)+,D1                ; D1 = LX CONTAINER
            MOVE.W  (A1)+,D2                ; D2 = UY CONTAINER
            MOVE.W  (A0)+,D3                ; D3 = RX CONTAINER
            MOVE.W  (A1)+,D4                ; D4 = LY CONTAINER
            TRAP    #15                     ; DRAWS THE CURRENT CONTAINER
            DBRA    D5,.LOOP1               ; NEXT CONTAINER
            
            ; DRAW TEXT
            
            LEA.L   TXTGAMXY,A0             ; A0 = TEXT COORDINATES ARRAY
            MOVE.B  #95,D0
            
            MOVE.W  (A0)+,D1                ; D1 = X TEXT COORDINATE
            MOVE.W  (A0)+,D2                ; D2 = Y TEXT COORDINATE
            LEA     TEXTSCRE,A1             ; A1 = TEXT SCORE POINTER
            TRAP    #15                     ; WRITE THE TEXT
            
            MOVE.W  (A0)+,D1
            MOVE.W  (A0)+,D2
            LEA     TEXTNEXT,A1             ; A1 = TEXT NEXT POINTER
            TRAP    #15
            
            ; DRAW SCORE
            
            MOVE.B  #11,D0
            MOVE.W  #$5E0F,D1               ; D1 = CURSOR POSITION
            TRAP    #15                     ; MOVE CURSOR
            MOVE.B  #3,D0
            MOVE.L  SCORE,D1                ; D1 = SCORE
            TRAP    #15                     ; WRITE SCORE
      
            ; DRAW NEXT TETROMINO
            
            
            LEA.L   COLOR,A1                ; A1 = COLOR ARRAY POINTER
            LEA.L   NEXTLINK,A2             ; A2 = NEXT TETROMINO TO DRAW
            
            CLR.L   D0
            MOVE.B  TETRONXT,D0             ; D0 = NEXT TETROMINO INDEX
            LSL.L   #2,D0                   ; MULTIPLIES BY 4
            MOVEA.L (A2,D0),A2              ; A2 = NEXT TETROMINO
            MOVE.W  (A2)+,D1                ; D1 = COLOR INDEX
            LSL.L   #2,D1                   ; MULTIPLIES BY 4
            MOVE.L  (A1,D1),D1              ; D1 = COLOR
            JSR     CHPENCL                 ; CHANGE PEN COLOR
            JSR     CHFILLCL                ; CHANGE FILL COLOR
            
            MOVE.B  #87,D0
            MOVE.W  (A2)+,D5                ; D5 = LOOP COUNTER
.LOOP2      MOVE.W  (A2)+,D1                ; D1 = LX
            MOVE.W  (A2)+,D2                ; D2 = UY
            MOVE.W  (A2)+,D3                ; D3 = RX
            MOVE.W  (A2)+,D4                ; D4 = LY
            TRAP    #15                     ; DRAW RECTANGLE
            DBRA    D5,.LOOP2               ; NEXT RECTANGLE
                 
            ; DRAW MATRIX
            
            LEA.L   MATRIX,A0               ; A0 = VISIBLE MATRIX
            LEA.L   COLOR,A1                ; A1 = COLOR LIST
            CLR.L   D0                      ; D0 = CURRENT SQUARE TO DRAW
            CLR.L   D2                      ; D2 = COORDENATE X FOR SQUARE
            CLR.L   D3                      ; D3 = COORDENATE Y FOR SQUARE
            
.LOOP3      CLR.L   D1
            MOVE.B  (A0,D0),D1              ; D1 = SQUARE CONTENT
            
            ; SQUARE CHECK
            
            BTST.L  #0,D1                   ; CHECK IF SQUARE IS USED
            BEQ     .SKIP1                  ; IF NOT SKIP
            
            ; SQUARE COLOR
            
            LSR.B   #4,D1                   ; D1 = COLOR INDEX
            LSL.L   #2,D1                   ; D1 = COLOR POINTER
            MOVE.L  (A1,D1),D1              ; D1 = COLOR
            JSR     CHFILLCL                ; CHANGE FILL COLOR
            JSR     CHPENCL
            
            ; SQUARE DRAW
            
            MOVE.L  D2,D1                   ; D1 = LX
            SWAP.W  D1                      ; D1 = LX IN UPPER WORD
            ADD.W   D3,D1                   ; D1 = UY IN LOWER WORD
            
            JSR     DRAWSQUARE              ; DRAW SQUARE
            
            ; NEXT SQUARE
            
.SKIP1      ADDQ.B  #1,D2                   ; ADDS 1 TO COORDENATE X
            CMP     #MCOLUMN,D2             ; CHECKS IF END OF ROW
            BNE     .SKIP2                  ; IF NOT THEN SKIP
            
            ADDQ.B  #1,D3                   ; ADDS 1 TO COORDENATE Y
            CLR.B   D2                      ; CLEAR COORDATE X
            
.SKIP2      ADDQ.W  #1,D0                   ; ADDS 1 TO SQUARE TO DRAW
            CMP     #(MROW-4)*MCOLUMN,D0    ; CHECKS IF END OF MATRIX
            BNE     .LOOP3                  ; NEXT SQUERE TO DRAW
            
            MOVEM.L (A7)+,D0-D5/A0-A1
            RTS

; -----------------------------------------------------------------------------
DRAWGAMEOVER
; OPERATIONS TO DRAW THE GAME OVER PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - SCREEN BUFFER
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D4/A0-A2,-(A7)
            
            ; SET COLOR AND WHITH FOR PEN AND FILL
            
            MOVE.L  #$000000FF,D1           ; D1 = RED
            JSR     CHPENCL                 ; CHANGES PEN COLOR
            CLR.L   D1                      ; D1 = BLACK
            JSR     CHFILLCL                ; CHANGES FILL COLOR
            MOVE.B  #93,D0
            MOVE.B  #5,D1                   ; D1 = WHITH 5 PIXELS
            TRAP    #15                     ; CHANGES PEN WHITH 
            
             ; WRITE TITLE "GAMEOVER"
            
            LEA.L   GMOVERY,A0              ; A0 = Y COORDINATES FOR TITLE
            LEA.L   GMOVERX,A1              ; A1 = X COORDINATES FOR TITLE
            LEA.L   GMOVER,A2               ; A2 = LOOP ARRAY             
            MOVE.W  #10,D4                  ; D4 = MAIN LOOP COUNTER  
            BSET.L  #31,D5                  ; SETS D5 UPPER BIT TO 1
            JSR     DRAWTITLE               ; DRAW THE TITLE
            
            ; SET COLOR AND WHITH FOR PEN
            
            MOVE.L  #$00FFFFFF,D1           ; D1 = WHITE
            JSR     CHPENCL                 ; CHANGES PEN COLOR
            MOVE.B  #93,D0
            MOVE.B  #1,D1                   ; D1 = WHITH 1 PIXEL
            TRAP    #15                     ; CHANGES PEN WHITH
            
            ; DRAW TOTAL SCORE
            
            MOVE.B  #11,D0
            MOVE.W  #$3B1D,D1               ; D1 = CURSOR POSITION FOR SCORE
            TRAP    #15                     ; MOVE CURSOR
            MOVE.B  #3,D0
            MOVE.L  SCORE,D1                ; D1 = SCORE VALUE
            TRAP    #15                     ; PRINT SCORE
            
            LEA.L   GMOVERXY,A0             ; A0 = TEXT COORDENATES
            MOVE.B  #95,D0
            MOVE.W  (A0)+,D1                ; D1 = TEXT X
            MOVE.W  (A0)+,D2                ; D2 = TEXT Y
            LEA.L   TEXTRESL,A1             ; A1 = TEXT TO PRINT
            TRAP    #15                     ; PRINT TEXT
            
            ; DRAW RETRY TEXT EACH SECOND APROX
            
            MOVE.B  SCRCYCCT,D1             ; D0 = CYCLE COUNTER
            ANDI.B  #%00100000,D1           ; AFTER X TIME SHOW TEXT
            BNE     .END
            MOVE.W  (A0)+,D1                ; D1 = TEXT X
            MOVE.W  (A0)+,D2                ; D2 = TEXT Y
            LEA.L   TEXTREST,A1             ; A1 = TEXT TO PRINT
            TRAP    #15                     ; PRINT       

.END        MOVEM.L (A7)+,D0-D4/A0-A2
            RTS

; -----------------------------------------------------------------------------
DRAWSQUARE
; DRAW A SQUARE IN THE SCREEN
; INPUT    - D1.L = LOWER BYTE IS Y, UPPER BYTE IS X
; OUTPUT   - NONE
; MODIFIES - SCREEN BUFFER
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D4,-(A7)
            
            MOVE.W  D1,D2                   ; D2 = Y
            SWAP.W  D1                      ; D1 = X
            
            MULU.W  #LENSQU,D1              ; D1 = SQUARE LX INSIDE MATRIX
            MULU.W  #LENSQU,D2              ; D2 = SQUARE UY INSIDE MATRIX
            ADD.W   #XMATRIX,D1             ; D1 = LX
            ADD.W   #YMATRIX,D2             ; D2 = UY
            
            MOVE.W  D1,D3
            ADD.W   #LENSQU,D3              ; D3 = RX
            MOVE.W  D2,D4
            ADD.W   #LENSQU,D4              ; D4 = LY
            
            MOVE.B  #87,D0
            TRAP    #15                     ; DRAW SQUARE
            
            MOVEM.L (A7)+,D0-D4
            RTS

; -----------------------------------------------------------------------------
DRAWTITLE
; DRAW THE TITLE LINE BY LINE AND CHANGES THE COLOR IF REQUIRED
; INPUT    - A0.L = COORDENATE X LIST
;            A1.L = COORDENATE Y LIST
;            A2.L = LOOP COUNTER LIST
;            A3.L = COLOR LIST IF IS USED IF NOT IGNORED
;            D4.W = NUMBER OF LETTER TO DRAW
;            D5.L = STARTING COLOR, SKIP COLOR IF UPPER BIT = 1
; OUTPUT   - NONE
; MODIFIES - SCREEN BUFFER
; -----------------------------------------------------------------------------
            
            
.NEXT       BTST.L  #31,D5                  ; CHECKS IF UPPER BIT IS 1
            BNE     .SKIP                   ; IF IT IS THEN SKIP
            MOVE.L  (A3,D5),D1              ; D1 = COLOR POINTER
            JSR     CHPENCL                 ; CHANGE COLOR FOR PEN
            LSR.L   #2,D5                   ; DIVIDES BY 4
            ADDQ.W  #1,D5                   ; ADDS 1 TO THE INDEX
            DIVU.W  #7,D5                   ; DIVIDES BY 7
            SWAP.W  D5                      ; GETS REMAINDER
            ANDI.L  #$0000FFFF,D5           ; CLEARS UPPER WORD
            LSL.L   #2,D5                   ; MULTIPLIES BY 4

            ; MOVES CURSOR AND GETS THE LOOP COUNTER
            
.SKIP       MOVE.B  #86,D0
            MOVE.W  (A1)+,D1                ; D1 = X CURSOR
            MOVE.W  (A0)+,D2                ; D2 = Y CURSOR
            TRAP    #15                     ; MOVER THE CURSOR
            MOVE.W  (A2)+,D3                ; D3 = LOOP COUNTER
            
            ; DRAW LETTER FOR TITLE
            
            MOVE.B  #85,D0
.LOOP       MOVE.W  (A1)+,D1                ; D1 = X DESTINATION LINE
            MOVE.W  (A0)+,D2                ; D2 = Y DESTINATION LINE
            TRAP    #15                     ; DRAW LINE
            DBRA    D3,.LOOP                ; DRAW NEXT LINE
            DBRA    D4,.NEXT                ; DRAW NEXT LETTER

; -----------------------------------------------------------------------------
CHPENCL
; CHANGES THE COLOR TO THE PEN
; INPUT    - D1.L = COLOR $00BBGGRR
; OUTPUT   - NONE
; MODIFIES - PEN COLOR
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
; MODIFIES - FILL COLOR
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
