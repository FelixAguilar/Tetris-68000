; =============================================================================
; TITLE    : TETRIS
; AUTHOR   : FELIX LLUIS AGUILAR FERRER
; CREATION : 16-DEC-2019
; =============================================================================

            ORG     $1000

; --- CODE INCLUDES -----------------------------------------------------------

            INCLUDE "SYSTEM/SYSCONST.X68"   ; SYSTEM CONSTANTS
            INCLUDE "TETRIS/CONST.X68"      ; TETRIS CONSTANTS
            
            INCLUDE "SYSTEM/SYSTEM.X68"     ; SYSTEM CODE
            
            INCLUDE "TETRIS/STATES.X68"     ; SYSTEM STATES
            INCLUDE "TETRIS/TETRIS.X68"     ; TETRIS INIT AND UPDATE CODE
            INCLUDE "TETRIS/TETROMINO.X68"  ; TETROMINO MOVEMENT
            INCLUDE "TETRIS/GRAPHICS.X68"   ; GRAPHICS CODE
            INCLUDE "TETRIS/SOUND.X68"      ; SOUND CODE
            
; --- INITIALIZE --------------------------------------------------------------

START       JSR     SYSINIT
            JSR     STAINIT                 ; INITIALIZE STATES
            
; --- UPDATE ------------------------------------------------------------------

.LOOP       TRAP    #KBDTRAP                ; READ KEYBOARD

            MOVE.L  STATE,A1                ; A1 = CURRENT STATE
            JSR     (A1)                    ; JUMPS TO CURRENT STATE
            
; --- WAIT SYNCH --------------------------------------------------------------

.WINT       TST.B   (SCRINTCT)              ; WAIT FOR INTERRUPT
            BEQ     .WINT
            CLR.B   (SCRINTCT)

; --- PLOT --------------------------------------------------------------------
         
            MOVE.L  DSTATE,A1               ; A1 = CURRENT DRAW RUTINE
            JSR     (A1)                    ; JUMPS TO CURRENT DRAW RUTINE
         
            TRAP    #SCRTRAP                ; SHOW GRAPHICS
            BRA     .LOOP
            SIMHALT

; --- VARIABLES ---------------------------------------------------------------

            INCLUDE "SYSTEM/SYSVAR.X68"     ; SYSTEM VARIABLES
            INCLUDE "TETRIS/VAR.X68"        ; SYSTEM VARUABLES
            
            END    START












*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
