; =============================================================================
; TITLE    : TETRIS GAME
; AUTHOR   : FELIX AGUILAR FERRER
; CREATION :
; =============================================================================

            ORG     $1000

; --- CODE INCLUDES -----------------------------------------------------------

            INCLUDE "SYSCONST.X68"          ; SYSTEM CONSTANTS
            INCLUDE "CONST.X68"             ; GAME CONSTANTS
            
            INCLUDE "SYSTEM.X68"            ; SYSTEM CODE
            INCLUDE "GRAPHICS/GRAPHICS.X68" ; GRAPHICS CODE
            
            INCLUDE "GAME.X68"              ; GAME CODE
            INCLUDE "STATES.X68"            ; GAME STATES
            INCLUDE "TETROMINO.X68"         ; GAME TETROMINO FIGURES
            
; --- INITIALIZE --------------------------------------------------------------

START       JSR     SYSINIT
            JSR     STAINIT                 ; INITIALIZE STATES
            
; --- UPDATE ------------------------------------------------------------------

.LOOP       TRAP    #KBDTRAP                ; READ KEYBOARD
            MOVE.L  STATE,A1
            JSR     (A1)                    ; JUMPS TO NEXT STATE
            
; --- WAIT SYNCH --------------------------------------------------------------

.WINT       TST.B   (SCRINTCT)              ; WAIT FOR INTERRUPT
            BEQ     .WINT
            CLR.B   (SCRINTCT)

; --- PLOT --------------------------------------------------------------------
         
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
