main:
	mv a6, ra
    # print map in frame 0
    	mv a0, s9
	li a1, 0
	li a2, 0
	li a3, 0
	call print
    # print map in frame 1
	li a1, 0
	li a2, 0
	li a3, 1
	call print
	
    # print fuleco in start position
    	li s3, 144			# posX fuleco
    	li s4, 176			# posY fuleco
    	mv a0, s10
	li a1, 144
	li a2, 176
	call print
	
	
	li s0, 0			# s0 = runing state : 0 = stop // 1 = left // 2 = right // 3 = up // 4 = down
	li s1, 0
	
loopgame:
	xori a3, a3, 1			# change frame 0 <--> 1
    # print map
    	mv a0, s9
    	li a1, 0
    	li a2, 0
    	call print
    	
    # print props
    	mv a0, s8
    	li a1, 0
    	li a2, 0
    	call printProps 

input:
	mv a1, s3
	mv a2, s4
	
	li t2, 0
	li t1,0xFF200000		# load KDMMIO andress
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
	beq t0,zero, goLeft  		# Se nao ha tecla pressionada entao vai clickLeft
	lw t2,4(t1)  			# le o valor da tecla tecla
	sw t2,12(t1)  			# escreve a tecla pressionada no display    		
		
clickLeft:
	mv a0, s8

	li t1, 'a'
	bne t2, t1, clickRight		# verifica se foi apertado a tecla 'a'
	
	addi a1, a1, -4			# update temporario da posicao para 4 pixels para esquerda
	call checkCollision		# check da colisao superior esquerda
	addi a1, a1, 4			# cancela o update temporario do eixo X
	beqz t1, goLeft			# se ha colisao, pula para "goLeft"
	
	addi a1, a1, -4			# update temporario da posicao para 4 pixels para esquerda
	addi a2, a2, 12			# update temporario da posicao para 15 pixels para baixo
	call checkCollision		# check da colisao superior esquerda
	addi a1, a1, 4			# cancela o update temporario do eixo X
	addi a2, a2, -12		# cancela o update temporario do eixo Y
	beqz t1, goLeft			# se ha colisao, pula para "goLeft"
	
	li s0, 1			# muda o s0 para 1
clickRight:
	li t1, 'd'
	bne t2, t1, clickUp		# verirfica se foi apertado a tecla 'd'
	
	addi a1, a1, 16			# update temporario do eixo X para a direita 
	call checkCollision		# check de colisao superior direita
	addi a1, a1, -16		# cancela o update temporario do eixo X para a direita
	li t0, 0			# t0 = 0
	beqz t1, goLeft			# se ha colisao, pula para "goLeft"
	
	addi a1, a1, 16			# update temporario do eixo X para a diereita
	addi a2, a2, 12			# update temporario do eixo Y para baixo
	call checkCollision		# check de colisao inferior direita
	addi a1, a1, -16		# cancela o update temporario do eixo X para a direita
	addi a2, a2, -12		# cancela o update temporario do eixo Y para a esquerda	
	beqz t1, goLeft			# se ha colisao, pula para "goLeft"
	
	li s0, 2
clickUp:	
	li t1, 'w'
	bne t2, t1, clickDown		# verifica se foi apertado a tecla 'w'
	
	addi a2, a2, -4			# update temporario do eixo Y para cima
	call checkCollision		# update de colisao superior esquerda
	addi a2, a2, 4			# cancela o update temporario do eixo Y
	beqz t1, goLeft			# se ha colisao, pula para "goLeft"
	
	addi a2, a2, -4			# update temporario do eixo Y para cima
	addi a1, a1, 12			# update temporario do eixo X para cima
	call checkCollision		# update de colisao superior esquerda
	addi a2, a2, 4			# cancela o update temporario do eixo Y
	addi a1, a1, -12		# cancela o update temporario do eixo X
	beqz t1, goLeft			# se ha colisao, pula para "goLeft"
	
	li s0, 3
