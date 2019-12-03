; =============================================================================
; SYSTEM MANAGEMENT (SYSTEM CODE)
; =============================================================================
; Felix Aguilar Ferrer, Adrian Bennasar Polzin, Alvaro Bueno Lopez
; -----------------------------------------------------------------------------
SYSINIT
; INITIALIZES THE SYSTEM
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.L  (A7)+,A0                ; GET RETURN ADDRESS
            JSR     KBDINIT                 ; INIT KEYBOARD
            JSR     SCRINIT                 ; INIT SCREEN
            JSR     DMMINIT                 ; INIT DYNAMIC MEMORY
            ANDI.W  #$DFFF,SR               ; SWITCH TO USER
            MOVE.L  A0,-(A7)                ; PUT RETURN ADDRESS
            RTS

; =============================================================================
; SCREEN MANAGEMENT (SYSTEM CODE)
; =============================================================================

; -----------------------------------------------------------------------------
SCRINIT
; INITIALIZES THE SCREEN, SCREEN-RELATED INTERRUPT AND VARS.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - WHATEVER IS REQUIRED, NO NEED TO RESTORE REGISTERS.
; -----------------------------------------------------------------------------
            ; TO DO:
            ; - DISABLE INTS (SET INT BITS IN SR TO 111)
            ORI.W   #$0700,SR
            
            ; - INSTALL SCRUPD INTO TRAP SCRTRAP
            MOVE.L  #SCRUPD,($80+SCRTRAP*4)
            
            ; - SET RESOLUTION TO SCRWIDTH X SCRHEIGHT
            MOVE.B  #33,D0
            MOVE.W  #SCRWIDTH,D1
            LSL.L   #8,D1
            LSL.L   #8,D1
            MOVE.W  #SCRHEIGH,D1
            TRAP    #15
            
            ; - SET WINDOWED MODE
            MOVEQ.L #1,D1
            TRAP    #15
            
            ; - CLEAR VISIBLE BUFFER
            MOVE.B  #11,D0
            MOVE.W  #$FF00, D1
            TRAP    #15
            
            ; - ENABLE DOUBLE BUFFER
            MOVE.B  #92,D0
            MOVE.B  #17,D1
            TRAP    #15
            
            ; - CLEAR HIDDEN BUFFER
            MOVE.B  #11,D0
            MOVE.W  #$FF00, D1
            TRAP    #15
            
            ; - INSTALL SCRISR FOR IRQ SCRIRQ (IRQ INTERRUPT VECTOR BEGINS
            ;   AT $60. INSTALLATION IS SIMILAR TO TRAP INSTALLATION)
            MOVE.L  #SCRISR,($60+SCRIRQ*4)
            
            ; - ENABLE AUTO-IRQ EVERY SCRTIM MS FOR IRQ SCRIRQ (SEE TRAP #15
            ;   TASK 32)
            MOVE.B  #32,D0
            MOVE.B  #06,D1
            MOVE.B  #1,D2
            LSL.B   #7,D2
            ADD.B   #SCRIRQ,D2
            MOVE.L  #SCRTIM,D3
            TRAP    #15
            
            ; - CLEAR SCRINTCT AND SCRCYCCT
            CLR.B   SCRINTCT
            CLR.B   SCRCYCCT
            
            ; - ENABLE INTS (SET INT BITS IN SR TO 000)
            ANDI.W  #$F8FF,SR
            RTS

; -----------------------------------------------------------------------------
SCRISR
; SCREEN TIMER ISR. INCREASES THE INTERRUPT COUNTER AND UPDATES DOUBLE BUFFER.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            ADDQ.B  #1,SCRINTCT           ; UPDATE INT FLAG/COUNTER
            ADDQ.B  #1,SCRCYCCT           ; UPDATE CYCLE COUNTER
            RTE

; -----------------------------------------------------------------------------
SCRUPD
; TRAP SERVICE ROUTINE IN CHARGE OF VISUALIZING CURRENT FRAME AND CLEARING
; BUFFER FOR THE NEXT ONE.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            ; TO DO: UPDATE DOUBLE BUFFER AND CLEAR HIDDEN BUFFER
            MOVE.B  #94,D0
            TRAP    #15
            MOVE.B  #11,D0
            MOVE.W  #$FF00,D1
            TRAP    #15
            RTE

