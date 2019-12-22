; =============================================================================
; TETRIS VARS
; =============================================================================

; --- GAME STATE RELATED VARIABLES --------------------------------------------

STATES      DC.L    STAINIT                 ; INITALIZE STATE
            DC.L    STAMENU                 ; MAIN MENU STATE
            DC.L    STANEW                  ; NEW GAME STATE     
            DC.L    STAPLAY                 ; GAME UPDATE STATE
            DC.L    STAOVER                 ; GAME OVER STATE
            
DSTATES     DC.L    DRAWMENU                ; DRAW MENU
            DC.L    DRAWGAME                ; DRAW GAME
            DC.L    DRAWGAMEOVER            ; DRAW GAME MODE
            
STATE       DS.L    1                       ; ACTIVE STATE
DSTATE      DS.L    1                       ; DRAW STATE

; --- GAME SCORE RELATED VARIABLES --------------------------------------------

SCORE       DS.L    1                       ; SCORE FOR THE GAME

; --- ACTUAL TETROMINO RELATED VARIABLES --------------------------------------

TETROACT    DS.L    1                       ; CURRENT TETROMINO
TETROMUL    DS.B    1                       ; CURRENT TETROMINO MATRIX
TETROROT    DS.B    1                       ; CURRENT ROTATION
TETROPOS    DS.B    1                       ; CURRENT POSITION
TETRONXT    DS.B    1                       ; NEXT TETROMINO INDEX
            DS.W    0

; --- TETROMINOS RELATED VARIABLES --------------------------------------------

TETROLNK    DC.L    OFORM,TFORM,LFORM,JFORM ; ADRESS TO EACH TETROMINOS MATRIX
            DC.L    SFORM,ZFORM,IFORM
            
MULS        DC.B    2,3,3,3,3,3,4           ; SIZE OF EACH TETROMINOS MATRIX
           
OFORM       DC.B    $31,$31,$31,$31,$31,$31 ; TETROMINO O
            DC.B    $31,$31,$31,$31,$31,$31
            DC.B    $31,$31,$31,$31
 
TFORM       DC.B    $00,$51,$00,$51,$51,$51 ; TETROMINO T
            DC.B    $00,$00,$00,$00,$51,$00
            DC.B    $00,$51,$51,$00,$51,$00
            DC.B    $00,$00,$00,$51,$51,$51
            DC.B    $00,$51,$00,$00,$51,$00
            DC.B    $51,$51,$00,$00,$51,$00
             
LFORM       DC.B    $00,$21,$00,$00,$21,$00 ; TETROMINO L
            DC.B    $00,$21,$21,$00,$00,$00
            DC.B    $21,$21,$21,$21,$00,$00
            DC.B    $21,$21,$00,$00,$21,$00
            DC.B    $00,$21,$00,$00,$00,$21
            DC.B    $21,$21,$21,$00,$00,$00
             
JFORM       DC.B    $00,$11,$00,$00,$11,$00 ; TETROMINO J
            DC.B    $11,$11,$00,$11,$00,$00
            DC.B    $11,$11,$11,$00,$00,$00
            DC.B    $00,$11,$11,$00,$11,$00
            DC.B    $00,$11,$00,$00,$00,$00
            DC.B    $11,$11,$11,$00,$00,$11
          
SFORM       DC.B    $00,$41,$41,$41,$41,$00 ; TETROMINO S
            DC.B    $00,$00,$00,$00,$41,$00
            DC.B    $00,$41,$41,$00,$00,$41
            DC.B    $00,$00,$00,$00,$41,$41
            DC.B    $41,$41,$00,$41,$00,$00
            DC.B    $41,$41,$00,$00,$41,$00
            
ZFORM       DC.B    $61,$61,$00,$00,$61,$61 ; TETROMINO Z
            DC.B    $00,$00,$00,$00,$00,$61
            DC.B    $00,$61,$61,$00,$61,$00
            DC.B    $00,$00,$00,$61,$61,$00
            DC.B    $00,$61,$61,$00,$61,$00
            DC.B    $61,$61,$00,$61,$00,$00
            
IFORM       DC.B    $00,$00,$01,$00,$00,$00 ; TETROMINO I
            DC.B    $01,$00,$00,$00,$01,$00
            DC.B    $00,$00,$01,$00,$00,$00
            DC.B    $00,$00,$00,$00,$00,$00
            DC.B    $01,$01,$01,$01,$00,$00
            DC.B    $00,$00,$00,$01,$00,$00
            DC.B    $00,$01,$00,$00,$00,$01
            DC.B    $00,$00,$00,$01,$00,$00
            DC.B    $00,$00,$00,$00,$01,$01
            DC.B    $01,$01,$00,$00,$00,$00
            DC.B    $00,$00,$00,$00
            
; --- SOUND RELATED VARIABLES -------------------------------------------------          
            
