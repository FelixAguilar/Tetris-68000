; =============================================================================
; GAME CONST
; =============================================================================

; --- GAME RELATED CONSTANTS ------------------------------------------------

; --- TETROMINO RELATED CONSTANTS ---------------------------------------------

MUL3         EQU     9


; --- MATRIX RELATED CONSTANTS ------------------------------------------------

MROW        EQU     24                      ; NOT CHANGES THE NUMBER OF ROWS
MCOLUMN     EQU     10    
ISFILLED    EQU     %00000001               ; MASK FOR CHECK A SQUARE IS USED
WHATCOLOR   EQU     %11110000               ; MASK TO GET THE COLOR OF A SQUARE

; --- GRAFICS RELATED CONSTANTS -----------------------------------------------

SIDELENGTH  EQU     30                       ; SIZE IN PIXEL OF A SQUARE
XMATRIX     EQU     (SCRWIDTH/2)-(SIDELENGTH*MCOLUMN)/2
YMATRIX     EQU     (SCRHEIGH/2)-(SIDELENGTH*(MROW-4))/2                      








*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
