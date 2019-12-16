; =============================================================================
; TETROMINO
; =============================================================================

; -----------------------------------------------------------------------------
INITTETROMINO
; ADDS A NEW TETROMINO 3X3 IN THE HIDEN ZONE OF THE MATRIX
; INPUT    - NONE
; OUTPUT   - ALL TETROMINO VARIABLES
; MODIFIES - MATRIX
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D1/A0,-(A7)
            
            ; CLEAR VARIABLES
            
            CLR.B   TETROLDW                ; LIMIT DOWN
            CLR.B   TETROLRG                ; LIMIT RIGHT
            CLR.B   TETROLLF                ; LIMIT LEFT
            CLR.B   TETROROT                ; ROTATION
            CLR.L   D0
            CLR.L   D1
            
            ; UPDATE TETROMINO
            
            LEA.L   RANDLIST,A1
            LEA.L   TETROLNK,A0             ; A0 = NEXT TETROMINO ARRAY

            MOVE.B  TETRONXT,D0             ; D0 = NEXT TETROMINO
            MOVE.B  D0,TETROMUL
            MULU.W  #4,D0
            MOVE.L  (A0,D0),TETROACT        ; UPDATES TETROACT WITH NEXT
            
            ADDQ.B  #1,RANDOM
            CMP.B   #MAXRAND,RANDOM
            BNE     .SKIP
            CLR.B   RANDOM
.SKIP       CLR.L   D0
            MOVE.B  RANDOM,D0
            MOVE.B  (A1,D0),TETRONXT
                    
            ; SETS STARTING POINT FOR TETROMINO
            
            MOVE.B  #MCOLUMN-6,TETROPOS     ; STARTING POSITION
            
            ; ADDS THE NEW TETROMINO INTO MATRIX
            
            JSR     ADDTETROMINO            ; ADDS THE NEW TETROMINO
            
            MOVEM.L (A7)+,D0-D1/A0
            RTS

; -----------------------------------------------------------------------------
DOWNTETROMINO
; MOVES DOWN BY ONE ROW THE CURRENT TETROMINO IN THE MATRIX
; INPUT    - NONE
; OUTPUT   - TETROPOS, TETROLDW
; MODIFIES - MATRIX
; -----------------------------------------------------------------------------

            MOVEM.L D0-D4/A0-A2,-(A7)
            CLR.L   D0
            CLR.L   D1
            CLR.L   D4
            
            ; CLEAR TETROMINO FROM MATRIX
            
            JSR     CLRTETROMINO
            
            ; GETS THE TETROMINO AND MATRIX VALUES

            LEA.L   HMATRIX,A0              ; A0 = MATRIX STATING POINT
            MOVEA.L TETROACT,A1             ; A1 = TETROMINO STRUCTURE MATRIX
            LEA.L   MULS,A2                 ; A2 = MULTIPLIER LIST
.
            MOVE.B  TETROPOS,D0             ; D0 = POSITION INDEX TETROMINO
            MOVE.B  TETROROT,D1             ; D1 = ROTATION INDEX TETROMINO
            
            ADD.B   #MCOLUMN,D0             ; D0 = INDEX TETROMINO 1 ROW LOWER
            
            MOVE.B  TETROMUL,D4             
            MOVE.B  (A2,D4),D4              ; D4 = MATRIX SIDE
            MULU.W  D4,D1
            MULU.W  D4,D1                   ; D1 = TETROMINO MATRIX TO USE
            
            ; CHECKS IF THE TETROMINO CAN GO DOWN 1 ROW
            
            MOVE.W  D4,D2                   ; D2 = COL INDEX FOR TETROMINO
            SUBQ.W  #1,D2
            MOVE.W  D4,D3                   ; D3 = ROW INDEX FOR TETROMINO
            SUBQ.W  #1,D3
            
.LOOP       BTST.B  #0,(A1,D1)              ; CHECK IF TETROMINO MATRIX IS FILL
            BEQ     .SKIP                   ; IF FALSE SKIP
            BTST.B  #0,(A0,D0)              ; CHECK IF BELOW MATRIX IS FILLED
            BEQ     .SKIP                   ; IF FALSE SKIP
            MOVE.B  #1,TETROLDW             ; IF TRUE UPDATES LDOW AND EXITS
            BRA     .EXIT
