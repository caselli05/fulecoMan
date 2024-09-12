.include "MACROSv21.s"
.data
SCR: .string  	 "SCORE:"

.text
loop:
	la a0,SCR  	#salva o endere�o da string
	li a1,10        #pixel da coluna
	li a2,5		#pixel da linha
	li a3,0x00FF	#2 primeiros:cor do fundo  2 ultimos:cor da palavra
	li a4,0		#frame
	li a7,104	#104: print string
	ecall
	
	li a0,40		#imprimir o score
	li a1,60
	li a2, 5
	li a3, 0x00FF
	li a4,0
	li a7,101	#101: print int
	ecall
	
	j loop
	
	li a7,10
	ecall

.include "SYSTEMv21.s"