; =============================================================================
; KEYBOARD MANAGEMENT (SYSTEM CODE)
; =============================================================================

; -----------------------------------------------------------------------------
KBDINIT
; INITIALIZES THE SYSTEM VARIABLES KBDSYS AND KBDVAL
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            CLR.B   KBDVAL                ; INIT VARS
            CLR.B   KBDEDGE
            MOVE.L  #KBDREAD,($80+KBDTRAP*4) ; INSTALL
            RTS

; -----------------------------------------------------------------------------
KBDREAD
; TRAP SERVICE ROUTINE.
; UPDATES THE SYSTEM VARIABLES KBDEDGE AND KBDVAL ACCORDING TO THE BITFIELD
; DESCRIBED IN SYSCONST. KBDVAL HOLDS THE CURRENT VALUES AND KBDEFGE HOLDS
; RISING EDGES FROM PREVIOUS CALL TO THE CURRENT ONE.
; INPUT    - NONE
; OUTPUT   - (KBDVAL) AND (KBDEDGE)
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            ; TO DO: UPDATE KBDVAL AND KBDEDGE
            MOVEM.L D0-D5,-(A7)
            MOVE.B  KBDVAL,D5               ; D5 = KBDVAL (T-1)
            CLR.B   KBDVAL
            
            ; - READ 8 KEYS FROM KEYBBOARD
            MOVE.B  #19,D0
            MOVE.L  #KBDPAUSE<<24+KBDFIRE3<<16+KBDFIRE2<<8+KBDFIRE1,D1
            TRAP    #15
            MOVE.L  D1,D3                   ; D3 = FIRST 4 KEYS
            MOVE.L  #KBDDOWN<<24+KBDRIGHT<<16+KBDUP<<8+KBDLEFT,D1
            TRAP    #15
            
            ; - UPDATE KBDVAL FROM VALUES OBTEINED FROM THE KEYBOARD
            MOVE.B  #KBDMSKLF,D2            ; D0 = MASK FOR THE KEY 0
            MOVE.W  #7,D4                   ; D4 = COUNT OF INTERACTIONS
.LOOP       AND.B   D2,D1
            OR.B    D1,KBDVAL               ; UPDATES 1 KEY AT A TIME.
            LSR.L   #8,D1                   ; MODIFIES D1 TO GET NEXT KEY INFO
            LSL.B   #1,D2                   ; MODIFIES MASK FOR THE NEXT KEY
            CMP.B   #KBDMSKF1,D2            ; WHEN REACHED KEY 4 DO NOT JUMP
            BNE     .SKIP
            MOVE.L  D3,D1                   ; LOADS NEXT 4 KEYS
.SKIP       DBRA    D4,.LOOP            
                                    
            ; - UPDATE KBDEDGE
            NOT.B   D5
            AND.B   KBDVAL,D5
            MOVE.B  D5,KBDEDGE
            
            MOVEM.L (A7)+,D0-D5
            RTE

; =============================================================================
; DYNAMIC MEMORY MANAGEMENT (SYSTEM CODE)
; DYNAMIC MEMORY IS A SET OF DMMBNUM SLOTS OF DMMBSIZE BYTES EACH ONE.
; DMMBSIZE MUST BE POWER OF TWO. A SLOT HAS:
; - HEADER - 1 WORD. SPECIFIES THE OWNER (0 MEANS OWNED BY SYSTEM)
; - DATA   - DMMBSIZE - 2 BYTES. MAY CONTAIN VARS AND ANY KIND OF DATA RELATED
;            THE THE OWNER. IF OWNER==0, DATA IS MEANINGLESS.
; =============================================================================

; -----------------------------------------------------------------------------
DMMINIT
; INITIALIZES THE DYNAMIC MEMORY TO ALL OWNED BY SYSTEM.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            LEA     DMMDATA,A0
            MOVE.W  #DMMBNUM-1,D0
.LOOP       MOVE.W  #DMMSYSID,(A0)
            ADD.L   #DMMBSIZE,A0
            DBRA.W  D0,.LOOP
            MOVEM.L (A7)+,D0/A0
            RTS

