; =============================================================================
; TETROMINO
; =============================================================================

; -----------------------------------------------------------------------------
INITTETROMINO
; ADDS A NEW TETROMINO IN THE HIDEN ZONE OF THE MATRIX
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - MATRIX,TETROLDW,TETROLRG,TETROROT,TETROMUL,TETROACT,RANDOM,
;            TETRONXT,TETROPOS
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D1/D5/A0,-(A7)
            
            ; CLEAR VARIABLES
            
            CLR.B   TETROROT
            CLR.L   D0
            CLR.L   D1
            
            ; LIST POINTERS
            
            LEA.L   TETROLNK,A0             ; A0 = TETROMINOS LIST
            LEA.L   RANDLIST,A1             ; A1 = RANDOM NUMBERS LIST
            
            ; UPDATE TETROMINO AND NEXT

            MOVE.B  TETRONXT,D0             ; D0 = NEXT TETROMINO INDEX
            MOVE.B  D0,TETROMUL             ; D0 = TETROMINO MULTIPLIER
            LSL.W   #2,D0                   ; D0 = TETROMINO MATRIX SIZE
            MOVE.L  (A0,D0),TETROACT        ; TETROACT = TETROMINO TO USE
            
            ADDQ.B  #1,RANDOM               ; NEXT VALUE FROM RANDOM
            CMP.B   #MAXRAND,RANDOM         ; CHECK IF RANDOM IS OUT OF LIST
            BNE     .SKIP                   ; IF NOT SKIP
            CLR.B   RANDOM                  ; IF TRUE CLEAR RANDOM
.SKIP       CLR.L   D0
            MOVE.B  RANDOM,D0               ; D0 = RANDOM INDEX
            MOVE.B  (A1,D0),TETRONXT        ; TETRONEXT = RANDOM NUMBER (0-6)
                    
            ; SETS STARTING POINT FOR TETROMINO
            
            MOVE.B  #RESPAWN,TETROPOS       ; SETS SPAWN POINT FOR TETROMINO
            
            ; ADDS THE NEW TETROMINO INTO MATRIX
            
            MOVE.B  #1,D5
            JSR     ADDCLRTETROMINO         ; ADDS TETROMINO TO THE MATRIX
            
            MOVEM.L (A7)+,D0-D1/D5/A0
            RTS

; -----------------------------------------------------------------------------
DOWNTETROMINO
; MOVES THE CURRENT TETROMINO DOWN BY ONE ROW IN THE MATRIX
; INPUT    - NONE
; OUTPUT   - D0 = NOT ABLE TO MOVE DOWN
; MODIFIES - MATRIX,TETROPOS
; -----------------------------------------------------------------------------

            MOVEM.L D1-D5/A0-A2,-(A7)
            
            ; CLEAR REGISTERS AND TETROMINO FROM MATRIX
            

            CLR.L   D0
            CLR.L   D1
            CLR.L   D4
            CLR.B   D5 
            JSR     ADDCLRTETROMINO
            
            ; LIST POINTERS

            LEA.L   HMATRIX,A0              ; A0 = HIDEN MATRIX POINTER
            MOVEA.L TETROACT,A1             ; A1 = CURRENT TETROMINO POINTER
            LEA.L   MULS,A2                 ; A2 = TETROMINOS MULTIPLIER LIST
            
            ; TETROMINO INFORMATION

            MOVE.B  TETROPOS,D0             ; D0 = TETROMINO CURRENT POSITION
            MOVE.B  TETROROT,D1             ; D1 = TETROMINO CURRENT ROTATION
            MOVE.B  TETROMUL,D4             ; D4 = TETROMINO MULTIPLIER INDEX
            
            ; PROCESS THE INFORMATION FOR THE ACTION TO EXECUTE
            
            ADD.B   #MCOLUMN,D0             ; D0 = NEXT TETROMINO POSITION
            MOVE.B  (A2,D4),D4              ; D4 = TETROMINO MULTIPLIER
            MULU.W  D4,D1
            MULU.W  D4,D1                   ; D1 = TETROMINO MATRIX TO USE
            
            ; LOOP COUNTERS
            
            MOVE.W  D4,D2
            SUBQ.W  #1,D2                   ; D2 = COLUMN LOOP COUNTER
            MOVE.W  D4,D3
            SUBQ.W  #1,D3                   ; D3 = ROW LOOP COUNTER
            
            ; CHECK IF THE TETROMINO CAN GO DOWN BY ONE ROW
            