clickDown:
	li t1, 's'
	bne t2, t1, goLeft
	
	addi a2, a2, 16			# update temporario do eixo Y para baixo
	call checkCollision		# update de colisao superior esquerda
	addi a2, a2, -16		# cancela o update temporario do eixo Y
	beqz t1, goLeft			# se ha colisao, pula para "goLeft"
	
	addi a2, a2, 16			# update temporario do eixo Y para baixo
	addi a1, a1, 12			# update temporario do eixo X para cima
	call checkCollision		# update de colisao superior esquerda
	addi a2, a2, -16		# cancela o update temporario do eixo Y
	addi a1, a1, -12		# cancela o update temporario do eixo X
	beqz t1, goLeft			# se ha colisao, pula para "goLeft"
	
	li s0, 4
	
goLeft:
	mv a0, s8

	li t1, 1
	bne s0, t1, goRight		# check if s0 = 1
	
	addi a1, a1, -4			# update temporario da posicao para 4 pixels para esquerda
	call checkCollision		# check da colisao superior esquerda
	li t0, 0			# t0 = 0
	addi a1, a1, 4			# cancela o update temporario do eixo X
	beq t1, t0, pass		# se ha colisao, pula para "pass"
	
	addi a1, a1, -4			# update da posicao para 4 pixels para esquerda
	addi a2, a2, 15			# update da posicao para 15 pixels para baixo
	call checkCollision		# check da colisao inferior esquerda
	li t0, 0			# t0 = 0
	addi a1, a1, 4			# cancela o update temporario do eixo X
	addi a2, a2, -15		# cancela o update temporario do eixo Y
	beq t1, t0, pass		# se ha colisao, pula para "pass"
	
	addi a1, a1, -4			# update da posicao para 4 pixels para a esquerda
	
goRight:
	li t1, 2
	bne s0, t1, goUp		# check if s0 = 2
	
	addi a1, a1, 16			# update temporario do eixo X para a direita 
	call checkCollision		# check de colisao superior direita
	addi a1, a1, -16		# cancela o update temporario do eixo X para a direita
	li t0, 0			# t0 = 0
	beq t1, t0, pass		# se ha colisao, pula para "pass"
	
	addi a1, a1, 16			# update temporario do eixo X para a diereita
	addi a2, a2, 15			# update temporario do eixo Y para baixo
	call checkCollision		# check de colisao inferior direita
	addi a1, a1, -16		# cancela o update temporario do eixo X para a direita
	addi a2, a2, -15		# cancela o update temporario do eixo Y para a esquerda
	li t0, 0			# t0 = 0
	beq t1, t0, pass		# se ha colisao, pula para "pass"
	
	addi a1, a1, 4			# update da posicao para 4 pixels para a direita	
goUp:	
	li t1, 3
	bne s0, t1, goDown		# check if s0 = 3
	
	addi a2, a2, -4			# update temporario do eixo Y para cima
	call checkCollision		# check de colisao superior equerda
	addi a2, a2, 4			# cancela o update temporario do eixo Y
	li t0, 0			# t0 = 0
	beq t1, t0, pass		# se ha colisao, pula para "pass"
	
	addi a2, a2, -4			# update temporario do eixo Y para cima
	addi a1, a1, 12			# update temporario do eixo X para direita
	call checkCollision		# check de colisao superior direito
	addi a2, a2, 4			# cancela update temporario do eixo Y para cima
	addi a1, a1, -12		# cancela update temporario do eixo X para direita
	li t0, 0			# t0 = 0
	beq t0, t1, pass		# se ha colisao, pula para "pass"
	
	addi a2, a2, -4			# update da posicao para 4 pixels para a cima
