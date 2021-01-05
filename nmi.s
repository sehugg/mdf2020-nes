;NMI handler

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
VRAM_BUF	=$0700

.export _nmi_user_1, _nmi_user_2, _nmi_user_0
_nmi_user_1 = nmiUserCall
_nmi_user_2 = nmiUserCall2
_nmi_user_0 = nmiUserCall0

.importzp PPU_CTRL_VAR
.importzp SCROLL_X, SCROLL_Y

.import _eqValues
.import _famitone_update

.import _krujFill
.import _krujFillAdr
.import _krujFillVal1
.import _krujFillVal2

nmiUserCall0: 
        jsr _famitone_update
        rts


nmiUserCall2: 
	lda #%00100010
	ldx #%00000010
	sta banktable, x

	lda _krujFill
	beq @1
	
	lda <PPU_CTRL_VAR
	and #%11111011
	sta PPU_CTRL

	lda _krujFillAdr
	clc
	adc #$D8
	tax
	lda _krujFillVal1
	jsr krujFillProc

	lda #$e1
	clc
	sbc _krujFillAdr
	tax
	lda _krujFillVal2
	jsr krujFillProc	
	
	
@1:

	lda <PPU_CTRL_VAR
	and #%11111011
	sta PPU_CTRL

	lda #0
	sta PPU_ADDR
	sta PPU_ADDR

	lda <SCROLL_X
	sta PPU_SCROLL
	lda <SCROLL_Y
	sta PPU_SCROLL

	lda <PPU_CTRL_VAR
	sta PPU_CTRL
	rts
	jmp _famitone_update
        
krujFillProc:
	ldy #$23
	sty PPU_ADDR
	stx PPU_ADDR
	sta PPU_DATA
	sta PPU_DATA
	sta PPU_DATA
	sta PPU_DATA
	sta PPU_DATA
	sta PPU_DATA
	sta PPU_DATA
	sta PPU_DATA
	rts
	

nmiUserCall:
	
	lda <PPU_CTRL_VAR
	and #%11111011
	adc #04
	sta PPU_CTRL

	lda	#$21
	sta	PPU_ADDR
	lda	#$6E
	sta	PPU_ADDR
	
	lda	_eqValues + 0
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 1
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 2
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 3
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 4
	sta	PPU_DATA
	
	lda	#$21
	sta	PPU_ADDR
	lda	#$70
	sta	PPU_ADDR
	
	lda	_eqValues + 0
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 1
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 2
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 3
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 4
	sta	PPU_DATA
	
	lda	#$21
	sta	PPU_ADDR
	lda	#$6C
	sta	PPU_ADDR

	lda	_eqValues + 0 + 5
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 1 + 5
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 2 + 5
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 3 + 5
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 4 + 5
	sta	PPU_DATA
	
	lda	#$21
	sta	PPU_ADDR
	lda	#$72
	sta	PPU_ADDR

	lda	_eqValues + 0 + 5
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 1 + 5
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 2 + 5
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 3 + 5
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 4 + 5
	sta	PPU_DATA

	lda	#$21
	sta	PPU_ADDR
	lda	#$6A
	sta	PPU_ADDR
	
	lda	_eqValues + 0 + 10
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 1 + 10
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 2 + 10
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 3 + 10
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 4 + 10
	sta	PPU_DATA

	lda	#$21
	sta	PPU_ADDR
	lda	#$74
	sta	PPU_ADDR
	
	lda	_eqValues + 0 + 10
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 1 + 10
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 2 + 10
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 3 + 10
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 4 + 10
	sta	PPU_DATA

	lda	#$21
	sta	PPU_ADDR
	lda	#$28
	sta	PPU_ADDR
	
	lda	_eqValues + 0 + 15
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 1 + 15
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 2 + 15
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 3 + 15
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 4 + 15
	sta	PPU_DATA

	lda	#$21
	sta	PPU_ADDR
	lda	#$36
	sta	PPU_ADDR
	
	lda	_eqValues + 0 + 15
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 1 + 15
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 2 + 15
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 3 + 15
	sta	PPU_DATA
	lda	PPU_DATA
	lda	_eqValues + 4 + 15
	sta	PPU_DATA

	lda <PPU_CTRL_VAR
	and #%11111011
	sta PPU_CTRL

	lda #0
	sta PPU_ADDR
	sta PPU_ADDR

	lda <SCROLL_X
	sta PPU_SCROLL
	lda <SCROLL_Y
	sta PPU_SCROLL

	lda <PPU_CTRL_VAR
	sta PPU_CTRL


	jmp _famitone_update
	
	
.segment "RODATA"
banktable:              ; Write to this table to switch banks.
  .byte $00, $01, $02, $03