.LOOP       BTST.B  #0,(A1,D1)              ; CHECK SQUARE IN TETROMINO
            BEQ     .SKIP                   ; IF IS NOT FULL THEN SKIP
            BTST.B  #0,(A0,D0)              ; CHECK SQAURE IN MATRIX
            BEQ     .SKIP                   ; IF IS NOT FULL THEN SKIP
            MOVE.B  #1,D0                   ; IF IS FULL D0 = 1
            BRA     .EXIT                   ; EXIT
.SKIP       ADDQ.B  #1,D1                   ; NEXT SQUARE IN TETROMINO
            ADDQ.B  #1,D0                   ; NEXT SQUARE IN MATRIX
            DBRA    D2,.LOOP                ; CHECK NEXT SQUARE
            ADD.B   #MCOLUMN,D0
            SUB.B   D4,D0                   ; D0 = NEXT ROW IN MATRIX             
            MOVE.W  D4,D2                   
            SUBQ.W  #1,D2                   ; D2 = COLUMN LOOP COUNTER
            DBRA    D3,.LOOP                ; CHECK NEXT ROW
            
            ; UPDATES MATRIX AND POSITION IF IT CAN
            
            ADD.B   #MCOLUMN,TETROPOS       ; ADD ONE ROW TO TETROMINO POSITION
            MOVE.B  #0,D0                   ; IF HAS BEEN ABLE TO MOVE D0 = 0
.EXIT       MOVE.B  #1,D5
            JSR     ADDCLRTETROMINO         ; ADD TETROMINO

            MOVEM.L (A7)+,D1-D5/A0-A2           
            RTS

; -----------------------------------------------------------------------------
LEFTTETROMINO
; MOVES THE CURRENT TETROMINO TO THE LEFT
; INPUT    - NONE
; OUTPUT   - D1 = LIMIT TO THE LEFT
; MODIFIES - MATRIX,TETROPOS
; -----------------------------------------------------------------------------
          
            MOVEM.L D0/D2-D6/A0-A2,-(A7)
            
            ; CLEAR REGISTERS AND TETROMINO FORM MATRIX

            CLR.L   D0
            CLR.L   D1
            CLR.L   D4
            CLR.B   D5
            JSR     ADDCLRTETROMINO
            
            ; LIST POINTERS
            
            LEA.L   HMATRIX,A0              ; A0 = HIDEN MATRIX POINTER
            MOVEA.L TETROACT,A1             ; A1 = CURRENT TETROMINO POINTER
            LEA.L   MULS,A2                 ; A2 = MULTIPLIER LIST

            ; TETROMINO INFORMATION
         
            MOVE.B  TETROPOS,D0             ; D0 = TETROMINO CURRENT POSITION
            MOVE.B  TETROROT,D1             ; D1 = TETROMINO CURRENT ROTATION
            MOVE.B  TETROMUL,D4             ; D4 = TETROMINO MULTIPLIER INDEX
             
            ; PROCESS THE INFORMATION FOR THE ACTION TO EXECUTE
            
            MOVE.B  (A2,D4),D4              ; D4 = TETROMINO MULTIPLIER
            MULU.W  D4,D1
            MULU.W  D4,D1                   ; D1 = TETROMINO MATRIX TO USE
            
            ; LOOP COUNTERS
            
            MOVE.W  D4,D2
            SUBQ.W  #1,D2                   ; D2 = ROW LOOP COUNTER
            MOVE.W  D4,D3
            SUBQ.W  #1,D3                   ; D3 = COLUMN LOOP COUNTER
            
            ; CHECK IF THERE IS A WALL TO THE LEFT
            
