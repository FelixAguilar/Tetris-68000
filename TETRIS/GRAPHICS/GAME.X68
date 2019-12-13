; =============================================================================
; GAME
; =============================================================================

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
      
            ; DRAW NEXT TETROMINO
            
            CLR.L   D0
            LEA.L   COLOR,A1                ; A1 = COLOR ARRAY POINTER
            LEA.L   LNEXT,A2
            MOVE.B  FIGNEXT,D0
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
            MULU.W  #4,D1                   ; D1 = COLOR POINTER
            MOVE.L  (A1,D1),D1              ; D1 = COLOR
            JSR     CHPENCL                 ; CHANGE PEN COLOR
            JSR     CHFILLCL                ; CHANGE FILL COLOR
            
            ; SQUARE PAINT
            
            MOVE.L  D2,D1                   ; D1 = LX.B,UY.B
            SWAP.W  D1
            ADD.W   D3,D1
            
            JSR     .DRAWSQUARE
            
            ; NEXT SQUARE
            
.SKIP1      ADDQ.B  #1,D2                   ; ADDS 1 TO X
            CMP     #MCOLUMN,D2             ; CHECKS IF END OF ROW
            BNE     .SKIP2
            
            ADDQ.B  #1,D3                   ; ADDS 1 TO Y
            CLR.B   D2                      ; CLEAR X
            
.SKIP2      ADDQ.W  #1,D0                   ; ADDS 1 TO CELL TO DRAW
            CMP     #(MROW-4)*MCOLUMN,D0    ; CHECKS IF END OF MATRIX
            BNE     .LOOP3
            
            MOVE.B  #87,D0                  
            TRAP    #15                     ; DRAW SQUARE
            
            MOVEM.L (A7)+,D0-D5/A0-A1
            RTS
              
; -----------------------------------------------------------------------------
.DRAWSQUARE
; DRAW A SQUARE IN THE SCREEN
; INPUT    - D1.L   X AND Y OF THE CELL
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D4,-(A7)
            
            MOVE.W  D1,D2                   ; D2 = Y
            CLR.W   D1
            SWAP.W  D1                      ; D1 = X
            
            MULU.W  #SIDELENGTH,D1          ; D1 = SQUARE LX INSIDE MATRIX
            MULU.W  #SIDELENGTH,D2          ; D2 = SQUARE UY INSIDE MATRIX
            
            ADD.W   #XMATRIX,D1             ; D1 = LX
            ADD.W   #YMATRIX,D2             ; D2 = UY
            
            MOVE.W  D1,D3
            ADD.W   #SIDELENGTH,D3          ; D3 = RX
            MOVE.W  D2,D4
            ADD.W   #SIDELENGTH,D4          ; D4 = LY
            
            MOVE.B  #87,D0
            TRAP    #15                     ; DRAW SQUARE
            
            MOVEM.L (A7)+,D0-D4

            RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
