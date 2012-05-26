; Bloka kopeeshanas proga (JSI - John's instruction set :D )
.def SRC = 1	; (Regjistrs 1) Kopeeshanas iterators - ievaddati
.def DEST = 2	; (Regjistrs 2) Kopeeshanas iterators - izvades adrese
.def TEMP = 3	; (Regjistrs 3) Buferis datu pagaidu uzglabaashanai
.def END = 6	; (Regjistrs 6) Ievaddatu bloka beigu adrese - nosaciijumam

.equ SRC_START = 0x11	; Kopeejamaa datu bloka saakuma adrese
.equ DEST_START = 0x30	; Izvades bloka saakuma adrese
.equ DATALEN = 16		; Datu bloka garums

Init:
	; Inicializee iteratoru saakuma veertiibas
	LDI SRC, SRC_START
	LDI DEST, DEST_START
	
	; Inicializee bloka beigu adreses veertiibu ("konstanti")
	LDI END, SRC_START + DATALEN

Loop:
	; Nosaciijuma paarbaude (saakumaa for/while stilaa)
	BRGE SRC, END, Finish	; if (SRC >= END) GOTO Finish;

	; Paarkopeet vienu elementu
	LD TEMP, SRC	; TEMP = *SRC;
	ST DEST, TEMP	; *DEST = TEMP;
	
	; Palielinaat iteratorus
	INC SRC		; SRC++;
	INC DEST	; DEST++;
	
	; Atsaakt ciklu
	JMP Loop

Finish:
	HLT	; Paartraukt darbiibu
	JMP Init ; Beznosaciijuma leciens uz saakumu (ja iziet no HLT)
	
; Dati
.org SRC_START
.dw 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16