.SKIP       ADDQ.B  #1,D1                   ; NEXT CELL FOR TETROMINO
            ADDQ.B  #1,D0                   ; NEXT CELL FOR MATRIX
            DBRA    D2,.LOOP
            ADD.B   #MCOLUMN,D0             
            SUB.B   D4,D0                   ; MOVE BY 1 ROW THE MATRIX POINTER                   
            MOVE.W  D4,D2                   
            SUBQ.W  #1,D2                   ; RESTART LOOP COUNTER D2
            DBRA    D3,.LOOP
            
            ; UPDATES MATRIX AND POSITION
            
            ADD.B   #MCOLUMN,TETROPOS       ; UPDATES TETROMINO POSITION
            
.EXIT       JSR     ADDTETROMINO            ; ADDS NEW TETROMINO
            MOVEM.L (A7)+,D0-D4/A0-A2           
            RTS

; -----------------------------------------------------------------------------
LEFTTETROMINO
; MOVES TO THE LEFT THE CURRENT TETROMINO
; INPUT    - NONE
; OUTPUT   - TETROPOS
; MODIFIES - MATRIX
; -----------------------------------------------------------------------------
          
            MOVEM.L D0-D6/A0-A2,-(A7)
            
            CLR.L   D0
            CLR.L   D1

            ; CLEAR TETROMINO FROM MATRIX

            JSR     CLRTETROMINO
            
            ; GETS THE TETROMINO VALUES AND PRERATES THEM FOR FIRST CHECK
            
            LEA.L   HMATRIX,A0              ; A0 = MATRIX STATING POINT
            MOVEA.L TETROACT,A1             ; A1 = TETROMINO STRUCTURE MATRIX   
            LEA.L   MULS,A2                 ; A2 = MULTIPLIER LIST
         
            MOVE.B  TETROPOS,D0             ; D0 = POSITION INDEX IN MATRIX
            MOVE.B  TETROROT,D1             ; D1 = ROTATION INDEX
            
            MOVE.B  TETROMUL,D4             
            MOVE.B  (A2,D4),D4              ; D4 = MATRIX SIDE
            
            MULU.W  D4,D1
            MULU.W  D4,D1                   ; D1 = TETROMINO MATRIX TO USE
            
            ; CHECKS IF THERE IS A WALL TO THE LEFT
            
            MOVE.W  D4,D2                   ; D2 = COL INDEX FOR TETROMINO
            SUBQ.W  #1,D2
            MOVE.W  D4,D3                   ; D3 = ROW INDEX FOR TETROMINO
            SUBQ.W  #1,D3
            
.LOOP1      BTST.B  #0,(A1,D1)              ; CHECKS IF THERE IS LEFT CONTENT
            BEQ     .SKIP1                  ; IF NOT SKIP
            DIVU.W  #MCOLUMN,D0             ; DIVIDE CURRENT POS WITH COLUMNS
            SWAP.W  D0                      ; GETS THE REMANIDER
            TST.W   D0                      ; CHECKS IF IT IS 0
            BEQ     .EXIT                   ; IF TRUE THEN EXIT
            BRA     .NEXT                   ; ELSE PROCEED NEXT VERIFICATION
.SKIP1      ADD.B   D4,D1                   ; MOVES TO NEXT ROW IN TETROMINO
            ADD.B   #MCOLUMN,D0             ; MOVES TO NEXT ROW IN MATRIX
            DBRA    D2,.LOOP1
            
            MOVE.W  D4,D5
            SUBQ.W  #1,D5
            MULU.W  D4,D5
            SUBQ.W  #1,D5
            SUB.B   D5,D1                   ; MOVES TO NEXT COLUMN IN TETROMINO
            
            MOVE.W  #MCOLUMN,D6
            MOVE.W  D4,D5
            SUBQ.W  #1,D5
            MULU.W  D5,D6
            SUBQ.W  #1,D6
            SUB.B   D6,D0                   ; MOVES TO NEXT COLUMN IN MATRIX
            
            
            MOVE.W  D4,D2 
            SUBQ.W  #1,D2
            DBRA    D3,.LOOP1                   
            
            ; GETS THE TETROMINO VALUES AND PRERATES THEM FOR FIRST CHECK
            
.NEXT       MOVE.B  TETROPOS,D0             ; D0 = POSITION INDEX IN MATRIX
            MOVE.B  TETROROT,D1             ; D1 = ROTATION INDEX
            
            MULU.W  D4,D1                   ; D1 = TETROMINOS MATRIX TO USE
            MULU.W  D4,D1
            
            SUBQ.B  #1,D0                   ; D0 = INDEX TETROMINO 1 COL LOWER
            
            ; CHECK IF THERE IS AN OBSTACLE TO THE LEFT
  
            MOVE.W  D4,D2                   ; D2 = COL INDEX FOR TETROMINO
            SUBQ.W  #1,D2
            MOVE.W  D4,D3                   ; D3 = ROW INDEX FOR TETROMINO
            SUBQ.W  #1,D3

