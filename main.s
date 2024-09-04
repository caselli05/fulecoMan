main:
	mv a6, ra			# a6 = return adress
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
	
    # setup Fuleco
    	la s11, fulecoInfo		# s11 = fulecoInfoAdress
    	li t0, 144			# t0 = 144
    	sw t0, 0(s11)			# guarda a posX inicial do fuleco em 0(s11)
	li t1, 176			# t1 = 176
	sw t1, 4(s11)			# guarda a posY inicial do fulecom em 4(s11)
	li t2, 0			# t2 = 0
	sw t2, 8(s11)			# comeca o runningState para 0
	li t3, 0			# t3 = 0
	sw t3, 12(s11)			# comeca os pontos para 0
	li t4, 0			# t4 = 0
	sw t4, 16(s11)			# comeca o superState para 0
	li t5, 1			# t5 = 0
	sw t5, 20(s11)			# comeca o frameAnimacao em 1
	sw t4, 24(s11)			# comeca o leftOrRight em  0 (left)
	
	mv a0, s10
	li a1, 144
	li a2, 176
	call print
	
    # setup Boateng
    	la s1, germanyInfo		# s1 = germanyInfo
    	li t1, 114			# t1 = 144
    	li t2, 128			# t2 = 128
    	sw t1, 0(s1)			# posXBoa = 144
    	sw t2, 4(s1)			# posYBoa = 128
    	li t1, -13			
    	sw t1, 8(s1)			# timeOutBoa = -130
	li t0, 0			
	sw t0, 12(s1)			# comeca o leftOrRightBoa em 0(left)
	
	
	li a3, 0
loopgame:
	li a3, 0
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
    # get input
	lw a1, 0(s11)			# pega a posX e guarda em a1
	lw a2, 4(s11)			# pega a posY e gurada em a2
	
	li t2, 0
	li t1,0xFF200000		# load KDMMIO andress
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
	beq t0,zero, goLeft  		# Se nao ha tecla pressionada entao vai clickLeft
	lw t2,4(t1)  			# le o valor da tecla tecla
	sw t2,12(t1)  			# escreve a tecla pressionada no display    		
		
clickLeft:
	mv a0, s8			# a0 = testeCollision

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
	
	li t1, 1
	sw t1, 8(s11)			# muda o runningState para 1
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
	
	li t1, 2
	sw t1, 8(s11)			# muda o runningState para 2
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
	
	li t1, 3
	sw t1, 8(s11)			# muda o runningState para 3
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
	
	li t1, 4
	sw t1, 8(s11)			# muda o runningState para  4
	
    # fuleco
goLeft:
	mv a0, s8

	lw t2, 8(s11)			# t2 = runningState
	li t1, 1
	bne t2, t1, goRight		# check if t2 = 1
		
	li t1, 0			# t1 = 0
	lw t0, 24(s11)			# t0 = leftOrRight
	beq t1, t0, dontChangeFulecoToLeft
	addi s10, s10, -528		# s10 += 528
	sw t1, 24(s11)			# leftOrRight = 0 (left)
	
dontChangeFulecoToLeft:
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
	lw t2, 8(s11)			# t2 = runnning state
	bne t2, t1, goUp		# check if t2 = 2
	
	li t1, 1			# t1 = 1
	lw t0, 24(s11)			# t0 = leftOrRight
	beq t1, t0, dontChangeFulecoToRight
	addi s10, s10, 528		# s10 += 528
	sw t1, 24(s11)			# leftOrRight = 1 (right)
	
dontChangeFulecoToRight:
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
	lw t2, 8(s11)			# t2 = runningState
	bne t2, t1, goDown		# check if t2 = 3
	
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
	lw t2, 8(s11)			# t2 = runningState	
	bne t2, t1, pass		# check if t2 = 4
	
	addi a2, a2, 16			# update temporario do eixo Y para baixo
	call checkCollision		# check de colisao inferior equerda
	addi a2, a2, -16		# cancela o update temporario do eixo Y
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
	lw t0, 8(s11)
	beq t0, t1, dontTeleportLeft	# se movState == right, pula pra "dontTeleportLeft" 
	li a1, 288			# usa o teleporte da esquerda
