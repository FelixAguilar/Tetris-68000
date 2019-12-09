; =============================================================================
; TETROMINO 3X3
; =============================================================================

; -----------------------------------------------------------------------------
INITT
; ADDS A NEW TETROMINO 3X3 IN THE HIDEN ZONE OF THE MATRIX
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - MATRIX
; -----------------------------------------------------------------------------
            
            MOVE.B  #0,FIGROTA              ; STARTING ROTATION
            MOVE.B  #MCOLUMN+3,FIGPOSI      ; STARTING POSITION
            JSR     ADDTETROMINO            ; ADDS THE NEW TETROMINO

            RTS

; -----------------------------------------------------------------------------
DOWNT
; MOVES DOWN THE CURRENT TETROMINO 3X3 IN THE MATRIX
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - MATRIX
; -----------------------------------------------------------------------------

            MOVEM.L D0-D4/A0-A1,-(A7)

            CLR.L   D0
            CLR.L   D1
            
            ; GETS THE TETROMINO VALUES AND THEM

            LEA.L   HROW4,A0                ; A0 = MATRIX STATING POINT
            MOVEA.L FIGTYPE,A1              ; A1 = TETROMINO STRUCTURE MATRIX
            MOVE.B  FIGPOSI,D0              ; D0 = POSITION INDEX TETROMINO
            MOVE.B  FIGROTA,D1              ; D1 = ROTATION INDEX
            
            ADD.B   #MCOLUMN,D0             ; D0 = INDEX TETROMINO 1 ROW LOWER
            MULU.W  #MUL3,D1                ; D1 = TETROMINOS MATRIX TO USE
            MOVE.B  D1,D4
            ADDQ.B  #5,D4                   ; D4 = VALUE TO CHECK WITH D1 LATER
            
            ; CHECKS IF THE TETROMINO CAN GO DOWN 1 ROW
            
            JSR     CLRTETROMINO            ; CLEANS CURRENT TETROMINO
            
            MOVE.W  #2,D2                   ; D2 = COL INDEX FOR TETROMINO
            MOVE.W  #2,D3                   ; D3 = ROW INDEX FOR TETROMINO
            
.LOOP       BTST.B  #0,(A1,D1)              ; CHECK IF TETROMINO MATRIX IS FILL
            BEQ     .SKIP2                  ; IF FALSE SKIP
            CMP.B   D4,D1                   ; CHECK IF D1 IS BIGER THAN 5
            BHS     .SKIP1                  ; IF TRUE SKIP
            BTST.B  #0,3(A1,D1)             ; CHECK IF BELOW TETROMINO IS FILL
            BNE     .SKIP2                  ; IF TRUE SKIP
.SKIP1      BTST.B  #0,(A0,D0)              ; CHECK IF BELOW MATRIX IS FILLED
            BEQ     .SKIP2                  ; IF FALSE SKIP
            MOVE.B  #1,FIGLDOW              ; IF TRUE UPDATES LDOW AND EXITS
            BRA     .EXIT
.SKIP2      ADDQ.B  #1,D1                   ; NEXT CELL FOR TETROMINO
            ADDQ.B  #1,D0                   ; NEXT CELL FOR MATRIX
            DBRA    D2,.LOOP
            ADD.B   #MCOLUMN-3,D0           ; MOVE BY 1 ROW THE MATRIX POINTER
            MOVE.W  #2,D2
            DBRA    D3,.LOOP
            
            ; UPDATES MATRIX AND POSITION
            
            ADD.B   #MCOLUMN,FIGPOSI        ; UPDATES TETROMINO POSITION
            
.EXIT       JSR     ADDTETROMINO            ; ADDS NEW TETROMINO
            MOVEM.L (A7)+,D0-D4/A0-A1           
            RTS

; -----------------------------------------------------------------------------
LEFTT
; MOVES TO THE LEFT THE CURRENT TETROMINO
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - MATRIX
; -----------------------------------------------------------------------------
          
            MOVEM.L D0-D3/A0-A1,-(A7)
            
            CLR.L   D0
            CLR.L   D1

            ; GETS THE TETROMINO VALUES AND PRERATES THEM FOR FIRST CHECK
            
            LEA.L   HROW4,A0                ; A0 = MATRIX STATING POINT
            MOVEA.L FIGTYPE,A1              ; A1 = TETROMINO STRUCTURE MATRIX            
            MOVE.B  FIGPOSI,D0              ; D0 = POSITION INDEX IN MATRIX
            MOVE.B  FIGROTA,D1              ; D1 = ROTATION INDEX
            
            MULU.W  #MUL3,D1                ; D1 = TETROMINOS MATRIX TO USE
            
            ; CHECKS IF THERE IS A WALL TO THE LEFT
          
            MOVE.W  #2,D2                   ; D2 = COL INDEX FOR TETROMINO
            MOVE.W  #2,D3                   ; D3 = ROW INDEX FOR TETROMINO
            
