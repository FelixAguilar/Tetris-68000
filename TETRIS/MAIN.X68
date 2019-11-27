; =============================================================================
; TITLE    : TETRIS 68000
; AUTHOR   : FELIX AGUILAR FERRER, 
;            ADRIAN BENNASAR POLZIN, 
;            ALVARO BUENO LOPEZ
; CREATION :
; =============================================================================

            ORG     $1000

; --- CODE INCLUDES -----------------------------------------------------------

            INCLUDE "SYSCONST.X68"          ; SYSTEM CONSTANTS
            INCLUDE "SYSTEM.X68"            ; SYSTEM CODE
            INCLUDE "GRAPHICS.X68"          ; INTERFACE
            ; TO DO: PUT YOUR GAME-RELATED INCLUDES HERE

; --- INITIALIZE --------------------------------------------------------------

START       JSR     SYSINIT
            ; TO DO: CALL GAME INITIALIZATION CODE HERE

; --- UPDATE ------------------------------------------------------------------

.LOOP       TRAP    #KBDTRAP                ; READ KEYBOARD
            ; TO DO: CALL GAME UPDATE CODE HERE
            MOVE.L  #$0,D1
            JSR     FIGURE

; --- WAIT SYNCH --------------------------------------------------------------

.WINT       TST.B   (SCRINTCT)              ; WAIT FOR INTERRUPT
            BEQ     .WINT
            CLR.B   (SCRINTCT)

; --- PLOT --------------------------------------------------------------------

            ; TO DO: CALL GAME PLOT CODE HERE
            
            TRAP    #SCRTRAP                ; SHOW GRAPHICS
            BRA     .LOOP
            SIMHALT

; --- VARIABLES ---------------------------------------------------------------

            INCLUDE "SYSVAR.X68"
            INCLUDE "VAR.X68"
            END    START



*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