dontTeleportLeft:	
	li t1, 300			# t1 = 300
	bne a1, t1, dontTeleportRight	# se posX != 300, pula pra "dontTeleportRight"
	li t1, 64			# t1 = 64
	bne a2, t1, dontTeleportRight	# se posY != 64, pula pra "dontTeleportRight"
	li t1, 1			# t1 = 1
	lw t0, 8(s11)
	beq t0, t1, dontTeleportRight	# se movState == left, pula pra "dontTeleportRight"
	li a1, 0			# usa o teleporte da direita
dontTeleportRight:
	li t1, 12			
	bge a2, t1, dontTeleportUp	# se posY > 12, pula pra dontTeleportUp
	li t1, 4
	lw t0, 8(s11)			# t0 = runningState
	beq t0, t1, dontTeleportUp	# se runningState == 4, pula pra dontTeleportUp
	li a2, 228			# usa o teleporte de cima
dontTeleportUp:
	li t1, 228
	bne a2, t1, dontTeleportDown	# se posY != 288, pula pra dontTeleportDown
	li t1, 3	
	lw t0, 8(s11)			# t0 = runningState
	beq t0, t1, dontTeleportDown	# se runningState == 3, pula pra dontTeleportDown
	li a2, 12 			# usa o teleporte de baixo
dontTeleportDown:
	li t0, 1			# t0 = 1
	beq t0, a3, dontChangeFrameAnimacao
	li t0, 0			# t0 = 0
	lw t1, 8(s11)			# t1 = runningState
	beq t0, t1, dontChangeFrameAnimacao
	lw t0, 20(s11)			# t0 = frameAnimacao
	li t1, 264			# t1 = 264
	mul t1, t1, t0			# t0 = +/- 264
	add s10, s10, t1		# muda o sprite do Fuleco para ser animado
	li t1, -1			# t1= -1
	mul t0, t0, t1			# t0 *= -1
	sw t0, 20(s11)			# guarda t0 em frameAnimacao
	
dontChangeFrameAnimacao:
	mv a0, s10			# a0 = endereco do Fuleco
	sw a1, 0(s11)			# posX = a1
	sw a2, 4(s11)			# posY = a2
	call print			# printa fuleco
    # checa contato com os pontos
	li t0, 320			# t0 = 320	
	
	add t2, s8, a1			# t2 = endereco + a1
	mul t3, a2, t0			# t3 = a2*320
	add t0, t2, t3			# t0 = t2 + t3 = endereco + a1 + a2*320
	
	lw t2, 8(t0)			# t2 = t0 + 4
	andi t2, t2, 0x000FF		# t2 = 8 bits menos signficativos

	li t1, 7			# t1 = 7	
	bne t1, t2, dontAddPoints	# se t1 != t2, pula pra "dontAddPoints"
	li t1, 17			# t1 = 17		 
	sw t1, 8(t0)			# guarda 17 no endereco que a bolinha recem pegada estava
	lw t0, 12(s11)			# t0 = pontos
	addi t0, t0, 1			# adiciona 1 ponto
	sw t0, 12(s11)			# guarda os pontos
	li t1, 115			# t1 = 115
	beq t0, t1, endGame		# se pontos == 115, acaba a run
	
dontAddPoints:
	li t1, 192			# t1 = 192
	bne t1, t2, dontBeSuper		# se t1 != t2, pula pra dontBeSuper
	li t1, 17			# t1 = 17
	sw t1, 8(t0)			# guarda 17 no endereco da brazuca recem pegada
	# trocar o estado de superfuleco
	lw t1, 16(s11)			# t1 = superState
	bne t1, zero, dontChangeSuperSprite	# sw t1 != 0, pula pra dontChangeSuperState
	li t0, 1056			# t0 = 1056
	add s10, s10, t0		# s10 += 1056
dontChangeSuperSprite:
	li t1, 132			# t1 = 132
	sw t1, 16(s11)			# superState = 132
dontBeSuper:
	lw t0, 16(s11)			# t0 = superState
	beqz t0, isNotSuper		# se t0 == 0, pula pra isNotSuper
	
	addi t0, t0, -1			# t0 -= 1
	sw t0, 16(s11)			# superState = t0
	bnez t0, isNotSuper		# se t0 == 0, pula pra isNotSuper
	li t0, 1056			# t0 = 1056
	sub s10, s10, t0		# s10 -= 1056
		