.LOOP1      BTST.B  #0,(A1,D1)              ; CHECK IF SQUARE IS FILLED
            BEQ     .SKIP1                  ; IF NOT SKIP
            DIVU.W  #MCOLUMN,D0             ; DIVIDE D0 BY COLUMN
            SWAP.W  D0                      ; GETS THE REMAINDER
            TST.W   D0                      ; CHECKS IF IT IS 0
            BNE     .NEXT                   ; IF NOT NEXT
            MOVE.B  #1,D1                   ; D1 = 1 IF THERE IS A WALL
            BRA     .EXIT                   ; EXIT
.SKIP1      ADD.B   D4,D1                   ; NEXT ROW IN TETROMINO MATRIX
            ADD.B   #MCOLUMN,D0             ; NEXT ROW IN MATRIX
            DBRA    D2,.LOOP1               ; CHECK NEXT ROW
            MOVE.W  D4,D5
            SUBQ.W  #1,D5
            MULU.W  D4,D5
            SUBQ.W  #1,D5                   ; D5 = VALUE TO THE NEXT COLUMN
            SUB.B   D5,D1                   ; D1 = NEXT TETROMINO COLUMN
            MOVE.W  #MCOLUMN,D6
            MOVE.W  D4,D5
            SUBQ.W  #1,D5
            MULU.W  D5,D6
            SUBQ.W  #1,D6                   ; D6 = VALUE TO NEXT COLUMN
            SUB.B   D6,D0                   ; D0 = NEXT MATRIX COLUMN TO CHECK
            MOVE.W  D4,D2
            SUBQ.W  #1,D2                   ; D2 = ROW LOOP COUNTER
            DBRA    D3,.LOOP1               ; NEXT COLUMN TO CHECK   
            
            ; TETROMINO INFORMATION
            
.NEXT       MOVE.B  TETROPOS,D0             ; D0 = TETROMINO CURRENT POSITION
            MOVE.B  TETROROT,D1             ; D1 = TETROMINO CURRENT ROTATION
            
            ; PROCESS THE INFORMATION FOR THE ACTION TO EXECUTE
            
            MULU.W  D4,D1
            MULU.W  D4,D1                   ; D1 = TETROMINO MATRIX TO USE
            SUBQ.B  #1,D0                   ; D0 = NEXT TETROMINO POSITION
            
            ; LOOP COUNTERS
  
            MOVE.W  D4,D2
            SUBQ.W  #1,D2                   ; D2 = COLUMN LOOP COUNTER
            MOVE.W  D4,D3
            SUBQ.W  #1,D3                   ; D3 = ROW LOOP COUNTER

            ; CHECK IF THERE IS A FILLED CELL TO THE LEFT

.LOOP2      BTST.B  #0,(A1,D1)              ; CHECK TETROMINO SQUARE
            BEQ     .SKIP2                  ; IF NOT FILLED SKIP
            BTST.B  #0,(A0,D0)              ; CHECK MATRIX SQUARE
            BEQ     .SKIP2                  ; IF NOT FILLED SKIP
            MOVE.B  #1,D1                   ; IF FILLED THEN D1 = 1
            BRA     .EXIT                   ; EXIT
.SKIP2      ADDQ.B  #1,D1                   ; NEXT TETROMINO SQUARE TO CHECK
            ADDQ.B  #1,D0                   ; NEXT MATRIX SQUARE TO CHECK
            DBRA    D2,.LOOP2               ; CHECK NEXT COLUMN
            ADD.B   #MCOLUMN,D0
            SUB.B   D4,D0                   ; D0 = MATRIX NEXT ROW
            MOVE.W  D4,D2
            SUBQ.W  #1,D2                   ; D2 = COLUMN LOOP COUNTER
            DBRA    D3,.LOOP2               ; CHECK NEXT ROW
            
            ; UPDATES MATRIX AND POSITION
            
            SUBQ.B  #1,TETROPOS             ; UPDATES TETROMINO POSITION
            MOVE.B  #0,D1                   ; D1 = 0 IF IT WAS POSIBLE TO MOVE
