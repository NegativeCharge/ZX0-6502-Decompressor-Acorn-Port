LOAD_ADDR = &5800

\ Allocate vars in ZP
ORG &80
GUARD &9F
.zp_start
    INCLUDE ".\lib\zx0_decompress.h.asm"
.zp_end

\ Main
CLEAR 0, LOAD_ADDR
GUARD LOAD_ADDR
ORG &1100
.start
    INCLUDE ".\lib\zx0_decompress.s.asm"

.entry_point

    \\ Turn off cursor by directly poking crtc
	LDA #10
    STA &FE00
	LDA #32
    STA &FE01

    LDX #LO(test_data)
    LDY #HI(test_data)
    STX ZX0_INPUT+0
    STY ZX0_INPUT+1
    
    LDX #LO(LOAD_ADDR)
    LDY #HI(LOAD_ADDR)
    STX ZX0_OUTPUT+0
    STY ZX0_OUTPUT+1
    
    JSR dzx0_standard

.loop
    JMP loop
    
.test_data
    INCBIN ".\tests\test_0.bin.zx0"

.end

SAVE "ZX0TEST", start, end, entry_point

\ ******************************************************************
\ *	Memory Info
\ ******************************************************************

PRINT "------------------------"
PRINT "ZX0 Decompressor"
PRINT "------------------------"
PRINT "CODE size      = ", ~end-start
PRINT "------------------------"
PRINT "LOAD ADDR      = ", ~start
PRINT "HIGH WATERMARK = ", ~P%
PRINT "RAM BYTES FREE = ", ~&3000-P%
PRINT "------------------------"

PUTBASIC "loader.bas","LOADER"
PUTFILE  "BOOT","!BOOT", &FFFF  