.segment "CODE"

.importzp TEMP
.import popax
.importzp FT_TEMP

PPU_CTRL	=$2000
PPU_MASK	=$2001
PPU_STATUS	=$2002
PPU_OAM_ADDR=$2003
PPU_OAM_DATA=$2004
PPU_SCROLL	=$2005
PPU_ADDR	=$2006
PPU_DATA	=$2007
PPU_OAM_DMA	=$4014
PPU_FRAMECNT=$4017
DMC_FREQ	=$4010
CTRL_PORT1	=$4016
CTRL_PORT2	=$4017

OAM_BUF		=$0200
PAL_BUF		=$01c0
VRAM_BUF	=$0600

.export _cnrom_set_bank
_cnrom_set_bank:
	lda #3
	tax
	ora secureTable, x
	sta banktable, x
	rts

.export _get_mus_pos
;unsigned int __fastcall__ get_mus_pos(void);
_get_mus_pos:
	lda FT_TEMP+3
	ldx FT_TEMP+4
	rts

.export _xy_split
;void __fastcall__ xy_split(unsigned int x, unsigned int y);
_xy_split:
	;Nametable number << 2 (that is: $00, $04, $08, or $0C) to $2006
	;Y to $2005
	;X to $2005
	;Low byte of nametable address to $2006, which is ((Y & $F8) << 2) | (X >> 3)

	sta <TEMP+2 ;y low
	stx <TEMP+3
	jsr popax
	sta <TEMP ;x low
	stx <TEMP+1
	
;push to stack in reverse order	
	lda <TEMP+2 ;low y
	and #$f8
	asl a
	asl a
	sta <TEMP+4
	lda <TEMP ;low x
	lsr a
	lsr a
	lsr a
	ora <TEMP+4
	pha
	
	lda <TEMP ;low x
	pha
	
	lda <TEMP+2 ;low y
	pha

	lda <TEMP+3 ;y high
	and #$01
	asl a
	sta <TEMP+4
	lda <TEMP+1 ;x high
	and #$01
	ora <TEMP+4
	asl a
	asl a
	pha

@3:

	bit PPU_STATUS
	bvs @3

@4:

	bit PPU_STATUS
	bvc @4


	;--- set back color = text palette roll
	;lda  #$3F
 	;sta  PPU_ADDR
 	;lda  #$00
 	;sta  PPU_ADDR
 	;lda  <NMI_SCROLL_TEXT_COLOR
 	;sta  PPU_DATA

	;lda #7
	;jsr _delay_a_25_clocks

	pla
	sta $2006
	pla
	sta $2005
	pla
	sta $2005
	pla
	sta $2006
	rts

.export _split_krujeva
;void __fastcall__ split_krujeva(void);
_split_krujeva:
	lda #%11000000
@3:
	bit PPU_STATUS
	bvs @3

@4:
	bit PPU_STATUS
	bvc @4

	lda #$00
	sta $2003
	sta $2004

	ldx #$8B
@5:
	dex
	bmi @5

	lda #%00110011
	ldx #%00000011
	sta banktable, x

	rts
        
.segment "RODATA"
banktable:              ; Write to this table to switch banks.
  .byte $00, $01, $02, $03
secureTable:
	.byte $00, $10, $20, $30