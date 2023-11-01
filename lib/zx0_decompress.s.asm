.dzx0_standard
    lda   #$ff
    sta   offsetL
    sta   offsetH
    ldy   #$00
    sty   lenL
    sty   lenH
    lda   #$80
.dzx0s_literals
    jsr   dzx0s_elias
    pha
.cop0          
    jsr   get_byte
    ldy   #$00
    sta   (ZX0_OUTPUT),y
    inc   ZX0_OUTPUT
    bne   l0
    inc   ZX0_OUTPUT+1
.l0
    lda   #$ff
lenL=*-1
    bne   l1
    dec   lenH
.l1
    dec   lenL
    bne   cop0
    lda   #$ff
lenH=*-1
    bne   cop0
    pla
    asl   a
    bcs   dzx0s_new_offset
    jsr   dzx0s_elias
.dzx0s_copy    
    pha
    lda   ZX0_OUTPUT
    clc
    adc   #$ff
offsetL=*-1
    sta   COPY_SRC
    lda   ZX0_OUTPUT+1
    adc   #$ff
offsetH=*-1
    sta   COPY_SRC+1
    ldy   #$00
    ldx   lenH
    beq   remainder
.page         
    lda   (COPY_SRC),y
    sta   (ZX0_OUTPUT),y
    iny
    bne   page
    inc   COPY_SRC+1
    inc   ZX0_OUTPUT+1
    dex
    bne   page
.remainder     
    ldx   lenL
    beq   copyDone
.copyByte      
    lda   (COPY_SRC),y
    sta   (ZX0_OUTPUT),y
    iny
    dex
    bne   copyByte
    tya
    clc
    adc   ZX0_OUTPUT
    sta   ZX0_OUTPUT
    bcc   copyDone
    inc   ZX0_OUTPUT+1
.copyDone      
    stx   lenH
    stx   lenL
    pla
    asl   a
    bcc   dzx0s_literals
.dzx0s_new_offset
    ldx   #$fe
    stx   lenL
    jsr   dzx0s_elias_loop
    pha
    php                         ; stream
    ldx   lenL
    inx
    stx   offsetH
    bne   l2
    plp                         ; stream
    pla
    rts                         ; end
.l2
    jsr   get_byte
    plp                         ; stream
    sta   offsetL
    ror   offsetH
    ror   offsetL
    ldx   #$00
    stx   lenH
    inx
    stx   lenL
    pla
    bcs   l3
    jsr   dzx0s_elias_backtrack
.l3
    inc   lenL
    bne   l4
    inc   lenH
.l4
    jmp   dzx0s_copy
.dzx0s_elias   
    inc   lenL
.dzx0s_elias_loop
    asl   a
    bne   dzx0s_elias_skip
    jsr   get_byte
    sec                         ; stream
    rol   a
.dzx0s_elias_skip
    bcc   dzx0s_elias_backtrack
    rts
.dzx0s_elias_backtrack
    asl   a
    rol   lenL
    rol   lenH
    jmp   dzx0s_elias_loop
.get_byte    
    lda    $ffff
ZX0_INPUT=*-2
    inc    ZX0_INPUT
    bne    l5
    inc    ZX0_INPUT+1
.l5
    rts