.EXIT       MOVE.B  #1,D5
            JSR     ADDCLRTETROMINO         ; ADDS TETROMINO TO THE MATRIX
             
            MOVEM.L (A7)+,D0/D2-D6/A0-A2           
            RTS

            
; -----------------------------------------------------------------------------
RIGHTTETROMINO
; MOVES THE CURRENT TETROMINO TO THE RIGHT
; INPUT    - NONE
; OUTPUT   - D2.B = LIMIT TO THE RIGHT
; MODIFIES - MATRIX,TETROPOS
; -----------------------------------------------------------------------------
   
            MOVEM.L D0-D1/D3-D6/A0-A2,-(A7)
            
            ; CLEAR REGISTERS AND TETROMINO FROM MATRIX
            
            CLR.L   D0
            CLR.L   D1
            CLR.L   D4
            CLR.B   D5
            JSR     ADDCLRTETROMINO

            ; LIST POINTERS
            
            LEA.L   HMATRIX,A0              ; A0 = HIDEN MATRIX POINTER
            MOVEA.L TETROACT,A1             ; A1 = CURRENT TETROMINO POINTER
            LEA.L   MULS,A2                 ; A2 = MULTIPLIER LIST

            ; TETROMINO INFORMATION
         
            MOVE.B  TETROPOS,D0             ; D0 = TETROMINO CURRENT POSITION
            MOVE.B  TETROROT,D1             ; D1 = TETROMINO CURRENT ROTATION
            MOVE.B  TETROMUL,D4             ; D4 = TETROMINO MULTIPLIER INDEX
            
            ; PROCESS THE INFORMATION FOR THE ACTION TO EXECUTE
            
            MOVE.B  (A2,D4),D4              ; D4 = TETROMINO MULTIPLIER
            MULU.W  D4,D1
            MULU.W  D4,D1                   ; D1 = TETROMINO CURRENT MATRIX
            MOVE.B  D4,D5
            MULU.W  D4,D5                   
            SUBQ.B  #1,D5                   ; D5 =  LAST SQUARE IN TETROMINO
            ADD.B   D5,D1                   ; D1 =  LAST SQUARE POINTER
            MOVE.B  D4,D5
            SUBQ.B  #1,D5
            MULU.W  #MCOLUMN,D5
            ADD.B   D4,D5
            SUBQ.B  #1,D5                   ; D5 = LAST SQUARE IN MATRIX
            ADD.B   D5,D0                   ; D0 = LAST SQUARE POINTER
            
            ; LOOP COUNTER
          
            MOVE.W  D4,D2
            SUBQ.W  #1,D2                   ; D2 = ROW LOOP COUNTER
            MOVE.W  D4,D3
            SUBQ.W  #1,D3                   ; D3 = COLUMN LOOP COUNTER
            
            ; CHECK IF THERE IS A WALL TO THE RIGHT
            
.LOOP1      BTST.B  #0,(A1,D1)              ; CHECK IF SQUARE IS FILLED
            BEQ     .SKIP1                  ; IF NOT SKIP
            DIVU.W  #MCOLUMN,D0             ; DIVIDE D0 BY COLUMN
            SWAP.W  D0                      ; GETS THE REMAINDER
            CMP.W   #MCOLUMN-1,D0           ; CHECK IF IS NOT THE LAST SQUARE
            BNE     .NEXT                   ; IF NOT NEXT
            MOVE.B  #1,D2                   ; D2 = 1 IF THERE IS A WALL
            BRA     .EXIT                   ; EXIT
.SKIP1      SUB.B   D4,D1                   ; TETROMINO NEXT ROW TO CHECK
            SUB.B   #MCOLUMN,D0             ; MATRIX NEXT ROW TO CHECK
            DBRA    D2,.LOOP1               ; CHECK NEXT ROW
            MOVE.W  D4,D5
            SUBQ.W  #1,D5
            MULU.W  D4,D5
            SUBQ.W  #1,D5                   ; D5 = VALUE TO THE NEXT COLUMN
            ADD.B   D5,D1                   ; D1 = NEXT TETROMINO COLUMN
            MOVE.W  #MCOLUMN,D6
            MOVE.W  D4,D5
            SUBQ.W  #1,D5
            MULU.W  D5,D6
            SUBQ.W  #1,D6                   ; D6 = VALUE TO THE NEXT COLUMN
            ADD.B   D6,D0                   ; D0 = NEXT MATRIX COLUMN
            MOVE.W  D4,D2
            SUBQ.W  #1,D2                   ; D2 = ROW LOOP COUNTER
            DBRA    D3,.LOOP1               ; CHECK NEXT COLUMN
            
            ; TETROMINO INFORMATION
            
