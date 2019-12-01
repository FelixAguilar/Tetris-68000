; =============================================================================
; TITLE    : TETRIS GAME
; AUTHOR   : FELIX AGUILAR FERRER
; CREATION :
; =============================================================================

            ORG     $1000

; --- CODE INCLUDES -----------------------------------------------------------

            INCLUDE "SYSCONST.X68"          ; SYSTEM CONSTANTS
            INCLUDE "SYSTEM.X68"            ; SYSTEM CODE
            INCLUDE "CONST.X68"             ; GAME CONSTANTS
            INCLUDE "INIT.X68"              ; GAME INICIALIZATION
            INCLUDE "GRAPHICS.X68"          ; GAME GRAPHICS
            INCLUDE "STATES.X68"            ; GAME STATES
            INCLUDE "FIGURES/SQUARE.X68"    ; FIGURE SQUARE
            
; --- INITIALIZE --------------------------------------------------------------

START       JSR     SYSINIT
            JSR     STAINIT                 ; INITIALIZE STATES
            
; --- UPDATE ------------------------------------------------------------------

.LOOP       TRAP    #KBDTRAP                ; READ KEYBOARD
            MOVE.L  NSTATE,A1
            JSR     (A1)                    ; JUMPS TO NEXT STATE
            MOVE.L  #100,D1
            MOVE.B  #23,D0
            TRAP    #15
            
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

            INCLUDE "SYSVAR.X68"
            INCLUDE "VAR.X68"
            
            END    START












*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