goDown:
	li t1, 4
	bne s0, t1, pass		# check if s0 = 4
	
	addi a2, a2, 16			# update temporario do eixo Y para baixo
	call checkCollision		# check de colisao inferior equerda
	addi a2, a2, -16			# cancela o update temporario do eixo Y
	li t0, 0			# t0 = 0
	beq t1, t0, pass		# se ha colisao, pula para "pass"
	
	addi a2, a2, 16			# update temporario do eixo Y para baixo
	addi a1, a1, 12			# update temporario do eixo X para direita
	call checkCollision		# check de colisao superior direito
	addi a2, a2, -16		# cancela o update temporario do eixo Y 
	addi a1, a1, -12		# cancela o update temporario do eixo X
	li t0, 0			# t0 = 0
	beq t0, t1, pass		# se ha colisao, pula para "pass"
	
	addi a2, a2, 4			# update da posicao para 4 pixels para a cima
pass:	
	li t1, 0			# t1 = 0
	bne a1, t1, dontTeleportLeft	# se posX != 0, pula pra "dontTeleportLeft"
	li t1, 64			# t1 = 64
	bne a2, t1, dontTeleportLeft	# se posY != 64, pula pra "dontTeleportLeft"
	li t1, 2			# t1 = 2
	beq s0, t1, dontTeleportLeft	# se movState == right, pula pra "dontTeleportLeft" 
	li a1, 288			# usa o teleporte da esquerda
dontTeleportLeft:	
	li t1, 300			# t1 = 300
	bne a1, t1, dontTeleportRight	# se posX != 300, pula pra "dontTeleportRight"
	li t1, 64			# t1 = 64
	bne a2, t1, dontTeleportLeft	# se posY != 64, pula pra "dontTeleportRight"
	li t1, 1			# t1 = 1
	beq s0, t1, dontTeleportRight	# se movState == left, pula pra "dontTeleportRight"
	li a1, 0			# usa o teleporte da direita
dontTeleportRight:
	li t0, 0
	bne a3, t0, animation1
	mv a0, s10			# a0 = endereco do Fuleco 0
	mv s3, a1			# s3 = posX
	mv s4, a2			# s4 = posY
	call print			# printa fuleco
	li t0, 4096
	add s10, s10, t0		# s10 = Fuleco 1
animation1:
	li t1, 1
	bne t1, a3, checkPoints
	mv a0, s10			# a0 = endereco do Fuleco 1
	mv s3, a1			# s3 = posX
	mv s4, a2			# s4 = posY
	call print			# printa fuleco
	li t0, 4096
	sub s10, s10, t0

checkPoints:
    # checa contato com os pontos
	li t0, 320			# t0 = 320	
	
	add t2, s8, s3			# t2 = endereco + s3
	mul t3, s4, t0			# t3 = s4*320
	add t0, t2, t3			# t0 = t2 + t3 = endereco + a1 + a2*320
	
	lw t2, 8(t0)			# t2 = t0 + 4
	andi t2, t2, 0x000FF		# t2 = 8 bits menos signficativos

	li t1, 7			# t1 = 7	
	bne t1, t2, dontAddPoints	# se t1 != t2, pula pra "dontAddPoints"
	li t1, 17			# t1 = 17		 
	sw t1, 8(t0)			# guarda 17 no endereco que a bolinha recem pegada estava
	addi s1, s1, 1			# adiciona 1 ponto
	li t1, 115			# t1 = 115
	beq s1, t1, endGame		# se pontos == 115, acaba a run
	
dontAddPoints:
	li t1, 192
	bne t1, t2, dontBeSuper
	li t1, 17
	sw t1, 8(t0)
	# trocar o estado de superfuleco
	
dontBeSuper:
	li a0,76			# pausa de 76m segundos
	li a7,32
	ecall
	
	j loopgame
	
endGame:
	mv ra, a6		
	ret
	
.include "src/print.s"
.include "src/checkCollision.s"
.include "src/printProps.s"

.data
space: .string " "
.include "sprites/props/arquivos .data/dot.data"
.include "sprites/props/arquivos .data/brazuca.data"
 
	
