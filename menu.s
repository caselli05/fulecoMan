###############
# s0 = Frame 0
# s1 = Frame 1
# s2 = endereco das notas
# s3 = numero de notas
# s4 = endereco das notas2
# s5 = numero de notas 2
# s6 = contador de 16
# s7
# s8
# s9 
# s10
# s11 =
# a2 = instrumento para notas
# a4 = instrumento para notas2 
# a3 = volume para notas
# a5 = contador de notas
# a6 = contador de notas2
.data
# Numero de Notas a tocar
NUM: .word 160
NUM2: .word 20
# lista de nota,duracao,nota,duraaoo,nota,duraaoo,...
NOTAS: 64, 200, 52, 200, 64, 200, 64, 200, 62, 200, 52, 200, 60, 200, 52, 200, 55, 200, 53, 200, 52, 200, 50, 200, 48, 200, 50, 200, 52, 200, 55, 200, 64, 200, 52, 200, 64, 200, 64, 200, 62, 200, 52, 200, 60, 200, 52, 200, 62, 200, 59, 200, 57, 200, 55, 200, 60, 200, 55, 200, 59, 200, 55, 200, 64, 200, 52, 200, 50, 200, 60, 200, 48, 200, 47, 200, 60, 200, 50, 200, 65, 200, 53, 200, 52, 200, 60, 200, 50, 200, 48, 200, 60, 200, 52, 200, 67, 200, 55, 200, 52, 200, 65, 200, 50, 200, 48, 200, 64, 200, 52, 200, 62, 200, 59, 200, 57, 200, 55, 200, 60, 200, 55, 200, 59, 200, 55, 200, 64, 200, 52, 200, 50, 200, 60, 200, 48, 200, 47, 200, 60, 200, 50, 200, 65, 200, 53, 200, 52, 200, 60, 200, 50, 200, 48, 200, 60, 200, 52, 200, 67, 200, 55, 200, 52, 200, 65, 200, 50, 200, 48, 200, 64, 200, 52, 200, 62, 200, 59, 200, 57, 200, 64, 200, 62, 200, 55, 200, 60, 200, 59, 200, 64, 200, 52, 200, 50, 200, 52, 200, 55, 200, 52, 200, 72, 200, 55, 200, 69, 200, 57, 200, 55, 200, 69, 200, 69, 200, 67, 200, 64, 200, 62, 200, 64, 200, 52, 200, 60, 200, 48, 200, 62, 200, 50, 200, 64, 200, 52, 200, 62, 200, 59, 200, 57, 200, 55, 200, 53, 200, 52, 200, 50, 200, 48, 200, 64, 200, 52, 200, 50, 200, 52, 200, 55, 200, 52, 200, 72, 200, 55, 200, 69, 200, 57, 200, 55, 200, 69, 200, 69, 200, 67, 200, 64, 200, 62, 200, 64, 200, 52, 200, 60, 200, 48, 200, 62, 200, 50, 200, 64, 200, 52, 200, 62, 200, 59, 200, 57, 200, 64, 200, 62, 200, 50, 200, 60, 200, 59, 200 
NOTAS2: 36, 1600, 41, 1600, 33, 1600, 43, 1600, 36, 1600, 38, 1600, 40, 1600, 43, 1600, 36, 1600, 38, 1600, 40, 1600, 43, 1600, 36, 1600, 41, 1600, 33, 1600, 43, 1600, 36, 1600, 41, 1600, 33, 1600, 43, 1600 

.include "sprites/Menu/arquivos .data/menu.data"			# inclui o .data com a menu
.include "sprites/Mapas/arquivos .data/map1.data"			# inclui o .data com o mapa 1
.include "sprites/fuleco/arquivos .data/fixedFuleco0.data"		# inclui o .data com o Fuleco 1
.include "sprites/Mapas/arquivos .data/testeCollision.data"		# inclui o .data com as colisoes mapa


.text
    # Setup musica
	la s2, NUM		# define o endereco do numero de notas
	lw s3, 0(s2)		# numero de notas
	la s2, NOTAS		#define o endereco das notas
	
	la s4, NUM2		# definde o endereco do numero de notas2
	lw s5, 0(s4)		# le o numero de notas2
	la s4, NOTAS2		# define o endereco das notas2
	
	li a2, 32		# define o instrumento para notas
	li a4, 128		# define o instrumento para notas2 
	li a3, 127		# define o volume para notas
	li s6, 16		# contador de 16 para notas 2
	
    # Setup tela 
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
	
	li t5, 0
	li t6, 0
	mv a5, s2
	mv a6, s4
	
	#verifica a tecla pressioanda
LOOP2:	li t1,0xFF200000	# carrega o endereco de controle do KDMMIO
	lw t0,0(t1)		# Le bit de Controle Teclado
	andi t0,t0,0x0001	# mascara o bit menos significativo
   	beq t0,zero,MUSIC   	# Se nao ha tecla pressionada entao vai para MUSIC
  	lw t2,4(t1)  		# le o valor da tecla tecla
	sw t2,12(t1)  		# escreve a tecla pressionada no display
	beq t2, t3, gameOneStart# vai pro mapa 1
	beq t2, t4, end		# "hack" pro mapa 2
	
    #toca a musica
MUSIC:	beq t5, s3, FORA
	beq t5, s6, DOIS
	
MUSIC2:	lw a0, 0(a5)
	lw a1, 4(a5)
	li a7, 31
	ecall
	
	addi a1, a1, -5
	mv a0, a1
	li a7, 32
	ecall

	addi a5, a5, 8
	addi t5, t5, 1
	
	j LOOP2
	
DOIS:	lw a0, 0(a6)
	lw a1, 4(a6)
	li a7, 31
	ecall
	
	addi s6, s6, 8
	addi a6, a6, 8
	addi t5, t5, 1
	j MUSIC2
	
	
gameOneStart:
	la s8, testeCollision
	la s9, map1
	la s10, fixedFuleco0
	jal a6, main


end:
	li a7, 10
	ecall

.include "main.s"


	
	
	