.LOOP1      BTST.B  #0,(A1,D1)              ; CHECKS IF THERE IS LEFT CONTENT
            BEQ     .SKIP1                  ; IF NOT SKIP
            DIVU.W  #MCOLUMN,D0             ; DIVIDE CURRENT POS WITH COLUMNS
            SWAP.W  D0                      ; GETS THE REMANIDER
            TST.W   D0                      ; CHECKS IF IT IS 0
            BEQ     .EXIT                   ; IF TRUE THEN EXIT
            BRA     .NEXT                   ; ELSE PROCEED NEXT VERIFICATION
.SKIP1      ADDQ.B  #3,D1                   ; MOVES TO NEXT ROW IN TETROMINO
            ADD.B   #MCOLUMN,D0             ; MOVES TO NEXT ROW IN MATRIX
            DBRA    D2,.LOOP1
            SUBQ.B  #3*2-1,D1               ; MOVES TO NEXT COLUMN IN TETROMINO
            SUB.B   #MCOLUMN*2-1,D0         ; MOVES TO NEXT COLUMN IN MATRIX
            MOVE.W  #2,D2
            DBRA    D3,.LOOP1                   
            
            ; GETS THE TETROMINO VALUES AND PRERATES THEM FOR FIRST CHECK
            
.NEXT       MOVE.B  FIGPOSI,D0              ; D0 = POSITION INDEX IN MATRIX
            MOVE.B  FIGROTA,D1              ; D1 = ROTATION INDEX
            
            MULU.W  #MUL3,D1                ; D1 = TETROMINOS MATRIX TO USE
            SUB.B   #1,D0                   ; D0 = INDEX TETROMINO 1 COL LOWER
            
            ; CHECK IF THERE IS AN OBSTACLE TO THE LEFT
  
            MOVE.W  #2,D2                   ; D2 = COL INDEX FOR TETROMINO
            MOVE.W  #2,D3                   ; D3 = ROW INDEX FOR TETROMINO
             
.LOOP2      BTST.B  #0,(A1,D1)              ; CHECK IF THE CELL IS FILLED
            BEQ     .SKIP2                  ; IF NOT SKIP
            BTST.B  #0,(A0,D0)              ; CHECK IF THE LEFT CELL IS FILED
            BNE     .EXIT                   ; IF YES EXIT
            ADD.B   D2,D1                   ; IF NOT, CHECK LOWER CELL BY 1 ROW
            ADDQ.B  #1,D1                   
            ADD.B   #MCOLUMN,D0             ; D0 LOWERS BY 1 ROW
            SUBQ.B  #2,D0
            ADD.B   D2,D0
            BRA     .SKIP3                  ; SKIP TO SECOND LOOP
.SKIP2      ADDQ.B  #1,D0                   
            ADDQ.B  #1,D1                   ; CHECL RIGHT CELL IN TETROMINO
            DBRA    D2,.LOOP2
.SKIP3      MOVE.W  #2,D2
            DBRA    D3,.LOOP2
            
            ; UPDATES MATRIX AND POSITION
            
            JSR     CLRTETROMINO            ; CLEAR CURRENT TETROMINO
            SUBQ.B  #1,FIGPOSI             ; UPDATES TETROMINO POSITION
            JSR     ADDTETROMINO            ; ADD NEW TETROMINO
             
.EXIT       MOVEM.L (A7)+,D0-D3/A0-A1           
            RTS

            
; -----------------------------------------------------------------------------
RIGHTT
; CHECKS IF CAN GO FUTHER DOWN
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
   
            MOVEM.L D0-D3/A0-A1,-(A7)
            
            CLR.L   D0
            CLR.L   D1

            ; GETS THE TETROMINO VALUES AND PRERATES THEM FOR FIRST CHECK
            
            LEA.L   HROW4,A0                ; A0 = MATRIX STATING POINT
            MOVEA.L FIGTYPE,A1              ; A1 = TETROMINO STRUCTURE MATRIX            
            MOVE.B  FIGPOSI,D0              ; D0 = POSITION INDEX IN MATRIX
            MOVE.B  FIGROTA,D1              ; D1 = ROTATION INDEX
            
            MULU.W  #MUL3,D1                ; D1 = TETROMINOS MATRIX TO USE
            ADDQ.B  #8,D1                   ; D1 = TETROMINO LOWEST CELL
            ADD.B   #MCOLUMN*2+2,D0         ; D0 = LOWER RIGHT CELL
            
            ; CHECKS IF THERE IS A WALL TO THE LEFT
          
            MOVE.W  #2,D2                   ; D2 = COL INDEX FOR TETROMINO
            MOVE.W  #2,D3                   ; D3 = ROW INDEX FOR TETROMINO
            
