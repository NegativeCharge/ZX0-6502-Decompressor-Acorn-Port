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
    lda #&0b
    sta &fe00
    lda #&20
    sta &fe01

    ldx #LO(test_data)
    ldy #HI(test_data)
    stx ZX0_INPUT+0
    sty ZX0_INPUT+1
    
    ldx #LO(LOAD_ADDR)
    ldy #HI(LOAD_ADDR)
    stx ZX0_OUTPUT+0
    sty ZX0_OUTPUT+1
    
    jsr dzx0_standard

.loop
    jmp loop
    
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
PRINT "RAM BYTES FREE = ", ~LOAD_ADDR-P%
PRINT "------------------------"

PUTBASIC "loader.bas","LOADER"
PUTFILE  "BOOT","!BOOT", &FFFF  