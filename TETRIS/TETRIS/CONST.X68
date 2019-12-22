; =============================================================================
; GAME CONSTANTS
; =============================================================================

; --- TIMER CONSTANTS ---------------------------------------------------------

TIMERF      EQU     %00001111               ; FAST TIMER
TIMERS      EQU     %00011111               ; SLOW TIMER

; --- SOUND RELATED CONSTANTS -------------------------------------------------

;           (0 = DISABLED, 1 = ENABLED)
MUSIC       EQU     1                       ; MUSIC TETRIS
SOUND       EQU     0                       ; SOUNDS (ONLY IF MUSIC = 0)

            ; MEMORY SOUND NUMBERS
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

GNUMMENU    EQU     0
GNUMGAME    EQU     1
GNUMOVER    EQU     2

; --- GAME RELATED CONSTANTS --------------------------------------------------

BASESCRE    EQU     4                       ; BASE SCORE (2^NUMBER)
RESPAWN     EQU     4                       ; SPAWN POINT FOR NEW TETROMINOS
MAXRAND     EQU     140                     ; MAX RANDOM LIST NUMBER

; --- MATRIX RELATED CONSTANTS ------------------------------------------------

MROW        EQU     24                      ; NUMBER OF ROWS
MCOLUMN     EQU     10                      ; NUMBER OF COLUMNS

; --- GRAFICS RELATED CONSTANTS -----------------------------------------------

PENWHITH    EQU     5                       ; WHITH OF THE PEN
LENSQU      EQU     30                      ; SIZE IN PIXEL OF A SQUARE SIDE
XMATRIX     EQU     350                     ; COORDENATE X FOR MATRIX IN PIXELS
YMATRIX     EQU     50                      ; COORDENATE Y FOR MATRIX IN PIXELS
























*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
