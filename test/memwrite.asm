START:
	LI		R0	0X80
	SLL		R0	R0	0X00
	LI		R1	0X10
	SW		R0	R1	0X00
	NOP
FOREVER:
	NOP
	B		FOREVER
	NOP
	NOP
