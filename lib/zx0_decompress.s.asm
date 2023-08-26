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
              bne   skip
              inc   ZX0_OUTPUT+1
.skip
              lda   #$ff
lenL=*-1
              bne   label1
              dec   lenH
.label1
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
              sta   copysrc
              lda   ZX0_OUTPUT+1
              adc   #$ff
offsetH=*-1
              sta   copysrc+1
              ldy   #$00
              ldx   lenH
              beq   Remainder
.Page         
              lda   (copysrc),y
              sta   (ZX0_OUTPUT),y
              iny
              bne   Page
              inc   copysrc+1
              inc   ZX0_OUTPUT+1
              dex
              bne   Page
.Remainder     
              ldx   lenL
              beq   copyDone
.copyByte      
              lda   (copysrc),y
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
              asl   A
              bcc   dzx0s_literals
.dzx0s_new_offset
              ldx   #$fe
              stx   lenL
              jsr   dzx0s_elias_loop
              pha
 php ; stream
              ldx   lenL
              inx
              stx   offsetH
              bne   label2
 plp ; stream
              pla
              rts           ; koniec
.label2
              jsr   get_byte
 plp ; stream
              sta   offsetL
              ror   offsetH
              ror   offsetL
              ldx   #$00
              stx   lenH
              inx
              stx   lenL
              pla
              bcs   label3
              jsr   dzx0s_elias_backtrack
.label3
              inc   lenL
              bne   label4
              inc   lenH
.label4
              jmp   dzx0s_copy
.dzx0s_elias   
              inc   lenL
.dzx0s_elias_loop
              asl   a
              bne   dzx0s_elias_skip
              jsr   get_byte
sec ; stream
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
              bne    skip2
              inc    ZX0_INPUT+1
.skip2
              rts