isNotSuper:
    # Boateng
    	lw a1, 0(s1)
    	lw a2, 4(s1)
    	
    	lw t0, 8(s1)			# t0 = timeOutBoateng
    	bgtz t0, dontStartBoa		# if t0 > 0, pula pra dontStartBoa
    	addi t0, t0, 1			# t0 += 1
    	sw t0, 8(s1)			# timeOutBoa = t0
    	bnez t0, boaHasMoved		# if t0 != 0, pula pra boaHasMoved
    	li t1, 144			
    	li t2, 96
    	li t3, 1
    	sw t1, 0(s1)			# posXBoa = 144
    	sw t2, 4(s1)			# posYBoa = 96
    	sw t3, 12(s1)			# runningStateBoa = 1 (left)
dontStartBoa:
    	lw a1, 0(s1)
    	lw a2, 4(s1)
    		
    	lw t0, 0(s11)			# t0 = posXFuleco			
    	lw t1, 4(s11)			# t1 = posYFuleco
    	sub t0, t0, a1			# t0 = posXFul - poxXBoa
    	sub t2, t1, a2			# t1 = posYFul - posYBoa

    	mv a0, s8			# a0 = collisionMap
    	
    	lw t3, 12(s1)			# t3 = runningStateBoateng
    	
    	lw t4, 16(s11)
	
	bnez t4, boaIsAfraid
	beqz t0, boaXZero
	bgtz t0, boaXGreater
	bltz t0, boaXLess
	
boaIsAfraid:
	beqz t3, boaIsAfraidLeft		
	addi t3, t3, -1
	beqz t3, boaIsAfraidRight
	addi t3, t3, -1
	beqz t3, boaIsAfraidUp
	j boaIsAfraidDown
	boaIsAfraidLeft:
		li a4, 113 		# a4 = 01.11.00.01 ( cima, baixo, esquerda, direita )
		j moveBoa
	boaIsAfraidRight:	
		li a4, 228 		# a4 = 11.10.01.00 ( baixo, cima, direita, esquerda )
		j moveBoa
	boaIsAfraidUp:
		li a4, 75 		# a4 = 01.00.10.11 ( direita, esquerda, cima, baixo )
		j moveBoa
	boaIsAfraidDown:
		li a4, 30		# a4 = 00.01.11.10 ( esquerda, direita, baixo, cima )
		j moveBoa
		
boaXZero:	# x == 0
	beqz t3, boaXZeroLeft		
	addi t3, t3, -1
	beqz t3, boaXZeroRight
	addi t3, t3, -1
	beqz t3, boaXZeroUp
	j boaXZeroDown
	boaXZeroLeft:		# t3 == 0
		beqz t2, boaTouch	# se y == 0, pula pra boaTouch
		bltz t2, boaXZeroLeftUp
		bgtz t2, boaXZeroLeftDown
		boaXZeroLeftUp:		# y < 0
			li a4, 141	# a4 = 10.00.11.01 ( cima, esquerda, baixo, direita )
			j moveBoa
		boaXZeroLeftDown:	# y > 0
			li a4, 201	# a4 = 11.00.10.01 ( baixo, esquerda, cima, direita )
			j moveBoa
	boaXZeroRight:		# t3 == 1
		beqz t2, boaTouch	# se y == 0, pula pra boaTouch
		bltz t2, boaXZeroRightUp
		bgtz t2, boaXZeroRightDown
		boaXZeroRightUp:	# y < 0	
			li a4, 156	# a4 = 10.01.11.00 ( cima, direita, baixo, esquerda )
			j moveBoa
		boaXZeroRightDown:	# y > 0
			li a4, 216	# a4 = 11.01.10.00 ( baixo, direita, cima, esquerda )
			j moveBoa
	boaXZeroUp:		# t3 == 2
		beqz t2, boaTouch	# se y == 0, pula pra boaTouch
		bltz t2,boaXZeroUpUp
		bgtz t2, boaXZeroUpDown
		boaXZeroUpUp:	# y < 0
			li a4, 147	# a4 = 10.01.00.11 ( cima, diretia, esquerda, baixo )
			j moveBoa
		boaXZeroUpDown:	# y > 0
			li a4, 27	# a4 = 00.01.10.11 ( esquerda, direita, cima, baixo )
			j moveBoa
	 boaXZeroDown:
	 	beqz t2, boaTouch	# se y == 0, pula pra boaTouch
	 	bltz t2, boaXZeroDownUp
	 	bgtz t2, boaXZeroDownDown
	 	boaXZeroDownUp:	# y < 0
	 		li a4, 78	# a4 = 01.00.11.10 ( direita, esquerda, baixo, cima )
	 		j moveBoa	
	 	boaXZeroDownDown:# y >= 0
	 		li a4, 198	# a4 = 11.00.01.10 ( baixo, esquerda, direita, cima )
	 		j moveBoa
