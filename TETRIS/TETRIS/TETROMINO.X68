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
            
            MOVEM.L D0-D1/A0,-(A7)
            
            ; CLEAR VARIABLES
            
            CLR.B   TETROROT
            CLR.L   D0
            CLR.L   D1
            
            ; LIST POINTERS
            
            LEA.L   RANDLIST,A1
            LEA.L   TETROLNK,A0
            
            ; UPDATE TETROMINO AND NEXT

            MOVE.B  TETRONXT,D0
            MOVE.B  D0,TETROMUL
            MULU.W  #4,D0
            MOVE.L  (A0,D0),TETROACT
            
            ADDQ.B  #1,RANDOM
            CMP.B   #MAXRAND,RANDOM
            BNE     .SKIP
            CLR.B   RANDOM
.SKIP       CLR.L   D0
            MOVE.B  RANDOM,D0
            MOVE.B  (A1,D0),TETRONXT
                    
            ; SETS STARTING POINT FOR TETROMINO
            
            MOVE.B  #RESPAWN,TETROPOS
            
            ; ADDS THE NEW TETROMINO INTO MATRIX
            
            JSR     ADDTETROMINO 
            
            MOVEM.L (A7)+,D0-D1/A0
            RTS

; -----------------------------------------------------------------------------
DOWNTETROMINO
; MOVES THE CURRENT TETROMINO DOWN BY ONE ROW IN THE MATRIX
; INPUT    - NONE
; OUTPUT   - D0 = NOT ABLE TO MOVE DOWN
; MODIFIES - MATRIX,TETROPOS
; -----------------------------------------------------------------------------

            MOVEM.L D1-D4/A0-A2,-(A7)
            
            ; CLEAR REGISTERS AND TETROMINO FROM MATRIX
            
            JSR     CLRTETROMINO
            CLR.L   D0
            CLR.L   D1
            CLR.L   D4 
            
            ; LIST POINTERS

            LEA.L   HMATRIX,A0
            MOVEA.L TETROACT,A1
            LEA.L   MULS,A2
            
            ; TETROMINO INFORMATION
.
            MOVE.B  TETROPOS,D0
            MOVE.B  TETROROT,D1
            MOVE.B  TETROMUL,D4
            
            ; PROCESS THE INFORMATION FOR THE ACTION TO EXECUTE
            
            ADD.B   #MCOLUMN,D0          
            MOVE.B  (A2,D4),D4
            MULU.W  D4,D1
            MULU.W  D4,D1
            
            ; LOOP COUNTERS
            
            MOVE.W  D4,D2
            SUBQ.W  #1,D2
            MOVE.W  D4,D3
            SUBQ.W  #1,D3
            
            ; CHECK IF THE TETROMINO CAN GO DOWN BY ONE ROW
            
.LOOP       BTST.B  #0,(A1,D1)
            BEQ     .SKIP
            BTST.B  #0,(A0,D0)
            BEQ     .SKIP
            MOVE.B  #1,D0
            BRA     .EXIT
.SKIP       ADDQ.B  #1,D1
            ADDQ.B  #1,D0
            DBRA    D2,.LOOP
            ADD.B   #MCOLUMN,D0             
            SUB.B   D4,D0                   
            MOVE.W  D4,D2                   
            SUBQ.W  #1,D2
            DBRA    D3,.LOOP
            
            ; UPDATES MATRIX AND POSITION IF IT CAN
            
            ADD.B   #MCOLUMN,TETROPOS
            MOVE.B  #0,D0
