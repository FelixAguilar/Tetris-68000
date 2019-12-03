; =============================================================================
; SQUARE
; =============================================================================

; -----------------------------------------------------------------------------
INITSQUARE
; ADDS A NEW SQUARE IN THE HIDEN ZONE OF THE MATRIX
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - MATRIX
; -----------------------------------------------------------------------------
            
            MOVEM.L D0/A0,-(A7)
            LEA.L   HROW4,A0
            CLR.L   D0
            
            MOVE.B  #4+MCOLUMN*2,D0
            MOVE.B  D0,FIGPOSI
            
            MOVE.B  #$61,(A0,D0)
            ADDQ.L  #1,D0
            MOVE.B  #$61,(A0,D0)
            ADD.B   #MCOLUMN,D0
            MOVE.B  #$61,(A0,D0)
            SUBQ.L  #1,D0
            MOVE.B  #$61,(A0,D0)
            
            MOVEM.L (A7)+,D0/A0
            RTS
 
; -----------------------------------------------------------------------------
DOWNSQUARE
; MOVES THE CURRENT SQUATE IN THE MATRIX
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - MATRIX
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D2/A0,-(A7)
            
            CLR.L   D0
            
            LEA.L   HROW4,A0                ; A0 = BEGIN OF MATRIX
            MOVE.B  FIGPOSI,D0              ; D0 = START OF FIGURE
            
            ; CHECK IF IT CAN GO DOWN MORE
            
            ADD.B   #MCOLUMN*2,D0           ; BOTTOM ROW AFTER THE SQUARE
            CMP     #MCOLUMN*MROW,D0        ; CHECK IF IS END OF MATRIX 
            BHS     .NEXT                   ; IF IT IS THEN GO TO NEXT
            
            MOVE.W  #1,D1                   ; CREATE A COUNTER FOR LOOP
            
.LOOP       MOVE.B  (A0,D0),D2              ; MOVE CELL TO D2
            BTST.L  #0,D2                   ; CHECKS IF D2 IS FILLED
            BEQ     .SKIP                   ; IF NOT SKIP
            BRA     .NEXT                   ; IF TRUE THEN NEXT
.SKIP       ADDQ.B  #1,D0                   ; NEXT CELL TO CHECK
            DBRA    D1,.LOOP                ; LOOP                   
            
            ; MOVES THE FIGURE DOWN BY ONE ROW
            
            CLR.L   D1
            MOVE.B  FIGPOSI,D0              ; D0 = START OF FIGURE
            MOVE.B  D0,D1                   
            ADD.B   #MCOLUMN*2,D1           ; D1 = CELL BELOW FIGURE
            
            MOVE.B  (A0,D0),(A0,D1)         ; MOVE CONTENT BETWEEN CELLS
            CLR.B   (A0,D0)                 ; CLEARS TOP CELL
            ADDQ.B  #1,D0                   ; DO = SECOND CELL
            ADDQ.B  #1,D1                   ; D1 = FOURTH CELL
            MOVE.B  (A0,D0),(A0,D1)
            CLR.B   (A0,D0)
            
            ADD.B   #MCOLUMN-1,D0           ; D0 = NEW FIGURE POINTER
            MOVE.B  D0,FIGPOSI              ; SAVES NEW FIGURE POINTER
            BRA     .END
            
.NEXT       MOVE.B  #1,FIGLDOW              ; CHANGES FIGLDOW TO YES (1)
.END        MOVEM.L (A7)+,D0-D2/A0
            RTS

; -----------------------------------------------------------------------------
LEFTSQUARE
; CHECKS IF CAN GO FUTHER DOWN
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D1/A0,-(A7)
            
            CLR.L   D0
            CLR.L   D1
            
            LEA.L   HROW4,A0                ; A0 = START OF MATRIX
            MOVE.B  FIGPOSI,D0              ; D0 = FIGURE POSITION
            
            ; CHECK IF THERE IS END OF MATRIX TO THE LEFT
            
            MOVE.W  D0,D1
            ADD.W   #MCOLUMN,D1
            DIVU.W  #MCOLUMN,D0
            LSR.L   #8,D0
            LSR.L   #8,D0
            CMP.W   #0,D0
            BNE     .SKIP1
            BRA     .END