boaXGreater:	# x > 0 ( direita )
	beqz t3, boaXGreaterLeft
	addi t3, t3, -1
	beqz t3, boaXGreaterRight
	addi t3, t3, -1
	beqz t3, boaXGreaterUp
	j boaXGreaterDown
	boaXGreaterLeft:	# t3 == 0
		bltz t2, boaXGreaterLeftUp
		bgez t2, boaXGreaterLeftDown
		boaXGreaterLeftUp:	# y < 0
			li a4, 141	# a4 = 10.00.11.01 ( cima, esqurda, baixo, direita )
			j moveBoa
		boaXGreaterLeftDown:	# y >= 0
			li a4, 201	# a4 = 11.00.10.01 ( baixo, esquerda, cima, direita )
			j moveBoa
	boaXGreaterRight:	# t3 == 1
		bltz t2, boaXGreaterRightUp
		bgez t2, boaXGreaterRightDown
		boaXGreaterRightUp:	# y < 0
			li a4, 108	# a4 = 01.10.11.00 ( direita, cima, baixo, esquerda )
			j moveBoa
		boaXGreaterRightDown:	
			li a4, 120	# a4 = 01.11.10.00 ( direita, baixo, cima, esquerda )
			j moveBoa
	boaXGreaterUp:		# t3 == 2
		bltz t2, boaXGreaterUpUp
		bgez t2, boaXGreaterUpDown
		boaXGreaterUpUp:			
			li a4, 99	# a4 = 01.10.00.11 ( direita, cima, esquerda, baixo ) 	
			j moveBoa
		boaXGreaterUpDown:
			li a4, 75	# a4 = 01.00.10.11 ( direita, esquerda, cima, baixo )
			j moveBoa
	boaXGreaterDown:	# t3 == 3
		bltz t2, boaXGreaterDownUp
		bgez t3, boaXGreaterDownDown
		boaXGreaterDownUp:
			li a4, 78	# a4 = 01.00.11.10 ( direita, esquerda, baixo, cima )
			j moveBoa		
		boaXGreaterDownDown:
			li a4, 114	# a4 = 01.11.00.10 ( direita, baixo, esquerda, cima )
			j moveBoa

boaXLess:	# x < 0 (esquerda)
	beqz t3, boaXLessLeft	
	addi t3, t3, -1
	beqz t3, boaXLessRight
	addi t3, t3, -1
	beqz t3, boaXLessUp
	addi t3, t3, -1
	beqz t3, boaXLessDown
	boaXLessLeft:		# t3 == 0
		bltz t2, boaXLessLeftUp
		bgez t2, boaXLessLeftDown
		boaXLessLeftUp:		# y < 0
			li a4, 45	# a4 = 00.10.11.01 ( esquerda, cima, baixo, direita )
			j moveBoa
		boaXLessLeftDown:	# y >= 0
			li a4, 57	# a4 = 00.11.10.01 ( esquerda, baixo, cima, direita )
			j moveBoa
	boaXLessRight:		# t3 == 1
		bltz t2, boaXLessRightUp
		bgez t2, boaXLessRightDown
		boaXLessRightUp:	# y < 0
			li a4, 156	# a4 = 10.01.11.00 ( cima, direita, baixo, esquerda )
			j moveBoa
		boaXLessRightDown:	# y >= 0
			li a4, 216	# a4 = 11.01.10.00 ( baixo, direita, cima, esquerda )  
			j moveBoa
	boaXLessUp:		# t3 == 2
		bltz t2, boaXLessUpUp
		bgez t2, boaXLessUpDown
		boaXLessUpUp:		# y < 0
			li a4, 39	# a4 = 00.10.01.11 ( esquerda, cima, direita, baixo )  
			j moveBoa
		boaXLessUpDown:		# y >= 0
			li a4, 27 	# a4 = 00.01.10.11 ( esquerda, direita, cima, baixo )
			j moveBoa
	boaXLessDown:		# t3 == 3    	
		bltz t2, boaXLessDownUp
		bgez t2, boaXLessDownDown
		boaXLessDownUp:		# y < 0
			li a4, 30 	# a4 = 00.01.11.10 ( esquerda, direita, baixo, cima )
		 	j moveBoa
		boaXLessDownDown: 	# y < 0
			li a4, 54	# a4 = 00.11.01.10 ( esquerda, baixo, direita, cima )
			j moveBoa
