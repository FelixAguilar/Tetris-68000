; =============================================================================
; GAME CONST
; =============================================================================

; --- GENERAL CONSTANTS -------------------------------------------------------

TESTBIT0    EQU     0

; --- SOUND RELATED CONSTANTS -------------------------------------------------

;           (0 = DISABLED, 1 = ENABLED)
MUSIC       EQU     0                       ; MUSIC TETRIS
SOUND       EQU     1                       ; SOUNDS (ONLY IF MUSIC = 0)

NCLEAR      EQU     0
NFALL       EQU     1
NOVER       EQU     2
NLINE       EQU     3
NMUSIC      EQU     4
NSELECT     EQU     5
NSUCCESS    EQU     6

; --- STATE RELATED CONSTANTS -------------------------------------------------

SNUMMENU    EQU     1
SNUMNEW     EQU     2
SNUMPLAY    EQU     3
SNUMOVER    EQU     4

; --- GAME RELATED CONSTANTS --------------------------------------------------

BASESCRE    EQU     5                       ; BASE SCORE
MAXRAND     EQU     140                     ; MAX LIST NUMBER

; --- MATRIX RELATED CONSTANTS ------------------------------------------------

MROW        EQU     24                      ; NUMBER OF ROWS
MCOLUMN     EQU     10                      ; NUMBER OF COLUMNS

; --- GRAFICS RELATED CONSTANTS -----------------------------------------------

LENSQU      EQU     30                      ; SIZE IN PIXEL OF A SQUARE SIDE
XMATRIX     EQU     350                     ; COORDENATE X FOR MATRIX IN PIXELS
YMATRIX     EQU     50                      ; COORDENATE Y FOR MATRIX IN PIXELS






*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