.LOOP2      BTST.B  #0,(A1,D1)
            BEQ     .SKIP2
            BTST.B  #0,(A0,D0)
            BNE     .EXIT      
.SKIP2      ADDQ.B  #1,D1
            ADDQ.B  #1,D0
            DBRA    D2,.LOOP2
            ADD.B   #MCOLUMN,D0
            SUB.B   D4,D0
            MOVE.W  D4,D2
            SUBQ.W  #1,D2
            DBRA    D3,.LOOP2
            
            ; UPDATES MATRIX AND POSITION
            
            SUBQ.B  #1,TETROPOS             ; UPDATES TETROMINO POSITION
.EXIT       JSR     ADDTETROMINO            ; ADD NEW TETROMINO
             
            MOVEM.L (A7)+,D0-D6/A0-A2           
            RTS

            
; -----------------------------------------------------------------------------
RIGHTTETROMINO
; CHECKS IF CAN GO FUTHER DOWN
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
   
            MOVEM.L D0-D6/A0-A2,-(A7)
            CLR.L   D0
            CLR.L   D1

            ; GETS THE TETROMINO VALUES AND PRERATES THEM FOR FIRST CHECK
            
            LEA.L   HMATRIX,A0              ; A0 = MATRIX STATING POINT
            MOVEA.L TETROACT,A1             ; A1 = TETROMINO STRUCTURE MATRIX   
            LEA.L   MULS,A2
         
            MOVE.B  TETROPOS,D0             ; D0 = POSITION INDEX IN MATRIX
            MOVE.B  TETROROT,D1             ; D1 = ROTATION INDEX
            
            MOVE.B  TETROMUL,D4             ; D4 = MATRIX SIZE
            MOVE.B  (A2,D4),D4
            
            MULU.W  D4,D1
            MULU.W  D4,D1                   ; D1 = TETROMINOS MATRIX TO USE
            
            MOVE.B  D4,D5
            MULU.W  D4,D5                   
            SUBQ.B  #1,D5
            ADD.B   D5,D1                   ; D1 = TETROMINO LOWEST CELL
            
            MOVE.B  D4,D5
            SUBQ.B  #1,D5
            MULU.W  #MCOLUMN,D5
            ADD.B   D4,D5
            SUBQ.B  #1,D5
            ADD.B   D5,D0                   ; D0 = LOWER RIGHT CELL
            
            ; CHECKS IF THERE IS A WALL TO THE LEFT
            
            JSR     CLRTETROMINO            ; CLEAR CURRENT TETROMINO
          
            MOVE.W  D4,D2                   ; D2 = COL INDEX FOR TETROMINO
            SUBQ.W  #1,D2
            MOVE.W  D4,D3                   ; D3 = ROW INDEX FOR TETROMINO
            SUBQ.W  #1,D3
            
.LOOP1      BTST.B  #0,(A1,D1)              ; CHECKS IF THERE IS RIGHT CONTENT
            BEQ     .SKIP1                  ; IF NOT SKIP
            DIVU.W  #MCOLUMN,D0             ; DIVIDE CURRENT POS WITH COLUMNS
            SWAP.W  D0                      ; GETS THE REMANIDER
            CMP.W   #MCOLUMN-1,D0           ; CHECKS IF IT IS 0
            BEQ     .EXIT                   ; IF TRUE THEN EXIT
            BRA     .NEXT                   ; ELSE PROCEED NEXT VERIFICATION
.SKIP1      SUB.B  D4,D1                   ; MOVES TO NEXT ROW IN TETROMINO
            SUB.B   #MCOLUMN,D0             ; MOVES TO NEXT ROW IN MATRIX
            DBRA    D2,.LOOP1
            
            MOVE.W  D4,D5
            SUBQ.W  #1,D5
            MULU.W  D4,D5
            SUBQ.W  #1,D5
            ADD.B   D5,D1                   ; MOVES TO NEXT COLUMN IN TETROMINO
            
            MOVE.W  #MCOLUMN,D6
            MOVE.W  D4,D5
            SUBQ.W  #1,D5
            MULU.W  D5,D6
            SUBQ.W  #1,D6
            ADD.B   D6,D0                   ; MOVES TO NEXT COLUMN IN MATRIX

            MOVE.W  D4,D2                   ; D2 = COL INDEX FOR TETROMINO
            SUBQ.W  #1,D2

            DBRA    D3,.LOOP1                   
            
            ; GETS THE TETROMINO VALUES AND PRERATES THEM FOR FIRST CHECK
            