; -----------------------------------------------------------------------------
DMMFIRST
; SEARCHES THE FIRST MEMORY SLOT NOT OWNED BY SYSTEM AND OUTPUTS A POINTER
; TO THE CORRESPONDING DATA (SLOT ADDRESS+2)
; INPUT    - NONE
; OUTPUT   - A0   : POINTER TO THE DATA OR 0 IF NOT FOUND
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            LEA     DMMDATA,A0
DMMFRLOP    TST.W   (A0)+
            BNE     DMMFRFND
            ADD.L   #DMMBSIZE-2,A0
DMMFRCOM    CMP.L   #DMMDATA+DMMBSIZE*DMMBNUM-1,A0
            BLT     DMMFRLOP
            MOVE.L  #0,A0
DMMFRFND    RTS

; -----------------------------------------------------------------------------
DMMNEXT
; SEARCHES THE NEXT MEMORY SLOT NOT OWNED BY SYSTEM AND OUTPUTS A POINTER
; TO THE CORRESPONDING DATA (SLOT ADDRESS+2)
; INPUT    - A0   : POINTER WITHIN THE CURRENT SLOT
; OUTPUT   - A0   : POINTER TO THE DATA OR 0 IF NOT FOUND
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            MOVE.L  D0,-(A7)
            MOVE.L  A0,D0
            AND.L   #-DMMBSIZE,D0           ; TAKE ADVANTAGE OF ALIGNMENT
            ADD.L   #DMMBSIZE,D0
            MOVE.L  D0,A0
            MOVE.L  (A7)+,D0
            BRA     DMMFRCOM

; -----------------------------------------------------------------------------
DMMFRSTO
; SEARCHES THE FIRST MEMORY SLOT WITH THE SPECIFIED ID AND OUTPUTS A POINTER
; TO THE CORRESPONDING DATA (SLOT ADDRESS+2)
; INPUT    - D0.W : ID TO SEARCH
; OUTPUT   - A0   : POINTER TO THE DATA OR 0 IF NOT FOUND
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            LEA     DMMDATA,A0
DMMFLOOP    CMP.W   (A0)+,D0
            BEQ     DMMFFND
            ADD.L   #DMMBSIZE-2,A0
DMMFCOM     CMP.L   #DMMDATA+DMMBSIZE*DMMBNUM-1,A0
            BLT     DMMFLOOP
            MOVE.L  #0,A0
DMMFFND     RTS

; -----------------------------------------------------------------------------
DMMNEXTO
; SEARCHES THE NEXT MEMORY SLOT WITH THE SPECIFIED ID AND OUTPUTS A POINTER
; TO THE CORRESPONDING DATA (SLOT ADDRESS+2)
; INPUT    - D0.W : ID TO SEARCH
;            A0   : POINTER WITHIN THE CURRENT SLOT
; OUTPUT   - A0   : POINTER TO THE DATA OR 0 IF NOT FOUND
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            MOVE.L  D0,-(A7)
            MOVE.L  A0,D0
            AND.L   #-DMMBSIZE,D0           ; TAKE ADVANTAGE OF ALIGNMENT
            ADD.L   #DMMBSIZE,D0
            MOVE.L  D0,A0
            MOVE.L  (A7)+,D0
            BRA     DMMFCOM

; -----------------------------------------------------------------------------
DMMALLOC
; SEARCHES THE FIRST FREE (SYS OWNED) SLOT, ASSIGNS TO THE SPECIFIED OWNER
; AND RETURNS A POINTER TO THE CORRESPONDING DATA (SLOT ADDRESS + 2)
; INPUT    - D0.W : ID TO ASSIGN
; OUTPUT   - A0   : POINTER TO THE DATA OR 0 IF NOT FREE SPACE
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            MOVE.W  D0,-(A7)
            CLR.W   D0
            JSR     DMMFRSTO
            MOVE.W  (A7)+,D0
            CMP.L   #0,A0
            BEQ     .END
            MOVE.W  D0,-2(A0)
.END        RTS

; -----------------------------------------------------------------------------
DMMFREE
; FREES THE SLOT TO WHICH THE PROVIDED POINTER BELONGS BY SETTING ITS OWNED TO
; SYSTEM (0)
; INPUT    - A0   : POINTER BELONGING TO THE SLOT TO FREE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            MOVE.L  A0,D0
            AND.L   #-DMMBSIZE,D0           ; TAKE ADVANTAGE OF ALIGNMENT
            MOVE.L  D0,A0
            CLR.W   (A0)
            MOVEM.L (A7)+,D0/A0
            RTS















*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
