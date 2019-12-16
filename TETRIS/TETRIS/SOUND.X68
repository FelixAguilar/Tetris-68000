; =============================================================================
; SOUND
; =============================================================================

; ----------------------------------------------------------------------------
SOUNDINIT
; INITALIZES SOUNDS MANAGER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D2/A1,-(A7)
            
            MOVE.B  #MUSIC,D0               ; CHECKS IF MUSIC IS ACTIVE
            BEQ     .SKIP

            MOVE.B  #71,D0
            MOVE.B  #NMUSIC,D1
            LEA.L   MELODY,A1
            TRAP    #15

            MOVE.B  #76,D0
            MOVE.L  #NMUSIC,D2
            TRAP    #15                     ; PLAYS MELODY IN LOOP
   
.SKIP       MOVE.B  #SOUND,D0               ; CHECKS IF SOUNDS ARE ACTIVE
            BEQ     .END
            
            MOVE.B  #71,D0
            MOVE.B  #NCLEAR,D1
            LEA.L   CLEAR,A1
            TRAP    #15
            MOVE.B  #NFALL,D1
            LEA.L   FALL,A1
            TRAP    #15
            MOVE.B  #NOVER,D1
            LEA.L   MGAMEOVR,A1
            TRAP    #15
            MOVE.B  #NLINE,D1
            LEA.L   LINE,A1
            TRAP    #15
            MOVE.B  #NSELECT,D1
            LEA.L   SELECTION,A1
            TRAP    #15
            MOVE.B  #NSUCCESS,D1
            LEA.L   SUCCESS,A1
            TRAP    #15

.END        MOVEM.L (A7)+,D0-D2/A1
            RTS
            
; ----------------------------------------------------------------------------
SOUNDPLAY
; PLAYS SOUND IF IS ACTIVE AND THERE IS NO MUSIC
; INPUT    - D1.B = SOUND TO PLAY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D2,-(A7)
            
            MOVE.B  #MUSIC,D0               ; CHECKS IF MUSIC IS ACTIVE
            BNE     .END
            
            MOVE.B  #SOUND,D0               ; CHECKS IF SOUNDS ARE ACTIVE
            BEQ     .END
            
            MOVE.B  #76,D0
            MOVE.L  #3,D2
            TRAP    #15                     ; STOPS ALL SOUNDS
            MOVE.B  #72,D0
            TRAP    #15                     ; PLAYS NEW SOUND
            
.END        MOVEM.L (A7)+,D0-D2
            RTS
            
; -----------------------------------------------------------------------------




*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