MELODY      DC.B    'SOUND/MUSIC.WAV',0     ; MUSIC SOUND          1
CLEAR       DC.B    'SOUND/CLEAR.WAV',0     ; 4 LINE CLEAR SOUND   2
FALL        DC.B    'SOUND/FALL.WAV',0      ; FALL SOUND           3
MGAMEOVR    DC.B    'SOUND/GAMEOVER.WAV',0  ; GAME OVER SOUND      4
LINE        DC.B    'SOUND/LINE.WAV',0      ; LINE CLEAR SOUND     5
SELECTION   DC.B    'SOUND/SELECTION.WAV',0 ; MENU SELECTION SOUND 6
SUCCESS     DC.B    'SOUND/SUCCESS.WAV',0   ; NEW GAME SOUND       7

; --- MATRIX RELATED VARIABLES ------------------------------------------------

HMATRIX     DS.B    MCOLUMN                 ; ALL THE HMATRIX ROWS WILL NOT
            DS.B    MCOLUMN                 ; SHOW ON THE SCREEN (HIDDEN)
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
                        
; --- COLOR RELATED VARIABLES -------------------------------------------------
         
ACOLOR      DS.B    1                       ; ACTUAL COLOR
            DS.W    0
            
COLOR       DC.L    $00FFFF00               ; CIAN        0 
            DC.L    $00FF0400               ; BLUE        1
            DC.L    $00008CFF               ; ORANGE      2
            DC.L    $0000FBFF               ; YELLOW      3
            DC.L    $001AFF00               ; GREEN       4
            DC.L    $00FF0095               ; PURPLE      5
            DC.L    $000000FF               ; RED         6


; --- MENU RELATED GRAPHIC VARIABLES ------------------------------------------

            ; TITLE VARIABLES

TITLECOL    DC.W    1                       ; COLOR IN USE
                
TITLELOP    DC.W    7,11,7,8,3,3,11         ; LOOP FOR EACH LETTER

TITLEX      DC.W    235,325,325,295,295,265 ; COORDENTATE X FOR A LINE
            DC.W    265,235,235,335,425,425
            DC.W    365,365,395,395,365,365
            DC.W    425,425,335,335,435,525
            DC.W    525,495,495,465,465,435
            DC.W    435,535,625,625,595,625
            DC.W    595,565,565,535,535,565
            DC.W    595,595,565,565,635,665
            DC.W    665,635,635,675,765,765
            DC.W    705,705,765,765,675,675
            DC.W    735,735,675,675
       
TITLEY      DC.W    065,065,095,095,185,185 ; COORDENTATE Y FOR A LINE
            DC.W    095,095,065,065,065,095
            DC.W    095,110,110,140,140,155
            DC.W    155,185,185,065,065,065
            DC.W    095,095,185,185,095,095
            DC.W    065,065,065,145,145,185
            DC.W    185,145,185,185,065,095
            DC.W    095,115,115,095,065,065
            DC.W    185,185,065,065,065,095
            DC.W    095,110,110,185,185,155
            DC.W    155,140,140,065
            
            ; MENU VARIABLES
      
MENUCONT    DC.W    365,330,645,405         ; LX, UY, RX, LY FOR MENU CONTAINER
      
MENUXY      DC.W    370,340,370,360,370,380 ; TEXT COORDENATES (X,Y)

            ; MENU TEXT
   
MENUINST    DC.B    'PRESS "P" TO SHOW THE INSTRUCTIONS',0
MENUSTRT    DC.B    'PRESS "SPACE" TO START THE GAME',0
MENUATHR    DC.B    'MADE BY FELIX LLUIS AGUILAR FERRER',0
            
            ; INSTRUCTIONS VARIABLES           
            
SHOWINST    DC.B    0
            DS.W    0
INSTCONT    DC.W    290,270,700,430         ; LX, UY, RX, LY FOR MENU CONTAINER
      
INSTXY      DC.W    300,280,300,320,300,340 ; TEXT COORDENATES (X,Y) 
            DC.W    300,360,300,380,300,400
            DC.W    400,320,400,340,400,360
            DC.W    400,380,400,400,430,320
            DC.W    430,340,430,360,430,380
            DC.W    430,400,370,440

            ; INSTRUCTION TEXT
 
INSTLINK    DC.L    INS1,INS3,INS5,INS7,INS9
            DC.L    INS11,INS4,INS6,INS8
            DC.L    INS10,INS12
           
INS1        DC.B    'CONTROLS:',0
INS2        DC.B    '->',0
INS3        DC.B    'ARROW UP',0
INS4        DC.B    'ROTATE THE TETROMINO',0
INS5        DC.B    'ARROW DOWN',0
INS6        DC.B    'DROP FASTER THE TETROMINO',0
INS7        DC.B    'ARROW LEFT',0
INS8        DC.B    'MOVE TO THE LEFT THE TETROMINO',0
INS9        DC.B    'ARROW RIGHT',0
INS10       DC.B    'MOVE TO THE RIGHT THE TETROMINO',0
INS11       DC.B    'SPACE',0
INS12       DC.B    'DROPS TO THE BOTTOM THE TETROMINO',0
            DS.W    0

