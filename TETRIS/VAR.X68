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
            DS.W    0

; --- TETROMINOS RELATED VARIABLES --------------------------------------------

TETROMINO   DC.L    TFORM,LFORM,JFORM,SFORM,ZFORM

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
            
COLOR       DC.L    $00FFFF00              ; CIAN   0 
            DC.L    $00FF0400              ; BLUE   1
            DC.L    $00008CFF              ; ORANGE 2
            DC.L    $0000FBFF              ; YELLOW 3
            DC.L    $001AFF00              ; GREEN  4
            DC.L    $00FF0095              ; PURPLE 5
            DC.L    $000000FF              ; RED    6
            
; --- SOUND RELATED VARIABLES -------------------------------------------------          
            
MELODY      DC.B    'SOUND/MAIN.WAV',0
            DS.W    0  

; --- MENU RELATED GRAPHIC VARIABLES ------------------------------------------

            ; TITLE VARIABLES

TITLEC      DC.W    1 
                
TETRIS      DC.W    7,11,7,8,3,3,11

TETRISX     DC.W    235,325,325,295,295,265,265,235,235                      ;T
            DC.W    335,425,425,365,365,395,395,365,365,425,425,335,335      ;E
            DC.W    435,525,525,495,495,465,465,435,435                      ;T
            DC.W    535,625,625,595,625,595,565,565,535,535                  ;R
            DC.W    565,595,595,565,565                                      ;R
            DC.W    635,665,665,635,635                                      ;I
            DC.W    675,765,765,705,705,765,765,675,675,735,735,675,675      ;S
       
TETRISY     DC.W    065,065,095,095,185,185,095,095,065                      ;T
            DC.W    065,065,095,095,110,110,140,140,155,155,185,185,065      ;E
            DC.W    065,065,095,095,185,185,095,095,065                      ;T
            DC.W    065,065,145,145,185,185,145,185,185,065                  ;R
            DC.W    095,095,115,115,095                                      ;R
            DC.W    065,065,185,185,065                                      ;I
            DC.W    065,065,095,095,110,110,185,185,155,155,140,140,065      ;S
            
            ; MENU VARIABLES
      
MENUCONT    DC.W    365,330,645,405
      
MENUXY      DC.W     370,340,370,360,370,380
   
TEXTINST    DC.B    'PRESS "P" TO SHOW THE INSTRUCTIONS',0
TEXTSTRT    DC.B    'PRESS "SPACE" TO START THE GAME',0
TEXTATHR    DC.B    'MADE BY FELIX LLUIS AGUILAR FERRER',0
            DS.W    0

; --- GAME RELATED GRAPHIC VARIABLES ------------------------------------------

GAMECONX    DC.W    345,655,700,830,700,830 
GAMECONY    DC.W    045,655,070,200,225,250 

LNEXT       DC.L    NEXTT,NEXTL,NEXTJ,NEXTS,NEXTZ,NEXTO,NEXTI
  
            ;       C L LX  UY  RX  LY  LX  UY RX  LY                     
NEXTT       DC.W    5,1,720,135,810,165,750,105,780,135
NEXTL       DC.W    2,1,765,090,795,171,735,141,765,171
NEXTJ       DC.W    1,1,735,090,765,171,765,141,795,171
NEXTS       DC.W    4,1,720,105,780,135,750,135,810,165
NEXTZ       DC.W    6,1,720,135,780,165,750,105,810,135
NEXTO       DC.W    3,0,735,105,795,165
NEXTI       DC.W    0,0,750,075,780,190

TXTGAMXY    DC.W    705,230,700,050
TEXTSCRE    DC.B    'SCORE:',0
TEXTNEXT    DC.B    'NEXT TETROMINO:',0
            DS.W    0

; --- GAME OVER RELATED GRAPHIC VARIABLES -------------------------------------

GMOVER      DC.W    11,7,3,11,11,3,3,6,11,8,3

GMOVERX     DC.W    105,105,195,195,135,135,165,165,145,145,195,195,105      ;G
            DC.W    205,205,295,295,265,265,235,235,205                      ;A
            DC.W    235,265,265,235,235                                      ;A
            DC.W    305,335,350,365,395,395,365,365,350,335,335,305,305      ;M
            DC.W    405,495,495,435,435,465,465,435,435,495,495,405,405      ;E
            DC.W    505,595,595,505,505                                      ;O
            DC.W    535,565,565,535,535                                      ;O
            DC.W    605,635,665,695,665,650,635,605                          ;V
            DC.W    705,795,795,735,735,765,765,735,735,795,795,705,705      ;E
            DC.W    805,895,895,865,895,865,835,835,805,805                  ;R
            DC.W    835,865,865,835,835                                      ;R
                   
GMOVERY     DC.W    185,065,065,095,095,155,155,140,140,110,110,185,185      ;G
            DC.W    185,065,065,185,185,145,145,185,185                      ;A
            DC.W    095,095,115,115,095                                      ;A
            DC.W    065,065,095,065,065,185,185,115,145,115,185,185,065      ;M
            DC.W    065,065,095,095,110,110,140,140,155,155,185,185,065      ;E
            DC.W    185,185,305,305,185                                      ;O
            DC.W    215,215,275,275,215                                      ;O
            DC.W    185,305,305,185,185,250,185,185                          ;V
            DC.W    185,185,215,215,230,230,260,260,275,275,305,305,185      ;E
            DC.W    185,185,265,265,305,305,265,305,305,185                  ;R
            DC.W    215,215,235,235,215                                      ;R
            
GMOVERXY    DC.W    370,467
TEXTREST    DC.B    'PRESS "SPACE" TO RESTART THE GAME',0
SHOWTEXT    DC.B    1
            DS.W    0



*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