.EXIT       JSR     ADDTETROMINO
            MOVEM.L (A7)+,D1-D4/A0-A2           
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
            JSR     CLRTETROMINO
            
            ; LIST POINTERS
            
            LEA.L   HMATRIX,A0
            MOVEA.L TETROACT,A1
            LEA.L   MULS,A2

            ; TETROMINO INFORMATION
         
            MOVE.B  TETROPOS,D0
            MOVE.B  TETROROT,D1            
            MOVE.B  TETROMUL,D4
             
            ; PROCESS THE INFORMATION FOR THE ACTION TO EXECUTE
            
            MOVE.B  (A2,D4),D4
            MULU.W  D4,D1
            MULU.W  D4,D1
            
            ; LOOP COUNTERS
            
            MOVE.W  D4,D2
            SUBQ.W  #1,D2
            MOVE.W  D4,D3
            SUBQ.W  #1,D3
            
            ; CHECK IF THERE IS A WALL TO THE LEFT
            
.LOOP1      BTST.B  #0,(A1,D1)
            BEQ     .SKIP1
            DIVU.W  #MCOLUMN,D0
            SWAP.W  D0
            TST.W   D0
            BNE     .NEXT
            MOVE.B  #1,D1
            BRA     .EXIT
.SKIP1      ADD.B   D4,D1
            ADD.B   #MCOLUMN,D0
            DBRA    D2,.LOOP1
            MOVE.W  D4,D5
            SUBQ.W  #1,D5
            MULU.W  D4,D5
            SUBQ.W  #1,D5
            SUB.B   D5,D1
            MOVE.W  #MCOLUMN,D6
            MOVE.W  D4,D5
            SUBQ.W  #1,D5
            MULU.W  D5,D6
            SUBQ.W  #1,D6
            SUB.B   D6,D0            
            MOVE.W  D4,D2 
            SUBQ.W  #1,D2
            DBRA    D3,.LOOP1                   
            
            ; TETROMINO INFORMATION
            
.NEXT       MOVE.B  TETROPOS,D0
            MOVE.B  TETROROT,D1
            
            ; PROCESS THE INFORMATION FOR THE ACTION TO EXECUTE
            
            MULU.W  D4,D1
            MULU.W  D4,D1
            SUBQ.B  #1,D0
            
            ; LOOP COUNTERS
  
            MOVE.W  D4,D2
            SUBQ.W  #1,D2
            MOVE.W  D4,D3
            SUBQ.W  #1,D3

            ; CHECK IF THERE IS A FILLED CELL TO THE LEFT

.LOOP2      BTST.B  #0,(A1,D1)
            BEQ     .SKIP2
            BTST.B  #0,(A0,D0)
            BEQ     .SKIP2
            MOVE.B  #1,D1
            BRA     .EXIT      
.SKIP2      ADDQ.B  #1,D1
            ADDQ.B  #1,D0
            DBRA    D2,.LOOP2
            ADD.B   #MCOLUMN,D0
            SUB.B   D4,D0
            MOVE.W  D4,D2
            SUBQ.W  #1,D2
            DBRA    D3,.LOOP2
            
            ; UPDATES MATRIX AND POSITION
            
            SUBQ.B  #1,TETROPOS
            MOVE.B  #0,D1
.EXIT       JSR     ADDTETROMINO
             
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
            JSR     CLRTETROMINO

            ; LIST POINTERS
            
            LEA.L   HMATRIX,A0
            MOVEA.L TETROACT,A1   
            LEA.L   MULS,A2
         
            ; TETROMINO INFORMATION
                     
            MOVE.B  TETROPOS,D0
            MOVE.B  TETROROT,D1
            MOVE.B  TETROMUL,D4
            
            ; PROCESS THE INFORMATION FOR THE ACTION TO EXECUTE
            
            MOVE.B  (A2,D4),D4
            MULU.W  D4,D1
            MULU.W  D4,D1
            MOVE.B  D4,D5
            MULU.W  D4,D5                   
            SUBQ.B  #1,D5
            ADD.B   D5,D1
            MOVE.B  D4,D5
            SUBQ.B  #1,D5
            MULU.W  #MCOLUMN,D5
            ADD.B   D4,D5
            SUBQ.B  #1,D5
            ADD.B   D5,D0
            
            ; LOOP COUNTER
          
            MOVE.W  D4,D2
            SUBQ.W  #1,D2
            MOVE.W  D4,D3
            SUBQ.W  #1,D3
            
            ; CHECK IF THERE IS A WALL TO THE RIGHT
            