.NEXT       MOVE.B  TETROPOS,D0             ; D0 = TETROMINO CURRENT POSITION
            MOVE.B  TETROROT,D1             ; D1 = TETROMINO CURRENT ROTATION
            
            ; PROCESS THE INFORMATION FOR THE ACTION TO EXECUTE

            MULU.W  D4,D1
            MULU.W  D4,D1                   ; D1 = TETROMINO CURRENT MATRIX
            ADDQ.B  #1,D0                   ; D0 = NEXT TETROMINO POSITION
            
            ; LOOP COUNTERS
  
            MOVE.W  D4,D2
            SUBQ.W  #1,D2                   ; D2 = COLUMN LOOP COUNTER
            MOVE.W  D4,D3
            SUBQ.W  #1,D3                   ; D3 = ROW LOOP COUNTER
            
.LOOP2      BTST.B  #0,(A1,D1)              ; CHECK TETROMINO SQUARE
            BEQ     .SKIP2                  ; IF NOT FILLED SKIP
            BTST.B  #0,(A0,D0)              ; CHECK MATRIX SQUARE
            BEQ     .SKIP2                  ; IF NOT FILLED SKIP
            MOVE.B  #1,D2                   ; IF FILLED THEN D2 = 1
            BRA     .EXIT                   ; EXIT
.SKIP2      ADDQ.B  #1,D1                   ; NEXT TETROMINO SQUARE TO CHECK
            ADDQ.B  #1,D0                   ; NEXT MATRIX SQUARE TO CHECK
            DBRA    D2,.LOOP2               ; CHECK NEXT COLUMN
            ADD.B   #MCOLUMN,D0
            SUB.B   D4,D0                   ; D0 = MATRIX NEXT ROW
            MOVE.W  D4,D2
            SUBQ.W  #1,D2                   ; D2 = COLUMN LOOP COUNTER
            DBRA    D3,.LOOP2               ; CHECK NEXT ROW
            
            ; UPDATES MATRIX AND POSITION
            
            ADDQ.B  #1,TETROPOS             ; UPDATES TETROMINO POSITION
            MOVE.B  #0,D2                   ; D2 = 0 IF IT WAS POSIBLE TO MOVE
.EXIT       MOVE.B  #1,D5
            JSR     ADDCLRTETROMINO         ; ADD TETROMINO TO MATRIX
             
            MOVEM.L (A7)+,D0-D1/D3-D6/A0-A2           
            RTS
 
