; =============================================================================
; GRAPHICS
; =============================================================================

; -----------------------------------------------------------------------------
DRAWMATRIX
; PRINTS THE MATRIX IN THE INDICATED SPACE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D3/A0-A1,-(A7)           
            
            LEA.L   ROW0,A0
            LEA.L   COLOR,A1
            CLR.L   D0                      ; D0 = CELL TO DRAW
            CLR.L   D2                      ; D2 = Y
            CLR.L   D3                      ; D3 = X
            
.LOOP       CLR.L   D1
            MOVE.B  (A0,D0),D1              ; D1 = CELL CONTENT
            
            BTST.L  #0,D1                   ; CHECKS IF THE CELL IS BEEING USED
            BEQ     .SKIP1                  ; IF NOT SKIPS.
            
            LSR.B   #4,D1                   ; D1 = COLOR INDEX
            MULU.W  #4,D1
            MOVE.L  (A1,D1),D1              ; D1 = COLOR
            JSR     CHPENCL                 ; CHANGES THE COLOR TO THE PEN
            JSR     CHFILLCL                ; CHANGES THE COLOR TO THE FILL
            
            MOVE.L  D2,D1                   ; D1 = LX.B,UY.B
            LSL.L   #8,D1
            LSL.L   #8,D1
            ADD.W   D3,D1
            
            JSR     DRAWCELL
            
.SKIP1      ADDQ.B  #1,D2                   ; ADDS 1 TO X
            CMP     #MCOLUMN,D2             ; CHECKS IF END OF ROW
            BNE     .SKIP2
            
            ADDQ.B  #1,D3                   ; ADDS 1 TO Y
            CLR.B   D2                      ; CLEAR X
            
.SKIP2      ADDQ.W  #1,D0                   ; ADDS 1 TO CELL TO DRAW
            CMP     #(MROW-4)*MCOLUMN,D0    ; CHECKS IF END OF MATRIX
            BNE     .LOOP
      
            MOVEM.L (A7)+,D0-D3/A0-A1
      
            RTS
            
; -----------------------------------------------------------------------------
DRAWCELL
; DRAW A SQUARE IN THE SCREEN
; INPUT    - D1.L   X AND Y OF THE CELL
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D4,-(A7)
            
            MOVE.W  D1,D2                   ; D2 = Y
            LSR.L   #8,D1
            LSR.L   #8,D1                   ; D1 = X
            
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

; -----------------------------------------------------------------------------
CHPENCL
; CHANGES THE COLOR TO THE PEN
; INPUT    - D1.L   COLOR $00BBGGRR
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
; INPUT    - D1.L   COLOR $00BBGGRR
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVE.L  D0,-(A7)
            MOVE.B  #81,D0
            TRAP    #15
            MOVE.L  (A7)+,D0
            RTS
            
; -----------------------------------------------------------------------------
DRAWTEXT
; ALLOWS TO DRAW TEXT IN WHITE IN THE SCREEN WHERE THE POINTER IS
; INPUT    - A0.L POINTER TO THE STRING 
; OUTPUT   - NONE
; MODIFIES - SCREEN
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D1,-(A7)
            MOVE.B  #6,D0
.LOOP:      MOVE.B  (A0)+,D1
            TRAP    #15
            BNE     .LOOP 
            MOVEM.L (A7)+,D0-D1
            RTS
            
; -----------------------------------------------------------------------------
SETCURSOR
; MOVES THE POINTER IN A CONCTRETE POSITION IN THE SCREEN
; INPUT    - D1.B = COL NUMBER D2.B = ROW NUMBER 
; OUTPUT   - NONE
; MODIFIES - SCREEN
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D1,-(A7)
            LSR.L   #4,D1
            ADD.W   D2,D1
            MOVE.B  #11,D0
            TRAP    #15
            MOVEM.L (A7)+,D0-D1
            RTS
            
; -----------------------------------------------------------------------------
GETCURSOR
; OBTEINS THE POINTER
; INPUT    - NONE
; OUTPUT   - D1 = HIGH BYTE IS COL, LOW BYTE IS ROW 
; MODIFIES - SCREEN
; -----------------------------------------------------------------------------
            
            MOVEM.L D0,-(A7)
            MOVE.W  #$00FF,D1
            MOVE.B  #11,D0
            TRAP    #15
            MOVEM.L (A7)+,D0
            RTS





*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
