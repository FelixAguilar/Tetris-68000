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

HMATRIX     DS.B    MCOLUMN                 ; ALL THE HROWS WILL NOT SHOW ON  
            DS.B    MCOLUMN                 ; THE SCREEN (HIDDEN)
            DS.B    MCOLUMN                 
            DS.B    MCOLUMN                 
MATRIX      DS.B    MCOLUMN
            DS.B    MCOLUMN
            DS.B    MCOLUMN
            DS.B    MCOLUMN
            DS.B    MCOLUMN
            DS.B    MCOLUMN
            DS.B    MCOLUMN
            DS.B    MCOLUMN
            DS.B    MCOLUMN
            DS.B    MCOLUMN
            DS.B    MCOLUMN
            DS.B    MCOLUMN
            DS.B    MCOLUMN
            DS.B    MCOLUMN
            DS.B    MCOLUMN
            DS.B    MCOLUMN
            DS.B    MCOLUMN
            DS.B    MCOLUMN
            DS.B    MCOLUMN
            DS.B    MCOLUMN
LIMIT       DS.B    MCOLUMN                 ; END OF MATRIX
            

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
