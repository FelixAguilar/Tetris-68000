; =============================================================================
; GRAFICS
; =============================================================================

; -----------------------------------------------------------------------------
SQUARE
; PRINTS A SQUARE IN A SPECIFIED COORDIANTES
; INPUT    - D1.W   X
;          - D2.W   Y
;          - D3.W   SIDE OF THE SQUARE IN PIXELS
; OUTPUT   - NONE
; MODIFIES - ADDS A SQUARE TO THE SCREEN
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4,-(A7)
            MOVE.B  #87,D0
            MOVE.W  D3,D4
            ADD.W   D1,D3                   ; OBTEINS UX
            ADD.W   D2,D3                   ; OBTEINS LY
            TRAP    #15
            MOVEM.L (A7)+,D0-D4
            RTS

; -----------------------------------------------------------------------------
COLOR
; CHANGES THE COLOR TO THE FILL AND PEN
; INPUT    - D1.L   COLOR $00BBGGRR
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.L  D0,-(A7)
            MOVE.B  #80,D0
            TRAP    #15                     ; PEN COLOR
            
            MOVE.B  #81,D0
            TRAP    #15                     ; FILL COLOR
            MOVE.L  (A7)+,D0
            RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