.SKIP1      DIVU.W  #MCOLUMN,D1
            LSR.L   #8,D1
            LSR.L   #8,D1
            CMP.W   #0,D1
            BEQ     .END
            
            ; CHECK IF THERE IS A FULL CELL TO THE LEFT
            
            CLR.L   D1
            CLR.L   D0
            MOVE.B  FIGPOSI,D0              ; D0 = FIGURE POSITION
            
            SUBQ.B  #1,D0
            BTST.B  #0,(A0,D0)
            BNE     .END
            ADD.B   #MCOLUMN,D0
            BTST.B  #0,(A0,D0)
            BNE     .END
            
            ; MOVES FIGURE TO THE LEFT BY ONE CELL
            
            CLR.L   D1
            MOVE.B  FIGPOSI,D0              ; D0 = FIGURE POSITION
            MOVE.B  D0,D1
            ADDQ.B  #1,D0                   ; D0 = CELL TO MOVE                   
            SUBQ.B  #1,D1                   ; D1 = NEXT COLUNM AFTER SQUARE
            
            MOVE.B  (A0,D0),(A0,D1)         ; COPY THE CELL CONTENT
            CLR.B   (A0,D0)                 ; CLEAR THE CELL CONTENT
            ADD.B   #MCOLUMN,D0             ; MOVE TO NEXT CELL TO MOVE
            ADD.B   #MCOLUMN,D1             ; MOVE TO NEXT CELL TO SAVE
            MOVE.B  (A0,D0),(A0,D1)
            CLR.B   (A0,D0)
            
            SUB.B   #MCOLUMN+2,D0           ; D0 = NEW FIGURE POINTER
            MOVE.B  D0,FIGPOSI              ; SAVES NEW FIGURE POINTER
            
.END        MOVEM.L (A7)+,D0-D1/A0
            RTS
            
; -----------------------------------------------------------------------------
RIGHTSQUARE
; CHECKS IF CAN GO FUTHER DOWN
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D1/A0,-(A7)
            
            CLR.L   D0
            CLR.L   D1
            
            LEA.L   HROW4,A0                ; A0 = START OF MATRIX
            MOVE.B  FIGPOSI,D0              ; D0 = FIGURE POSITION
            
            ; CHECK IF THERE IS END OF MATRIX TO THE LEFT
            
            MOVE.W  D0,D1
            ADD.W   #MCOLUMN,D1
            DIVU.W  #MCOLUMN,D0
            LSR.L   #8,D0
            LSR.L   #8,D0
            CMP.W   #8,D0
            BNE     .SKIP1
            BRA     .END
.SKIP1      DIVU.W  #MCOLUMN,D1
            LSR.L   #8,D1
            LSR.L   #8,D1
            CMP.W   #8,D1
            BEQ     .END

            ; CHECK IF THERE IS A FULL CELL TO THE LEFT
            
            CLR.L   D1
            CLR.L   D0
            MOVE.B  FIGPOSI,D0              ; D0 = FIGURE POSITION
            
            ADDQ.B  #2,D0
            BTST.B  #0,(A0,D0)
            BNE     .END
            ADD.B   #MCOLUMN,D0
            BTST.B  #0,(A0,D0)
            BNE     .END
            
            ; MOVES FIGURE TO THE LEFT BY ONE CELL
            
            CLR.L   D1
            MOVE.B  FIGPOSI,D0              ; D0 = FIGURE POSITION
            MOVE.B  D0,D1                
            ADDQ.B  #2,D1                   ; D1 = NEXT COLUNM AFTER SQUARE
            
            MOVE.B  (A0,D0),(A0,D1)         ; COPY THE CELL CONTENT
            CLR.B   (A0,D0)                 ; CLEAR THE CELL CONTENT
            ADD.B   #MCOLUMN,D0             ; MOVE TO NEXT CELL TO MOVE
            ADD.B   #MCOLUMN,D1             ; MOVE TO NEXT CELL TO SAVE
            MOVE.B  (A0,D0),(A0,D1)
            CLR.B   (A0,D0)
            
            SUB.B   #MCOLUMN-1,D0           ; D0 = NEW FIGURE POINTER
            MOVE.B  D0,FIGPOSI              ; SAVES NEW FIGURE POINTER
            
.END        MOVEM.L (A7)+,D0-D1/A0
            RTS
            
; -----------------------------------------------------------------------------
ROTATESQUARE
; IT DOES NOT REQUIRED TO ROTATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            RTS









*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
