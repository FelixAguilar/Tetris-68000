; =============================================================================
; TETROMINO T
; =============================================================================

; -----------------------------------------------------------------------------
INITT
; ADDS A NEW T IN THE HIDEN ZONE OF THE MATRIX
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - MATRIX
; -----------------------------------------------------------------------------
            
            MOVEM.L DO-D2/A0-A1,-(A7)
            
            ; SETS VALUES FOR THE NEW FIGURE
            
            MOVE.B  #1,FIGROTA
            MOVE.B  #4+MCOLUMN*2,FIGPOSI
            
            ; ADDS THE FIGURE TO THE MATRIX
            
            LEA.L   HROW4,A0
            MOVE.B  FIGPOSI,D0
            MOVE.B  D0,D2
            
            LEA.L   TROT,A1
            MOVE.B  FIGROTA,D1
            MULU.W  #3,D1
             
            MOVE.B  #51,(A0,D0)
            ADD.B   (A1,D1),D0
            MOVE.B  #51,(A0,D0)
            ADDQ.B  #1,D1
            MOVE.B  D2,D0
            ADD.B   (A1,D1),D0
            MOVE.B  #51,(A0,D0)
            ADDQ.B  #1,D1
            MOVE.B  D2,D0
            ADD.B   (A1,D1),D0
            MOVE.B  #51,(A0,D0)
            
            MOVEM.L (A7)+,DO-D2/A0-A1
            RTS

; -----------------------------------------------------------------------------
DOWNT
; MOVES THE CURRENT T IN THE MATRIX
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - MATRIX
; -----------------------------------------------------------------------------

            ; GETS VALUES OF THE FIGURE
            
            MOVE.B  FIGROTA,D1
            MOVE.B  FIGPOSI,D0
            
            ; CHECKS ROTATION
            
            TST.B   D1
            BEQ     .POS0
            CMP.B   #1,D1
            BEQ     .POS1
            CMP.B   #2,D1
            BEQ     .POS2
            BRA     .POS3
            
            
            
.POS0       ; IF FIGURE IS IN POSITION 0


            BRA     .END
            
.POS1       ; IF FIGURE IS IN POSITION 1
            
            ; CHECK IF CAN BE MOVED
            ADDQ.B  #1,D0
            BTST.B  #0,MCOLUMN(A0,D0)
            
            BRA     .END
            
.POS2       ; IF FIGURE IS IN POSITION 2


            BRA     .END
                    
.POS3       ; IF FIGURE IS IN POSITION 3


            
.END        RTS

; -----------------------------------------------------------------------------
LEFTT
; CHECKS IF CAN GO FUTHER DOWN
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
          
            
            RTS
            
; -----------------------------------------------------------------------------
RIGHTT
; CHECKS IF CAN GO FUTHER DOWN
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            
            RTS
            
; -----------------------------------------------------------------------------
ROTATET
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
