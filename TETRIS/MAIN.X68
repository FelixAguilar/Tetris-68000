; =============================================================================
; TITLE    : TETRIS GAME
; AUTHOR   : FELIX AGUILAR FERRER
; CREATION :
; =============================================================================

            ORG     $1000

; --- CODE INCLUDES -----------------------------------------------------------

            INCLUDE "SYSTEM/SYSCONST.X68"   ; SYSTEM CONSTANTS
            INCLUDE "SYSTEM/SYSTEM.X68"     ; SYSTEM CODE
            INCLUDE "GRAPHICS/GRAPHICS.X68" ; GRAPHICS CODE
            INCLUDE "GAME/GAME.X68"         ; GAME CODE
            
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

            INCLUDE "SYSTEM/SYSVAR.X68"
            INCLUDE "GAME/VAR.X68"
            
            END    START


























*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
