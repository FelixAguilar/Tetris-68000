; =============================================================================
; GAME VARS
; =============================================================================

; --- GAME STATUS RELATED VARIABLES -------------------------------------------

STATES      DC.L    STAINIT                 ; INITALIZE STATE
            DC.L    STANMME                 ; MAIN MENU STATE
            DC.L    STANWGM                 ; NEW GAME STATE      
            DC.L    STAUPDA                 ; GAME UPDATE STATE
            DC.L    STAGMOV                 ; GAME OVER STATE
            DC.L    STADWGM                 ; DRAW GAME
            DC.L    STADWMM                 ; DRAW MAIN MENU
            DC.L    STADWGO                 ; DRAW GAME OVER
            
NSTATE      DS.L    1                       ; NEXT STATE
DSTATE      DS.L    1                       ; DRAW STATE

; --- FIGURE RELATED VARIABLES ------------------------------------------------

FIGUPDA     DS.L    1                       ; CURRENT 
FIGROTA     DS.B    1                       ; CURRENT ROTATION
FIGPOSI     DS.B    1                       ; CURRENT POSITION CELL

; --- MATRIX RELATED VARIABLES ------------------------------------------------

HROW4       DS.B    MCOLUMN                 ; ALL THE HROWS WILL NOT SHOW ON  
HROW3       DS.B    MCOLUMN                 ; THE SCREEN (HIDDEN)
HROW2       DS.B    MCOLUMN                 
HROW1       DS.B    MCOLUMN                 
ROW0        DS.B    MCOLUMN
ROW1        DS.B    MCOLUMN
ROW2        DS.B    MCOLUMN
ROW3        DS.B    MCOLUMN
ROW4        DS.B    MCOLUMN
ROW5        DS.B    MCOLUMN
ROW6        DS.B    MCOLUMN
ROW7        DS.B    MCOLUMN
ROW8        DS.B    MCOLUMN
ROW9        DS.B    MCOLUMN
ROW10       DS.B    MCOLUMN
ROW11       DS.B    MCOLUMN
ROW12       DS.B    MCOLUMN
ROW13       DS.B    MCOLUMN
ROW14       DS.B    MCOLUMN
ROW15       DS.B    MCOLUMN
ROW16       DS.B    MCOLUMN
ROW17       DS.B    MCOLUMN
ROW18       DS.B    MCOLUMN
ROW19       DS.B    MCOLUMN
            
; --- COLOR RELATED VARIABLES -------------------------------------------------
         
ACOLOR      DS.B    1
            DS.W    0
            
COLOR       DC.L    $0000FFFF              ; CIAN 
            DC.L    $000004FF              ; BLUE
            DC.L    $00FF8C00              ; ORANGE
            DC.L    $00FFFB00              ; YELLOW
            DC.L    $0000FF1A              ; GREEN
            DC.L    $009500FF              ; PURPLE
            DC.L    $00FF0000              ; RED






















*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
