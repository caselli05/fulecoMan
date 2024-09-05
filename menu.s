###############
# s0 =
# s1 = 
# s2 = endereco das notas
# s3 = numero de notas
# s4 =
# s5 =
# s6 =
# s7 = 
# s8 = mapa
# s9 = mapacColisao
# s10 = sprite fuleco
# s11 = fulecoInfo
.include "MACROSv21.s"

.text
COMECO: 
    # Setup musica
	la s2, NUM		# define o endereco do numero de notas
	lw s3, 0(s2)		# numero de notas
	la s2, NOTAS		#define o endereco das notas
	
	li a2, 32		# define o instrumento para notas
	li a3, 127		# define o volume para notas

	
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
	
	#verifica a tecla pressioanda
LOOP2:	li t1,0xFF200000	# carrega o endereco de controle do KDMMIO
	lw t0,0(t1)		# Le bit de Controle Teclado
	andi t0,t0,0x0001	# mascara o bit menos significativo
   	beq t0,zero,MUSIC   	# Se nao ha tecla pressionada entao vai para MUSIC
  	lw t2,4(t1)  		# le o valor da tecla tecla
	sw t2,12(t1)  		# escreve a tecla pressionada no display
	beq t2, t3, gameOneStart# vai pro mapa 1
	beq t2, t4, gameTwoStart# "hack" pro mapa 2
	
    #toca a musica
MUSIC:	beq t5, s3, FORA
	
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
	
gameOneStart:
    # setup dos sprites
	la s8, map1Collision
	la s9, map1
	la s10, fulecoLeft0
	call main
	
gameTwoStart:
    # setup dos sprites
	la s8, map2Collision
	la s9, map2
	la s10, fulecoLeft0
	call main
	
	j COMECO

end:
	li a7, 10
	ecall

.include "main.s"

.data
# Numero de Notas a tocar
NUM: .word 160
# lista de nota,duracao,nota,duraaoo,nota,duraaoo,...
NOTAS: 64, 200, 52, 200, 64, 200, 64, 200, 62, 200, 52, 200, 60, 200, 52, 200, 55, 200, 53, 200, 52, 200, 50, 200, 48, 200, 50, 200, 52, 200, 55, 200, 64, 200, 52, 200, 64, 200, 64, 200, 62, 200, 52, 200, 60, 200, 52, 200, 62, 200, 59, 200, 57, 200, 55, 200, 60, 200, 55, 200, 59, 200, 55, 200, 64, 200, 52, 200, 50, 200, 60, 200, 48, 200, 47, 200, 60, 200, 50, 200, 65, 200, 53, 200, 52, 200, 60, 200, 50, 200, 48, 200, 60, 200, 52, 200, 67, 200, 55, 200, 52, 200, 65, 200, 50, 200, 48, 200, 64, 200, 52, 200, 62, 200, 59, 200, 57, 200, 55, 200, 60, 200, 55, 200, 59, 200, 55, 200, 64, 200, 52, 200, 50, 200, 60, 200, 48, 200, 47, 200, 60, 200, 50, 200, 65, 200, 53, 200, 52, 200, 60, 200, 50, 200, 48, 200, 60, 200, 52, 200, 67, 200, 55, 200, 52, 200, 65, 200, 50, 200, 48, 200, 64, 200, 52, 200, 62, 200, 59, 200, 57, 200, 64, 200, 62, 200, 55, 200, 60, 200, 59, 200, 64, 200, 52, 200, 50, 200, 52, 200, 55, 200, 52, 200, 72, 200, 55, 200, 69, 200, 57, 200, 55, 200, 69, 200, 69, 200, 67, 200, 64, 200, 62, 200, 64, 200, 52, 200, 60, 200, 48, 200, 62, 200, 50, 200, 64, 200, 52, 200, 62, 200, 59, 200, 57, 200, 55, 200, 53, 200, 52, 200, 50, 200, 48, 200, 64, 200, 52, 200, 50, 200, 52, 200, 55, 200, 52, 200, 72, 200, 55, 200, 69, 200, 57, 200, 55, 200, 69, 200, 69, 200, 67, 200, 64, 200, 62, 200, 64, 200, 52, 200, 60, 200, 48, 200, 62, 200, 50, 200, 64, 200, 52, 200, 62, 200, 59, 200, 57, 200, 64, 200, 62, 200, 50, 200, 60, 200, 59, 200 

.include "sprites/Menu/arquivos .data/menu.data"			# inclui o .data com a menu
    # Mapa 1
.include "sprites/Mapas/arquivos .data/map1.data"			# inclui o .data com o mapa 1
.include "sprites/Mapas/arquivos .data/map1Collision.data"		# inclui o .data com as colisoes mapa 1
    # Mapa 2
.include "sprites/Mapas/arquivos .data/map2.data"			# inclui o .data com o mapa 2
.include "sprites/Mapas/arquivos .data/map2Collision.data"		# inclui o .data com as colisoes mapa 2
    # Sprites do Fuleco
.include "sprites/fuleco/arquivos .data/fulecoLeft0.data"		# inclui o .data com o Fuleco Left 0
.include "sprites/fuleco/arquivos .data/fulecoLeft1.data"		# inclui o .data com o Fuleco Left 1
.include "sprites/fuleco/arquivos .data/fulecoRight0.data"		# inclui o .data com o Fuleco Right 0
.include "sprites/fuleco/arquivos .data/fulecoRight1.data"		# inclui o .data com o Fuleco Right 1

.include "sprites/fuleco/arquivos .data/fulecoBallLeft0.data"		# inclui o .data com o Fuleco Ball Left 0
.include "sprites/fuleco/arquivos .data/fulecoBallLeft1.data"		# inclui o .data com o Fuleco Ball Left 1
.include "sprites/fuleco/arquivos .data/fulecoBallRight0.data"		# inclui o .data com o Fuleco Ball Right 0
.include "sprites/fuleco/arquivos .data/fulecoBallRight1.data"		# inclui o .data com o Fuleco Ball Right 1




	
	
	