; -----------------------------------------------------------------------------
ROTATETETROMINO
; IT DOES NOT REQUIRED TO ROTATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - MATRIX,TETROPOS
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D7/A0-A2,-(A7)
            
            ; CLEAR REGISTERS AND TETROMINO FROM MATRIX
            
            CLR.L   D0
            CLR.L   D1
            CLR.L   D4
            CLR.B   D5
            JSR     ADDCLRTETROMINO
            
            ; LIST POINTERS
            
            LEA.L   HMATRIX,A0              ; A0 = HIDEN MATRIX POINTER
            MOVEA.L TETROACT,A1             ; A1 = CURRENT TETROMINO POINTER
            LEA.L   MULS,A2                 ; A2 = MULTIPLIER LIST

            ; TETROMINO INFORMATION
         
            MOVE.B  TETROPOS,D0             ; D0 = TETROMINO CURRENT POSITION
            MOVE.B  TETROROT,D1             ; D1 = TETROMINO CURRENT ROTATION
            MOVE.B  TETROMUL,D4             ; D4 = TETROMINO MULTIPLIER INDEX
            
            ; PROCESS THE INFORMATION FOR THE ACTION TO EXECUTE
            
            MOVE.B  (A2,D4),D4              ; D4 = TETROMINO MULTIPLIER
            ADDQ.B  #1,D1                   ; D1 = NEXT ROTATION
            ANDI.W  #$0003,D1               ; ENSURE D1 INSIDE TETROMINO MATRIX
            MOVE.L  D1,D5
            MULU.W  D4,D1
            MULU.W  D4,D1                   ; D1 = NEXT TETROMINO MATRIX
            MOVE.W  D4,D6
            SUBQ.W  #2,D6
            MOVE.W  #MCOLUMN,D3
            SUB.W   D6,D3                   ; D3 = LEFT WALL LIMIT
            SUBQ.W  #1,D6                   ; D6 = RIGHT WALL LIMIT
           
            ; LOOP COUNTER
            
            MOVE.W  D4,D2
            SUBQ.W  #1,D2                   ; D2 = ROW LOOP COUNTER
            
            ; CHECK IF COLIDES WITH A WALL AND CORRECTS IT BY MOVING IT
            
.LOOP1      MOVE.L  D0,D7
            BTST.B  #0,(A1,D1)              ; CHECK IF TETROMINO SQUARE IS FILL
            BEQ     .SKIP1                  ; IF NOT SKIP
            DIVU.W  #MCOLUMN,D0             ; DIVIDE D0 BY COLUMN
            SWAP.W  D0                      ; GET THE REMAINDER
            CMP.W   D3,D0                   ; CHECK IF IS WALL TO THE LEFT
            BHS     .EXIT                   ; IF TRUE THEN EXIT
.SKIP1      MOVE.L  D7,D0                   ; RESTORES D0
            ADD.B   D4,D1
            SUBQ.B  #1,D1                   ; D1 = LAST COLUMN IN TETROMINO
            ADD.B   D4,D0
            SUBQ.B  #1,D0                   ; D0 = LAST COLUMN IN MATRIX
            BTST.B  #0,(A1,D1)              ; CHECK IF IS FILLED
            BEQ     .SKIP2                  ; IF NOT THEN SKIP
            DIVU.W  #MCOLUMN,D0             ; DIVIDE D0 BY COLUMN
            SWAP.W  D0                      ; GET THE REMAINDER
            CMP.W   D6,D0                   ; CHECK IF IS WALL TO THE RIGHT
            BLS     .EXIT                   ; IF TRUE EXIT
.SKIP2      MOVE.L  D7,D0                   ; RESTORES D0
            ADDQ.B  #1,D1                   ; D1 = NEXT TETROMINO ROW TO CHECK
            ADD.B   #MCOLUMN,D0             ; D0 = NEXT MATRIX ROW TO CHECK
            DBRA    D2,.LOOP1               ; CHECK NEXT ROW
            
            ; TETROMINO INFORMATION
            
            MOVE.B  TETROPOS,D0             ; D0 = TETROMINO CURRENT POSITION
            MOVE.B  D5,D1                   ; D1 = NEXT TETROMINO ROTATION
            MULU.W  D4,D1
            MULU.W  D4,D1                   ; D1 = NEXT TETROMINO MATRIX
            
            ; LOOP COUNTER
                      
            MOVE.W  D4,D2
            SUBQ.W  #1,D2                   ; D2 = COLUMN LOOP COUNTER
            MOVE.W  D4,D3
            SUBQ.W  #1,D3                   ; D3 = ROW LOOP COUNTER
            
            ; CHECK IF IT WILL COLIDE WITH A FILLED CELL
            
.LOOP2      BTST.B  #0,(A1,D1)              ; CHECK IF IS FILLED
            BEQ     .SKIP3                  ; IF NOT THEN SKIP
            BTST.B  #0,(A0,D0)              ; CHECK IF IS FILLED IN MATRIX
            BNE     .EXIT                   ; IF TRUE THEN EXIT