boaTouch:
	#tira vida
	lw t0, 16(s11)
	
	beqz t0, boaKillFuleco
		#la s4, fixedBoateng0	# superState > 0
		li a1, 114
		li a2, 128
		li t1, -131
		sw t1, 8(s1)
		j boaHasMoved
	boaKillFuleco:			# superState == 0
		addi s0, s0, -1
		bgtz s0, restartGame  
		li a7, 10
		ecall
		
moveBoa:
	srli t0, a4, 6			# t0 = ultimos 2 bits d a4 (xx.--.--.--)
	slli t1, t0, 6
	sub a4, a4, t1
	slli a4, a4, 2			# a4 = xx.xx.xx.00

	mv a0, s8			# a0 = collisionMap
	
	bnez t0, moveBoaRight		# t0 == 0
	addi a1, a1, -4			# update temporario da posicao para 4 pixels para esquerda
	call checkCollision		# check da colisao superior esquerda
	li t0, 0			# t0 = 0
	addi a1, a1, 4			# cancela o update temporario do eixo X
	beq t1, t0, moveBoa		# se ha colisao, pula para "moveBoa"
	
	addi a1, a1, -4			# update da posicao para 4 pixels para esquerda
	addi a2, a2, 15			# update da posicao para 15 pixels para baixo
	call checkCollision		# check da colisao inferior esquerda
	li t0, 0			# t0 = 0
	addi a1, a1, 4			# cancela o update temporario do eixo X
	addi a2, a2, -15		# cancela o update temporario do eixo Y
	beq t1, t0, moveBoa		# se ha colisao, pula para "moveBoa"
	
	li t0, 0
	sw t0, 12(s1)
	
	addi a1, a1, -4			# update da posicao para 4 pixels para a esquerda
	
	li t1, 0			# t1 = 0
	bne a1, t1, dontTeleportLeftBoa	# se posX != 0, pula pra "dontTeleportLeftBoa"
	li t1, 0			# t1 = 0
	lw t0, 12(s1)
	bne t0, t1, dontTeleportLeftBoa	# se movState == right, pula pra "dontTeleportLeftBoa" 
	li a1, 288			# usa o teleporte da esquerda
	dontTeleportLeftBoa:
	j boaHasMoved
	
moveBoaRight:
	li t1, 1
	bne t0, t1, moveBoaUp		# t0 == 1
	
	addi a1, a1, 16			# update temporario do eixo X para a direita 
	call checkCollision		# check de colisao superior direita
	addi a1, a1, -16		# cancela o update temporario do eixo X para a direita
	li t0, 0			# t0 = 0
	beq t1, t0, moveBoa		# se ha colisao, pula para "moveBoa"
	
	addi a1, a1, 16			# update temporario do eixo X para a diereita
	addi a2, a2, 15			# update temporario do eixo Y para baixo
	call checkCollision		# check de colisao inferior direita
	addi a1, a1, -16		# cancela o update temporario do eixo X para a direita
	addi a2, a2, -15		# cancela o update temporario do eixo Y para a esquerda
	li t0, 0			# t0 = 0
	beq t1, t0, moveBoa		# se ha colisao, pula para "moveBoa"
	
	li t0, 1
	sw t0, 12(s1)
	
	addi a1, a1, 4			# update da posicao para 4 pixels para a direita
	
	li t1, 300			# t1 = 300
	bne a1, t1, dontTeleportRightBoa# se posX != 300, pula pra "dontTeleportRightBoa"
	li t1, 1
	lw t0, 12(s1)
	bne t0, t1, dontTeleportRightBoa# se movState == left, pula pra "dontTeleportRightBoa"
	li a1, 0			# usa o teleporte da direita
	dontTeleportRightBoa:
	j boaHasMoved
	