.LOOP1      BTST.B  #0,(A1,D1)
            BEQ     .SKIP1
            DIVU.W  #MCOLUMN,D0
            SWAP.W  D0
            CMP.W   #MCOLUMN-1,D0
            BNE     .NEXT
            MOVE.B  #1,D2
            BRA     .EXIT
.SKIP1      SUB.B   D4,D1
            SUB.B   #MCOLUMN,D0
            DBRA    D2,.LOOP1
            MOVE.W  D4,D5
            SUBQ.W  #1,D5
            MULU.W  D4,D5
            SUBQ.W  #1,D5
            ADD.B   D5,D1 
            MOVE.W  #MCOLUMN,D6
            MOVE.W  D4,D5
            SUBQ.W  #1,D5
            MULU.W  D5,D6
            SUBQ.W  #1,D6
            ADD.B   D6,D0
            MOVE.W  D4,D2
            SUBQ.W  #1,D2
            DBRA    D3,.LOOP1                   
            
            ; TETROMINO INFORMATION
            
.NEXT       MOVE.B  TETROPOS,D0
            MOVE.B  TETROROT,D1
            
            ; PROCESS THE INFORMATION FOR THE ACTION TO EXECUTE

            MULU.W  D4,D1
            MULU.W  D4,D1
            ADDQ.B  #1,D0
            
            ; LOOP COUNTERS
  
            MOVE.W  D4,D2
            SUBQ.W  #1,D2
            MOVE.W  D4,D3
            SUBQ.W  #1,D3

.LOOP2      BTST.B  #0,(A1,D1)
            BEQ     .SKIP2
            BTST.B  #0,(A0,D0)
            BEQ     .SKIP2
            MOVE.B  #1,D2
            BRA     .EXIT      
.SKIP2      ADDQ.B  #1,D1
            ADDQ.B  #1,D0
            DBRA    D2,.LOOP2
            ADD.B   #MCOLUMN,D0
            SUB.B   D4,D0
            MOVE.W  D4,D2
            SUBQ.W  #1,D2
            DBRA    D3,.LOOP2
            
            ; UPDATES MATRIX AND POSITION
            
            ADDQ.B  #1,TETROPOS
            MOVE.B  #0,D2
.EXIT       JSR     ADDTETROMINO
             
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
            JSR     CLRTETROMINO
            
            ; LIST POINTERS
            
            LEA.L   HMATRIX,A0
            MOVEA.L TETROACT,A1
            LEA.L   MULS,A2
            
            ; TETROMINO INFORMATION
         
            MOVE.B  TETROPOS,D0
            MOVE.B  TETROROT,D1
            MOVE.B  TETROMUL,D4
            
            ; PROCESS THE INFORMATION FOR THE ACTION TO EXECUTE
            
            MOVE.B  (A2,D4),D4
            ADDQ.B  #1,D1
            DIVU.W  #4,D1
            SWAP.W  D1
            ANDI.L  #$000000FF,D1
            MOVE.L  D1,D5
            MULU.W  D4,D1
            MULU.W  D4,D1
            MOVE.W  D4,D6
            SUBQ.W  #2,D6
            MOVE.W  #MCOLUMN,D3
            SUB.W   D6,D3
            SUBQ.W  #1,D6
           
            ; LOOP COUNTER
            
            MOVE.W  D4,D2
            SUBQ.W  #1,D2
            
            ; CHECK IF COLIDES WITH A WALL AND CORRECTS IT BY MOVING IT
            
.LOOP1      MOVE.L  D0,D7
            BTST.B  #0,(A1,D1)
            BEQ     .SKIP1
            DIVU.W  #MCOLUMN,D0
            SWAP.W  D0
            CMP.W   D3,D0
            BHS     .EXIT
