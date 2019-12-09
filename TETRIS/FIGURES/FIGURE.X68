; =============================================================================
; FIGURE
; =============================================================================

; --- CODE INCLUDES -----------------------------------------------------------

            INCLUDE "FIGURES/O.X68"   ; TETROMINO O
            INCLUDE "FIGURES/T.X68"   ; TETROMINO T

; -----------------------------------------------------------------------------
INITFIGURE
; ADDS A NEW FIGURE IN THE HIDEN ZONE OF THE MATRIX
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - MATRIX
; -----------------------------------------------------------------------------
            
            MOVEM.L D0/A0,-(A7)

            CLR.B   FIGLDOW
            CLR.B   FIGLRIG
            CLR.B   FIGLLEF
            
            CLR.L   D0
            MOVE.B  D0,FIGTYPE              ; AÑADIR D0 LUEGO
            
            LEA.L   .DATA,A0             
            MOVEA.L (A0,D0),A0
            
            JSR     (A0)                      
            
            MOVEM.L (A7)+,D0/A0
            RTS
            
.DATA       DC.L    INITO, INITT
            
; -----------------------------------------------------------------------------
LEFTFIGURE
; EXECUTES A FIGURE LEFT MOVEMENT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - MATRIX
; -----------------------------------------------------------------------------
            
            
            MOVEM.L D0/A0,-(A7)
            
            CLR.L   D0
            MOVE.B  FIGTYPE,D0
            
            LEA.L   .DATA,A0             
            MOVEA.L (A0,D0),A0
            
            JSR     (A0)
            
            MOVEM.L (A7)+,D0/A0
            RTS
            
.DATA       DC.L    LEFTO, LEFTT
            
; -----------------------------------------------------------------------------
RIGHTFIGURE
; ADDS A NEW SQUARE IN THE HIDEN ZONE OF THE MATRIX
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - MATRIX
; -----------------------------------------------------------------------------
                        
            MOVEM.L D0/A0,-(A7)
            
            CLR.L   D0
            MOVE.B  FIGTYPE,D0
            
            LEA.L   .DATA,A0             
            MOVEA.L (A0,D0),A0
            
            JSR     (A0)
            
            MOVEM.L (A7)+,D0/A0
            RTS
            
.DATA       DC.L    RIGHTO, RIGHTT
            
; -----------------------------------------------------------------------------
ROTATEFIGURE
; ADDS A NEW SQUARE IN THE HIDEN ZONE OF THE MATRIX
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - MATRIX
; -----------------------------------------------------------------------------
            
            MOVEM.L D0/A0,-(A7)
            
            CLR.L   D0
            MOVE.B  FIGTYPE,D0
            
            LEA.L   .DATA,A0             
            MOVEA.L (A0,D0),A0
            
            JSR     (A0)
            
            MOVEM.L (A7)+,D0/A0
            RTS
            
.DATA       DC.L    ROTATEO, ROTATET
            
; -----------------------------------------------------------------------------
DOWNFIGURE
; ADDS A NEW SQUARE IN THE HIDEN ZONE OF THE MATRIX
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - MATRIX
; -----------------------------------------------------------------------------
            
            MOVEM.L D0/A0,-(A7)
            
            CLR.L   D0
            MOVE.B  FIGTYPE,D0
            
            LEA.L   .DATA,A0             
            MOVEA.L (A0,D0),A0
            
            JSR     (A0)
            
            MOVEM.L (A7)+,D0/A0
            RTS
            
.DATA       DC.L    DOWNO, DOWNT





















*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