; --- GAME RELATED GRAPHIC VARIABLES ------------------------------------------

GAMECONX    DC.W    345,655,700,830,700,830 ; CONTAINERS COORDENATE X
GAMECONY    DC.W    045,655,070,200,220,245 ; CONTAINERS COORDENATE Y

            ; NEXT TETRINOMIO

NEXTLINK    DC.L    NEXTO,NEXTT,NEXTL,NEXTJ ; TETRINOMIO TO DRAW AS NEXT
            DC.L    NEXTS,NEXTZ,NEXTI
            
            ;       (COLOR, LOOP, COORDENATES)
NEXTO       DC.W    3,0,735,105,795,165     ; TETRINOMIO O                       
NEXTT       DC.W    5,1,720,135,810,165,750 ; TETRINOMIO T
            DC.W    105,780,135
NEXTL       DC.W    2,1,735,090,765,171,765 ; TETRINOMIO L
            DC.W    141,795,171
NEXTJ       DC.W    1,1,765,090,795,171,735 ; TETRINOMIO J
            DC.W    141,765,171
NEXTS       DC.W    4,1,720,135,780,165,750 ; TETRINOMIO S
            DC.W    105,810,135
NEXTZ       DC.W    6,1,720,105,780,135,750 ; TETRINOMIO Z
            DC.W    135,810,165
NEXTI       DC.W    0,0,750,075,780,190     ; TETRINOMIO I

TXTGAMXY    DC.W    705,225,700,050         ; TEXT COORDENATES X,Y
TEXTSCRE    DC.B    'SCORE:',0
TEXTNEXT    DC.B    'NEXT TETROMINO:',0
            DS.W    0

; --- GAME OVER RELATED GRAPHIC VARIABLES -------------------------------------

            ; GAME OVER VARIABLES

GMOVER      DC.W    11,7,3,11,11,3,3,6,11,8 ; LOOP COUNTER FOR EACH LETTER
            DC.W    3

GMOVERX     DC.W    105,105,195,195,135,135 ; X COORDENATE FOR GAME OVER
            DC.W    165,165,145,145,195,195
            DC.W    105,205,205,295,295,265
            DC.W    265,235,235,205,235,265
            DC.W    265,235,235,305,335,350
            DC.W    365,395,395,365,365,350
            DC.W    335,335,305,305,405,495
            DC.W    495,435,435,465,465,435
            DC.W    435,495,495,405,405,505
            DC.W    595,595,505,505,535,565
            DC.W    565,535,535,605,635,665
            DC.W    695,665,650,635,605,705
            DC.W    795,795,735,735,765,765
            DC.W    735,735,795,795,705,705
            DC.W    805,895,895,865,895,865
            DC.W    835,835,805,805,835,865
            DC.W    865,835,835 
                   
GMOVERY     DC.W    185,065,065,095,095,155 ; Y COORDENATE FOR GAME OVER
            DC.W    155,140,140,110,110,185
            DC.W    185,185,065,065,185,185
            DC.W    145,145,185,185,095,095
            DC.W    115,115,095,065,065,095
            DC.W    065,065,185,185,115,145
            DC.W    115,185,185,065,065,065
            DC.W    095,095,110,110,140,140
            DC.W    155,155,185,185,065,185
            DC.W    185,305,305,185,215,215
            DC.W    275,275,215,185,305,305
            DC.W    185,185,250,185,185,185
            DC.W    185,215,215,230,230,260
            DC.W    260,275,275,305,305,185
            DC.W    185,185,265,265,305,305
            DC.W    265,305,305,185,215,215
            DC.W    235,235,215
            
            ; TEXT IN GAME OVER SCREEN
            
GMOVERXY    DC.W    370,435,370,467         ; TEXT POINTERS (X,Y)

TEXTRESL    DC.B    'TOTAL SCORE: ',0
TEXTREST    DC.B    'PRESS "SPACE" TO RESTART THE GAME',0
            
            ; RANDOM LIST

RANDOM      DS.B    1                       ; RANDOM INDEX IN USE
            
RANDLIST    DC.B    5,6,1,4,0,3,2,4,3,6,1,0 ; RANDOM NUMBER LIST
            DC.B    5,2,4,3,1,0,5,6,2,1,3,6
            DC.B    0,1,2,4,5,0,6,1,4,3,5,3
            DC.B    2,1,5,6,0,4,3,6,4,1,2,0
            DC.B    5,2,6,5,4,1,3,0,2,1,6,4
            DC.B    5,3,0,3,6,4,5,1,2,0,6,5
            DC.B    4,1,2,0,3,2,1,5,4,6,0,3
            DC.B    5,6,0,2,3,4,1,0,2,6,4,5
            DC.B    1,3,1,6,5,4,0,2,3,3,2,1
            DC.B    5,6,0,4,3,0,2,4,5,6,1,5
            DC.B    4,6,0,3,1,2,3,5,0,2,6,4
            DC.B    1,4,1,0,2,3,5,6

            DS.W    0




*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