.NEXT       MOVE.B  TETROPOS,D0             ; D0 = POSITION INDEX IN MATRIX
            MOVE.B  TETROROT,D1             ; D1 = ROTATION INDEX
            
            MULU.W  D4,D1                   ; D1 = TETROMINOS MATRIX TO USE
            MULU.W  D4,D1
            
            ADDQ.B  #1,D0                   ; D0 = INDEX TETROMINO 1 COL LOWER
            
            ; CHECK IF THERE IS AN OBSTACLE TO THE LEFT
  
            MOVE.W  D4,D2                   ; D2 = COL INDEX FOR TETROMINO
            SUBQ.W  #1,D2
            MOVE.W  D4,D3                   ; D3 = ROW INDEX FOR TETROMINO
            SUBQ.W  #1,D3

.LOOP2      BTST.B  #0,(A1,D1)
            BEQ     .SKIP2
            BTST.B  #0,(A0,D0)
            BNE     .EXIT      
.SKIP2      ADDQ.B  #1,D1
            ADDQ.B  #1,D0
            DBRA    D2,.LOOP2
            ADD.B   #MCOLUMN,D0
            SUB.B   D4,D0
            MOVE.W  D4,D2
            SUBQ.W  #1,D2
            DBRA    D3,.LOOP2
            
            ; UPDATES MATRIX AND POSITION
            
            
            ADDQ.B  #1,TETROPOS             ; UPDATES TETROMINO POSITION
.EXIT       JSR     ADDTETROMINO            ; ADD NEW TETROMINO
             
            MOVEM.L (A7)+,D0-D6/A0-A2           
            RTS
 
; -----------------------------------------------------------------------------
ROTATETETROMINO
; IT DOES NOT REQUIRED TO ROTATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D7/A0-A2,-(A7)
            CLR.L   D0
            CLR.L   D1
            CLR.L   D4
            
            ; CLEAR TETROMINO FROM MATRIX
            
            JSR     CLRTETROMINO
            
            ; GETS THE TETROMINO VALUES AND PRERATES THEM FOR FIRST CHECK
            
            LEA.L   HMATRIX,A0              ; A0 = MATRIX STATING POINT
            MOVEA.L TETROACT,A1             ; A1 = TETROMINO STRUCTURE MATRIX
            LEA.L   MULS,A2
         
            MOVE.B  TETROPOS,D0             ; D0 = POSITION INDEX IN MATRIX
            MOVE.B  TETROROT,D1             ; D1 = ROTATION INDEX
            
            MOVE.B  TETROMUL,D4             ; D4 = MATRIX SIZE
            MOVE.B  (A2,D4),D4

            ADDQ.B  #1,D1
            DIVU.W  #4,D1
            SWAP.W  D1
            ANDI.L  #$000000FF,D1           ; D1 = NEXT ROTATION FOR TETROMINO
            MOVE.L  D1,D5                   ; D2 = COPY OF D1
            
            MULU.W  D4,D1
            MULU.W  D4,D1                   ; D1 = TETROMINOS MATRIX TO USE
           
            MOVE.W  D4,D6
            SUBQ.W  #2,D6
            MOVE.W  #MCOLUMN,D3
            SUB.W   D6,D3
            SUBQ.W  #1,D6
           
            ; CHECKS IF COLIDES WITH A WALL
            
            MOVE.W  D4,D2                   ; D2 = COL INDEX FOR TETROMINO
            SUBQ.W  #1,D2
            
.LOOP1      MOVE.L  D0,D7
            BTST.B  #0,(A1,D1)
            BEQ     .SKIP1
            DIVU.W  #MCOLUMN,D0
            SWAP.W  D0
            CMP.W   D3,D0
            BHS     .EXIT
            MOVE.L  D7,D0
.SKIP1      ADD.B   D4,D1
            SUBQ.B  #1,D1
            ADD.B   D4,D0
            SUBQ.B  #1,D0
            BTST.B  #0,(A1,D1)
            BEQ     .SKIP2
            DIVU.W  #MCOLUMN,D0
            SWAP.W  D0
            CMP.W   D6,D0
            BLS     .EXIT            
.SKIP2      MOVE.L  D7,D0
            ADDQ.B  #1,D1
            ADD.B   #MCOLUMN,D0
            DBRA    D2,.LOOP1
            
            ; GETS THE TETROMINO VALUES AND PRERATES THEM FOR FIRST CHECK
            
            MOVE.B  TETROPOS,D0             ; D0 = POSITION INDEX IN MATRIX
            MOVE.B  D5,D1                   ; D1 = ROTATION INDEX
            
            MULU.W  D4,D1
            MULU.W  D4,D1                   ; D1 = TETROMINOS MATRIX TO USE
            
            ; CHECKS IF IN THE NEW ROTATION COLIDES WITH ANY OBJECT
                      
            MOVE.W  D4,D2                   ; D2 = COL INDEX FOR TETROMINO
            SUBQ.W  #1,D2
            MOVE.W  D4,D3                   ; D3 = ROW INDEX FOR TETROMINO
            SUBQ.W  #1,D3
            
