;written by Doug Fraker 2018
;v 1.01

.export _set_vram_buffer, _multi_vram_buffer_horz, _multi_vram_buffer_vert, _one_vram_buffer
.export _clear_vram_buffer


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

.segment "ZEROPAGE"

VRAM_INDEX:			.res 1
META_PTR:			.res 2
DATA_PTR:			.res 2

.segment "CODE"

.import _set_vram_update, _ppu_wait_nmi
.import popa, popax
.import _delay, _pal_bright
.importzp TEMP, FRAME_CNT1
.importzp _PAD_STATE
.importzp PPU_MASK_VAR, PPU_CTRL_VAR
;.importzp FT_SONG_SPEED
.importzp SCROLL_X, SCROLL_Y, RAND_SEED


PTR = TEMP

;void set_vram_buffer(void)
_set_vram_buffer:
	lda #$ff
	sta VRAM_BUF
	ldx #>VRAM_BUF
	lda #<VRAM_BUF
	jmp _set_vram_update
	
	

	
;void multi_vram_buffer_horz(char * data, unsigned char len, int ppu_address);
_multi_vram_buffer_horz:
	;note PTR = TEMP and TEMP+1

	ldy VRAM_INDEX
	sta VRAM_BUF+1, y
	txa
	clc
	adc #$40 ; NT_UPD_HORZ
	sta VRAM_BUF, y
	
_multi_vram_buffer_common:
	jsr popa ;len
		sta TEMP+3 ;loop count
		ldy VRAM_INDEX
		sta VRAM_BUF+2, y
	jsr popax ;pointer to data
		sta <PTR
		stx <PTR+1
	ldx VRAM_INDEX ;need y for source, x is for dest and for vram_index
		inx
		inx
		inx
		
	ldy #0
@loop:
	lda (PTR), y
	sta VRAM_BUF, x
	inx
	iny
	cpy TEMP+3
	bne @loop
	lda #$ff ;=NT_UPD_EOF
	sta VRAM_BUF, x
	stx VRAM_INDEX
	rts
	
	
	

;void multi_vram_buffer_vert(char * data, unsigned char len, int ppu_address);
_multi_vram_buffer_vert:
	ldy VRAM_INDEX
	sta VRAM_BUF+1, y
	txa
	clc
	adc #$80 ; NT_UPD_VERT
	sta VRAM_BUF, y
	
	jmp _multi_vram_buffer_common
	
	
	

;void one_vram_buffer(unsigned char data, int ppu_address);
_one_vram_buffer:
	ldy VRAM_INDEX
	sta VRAM_BUF+1, y
	txa
	sta VRAM_BUF, y
	iny
	iny
		sty <TEMP ;popa uses y
	jsr popa
		ldy <TEMP
	sta VRAM_BUF, y
	iny
	lda #$ff ;=NT_UPD_EOF
	sta VRAM_BUF, y
	sty VRAM_INDEX
	rts
	
	
	
	
;void clear_vram_buffer(void);	
_clear_vram_buffer:
	lda #0
	sta VRAM_INDEX
	lda #$ff
	sta VRAM_BUF
	rts
	
PTR2 = TEMP+2 ;and TEMP+3

