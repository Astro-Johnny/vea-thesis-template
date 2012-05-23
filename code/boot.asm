.include "JISonFUSIONr3.inc" ; The JSI include for Fusion device board
; REGISTERS AND CONSTANTS
.def _ZERO = 0         ; Register for zerofill
.def _TMP1 = 1         ; Temporary data register
.def _OUT_ITERATOR = 2 ; Register to hold Output Iterator/pointer
.def _ENDPOS_PTR = 4   ; Register to hold ending address of program
.def _SPI_RING_PTR = 3 ; Register to hold Ptr. to SPI I/O ring register

; SPI Flash memory read protocol.
.equ _READ_COMMAND = 0x03
; NOTE: The Fusion development kit board can have either
;       Winbond W25X16 or Atmel AT45DB161D SPI Flash chip.
;       The 0x03 command is slower, but common to both chips.

; This is a Boot ROM program, should start ar zero address
.org BOOT_ROM_START

_Init:
	; Enable SPI interface to read from SPI flash
	LDI _TMP1, (1<<DCR_SPI_FLASH_EN)|(SPI_16_MODE<<DCR_SPI_WIDTH)
	LDI _OUT_ITERATOR, DEVCTRL_REG_ADDR
	ST _OUT_ITERATOR, _TMP1	; Raises enable and 16 mode control bits

	; Transfer the opcode and address bytes (use 0x000000 for address)
	; Use "pseudo"-16bit mode (with two bytes sticked together)
	LDI _SPI_RING_PTR, SPI_RING_REG_ADDR
	LDI _TMP1, (_READ_COMMAND<<8)|(0x00) ; Prepare first word...
	ST _SPI_RING_PTR, _TMP1              ; ...and send
	LDI _ZERO, 0x0000
	ST _SPI_RING_PTR, _ZERO              ; then send extra two zero bytes
	
	; The transfer here is initiated and will continue while
	; DCR_SPI_FLASH_EN is kept high (i.e. respective CS signal kept low)
	
	LDI _OUT_ITERATOR, SRAM_A_START ; Initialise output iterator
	
	; FIXME: This is very naive implementation since we don't check
	;        where is the end of program (in fact we cannot).
	;        Should use an ELF executable image or similar.
	LDI _ENDPOS_PTR, SRAM_A_END+1
	
_Transfer:
	; Now send dummy zero bytes, and dump received program data to RAM
	; FIXME: This is very naive implementation since we don't check
	;        where is the end of program (in fact we cannot).
	;        Should use an ELF executable image or similar.
	ST _SPI_RING_PTR, _ZERO ; Send a dummy word
	LD _TMP1, _SPI_RING_PTR ; Read the received word back
	ST _OUT_ITERATOR, _TMP1 ; Dump data to RAM
	INC _OUT_ITERATOR       ; Advance iterator
	BRNQ _OUT_ITERATOR, _ENDPOS_PTR, _Transfer
	
_Prepare:
	; Prepare to switch to proper program
	; Start by shutting down the SPI transfer
	; Also disable the SPI Flash and interface
	LDI _TMP1, DEVCTRL_REG_ADDR
	ST _TMP1, _ZERO ; Zerofill control register
	
	; Clear all used register (just in case)
	;CLR _ZERO ; Never changed
	CLR _TMP1
	CLR _OUT_ITERATOR
	CLR _ENDPOS_PTR
	CLR _SPI_RING_PTR

	; Jump to program proper
	JMP SRAM_A_START-1 ; Jump to zero-th RAM address
	; NOTE: Since PC is incremented after jump, must use address-1

; Boot program size
;----------------------------------
; 10*dword instructions = 20w
; 12*word instructions  = 12w
; 0 words in data seg.  =  0w
;----------------------------------
;                 TOTAL = 32 words