.LOOP2      BTST.B  #0,(A1,D1)
            BEQ     .SKIP3
            BTST.B  #0,(A0,D0)
            BNE     .EXIT
.SKIP3      ADDQ.B  #1,D0
            ADDQ.B  #1,D1
            DBRA    D2,.LOOP2
            ADD.B   #MCOLUMN,D0
            SUB.B   D4,D0
            MOVE.W  D4,D2
            SUBQ.W  #1,D2
            DBRA    D3,.LOOP2
            
            ; CHANGES TO NEW ROTATION
            
            MOVE.B  D5,TETROROT
            
.EXIT       JSR     ADDTETROMINO

            MOVEM.L (A7)+,D0-D7/A0-A2            
            RTS

; -----------------------------------------------------------------------------
ADDTETROMINO
; INSERTS CURRENT TETROMINO INTO MATRIX
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D4/A0-A2,-(A7)
            
            CLR.L   D0
            CLR.L   D1
            CLR.L   D4
            
            LEA.L   HMATRIX,A0              ; A0 = MATRIX STATING POINT
            MOVEA.L TETROACT,A1             ; A1 = TETROMINO STRUCTURE MATRIX
            MOVE.B  TETROPOS,D0             ; D0 = POSITION INDEX TETROMINO 
            MOVE.B  TETROROT,D1             ; D1 = CURRENT ROTATION TETROMINO
            
            LEA.L   MULS,A2
            MOVE.B  TETROMUL,D4             ; D4 = MATRIX SIZE
            MOVE.B  (A2,D4),D4
            
            MOVE.W  D4,D2                   ; D2 = COL INDEX FOR TETROMINO
            SUBQ.W  #1,D2
            MOVE.W  D4,D3                   ; D3 = ROW INDEX FOR TETROMINO
            SUBQ.W  #1,D3
            
            MULU.W  D4,D1
            MULU.W  D4,D1
            
.LOOP3      BTST.B  #0,(A1,D1)
            BEQ     .SKIP4
            MOVE.B  (A1,D1),(A0,D0)
.SKIP4      ADDQ.B  #1,D1
            ADDQ.B  #1,D0
            DBRA    D2,.LOOP3
            ADD.B   #MCOLUMN,D0
            SUB.B   D4,D0
            MOVE.W  D4,D2                   
            SUBQ.W  #1,D2
            DBRA    D3,.LOOP3
             
            MOVEM.L (A7)+,D0-D4/A0-A2
            RTS

; -----------------------------------------------------------------------------
CLRTETROMINO
; CLEAR CURRENT TETROMINO FROM THE MATRIX
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D4/A0-A2,-(A7)
            
            CLR.L   D0
            CLR.L   D1
            CLR.L   D4
            
            LEA.L   HMATRIX,A0              ; A0 = MATRIX STATING POINT
            MOVEA.L TETROACT,A1             ; A1 = TETROMINO STRUCTURE MATRIX
            MOVE.B  TETROPOS,D0             ; D0 = POSITION INDEX TETROMINO 
            MOVE.B  TETROROT,D1             ; D1 = CURRENT ROTATION TETROMINO
            
            LEA.L   MULS,A2
            MOVE.B  TETROMUL,D4             ; D4 = MATRIX SIZE
            MOVE.B  (A2,D4),D4
            
            MOVE.W  D4,D2                   ; D2 = COL INDEX FOR TETROMINO
            SUBQ.W  #1,D2
            MOVE.W  D4,D3                   ; D3 = ROW INDEX FOR TETROMINO
            SUBQ.W  #1,D3
            
            MULU.W  D4,D1
            MULU.W  D4,D1
            
.LOOP3      BTST.B  #0,(A1,D1)
            BEQ     .SKIP4
            CLR.B   (A0,D0)
.SKIP4      ADDQ.B  #1,D1
            ADDQ.B  #1,D0
            DBRA    D2,.LOOP3
            ADD.B   #MCOLUMN,D0
            SUB.B   D4,D0
            MOVE.W  D4,D2                   
            SUBQ.W  #1,D2
            DBRA    D3,.LOOP3
             
            MOVEM.L (A7)+,D0-D4/A0-A2
            RTS
            
            MOVEM.L (A7)+,D0-D3/A0-A1
            RTS

















*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