.LOOP1      BTST.B  #0,(A1,D1)              ; CHECKS IF THERE IS RIGHT CONTENT
            BEQ     .SKIP1                  ; IF NOT SKIP
            DIVU.W  #MCOLUMN,D0             ; DIVIDE CURRENT POS WITH COLUMNS
            SWAP.W  D0                      ; GETS THE REMANIDER
            CMP.W   #9,D0                   ; CHECKS IF IT IS 0
            BEQ     .EXIT                   ; IF TRUE THEN EXIT
            BRA     .NEXT                   ; ELSE PROCEED NEXT VERIFICATION
.SKIP1      SUBQ.B  #3,D1                   ; MOVES TO NEXT ROW IN TETROMINO
            SUB.B   #MCOLUMN,D0             ; MOVES TO NEXT ROW IN MATRIX
            DBRA    D2,.LOOP1
            ADDQ.B  #3*2-1,D1               ; MOVES TO NEXT COLUMN IN TETROMINO
            ADD.B   #MCOLUMN*2-1,D0         ; MOVES TO NEXT COLUMN IN MATRIX
            MOVE.W  #2,D2
            DBRA    D3,.LOOP1                   
            
            ; GETS THE TETROMINO VALUES AND PRERATES THEM FOR FIRST CHECK
            
.NEXT       MOVE.B  FIGPOSI,D0              ; D0 = POSITION INDEX IN MATRIX
            MOVE.B  FIGROTA,D1              ; D1 = ROTATION INDEX
            
            MULU.W  #MUL3,D1                ; D1 = TETROMINOS MATRIX TO USE
            ADDQ.B  #8,D1                   ; D1 = TETROMINO LOWEST CELL
            ADD.B   #MCOLUMN*2+3,D0         ; D0 = LOWER RIGHT CELL
            
            ; CHECK IF THERE IS AN OBSTACLE TO THE RIGHT
  
            MOVE.W  #2,D2                   ; D2 = COL INDEX FOR TETROMINO
            MOVE.W  #2,D3                   ; D3 = ROW INDEX FOR TETROMINO
             
.LOOP2      BTST.B  #0,(A1,D1)              ; CHECK IF THE CELL IS FILLED
            BEQ     .SKIP2                  ; IF NOT SKIP
            BTST.B  #0,(A0,D0)              ; CHECK IF THE RIGHT CELL IS FILED
            BNE     .EXIT                   ; IF YES EXIT
            SUB.B   D2,D1                   ; IF NOT, CHECK LOWER CELL BY 1 ROW
            SUBQ.B  #1,D1                   
            SUB.B   #MCOLUMN,D0             ; D0 LOWERS BY 1 ROW
            ADDQ.B  #2,D0
            SUB.B   D2,D0
            BRA     .SKIP3                  ; SKIP TO SECOND LOOP
.SKIP2      SUBQ.B  #1,D0                   
            SUBQ.B  #1,D1                   ; CHECK LEFT CELL IN TETROMINO
            DBRA    D2,.LOOP2
.SKIP3      MOVE.W  #2,D2
            DBRA    D3,.LOOP2
            
            ; UPDATES MATRIX AND POSITION
            
            JSR     CLRTETROMINO            ; CLEAR CURRENT TETROMINO
            ADDQ.B  #1,FIGPOSI             ; UPDATES TETROMINO POSITION
            JSR     ADDTETROMINO            ; ADD NEW TETROMINO
             
.EXIT       MOVEM.L (A7)+,D0-D3/A0-A1           
            RTS
 
