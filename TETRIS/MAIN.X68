; =============================================================================
; TITLE    : TETRIS GAME
; AUTHOR   : FELIX AGUILAR FERRER
; CREATION :
; =============================================================================

            ORG     $1000

; --- CODE INCLUDES -----------------------------------------------------------

            INCLUDE "SYSTEM/SYSCONST.X68"   ; SYSTEM CONSTANTS
            INCLUDE "SYSTEM/SYSTEM.X68"     ; SYSTEM CODE
            INCLUDE "GAME/CONST.X68"        ; GAME CONSTANTS
            INCLUDE "GAME/INIT.X68"         ; GAME INICIALIZATION
            INCLUDE "GAME/GRAPHICS.X68"     ; GAME GRAPHICS
            INCLUDE "GAME/STATES.X68"       ; GAME STATES
            INCLUDE "GAME/STATUS.X68"       ; GAME CHECKING CODE
            INCLUDE "FIGURES/FIGURE.X68"    ; FIGURE CODE
            INCLUDE "FIGURES/SQUARE.X68"    ; FIGURE SQUARE
            
; --- INITIALIZE --------------------------------------------------------------

START       JSR     SYSINIT
            JSR     STAINIT                 ; INITIALIZE STATES
            
; --- UPDATE ------------------------------------------------------------------

.LOOP       TRAP    #KBDTRAP                ; READ KEYBOARD
            MOVE.L  NSTATE,A1
            JSR     (A1)                    ; JUMPS TO NEXT STATE
            
; --- WAIT SYNCH --------------------------------------------------------------

.WINT       TST.B   (SCRINTCT)              ; WAIT FOR INTERRUPT
            BEQ     .WINT
            CLR.B   (SCRINTCT)

; --- PLOT --------------------------------------------------------------------

            MOVE.L  DSTATE,A1
            JSR     (A1)                    ; DRAWS THE CURRENT PLOT STATE         
            TRAP    #SCRTRAP                ; SHOW GRAPHICS
            BRA     .LOOP
            SIMHALT

; --- VARIABLES ---------------------------------------------------------------

            INCLUDE "SYSTEM/SYSVAR.X68"
            INCLUDE "GAME/VAR.X68"
            
            END    START




















*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
