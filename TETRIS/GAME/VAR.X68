; =============================================================================
; GAME VARS
; =============================================================================

; --- GAME STATE RELATED VARIABLES --------------------------------------------

STATES      DC.L    STAINIT                 ; INITALIZE STATE   0
            DC.L    STANMME                 ; MAIN MENU STATE   1
            DC.L    STANWGM                 ; NEW GAME STATE    2     
            DC.L    STAUPDA                 ; GAME UPDATE STATE 3
            DC.L    STAGMOV                 ; GAME OVER STATE   4
            
STATE       DS.L    1                       ; ACTIVE STATE

; --- ACTUAL TETROMINO RELATED VARIABLES --------------------------------------

FIGTYPE     DS.L    1                       ; CURRENT TETROMINO

FIGNEXT     DS.B    1                       ; NEXT

FIGROTA     DS.B    1                       ; CURRENT ROTATION
FIGPOSI     DS.B    1                       ; CURRENT POSITION
FIGLDOW     DS.B    1                       ; 1 IF CAN NOT GO DOWN
FIGLRIG     DS.B    1                       ; 1 IF CAN NOT GO RIGHT
FIGLLEF     DS.B    1                       ; 1 IF CAN NOT GO LEFT

; --- TETROMINOS RELATED VARIABLES --------------------------------------------

;(ROW,COL)          (00)(01)(02)(10)(11)(12)(20)(21)(22) 
TFORM       DC.B    $00,$51,$00,$51,$51,$51,$00,$00,$00
            DC.B    $00,$51,$00,$00,$51,$51,$00,$51,$00
            DC.B    $00,$00,$00,$51,$51,$51,$00,$51,$00
            DC.B    $00,$51,$00,$51,$51,$00,$00,$51,$00
            
;(ROW,COL)          (00)(01)(02)(10)(11)(12)(20)(21)(22) 
LFORM       DC.B    $00,$21,$00,$00,$21,$00,$00,$21,$21
            DC.B    $00,$00,$00,$21,$21,$21,$21,$00,$00
            DC.B    $21,$21,$00,$00,$21,$00,$00,$21,$00
            DC.B    $00,$00,$21,$21,$21,$21,$00,$00,$00
 
;(ROW,COL)          (00)(01)(02)(10)(11)(12)(20)(21)(22)            
JFORM       DC.B    $00,$11,$00,$00,$11,$00,$11,$11,$00
            DC.B    $11,$00,$00,$11,$11,$11,$00,$00,$00
            DC.B    $00,$11,$11,$00,$11,$00,$00,$11,$00
            DC.B    $00,$00,$00,$11,$11,$11,$00,$00,$11

;(ROW,COL)          (00)(01)(02)(10)(11)(12)(20)(21)(22)             
SFORM       DC.B    $00,$41,$41,$41,$41,$00,$00,$00,$00
            DC.B    $00,$41,$00,$00,$41,$41,$00,$00,$41
            DC.B    $00,$00,$00,$00,$41,$41,$41,$41,$00
            DC.B    $41,$00,$00,$41,$41,$00,$00,$41,$00
            
;(ROW,COL)          (00)(01)(02)(10)(11)(12)(20)(21)(22) 
ZFORM       DC.B    $61,$61,$00,$00,$61,$61,$00,$00,$00
            DC.B    $00,$00,$61,$00,$61,$61,$00,$61,$00
            DC.B    $00,$00,$00,$00,$61,$61,$61,$61,$00
            DC.B    $00,$61,$00,$61,$61,$00,$61,$00,$00

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
ROW20       DS.B    MCOLUMN                 ; END OF MATRIX
            

; --- GAME STATUS RELATED VARIABLES -------------------------------------------

GAMEOVER    DC.B    1                       ; 1 IF IT IS A GAMEOVER
            
; --- COLOR RELATED VARIABLES -------------------------------------------------
         
ACOLOR      DS.B    1
            DS.W    0
            
COLOR       DC.L    $00FFFF00              ; CIAN 
            DC.L    $00FF0400              ; BLUE
            DC.L    $00008CFF              ; ORANGE
            DC.L    $0000FBFF              ; YELLOW
            DC.L    $001AFF00              ; GREEN
            DC.L    $00FF0095              ; PURPLE
            DC.L    $000000FF              ; RED




*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