; -----------------------------------------------------------------------------
ROTATET
; IT DOES NOT REQUIRED TO ROTATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D4/A0-A1,-(A7)
            
            CLR.L   D0
            CLR.L   D1
            
            ; GETS THE TETROMINO VALUES AND PRERATES THEM FOR FIRST CHECK
            
            LEA.L   HROW4,A0                ; A0 = MATRIX STATING POINT
            MOVEA.L FIGTYPE,A1              ; A1 = TETROMINO STRUCTURE MATRIX
            MOVE.B  FIGPOSI,D0              ; D0 = POSITION INDEX TETROMINO 
            MOVE.B  FIGROTA,D1              ; D1 = CURRENT ROTATION TETROMINO
            
            ADDQ.B  #1,D1
            DIVU.W  #4,D1
            SWAP.W  D1
            ANDI.L  #$000000FF,D1           ; D1 = NEXT ROTATION FOR TETROMINO
            MOVE.B  D1,D2                   ; D2 = COPY OF D1
            
            MULU.W  #MUL3,D1                ; TETROMINO MATRIX TO USE
            
            ; CHECKS IF IN THE NEW ROTATION COLIDES WITH ANY OBJECT
            
            JSR     CLRTETROMINO            ; CLEARS CURRENT TETROMINO
          
            MOVE.W  #2,D3                   ; D3 = COL INDEX FOR TETROMINO
            MOVE.W  #2,D4                   ; D4 = ROW INDEX FOR TETROMINO
            
.LOOP       BTST.B  #0,(A1,D2)
            BEQ     .SKIP
            BTST.B  #0,(A0,D0)
            BEQ     .SKIP
            BRA     .EXIT
.SKIP       ADDQ.B  #1,D0
            ADDQ.B  #1,D1
            DBRA    D3,.LOOP            
            MOVE.W  #2,D3
            ADD.B   #MCOLUMN-3,D0           ; MOVE BY 1 ROW THE MATRIX POINTER
            DBRA    D4,.LOOP
            
            ; CHANGES TO NEW ROTATION
            
            MOVE.B  D2,FIGROTA
            
.EXIT       JSR     ADDTETROMINO

            MOVEM.L (A7)+,D0-D4/A0-A1            
            RTS

; -----------------------------------------------------------------------------
ADDTETROMINO
; INSERTS CURRENT TETROMINO INTO MATRIX
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D3/A0-A1,-(A7)
            
            CLR.L   D0
            CLR.L   D1
            
            LEA.L   HROW4,A0                ; A0 = MATRIX STATING POINT
            MOVEA.L FIGTYPE,A1              ; A1 = TETROMINO STRUCTURE MATRIX
            MOVE.B  FIGPOSI,D0              ; D0 = POSITION INDEX TETROMINO 
            MOVE.B  FIGROTA,D1              ; D1 = CURRENT ROTATION TETROMINO
            MOVE.W  #2,D2                   ; D2 = COL INDEX FOR TETROMINO
            MOVE.W  #2,D3                   ; D3 = ROW INDEX FOR TETROMINO
            
            MULU.W  #MUL3,D1
            
.LOOP3      BTST.B  #0,(A1,D1)
            BEQ     .SKIP4
            MOVE.B  (A1,D1),(A0,D0)
.SKIP4      ADDQ.B  #1,D1
            ADDQ.B  #1,D0
            DBRA    D2,.LOOP3
            ADD.B   #MCOLUMN-3,D0
            MOVE.W  #2,D2
            DBRA    D3,.LOOP3
             
            MOVEM.L (A7)+,D0-D3/A0-A1
            RTS

; -----------------------------------------------------------------------------
CLRTETROMINO
; CLEAR CURRENT TETROMINO FROM THE MATRIX
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D3/A0-A1,-(A7)
                                    
            CLR.L   D0
            CLR.L   D1
            
            LEA.L   HROW4,A0                ; A0 = MATRIX STATING POINT
            MOVEA.L FIGTYPE,A1                ; A1 = TETROMINO STRUCTURE MATRIX
            MOVE.B  FIGPOSI,D0              ; D0 = POSITION INDEX TETROMINO 
            MOVE.B  FIGROTA,D1              ; D1 = CURRENT ROTATION TETROMINO
            MOVE.W  #2,D2                   ; D2 = COL INDEX FOR TETROMINO
            MOVE.W  #2,D3                   ; D3 = ROW INDEX FOR TETROMINO
            
            MULU.W  #MUL3,D1
            
.LOOP2      BTST.B  #0,(A1,D1)
            BEQ     .SKIP3
            CLR.B   (A0,D0)
.SKIP3      ADDQ.B  #1,D1
            ADDQ.B  #1,D0
            DBRA    D2,.LOOP2
            ADD.B   #MCOLUMN-3,D0
            MOVE.W  #2,D2
            DBRA    D3,.LOOP2
            
            MOVEM.L (A7)+,D0-D3/A0-A1
            RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