.SKIP1      MOVE.L  D7,D0
            ADD.B   D4,D1
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
            
            ; TETROMINO INFORMATION
            
            MOVE.B  TETROPOS,D0
            MOVE.B  D5,D1
            MULU.W  D4,D1
            MULU.W  D4,D1
            
            ; LOOP COUNTER
                      
            MOVE.W  D4,D2
            SUBQ.W  #1,D2
            MOVE.W  D4,D3
            SUBQ.W  #1,D3
            
            ; CHECK IF IT WILL COLIDE WITH A FILLED CELL
            
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
; MODIFIES - MATRIX
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D4/A0-A2,-(A7)
            
            ; CLEAR REGISTERS
            
            CLR.L   D0
            CLR.L   D1
            CLR.L   D4
            
            ; LIST POINTERS
            
            LEA.L   HMATRIX,A0
            MOVEA.L TETROACT,A1
            LEA.L   MULS,A2
            
            ; TETROMINO INFORMATION
            
            MOVE.B  TETROPOS,D0 
            MOVE.B  TETROROT,D1
            MOVE.B  TETROMUL,D4
            
            ; PROCESS THE INFORMATION FOR THE ACTION TO EXECUTE
            
            MOVE.B  (A2,D4),D4
            MULU.W  D4,D1
            MULU.W  D4,D1
            
            ; LOOP COUNTERS
            
            MOVE.W  D4,D2
            SUBQ.W  #1,D2
            MOVE.W  D4,D3
            SUBQ.W  #1,D3
            
            ; ADDS TETROMINO INTO THE MATRIX
            
.LOOP       BTST.B  #0,(A1,D1)
            BEQ     .SKIP
            MOVE.B  (A1,D1),(A0,D0)
.SKIP       ADDQ.B  #1,D1
            ADDQ.B  #1,D0
            DBRA    D2,.LOOP
            ADD.B   #MCOLUMN,D0
            SUB.B   D4,D0
            MOVE.W  D4,D2                   
            SUBQ.W  #1,D2
            DBRA    D3,.LOOP
             
            MOVEM.L (A7)+,D0-D4/A0-A2
            RTS

; -----------------------------------------------------------------------------
CLRTETROMINO
; CLEAR CURRENT TETROMINO FROM THE MATRIX
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - MATRIX
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D4/A0-A2,-(A7)
            
            ; CLEAR REGISTERS
            
            CLR.L   D0
            CLR.L   D1
            CLR.L   D4
            
            ; LIST POINTERS
            
            LEA.L   HMATRIX,A0
            MOVEA.L TETROACT,A1
            LEA.L   MULS,A2
            
            ; TETROMINO INFORMATION
            
            MOVE.B  TETROPOS,D0 
            MOVE.B  TETROROT,D1
            MOVE.B  TETROMUL,D4
            
            ; PROCESS THE INFORMATION FOR THE ACTION TO EXECUTE
            
            MOVE.B  (A2,D4),D4
            MULU.W  D4,D1
            MULU.W  D4,D1
            
            ; LOOP COUNTERS
            
            MOVE.W  D4,D2
            SUBQ.W  #1,D2
            MOVE.W  D4,D3
            SUBQ.W  #1,D3
            
            ; CLEARS TETROMINO INTO THE MATRIX
            
.LOOP       BTST.B  #0,(A1,D1)
            BEQ     .SKIP
            CLR.B   (A0,D0)
.SKIP       ADDQ.B  #1,D1
            ADDQ.B  #1,D0
            DBRA    D2,.LOOP
            ADD.B   #MCOLUMN,D0
            SUB.B   D4,D0
            MOVE.W  D4,D2                   
            SUBQ.W  #1,D2
            DBRA    D3,.LOOP
             
            MOVEM.L (A7)+,D0-D4/A0-A2
            RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