moveBoaUp:
	li t1, 2
	bne t0, t1, moveBoaDown		# t0 == 2
	
	addi a2, a2, -4			# update temporario do eixo Y para cima
	call checkCollision		# check de colisao superior equerda
	addi a2, a2, 4			# cancela o update temporario do eixo Y
	li t0, 0			# t0 = 0
	beq t1, t0, moveBoa		# se ha colisao, pula para "moveBoa"
	
	addi a2, a2, -4			# update temporario do eixo Y para cima
	addi a1, a1, 12			# update temporario do eixo X para direita
	call checkCollision		# check de colisao superior direito
	addi a2, a2, 4			# cancela update temporario do eixo Y para cima
	addi a1, a1, -12		# cancela update temporario do eixo X para direita
	li t0, 0			# t0 = 0
	beq t0, t1, moveBoa		# se ha colisao, pula para "moveBoa"
	
	li t0, 2
	sw t0, 12(s1)
	
	addi a2, a2, -4			# update da posicao para 4 pixels para a cima
	
	li t1, 12
	bge a2, t1, dontTeleportUpBoa
	li a2, 228
	dontTeleportUpBoa:
	j boaHasMoved
	
moveBoaDown:
	addi a2, a2, 16			# update temporario do eixo Y para baixo
	call checkCollision		# check de colisao inferior equerda
	addi a2, a2, -16		# cancela o update temporario do eixo Y
	li t0, 0			# t0 = 0
	beq t1, t0, moveBoa		# se ha colisao, pula para "moveBoa"
	
	addi a2, a2, 16			# update temporario do eixo Y para baixo
	addi a1, a1, 12			# update temporario do eixo X para direita
	call checkCollision		# check de colisao superior direito
	addi a2, a2, -16		# cancela o update temporario do eixo Y 
	addi a1, a1, -12		# cancela o update temporario do eixo X
	li t0, 0			# t0 = 0
	beq t0, t1, moveBoa		# se ha colisao, pula para "moveBoa"
	
	li t0, 3
	sw t0, 12(s1)
	
	addi a2, a2, 4			# update da posicao para 4 pixels para a baixo
	
	li t1, 228
	bne a2, t1, boaHasMoved
	li a2, 12 
	
boaHasMoved:
	mv a0, s4
	sw a1, 0(s1)
    	sw a2, 4(s1)
    	call print
    	
    	lw t1, 0(s11)
    	lw t2, 4(s11)
  	
    	blt a1, t1, muller  	
    	addi t1, t1, 15	
    	bgt a1, t1, muller
    	blt a2, t2, muller	
    	addi t2, t2, 15
    	bgt a2, t2, muller
    	j boaTouch

muller:	

	li a0,76			# pausa de 76m segundos
	li a7,32
	ecall
	
	j loopgame
	
endGame:
	mv ra, a6		
	ret
restartGame:
	mv ra, a6
	addi ra, ra, -16
	ret
	
.include "src/print.s"
.include "src/checkCollision.s"
.include "src/printProps.s"

.data
fulecoInfo: .word 144, 176, 0, 0, 0, 1, 0	# posX, posY, runningState, points, superState, frameAnimacao, leftOrRight
germanyInfo: .word 114, 128, -130, 0, 0, 0 	#posXBoa, posYBoa, timeOutBoa, runningStateBoa, frameAnimacaoBoa,leftorRightBoa		#134, 128, 154, 128, 174, 128
space: .string " "
ae: .string "a\n"
be: .string "b\n"
ce: .string "c\n"
de: .string "b\n"
.include "sprites/props/arquivos .data/dot.data"
.include "sprites/props/arquivos .data/brazuca.data"
 
	