.SKIP3      ADDQ.B  #1,D0                   ; D0 = NEXT SQUARE TO CHECK
            ADDQ.B  #1,D1                   ; D1 = NEXT COLUMN TO CHECK
            DBRA    D2,.LOOP2               ; CHECK NEXT SQUARE
            ADD.B   #MCOLUMN,D0             ; D0 = NEXT MATRIX ROW
            SUB.B   D4,D0                   ; D0 = NEXT MATRIX ROW                 
            MOVE.W  D4,D2
            SUBQ.W  #1,D2                   ; D2 = COLUMN LOOP COUNTER
            DBRA    D3,.LOOP2               ; CHECK NEXT ROW
            
            ; CHANGES TO NEW ROTATION
            
            MOVE.B  D5,TETROROT             ; UPDATES TETROMINO ROTATION
.EXIT       MOVE.B  #1,D5
            JSR     ADDCLRTETROMINO         ; ADDS TETROMINO TO THE MATRIX

            MOVEM.L (A7)+,D0-D7/A0-A2            
            RTS

; -----------------------------------------------------------------------------
ADDCLRTETROMINO
; INSERTS CURRENT TETROMINO OR CLEAR IT FROM MATRIX
; INPUT    - D5.B = CLEAR OR ADD (0/1)
; OUTPUT   - NONE
; MODIFIES - MATRIX
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D5/A0-A2,-(A7)
            
            ; CLEAR REGISTERS
            
            CLR.L   D0
            CLR.L   D1
            CLR.L   D4
            
            ; LIST POINTERS
            
            LEA.L   HMATRIX,A0              ; A0 = HIDEN MATRIX POINTER
            MOVEA.L TETROACT,A1             ; A1 = CURRENT TETROMINO POINTER
            LEA.L   MULS,A2                 ; A2 = MULTIPLIER LIST

            ; TETROMINO INFORMATION
         
            MOVE.B  TETROPOS,D0             ; D0 = TETROMINO CURRENT POSITION
            MOVE.B  TETROROT,D1             ; D1 = TETROMINO CURRENT ROTATION
            MOVE.B  TETROMUL,D4             ; D4 = TETROMINO MULTIPLIER INDEX
            
            ; PROCESS THE INFORMATION FOR THE ACTION TO EXECUTE
            
            MOVE.B  (A2,D4),D4              ;D4 = TETROMINO MULTIPLIER
            MULU.W  D4,D1
            MULU.W  D4,D1                   ; D1 = NEXT TETROMINO MATRIX
            
            ; LOOP COUNTERS
            
            MOVE.W  D4,D2
            SUBQ.W  #1,D2                   ; D2 = COLUMN LOOP COUNTER
            MOVE.W  D4,D3
            SUBQ.W  #1,D3                   ; D3 = ROW LOOP COUNTER
            
            ; ADDS TETROMINO INTO THE MATRIX
            
.LOOP       BTST.B  #0,(A1,D1)              ; CHECK IF SQUARE IS FILLED
            BEQ     .SKIP                   ; FALSE THEN SKIP
            BTST.L  #0,D5                   ; CHECKS D5 VALUE
            BEQ     .CLEAR                  ; IF D5 = 0 THEN CLEAR
            MOVE.B  (A1,D1),(A0,D0)         ; MOVE TETROMINO SQUARE IN MATRIX
            BRA     .SKIP                   ; SKIP
.CLEAR      CLR.B   (A0,D0)                 ; CLEAR TETROMINO SQUARE IN MATRIX
.SKIP       ADDQ.B  #1,D1                   ; D1 = NEXT TETROMINO SQUARE
            ADDQ.B  #1,D0                   ; D0 = NEXT MATRIX SQUARE
            DBRA    D2,.LOOP                ; CHECK NEXT SQUARE
            ADD.B   #MCOLUMN,D0             
            SUB.B   D4,D0                   ; D0 = NEXT MATRIX ROW
            MOVE.W  D4,D2                   
            SUBQ.W  #1,D2                   ; D2 = COLUMN COUNTER LOOP
            DBRA    D3,.LOOP                ; CHECK NEXT ROW
             
            MOVEM.L (A7)+,D0-D5/A0-A2
            RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
