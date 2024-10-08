###############
# s0 = vida
# s1 = alemanhaInfo
# s2 = endereco das notas
# s3 = numero de notas
# s4 = sprite Boateng
# s5 = sprite Gotze
# s6 = sprite Muller 
# s7 = sprite Kross
# s8 = mapa
# s9 = mapacColisao
# s10 = sprite fuleco
# s11 = fulecoInfo


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
	
FORA:	
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
	li s0, 3
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
        la s4, fixedBoateng0
        la s5, fixedMuller0
        la s6, fixedGotze0
        la s7, fixedKross0
	la s8, map1Collision
	la s9, map1
	la s10, fulecoLeft0
	call main
	
	sw zero, 12(s11)
gameTwoStart:
    # setup dos sprites
    	la s4, fixedBoateng0
    	la s5, fixedMuller0
    	la s6, fixedGotze0
    	la s7, fixedKross0
	la s8, map2Collision
	la s9, map2
	la s10, fulecoLeft0
	call main

youWinScreen:	
	la a0, youWin
	li a1, 0
	li a2, 0
	li a3, 0
	call print
	li a3, 1
	call print
	j typeEnd

gameOverScreen:
	la a0, gameOver
	li a1, 0
	li a2, 0
	li a3, 0
	call print
	li a3, 1
	call print
	j typeEnd

typeEnd:
	li t3, 49		# t3 = '1'
	li t1,0xFF200000	# carrega o endereco de controle do KDMMIO
	lw t0,0(t1)		# Le bit de Controle Teclado
	andi t0,t0,0x0001	# mascara o bit menos significativo
   	beq t0,zero, typeEnd   	# Se nao ha tecla pressionada entao vai para typeEnd
  	lw t2,4(t1)  		# le o valor da tecla tecla
	sw t2,12(t1)  		# escreve a tecla pressionada no display
	beq t2, t3, end		# vai pro mapa 1
	j typeEnd

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
.include "sprites/Menu/arquivos .data/gameOver.data"			# inclui o .data com a gameOver
.include "sprites/Menu/arquivos .data/youWin.data"			# inclui o .data com a youWin
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
    # Sprites do Boateng
.include "sprites/alemanha/arquivos .data/BoatengLeft0.data"		# inclui o .data com o Boateng Left 0
.include "sprites/alemanha/arquivos .data/BoatengLeft1.data"		# inclui o .data com o Boateng Left 1
.include "sprites/alemanha/arquivos .data/BoatengRight0.data"		# inclui o .data com o Boateng Right 0
.include "sprites/alemanha/arquivos .data/BoatengRight1.data"		# inclui o .data com o Boateng Right 1

.include "sprites/alemanha/argentina/arquivos .data/MascheranoLeft0.data"		# inclui o .data com o Boateng Left 0 Inv
.include "sprites/alemanha/argentina/arquivos .data/MascheranoLeft1.data"		# inclui o .data com o Boateng Left 1 Inv
.include "sprites/alemanha/argentina/arquivos .data/MascheranoRight0.data"	# inclui o .data com o Boateng Right 0 Inv
.include "sprites/alemanha/argentina/arquivos .data/MascheranoRight1.data"	# inclui o .data com o Boateng Right 1 Inv
    # Sprites do Muller
.include "sprites/alemanha/arquivos .data/MullerLeft0.data"		# inclui o .data com o Boateng Left 0
.include "sprites/alemanha/arquivos .data/MullerLeft1.data" 		# inclui o .data com o Boateng Left 1
.include "sprites/alemanha/arquivos .data/MullerRight0.data"		# inclui o .data com o Boateng Right 0
.include "sprites/alemanha/arquivos .data/MullerRight1.data"		# inclui o .data com o Boateng Right 1

.include "sprites/alemanha/argentina/arquivos .data/MessiLeft0.data"		# inclui o .data com o Boateng Left 0 Inv
.include "sprites/alemanha/argentina/arquivos .data/MessiLeft1.data" 		# inclui o .data com o Boateng Left 1 Inv
.include "sprites/alemanha/argentina/arquivos .data/MessiRight0.data"		# inclui o .data com o Boateng Right 0 Inv
.include "sprites/alemanha/argentina/arquivos .data/MessiRight1.data"		# inclui o .data com o Boateng Right 1 Inv
    # Sprites do Gotze
.include "sprites/alemanha/arquivos .data/GotzeLeft0.data"		# inclui o .data com o Gotze Left 0
.include "sprites/alemanha/arquivos .data/GotzeLeft1.data" 		# inclui o .data com o Gotze Left 1
.include "sprites/alemanha/arquivos .data/GotzeRight0.data"		# inclui o .data com o Gotze Right 0
.include "sprites/alemanha/arquivos .data/GotzeRight1.data"		# inclui o .data com o Gotze Right 1

.include "sprites/alemanha/argentina/arquivos .data/BigliaLeft0.data"		# inclui o .data com o Gotze Left 0 Inv
.include "sprites/alemanha/argentina/arquivos .data/BigliaLeft1.data" 		# inclui o .data com o Gotze Left 1 Inv
.include "sprites/alemanha/argentina/arquivos .data/BigliaRight0.data"		# inclui o .data com o Gotze Right 0 Inv
.include "sprites/alemanha/argentina/arquivos .data/BigliaRight1.data"		# inclui o .data com o Gotze Right 1 Inv
    # Sprites do Kross
.include "sprites/alemanha/arquivos .data/KrossLeft0.data"		# inclui o .data com o Kross Left 0
.include "sprites/alemanha/arquivos .data/KrossLeft1.data" 		# inclui o .data com o Kross Left 1
.include "sprites/alemanha/arquivos .data/KrossRight0.data"		# inclui o .data com o Kross Right 0
.include "sprites/alemanha/arquivos .data/KrossRight1.data"		# inclui o .data com o Kross Right 1

.include "sprites/alemanha/argentina/arquivos .data/DiMariaLeft0.data"		# inclui o .data com o Kross Left 0 Inv
.include "sprites/alemanha/argentina/arquivos .data/DiMariaLeft1.data" 		# inclui o .data com o Kross Left 1 Inv
.include "sprites/alemanha/argentina/arquivos .data/DiMariaRight0.data"		# inclui o .data com o Kross Right 0 Inv
.include "sprites/alemanha/argentina/arquivos .data/DiMariaRight1.data"		# inclui o .data com o Kross Right 1 Inv
    # HUD
.include "sprites/numbers/arquivos .data/zero.data"
.include "sprites/numbers/arquivos .data/one.data"
.include "sprites/numbers/arquivos .data/two.data"
.include "sprites/numbers/arquivos .data/three.data"
.include "sprites/numbers/arquivos .data/four.data"
.include "sprites/numbers/arquivos .data/five.data"
.include "sprites/numbers/arquivos .data/six.data"
.include "sprites/numbers/arquivos .data/seven.data"
.include "sprites/numbers/arquivos .data/eight.data"
.include "sprites/numbers/arquivos .data/nine.data"
.include "sprites/numbers/arquivos .data/score.data"
.include "sprites/numbers/arquivos .data/heart.data"




	
	
	

