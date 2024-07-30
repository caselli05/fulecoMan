.data
.include "sprites\Menu\arquivos .data/menu.data"		# inclui o .data com a imagem


.text
	li s0,0xFF200604	# seleciona frame 0
	sw zero,0(s0)
	
	li s0,0xFF000000	# Frame0
	li s1,0xFF100000	# Frame1
	la t0,menu		# endere�o da imagem
	lw t1,0(t0)		# n�mero de linhas
	lw t2,4(t0)		# n�mero de colunas
	li t3,0			# contador
	mul t4,t1,t2		# numero total de pixels
	addi t0,t0,8		# primeiro pixel da imagem
LOOP: 	beq t3,t4,FORA		# Coloca a imagem no Frame0
	lw t5,0(t0)
	sw t5,0(s0)
	not t5, t5
	sw t5,0(s1)	
	addi t0,t0,4
	addi s0,s0,4
	addi s1,s1,4
	addi t3,t3,1
	j LOOP	
	
FORA:	li s0,0xFF200604	# Escolhe o Frame 0 ou 1
	li t2,0			# inicio Frame 0

	sw t2,0(s0)		# seleciona a Frame t2
	li t3, 49		# t3 = '1'
	li t4, '2'		# t4 = '2'
	
LOOP2:	li t1,0xFF200000	# carrega o endere�o de controle do KDMMIO
	lw t0,0(t1)		# Le bit de Controle Teclado
	andi t0,t0,0x0001	# mascara o bit menos significativo
   	beq t0,zero,LOOP2   	# Se n�o h� tecla pressionada ent�o vai para FIM
  	lw t2,4(t1)  		# le o valor da tecla tecla
	sw t2,12(t1)  		# escreve a tecla pressionada no display
	beq t2, t3, FIM		# vai pro mapa 1
	beq t2, t4, FIM		# "hack" pro mapa 2
	j LOOP2
	
FIM:	li s0,0xFF200604	# Escolhe o Frame 0 ou 1
	li t2,0			# inicio Frame 0
	xori t2,t2,0x001	# escolhe a outra frame
	sw t2,0(s0)		# seleciona a Frame t2
	
	li a7, 10
	ecall
	
	
	
	


