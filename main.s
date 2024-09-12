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
	li t4, 0			# t4 = 0
	sw t4, 16(s11)			# comeca o superState para 0
	li t5, 1			# t5 = 0
	sw t5, 20(s11)			# comeca o frameAnimacao em 1
	sw t4, 24(s11)			# comeca o leftOrRight em  0 (left)
	
	mv a0, s10
	li a1, 144
	li a2, 176
	call print
	
	la s1, germanyInfo		# s1 = germanyInfo
	
    # setup Boateng
    	li t1, 114			# t1 = 144
    	li t2, 128			# t2 = 128
    	sw t1, 0(s1)			# posXBoa = 144
    	sw t2, 4(s1)			# posYBoa = 128
    	li t1, -130			
    	sw t1, 8(s1)			# timeOutBoa = -130
	li t0, 0	
	sw t0, 12(s1)			# comeca o runningStateBoa em 0(left)
	sw t0, 16(s1)			# comeca o leftOrRightBoa em 0(left)
	sw t0, 20(s1)			# comeca o frameBoa em 0
	
    # setup Muller
    	li t1, 134			# t1 = 134
    	li t2, 128			# t2 = 128
    	sw t1, 24(s1)			# posXMul = 134
    	sw t2, 28(s1)			# posYMul = 128
    	li t1, -180			
    	sw t1, 32(s1)			# timeOutBoa = -180
	li t0, 0										
	sw t0, 36(s1)			# comeca o runningStateMul em 0(left)
	sw t0, 40(s1)			# comeca o leftOrRightMul em 0(left)
	sw t0, 44(s1)			# comeca o frameMul em 0

    # Setup Gotze
    	li t1, 154			# t1 = 154
    	li t2, 128			# t2 = 128
    	sw t1, 48(s1)			# posXGot = 134
    	sw t2, 52(s1)			# posYGot = 128
    	li t1, -230			
    	sw t1, 56(s1)			# timeOutGot = -230
	li t0, 0										
	sw t0, 60(s1)			# comeca o runningStateGot em 0(left)
	sw t0, 64(s1)			# comeca o leftOrRightGot em 0(left)
	sw t0, 68(s1)			# comeca o frameGot em 0
	
    # Setup Kross
    	li t1, 174			# t1 = 174
    	li t2, 128			# t2 = 128
    	sw t1, 72(s1)			# posXKro = 134
    	sw t2, 76(s1)			# posYKro = 128
    	li t1, -280			
    	sw t1, 80(s1)			# timeOutKro = -230
	li t0, 0									
	sw t0, 84(s1)			# comeca o runningStateKro em 0(left)
	sw t0, 88(s1)			# comeca o leftOrRightKroem 0(left)
	sw t0, 92(s1)			# comeca o frameKro em 0	
	
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
	sb t1, 8(t0)			# guarda 17 no endereco que a bolinha recem pegada estava
	
	lw t0, 12(s11)			# t0 = pontos
	addi t0, t0, 1			# adiciona 1 ponto
	sw t0, 12(s11)			# guarda os pontos
	li t1, 115			# t1 = 115
	beq t0, t1, endGame		# se pontos == 115, acaba a run
dontAddPoints:
	li t1, 192			# t1 = 192
	bne t1, t2, dontBeSuper		# se t1 != t2, pula pra dontBeSuper
	li t1, 17			# t1 = 17
	sb t1, 8(t0)			# guarda 17 no endereco da brazuca recem pegada
	# trocar o estado de superfuleco
	lw t1, 16(s11)			# t1 = superState
	bne t1, zero, dontChangeSuperSprite	# sw t1 != 0, pula pra dontChangeSuperState
	li t0, 1056			# t0 = 1056
	add s10, s10, t0		# s10 += 1056
	add s4, s4, t0			# s4 += 1056
	add s5, s5, t0
	add s6, s6, t0
	add s7, s7, t0
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
	sub s4, s4, t0			# s4 -= 1056
	sub s5, s5, t0
	sub s6, s6, t0
	sub s7, s7, t0
		
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
    	sw t3, 16(s1)			# frameBoaAnimacao = 1
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
		li a4, 177 		# a4 = 10.11.00.01 ( cima, baixo, esquerda, direita )
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
	lw t0, 16(s11)
	
	beqz t0, boaKillFuleco
		li a1, 114			# posBoaX = 114
		li a2, 128			# posYBoa = 128
		li t1, -131
		sw t1, 8(s1)			# boaTimeout = -131
		li t0, 0
		lw t1, 20(s1)			# t1 = boaLeftOrRight
		beqz t1, boaIsDeadAndLeft	
		addi s4, s4, -528		# s4 -= 528, se tiver pra direita 
		sw t0, 20(s1)			# boaLeftOrRight = 0 = esquerda
		boaIsDeadAndLeft:
		lw t1, 16(s1)			# t1 = frameBoa
		bgtz t1, boaIsDeadAndFrame0	
		addi s4, s4, -264		# s4 -= 264, se tiver no frame 1
		sw zero, 16(s1)			# frameBoa = 0
		boaIsDeadAndFrame0:
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
	
	li t0, 0			# t0 = 0
	lw t1, 20(s1)			# t1 = boaLeftOrRight
	beq t0, t1, boaIsLeft	
	addi s4, s4, -528		# s4 -= 528, se tiver pra direita
	sw t0, 20(s1)			# boaLeftOrRight = 0 = esquerda
	boaIsLeft:
	sw t0, 12(s1)			# boaRunningState = 0 = equerda
	
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
	
	li t0, 1			# t0 = 1
	lw t1, 20(s1)			# t1 = boaLeftOrRight
	beq t0, t1, boaIsRight	 
	addi s4, s4, 528		# s4 += 528, se estiver pra esquerda
	sw t0, 20(s1)			# boaLeftOrRight = 1 = direita
	boaIsRight:
	sw t0, 12(s1)			# boaRunningState = 1 = direita
	
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
	mv a0, s4				# a0 = spriteBoateng
	sw a1, 0(s1)				# posXBoa = a1
    	sw a2, 4(s1)				# posYBoa = a2
    	call print
    	
    	lw t1, 0(s11)
    	lw t2, 4(s11)
    	
    	lw t3, 8(s1)
    	bltz t3, muller
  	
    	blt a1, t1, boaDontTouch  	
    	addi t1, t1, 15	
    	bgt a1, t1, boaDontTouch
    	blt a2, t2, boaDontTouch	
    	addi t2, t2, 15
    	bgt a2, t2, boaDontTouch
    	j boaTouch
    	boaDontTouch:
		lw t0, 16(s1)			# t0 = frameBoaAnimacao
		li t1, 264			# t1 = 264
		mul t1, t1, t0			# t0 = +/- 264
		add s4, s4, t1			# muda o sprite do Boateng para ser animado
		li t1, -1			# t1= -1
		mul t0, t0, t1			# t0 *= -1
		sw t0, 16(s1)			# guarda t0 em frameBoaAnimacao

muller:	
	lw a1, 24(s1)			# a1 = posXMuller
	lw a2, 28(s1)			# a2 = posYMuller
	
	lw t0, 32(s1)			# t0 = timeOutMul
	bgtz t0, dontStartMul		
	addi t0, t0, 1
	sw t0, 32(s1)
	bnez t0, mulHasMoved
	li t1, 144			
    	li t2, 96
    	li t3, 1
    	sw t1, 24(s1)			# posXMul = 144
    	sw t2, 28(s1)			# posYMul = 96
    	sw t3, 36(s1)			# runningStateMul = 1 (left)
    	sw t3, 40(s1)			# frameMulAnimacao = 1
	dontStartMul:
	lw a1, 24(s1)			# a1 = posXMul
	lw a2, 28(s1)			# a2 = posYMul
	
	lw t0, 0(s11)			# t0 = posXFuleco			
    	lw t1, 4(s11)			# t1 = posYFuleco
    	sub t0, t0, a1			# t0 = posXFul - poxXMul
    	sub t2, t1, a2			# t1 = posYFul - posYMul

    	mv a0, s8			# a0 = collisionMap
    	
    	lw t3, 36(s1)			# t3 = runningStateMul
    	
    	lw t4, 16(s11)			# t4 = superState
    	
	bnez t4, mulIsAfraid
	beqz t2, mulYZero
	bgtz t2, mulYGreater
	bltz t2, mulYLess
	
mulIsAfraid:
	beqz t3, mulIsAfraidLeft		
	addi t3, t3, -1
	beqz t3, mulIsAfraidRight
	addi t3, t3, -1
	beqz t3, mulIsAfraidUp
	j mulIsAfraidDown
	mulIsAfraidLeft:
		li a4, 177 		# a4 = 10.11.00.01 ( cima, baixo, esquerda, direita )
		j moveMul
	mulIsAfraidRight:	
		li a4, 228 		# a4 = 11.10.01.00 ( baixo, cima, direita, esquerda )
		j moveMul
	mulIsAfraidUp:
		li a4, 75 		# a4 = 01.00.10.11 ( direita, esquerda, cima, baixo )
		j moveMul
	mulIsAfraidDown:
		li a4, 30		# a4 = 00.01.11.10 ( esquerda, direita, baixo, cima )
		j moveMul
		
mulYZero:
	beqz t3, mulYZeroLeft		
	addi t3, t3, -1
	beqz t3, mulYZeroRight
	addi t3, t3, -1
	beqz t3, mulYZeroUp
	j mulYZeroDown
	mulYZeroLeft:	 
		bltz t0, mulYZeroLeftLeft
		beqz t0, mulTouch
		bgtz t0, mulYZeroLeftRight
		mulYZeroLeftLeft:
			li a4, 45		# a4 = 00.10.11.01 ( esquerda, cima, baixo, direita ) 
			j moveMul
		mulYZeroLeftRight:
			li a4, 225		# a4 = 11.10.00.01 ( baixo, cima, esquerda, direita ) 
			j moveMul
	mulYZeroRight:
		bltz t0, mulYZeroRightLeft
		beqz t0, mulTouch
		bgtz t0, mulYZeroRightRight
		mulYZeroRightLeft:
			li a4, 180 		# a4 = 10.11.01.00 ( cima, baixo, direita, esquerda )
			j moveMul
		mulYZeroRightRight:
			li a4, 120 		# a4 = 01.11.10.00 ( direita, baixo, cima, esquerda )
			j moveMul
	mulYZeroUp:
		bltz t0, mulYZeroUpLeft
		beqz t0, mulTouch
		bgtz t0, mulYZeroUpRight
		mulYZeroUpLeft:
			li a4, 39		# a4 = 00.10.01.11 ( esquerda, cima, direita, baixo )
			j moveMul
		mulYZeroUpRight:
			li a4, 99		# a4 = 01.10.00.11 ( direita, cima, esquerda, baixo )
			j moveMul
	mulYZeroDown:
		bltz t0, mulYZeroDownLeft
		beqz t0, mulTouch
		bgtz t0, mulYZeroDownRight
		mulYZeroDownLeft:
			li a4, 54 		# a4 = 00.11.01.10 ( esquerda, baixo, direita, cima )
			j moveMul
		mulYZeroDownRight:
			li a4, 114		# a4 = 01.11.00.10 ( direita, baixo, esquerda, cima )
			j moveMul
mulYGreater:
	beqz t3, mulYGreaterLeft		
	addi t3, t3, -1
	beqz t3, mulYGreaterRight
	addi t3, t3, -1
	beqz t3, mulYGreaterUp
	j mulYGreaterDown
	mulYGreaterLeft:
		bltz t0, mulYGreaterLeftLeft
		bgez t0, mulYGreaterLeftRight
		mulYGreaterLeftLeft:
			li a4, 201 		# a4 = 11.00.10.01 ( baixo, esquerda, cima, direita )
			j moveMul
		mulYGreaterLeftRight:
			li a4, 225		# a4 = 11.10.00.01 ( baixo, cima, esquerda, direita )
			j moveMul
	mulYGreaterRight:
		bltz t0, mulYGreaterRightLeft
		bgez t0, mulYGreaterRightRight
		mulYGreaterRightLeft:
			li a4, 228 		# a4 = 11.10.01.00 ( baixo, cima, direita, esquerda )
			j moveMul
		mulYGreaterRightRight:
			li a4, 216		# a4 = 11.01.10.00 ( baixo, direita, cima, esquerda )
			j moveMul
	mulYGreaterUp:
		bltz t0, mulYGreaterUpLeft
		bgez t0, mulYGreaterUpRight
		mulYGreaterUpLeft:
			li a4, 27		# a4 = 00.01.10.11 ( esquerda, direita, cima, baixo )
			j moveMul
		mulYGreaterUpRight:
			li a4, 75		# a4 = 01.00.10.11 ( direita, esquerda, cima, baixo ) 
			j moveMul
	mulYGreaterDown:
		bltz t0, mulYGreaterDownLeft
		bgtz t0, mulYGreaterDownRight
		mulYGreaterDownLeft:
			li a4, 198 		# a4 = 11.00.01.10 ( baixo, esquerda, direita, cima ) 
			j moveMul
		mulYGreaterDownRight:
			li a4, 210 		# a4 = 11.01.00.10 ( baixo, direita, esquerda, cima )
			j moveMul
mulYLess:
	beqz t3, mulYLessLeft		
	addi t3, t3, -1
	beqz t3, mulYLessRight
	addi t3, t3, -1
	beqz t3, mulYLessUp
	j mulYLessDown
	mulYLessLeft:
		bltz t0, mulYLessLeftLeft
		bgez t0, mulYLessLeftRight
		mulYLessLeftLeft:
			li a4, 141 		# a4 = 10.00.11.01 ( cima, esquerda, baixo, direita )
			j moveMul
		mulYLessLeftRight:
			li a4, 177		# a4 = 10.11.00.01 ( cima, baixo, esquerda, direita )
			j moveMul
	mulYLessRight:
		bltz t0, mulYLessRightLeft
		bgez t0, mulYLessRightRight
		mulYLessRightLeft:
			li a4, 180		# a4 = 10.11.01.00 ( cima, baixo, direita, esquerda )
			j moveMul
		mulYLessRightRight:
			li a4, 156		# a4 = 10.01.11.00 ( cima, direita, baixo, esquerda )
			j moveMul
	mulYLessUp: 
		bltz t0, mulYLessUpLeft
		bgez t0, mulYLessUpRight
		mulYLessUpLeft:
			li a4, 135		# a4 = 10.00.01.11 ( cima, esquerda, direita, baixo )
			j moveMul
		mulYLessUpRight:
			li a4, 147 		# a4 = 10.01.00.11 ( cima, direita, esquerda, baixo )
			j moveMul
	mulYLessDown:
		bltz t0, mulYLessDownLeft
		bgez t0, mulYLessDownRight
		mulYLessDownLeft:
			li a4, 30		# a4 = 00.01.11.10 ( esquerda, direita, baixo, cima )
			j moveMul
		mulYLessDownRight:
			li a4, 78 		# a4 = 01.00.11.10 ( direita, esquerda, baixo, cima )
			j moveMul
mulTouch:	
	lw t0, 16(s11)
	
	beqz t0, mulKillFuleco
		li a1, 134			# posXMul = 134
		li a2, 128			# posYMul = 128
		li t1, -131
		sw t1, 32(s1)			# mulTimeout = -131
		li t0, 0
		lw t1, 44(s1)			# t1 = mulLeftOrRight
		beqz t1, mulIsDeadAndLeft	
		addi s5, s5, -528		# s5 -= 528, se tiver pra direita 
		sw t0, 44(s1)			# mulLeftOrRight = 0 = esquerda
		mulIsDeadAndLeft:
		lw t1, 40(s1)			# t1 = frameMul
		bgtz t1, mulIsDeadAndFrame0	
		addi s5, s5, -264		# s5 -= 264, se tiver no frame 1
		sw zero, 40(s1)			# frameMul = 0
		mulIsDeadAndFrame0:
		j mulHasMoved

	mulKillFuleco:			# superState == 0
		addi s0, s0, -1
		bgtz s0, restartGame  
		li a7, 10
		ecall		

moveMul:
	srli t0, a4, 6			# t0 = ultimos 2 bits d a4 (xx.--.--.--)
	slli t1, t0, 6
	sub a4, a4, t1
	slli a4, a4, 2			# a4 = xx.xx.xx.00

	mv a0, s8			# a0 = collisionMap
	
	bnez t0, moveMulRight		# t0 == 0
	addi a1, a1, -4			# update temporario da posicao para 4 pixels para esquerda
	call checkCollision		# check da colisao superior esquerda
	li t0, 0			# t0 = 0
	addi a1, a1, 4			# cancela o update temporario do eixo X
	beq t1, t0, moveMul		# se ha colisao, pula para "moveMul"
	
	addi a1, a1, -4			# update da posicao para 4 pixels para esquerda
	addi a2, a2, 15			# update da posicao para 15 pixels para baixo
	call checkCollision		# check da colisao inferior esquerda
	li t0, 0			# t0 = 0
	addi a1, a1, 4			# cancela o update temporario do eixo X
	addi a2, a2, -15		# cancela o update temporario do eixo Y
	beq t1, t0, moveMul		# se ha colisao, pula para "moveMul"
	
	li t0, 0			# t0 = 0
	lw t1, 44(s1)			# t1 = mulLeftOrRight
	beq t0, t1, mulIsLeft	
	addi s5, s5, -528		# s5 -= 528, se tiver pra direita
	sw t0, 44(s1)			# mulLeftOrRight = 0 = esquerda
	mulIsLeft:
	sw t0, 36(s1)			# mulRunningState = 0 = equerda
	
	addi a1, a1, -4			# update da posicao para 4 pixels para a esquerda
	
	li t1, 0			# t1 = 0
	bne a1, t1, dontTeleportLeftMul	# se posX != 0, pula pra "dontTeleportLeftMul"
	li t1, 0			# t1 = 0
	lw t0, 36(s1)
	bne t0, t1, dontTeleportLeftMul	# se movState == right, pula pra "dontTeleportLeftMul" 
	li a1, 288			# usa o teleporte da esquerda
	dontTeleportLeftMul:
	j mulHasMoved
	
moveMulRight:
	li t1, 1
	bne t0, t1, moveMulUp		# t0 == 1
	
	addi a1, a1, 16			# update temporario do eixo X para a direita 
	call checkCollision		# check de colisao superior direita
	addi a1, a1, -16		# cancela o update temporario do eixo X para a direita
	li t0, 0			# t0 = 0
	beq t1, t0, moveMul		# se ha colisao, pula para "moveMul"
	
	addi a1, a1, 16			# update temporario do eixo X para a diereita
	addi a2, a2, 15			# update temporario do eixo Y para baixo
	call checkCollision		# check de colisao inferior direita
	addi a1, a1, -16		# cancela o update temporario do eixo X para a direita
	addi a2, a2, -15		# cancela o update temporario do eixo Y para a esquerda
	li t0, 0			# t0 = 0
	beq t1, t0, moveMul		# se ha colisao, pula para "moveMul"
	
	li t0, 1			# t0 = 1
	lw t1, 44(s1)			# t1 = mulLeftOrRight
	beq t0, t1, mulIsRight	 
	addi s5, s5, 528		# s5 += 528, se estiver pra esquerda
	sw t0, 44(s1)			# mulLeftOrRight = 1 = direita
	mulIsRight:
	sw t0, 36(s1)			# mulRunningState = 1 = direita
	
	addi a1, a1, 4			# update da posicao para 4 pixels para a direita
	
	li t1, 300			# t1 = 300
	bne a1, t1, dontTeleportRightMul# se posX != 300, pula pra "dontTeleportRightMul"
	li t1, 1
	lw t0, 36(s1)
	bne t0, t1, dontTeleportRightMul# se movState == left, pula pra "dontTeleportRightMul"
	li a1, 0			# usa o teleporte da direita
	dontTeleportRightMul:
	j mulHasMoved
	
moveMulUp:
	li t1, 2
	bne t0, t1, moveMulDown		# t0 == 2
	
	addi a2, a2, -4			# update temporario do eixo Y para cima
	call checkCollision		# check de colisao superior equerda
	addi a2, a2, 4			# cancela o update temporario do eixo Y
	li t0, 0			# t0 = 0
	beq t1, t0, moveMul		# se ha colisao, pula para "moveMul"
	
	addi a2, a2, -4			# update temporario do eixo Y para cima
	addi a1, a1, 12			# update temporario do eixo X para direita
	call checkCollision		# check de colisao superior direito
	addi a2, a2, 4			# cancela update temporario do eixo Y para cima
	addi a1, a1, -12		# cancela update temporario do eixo X para direita
	li t0, 0			# t0 = 0
	beq t0, t1, moveMul		# se ha colisao, pula para "moveMul"
	
	li t0, 2
	sw t0, 36(s1)
	
	addi a2, a2, -4			# update da posicao para 4 pixels para a cima
	
	li t1, 12
	bge a2, t1, dontTeleportUpMul
	li a2, 228
	dontTeleportUpMul:
	j mulHasMoved
	
moveMulDown:
	addi a2, a2, 16			# update temporario do eixo Y para baixo
	call checkCollision		# check de colisao inferior equerda
	addi a2, a2, -16		# cancela o update temporario do eixo Y
	li t0, 0			# t0 = 0
	beq t1, t0, moveMul		# se ha colisao, pula para "moveMul"
	
	addi a2, a2, 16			# update temporario do eixo Y para baixo
	addi a1, a1, 12			# update temporario do eixo X para direita
	call checkCollision		# check de colisao superior direito
	addi a2, a2, -16		# cancela o update temporario do eixo Y 
	addi a1, a1, -12		# cancela o update temporario do eixo X
	li t0, 0			# t0 = 0
	beq t0, t1, moveMul		# se ha colisao, pula para "moveMul"
	
	li t0, 3
	sw t0, 36(s1)
	
	addi a2, a2, 4			# update da posicao para 4 pixels para a baixo
	
	li t1, 228
	bne a2, t1, mulHasMoved
	li a2, 12 
	
	
mulHasMoved:
	mv a0, s5				# a0 = spriteMuller
	sw a1, 24(s1)				# posXMul = a1
    	sw a2, 28(s1)				# posYMul = a2
    	call print
    	    	
    	lw t1, 0(s11)
    	lw t2, 4(s11)
    	
    	lw t3, 32(s1)
    	bltz t3, gotze
  	
    	blt a1, t1, mulDontTouch  	
    	addi t1, t1, 15	
    	bgt a1, t1, mulDontTouch
    	blt a2, t2, mulDontTouch	
    	addi t2, t2, 15
    	bgt a2, t2, mulDontTouch
    	j mulTouch
    	mulDontTouch:
		lw t0, 40(s1)			# t0 = frameMulAnimacao
		li t1, 264			# t1 = 264
		mul t1, t1, t0			# t0 = +/- 264
		add s5, s5, t1			# muda o sprite do Muller para ser animado
		li t1, -1			# t1= -1
		mul t0, t0, t1			# t0 *= -1
		sw t0, 40(s1)			# guarda t0 em frameMulAnimacao
gotze:
	lw a1, 48(s1)			# a1 = posXGot
    	lw a2, 52(s1)			# a2 = posYGot
    	
    	lw t0, 56(s1)			# t0 = timeOutGot
    	bgtz t0, dontStartGot		# if t0 > 0, pula pra dontStartGot
    	addi t0, t0, 1			# t0 += 1
    	sw t0, 56(s1)			# timeOutGot = t0
    	bnez t0, gotHasMoved		# if t0 != 0, pula pra gotHasMoved
    	li t1, 144			
    	li t2, 96
    	li t3, 1
    	sw t1, 48(s1)			# posXGot = 144
    	sw t2, 52(s1)			# posYGot = 96
    	sw t3, 60(s1)			# runningStateGot = 1 (left)
    	sw t3, 64(s1)			# frameGotAnimacao = 1
dontStartGot:
    	lw a1, 0(s1)			# a1 = posXBoa
    	lw a2, 4(s1)			# a2 = posYBoa		
    	lw t0, 0(s11)			# t0 = posXFuleco			
    	lw t1, 4(s11)			# t1 = posYFuleco
    	
    	add t0, t0, t0			# t0 = 2*posXFul
    	sub t0, t0, a1			# t0 = 2*posXFul - posXBoa
    	add t1, t1, t1			# t1 = 2*posYFul
    	sub t2, t1, a2			# t2 = 2*posYFul - posYBoa
    	
    	lw a1, 48(s1)			# a1 = posXgot
    	lw a2, 52(s1)			# a2 = posYGot
    	sub t0, t0, a1			# t0 = t0 - posXGot
    	sub t2, t2, a2			# t2 = t2 - posYGot

    	mv a0, s8			# a0 = collisionMap
    	
    	lw t3, 60(s1)			# t3 = runningStateGot
    	
    	lw t4, 16(s11)
	
	bnez t4, gotIsAfraid
	beqz t0, gotXZero
	bgtz t0, gotXGreater
	bltz t0, gotXLess
	
gotIsAfraid:
	beqz t3, gotIsAfraidLeft		
	addi t3, t3, -1
	beqz t3, gotIsAfraidRight
	addi t3, t3, -1
	beqz t3, gotIsAfraidUp
	j gotIsAfraidDown
	gotIsAfraidLeft:
		li a4, 177 		# a4 = 10.11.00.01 ( cima, baixo, esquerda, direita )
		j moveGot
	gotIsAfraidRight:	
		li a4, 228 		# a4 = 11.10.01.00 ( baixo, cima, direita, esquerda )
		j moveGot
	gotIsAfraidUp:
		li a4, 75 		# a4 = 01.00.10.11 ( direita, esquerda, cima, baixo )
		j moveGot
	gotIsAfraidDown:
		li a4, 30		# a4 = 00.01.11.10 ( esquerda, direita, baixo, cima )
		j moveGot
		
gotXZero:	# x == 0
	beqz t3, gotXZeroLeft		
	addi t3, t3, -1
	beqz t3, gotXZeroRight
	addi t3, t3, -1
	beqz t3, gotXZeroUp
	j gotXZeroDown
	gotXZeroLeft:		# t3 == 0
		beqz t2, gotTouch	# se y == 0, pula pra gotTouch
		bltz t2, gotXZeroLeftUp
		bgtz t2, gotXZeroLeftDown
		gotXZeroLeftUp:		# y < 0
			li a4, 141	# a4 = 10.00.11.01 ( cima, esquerda, baixo, direita )
			j moveGot
		gotXZeroLeftDown:	# y > 0
			li a4, 201	# a4 = 11.00.10.01 ( baixo, esquerda, cima, direita )
			j moveGot
	gotXZeroRight:		# t3 == 1
		beqz t2, gotTouch	# se y == 0, pula pra gotTouch
		bltz t2, gotXZeroRightUp
		bgtz t2, gotXZeroRightDown
		gotXZeroRightUp:	# y < 0	
			li a4, 156	# a4 = 10.01.11.00 ( cima, direita, baixo, esquerda )
			j moveGot
		gotXZeroRightDown:	# y > 0
			li a4, 216	# a4 = 11.01.10.00 ( baixo, direita, cima, esquerda )
			j moveGot
	gotXZeroUp:		# t3 == 2
		beqz t2, gotTouch	# se y == 0, pula pra gotTouch
		bltz t2, gotXZeroUpUp
		bgtz t2, gotXZeroUpDown
		gotXZeroUpUp:	# y < 0
			li a4, 147	# a4 = 10.01.00.11 ( cima, diretia, esquerda, baixo )
			j moveGot
		gotXZeroUpDown:	# y > 0
			li a4, 27	# a4 = 00.01.10.11 ( esquerda, direita, cima, baixo )
			j moveGot
	 gotXZeroDown:
	 	beqz t2, gotTouch	# se y == 0, pula pra gotTouch
	 	bltz t2, gotXZeroDownUp
	 	bgtz t2, gotXZeroDownDown
	 	gotXZeroDownUp:	# y < 0
	 		li a4, 78	# a4 = 01.00.11.10 ( direita, esquerda, baixo, cima )
	 		j moveGot	
	 	gotXZeroDownDown:# y >= 0
	 		li a4, 198	# a4 = 11.00.01.10 ( baixo, esquerda, direita, cima )
	 		j moveGot
gotXGreater:	# x > 0 ( direita )
	beqz t3, gotXGreaterLeft
	addi t3, t3, -1
	beqz t3, gotXGreaterRight
	addi t3, t3, -1
	beqz t3, gotXGreaterUp
	j gotXGreaterDown
	gotXGreaterLeft:	# t3 == 0
		bltz t2, gotXGreaterLeftUp
		bgez t2, gotXGreaterLeftDown
		gotXGreaterLeftUp:	# y < 0
			li a4, 141	# a4 = 10.00.11.01 ( cima, esqurda, baixo, direita )
			j moveGot
		gotXGreaterLeftDown:	# y >= 0
			li a4, 201	# a4 = 11.00.10.01 ( baixo, esquerda, cima, direita )
			j moveGot
	gotXGreaterRight:	# t3 == 1
		bltz t2, gotXGreaterRightUp
		bgez t2, gotXGreaterRightDown
		gotXGreaterRightUp:	# y < 0
			li a4, 108	# a4 = 01.10.11.00 ( direita, cima, baixo, esquerda )
			j moveGot
		gotXGreaterRightDown:	
			li a4, 120	# a4 = 01.11.10.00 ( direita, baixo, cima, esquerda )
			j moveGot
	gotXGreaterUp:		# t3 == 2
		bltz t2, gotXGreaterUpUp
		bgez t2, gotXGreaterUpDown
		gotXGreaterUpUp:			
			li a4, 99	# a4 = 01.10.00.11 ( direita, cima, esquerda, baixo ) 	
			j moveGot
		gotXGreaterUpDown:
			li a4, 75	# a4 = 01.00.10.11 ( direita, esquerda, cima, baixo )
			j moveGot
	gotXGreaterDown:	# t3 == 3
		bltz t2, gotXGreaterDownUp
		bgez t3, gotXGreaterDownDown
		gotXGreaterDownUp:
			li a4, 78	# a4 = 01.00.11.10 ( direita, esquerda, baixo, cima )
			j moveGot		
		gotXGreaterDownDown:
			li a4, 114	# a4 = 01.11.00.10 ( direita, baixo, esquerda, cima )
			j moveGot

gotXLess:	# x < 0 (esquerda)
	beqz t3, gotXLessLeft	
	addi t3, t3, -1
	beqz t3, gotXLessRight
	addi t3, t3, -1
	beqz t3, gotXLessUp
	addi t3, t3, -1
	beqz t3, gotXLessDown
	gotXLessLeft:		# t3 == 0
		bltz t2, gotXLessLeftUp
		bgez t2, gotXLessLeftDown
		gotXLessLeftUp:		# y < 0
			li a4, 45	# a4 = 00.10.11.01 ( esquerda, cima, baixo, direita )
			j moveGot
		gotXLessLeftDown:	# y >= 0
			li a4, 57	# a4 = 00.11.10.01 ( esquerda, baixo, cima, direita )
			j moveGot
	gotXLessRight:		# t3 == 1
		bltz t2, gotXLessRightUp
		bgez t2, gotXLessRightDown
		gotXLessRightUp:	# y < 0
			li a4, 156	# a4 = 10.01.11.00 ( cima, direita, baixo, esquerda )
			j moveGot
		gotXLessRightDown:	# y >= 0
			li a4, 216	# a4 = 11.01.10.00 ( baixo, direita, cima, esquerda )  
			j moveGot
	gotXLessUp:		# t3 == 2
		bltz t2, gotXLessUpUp
		bgez t2, gotXLessUpDown
		gotXLessUpUp:		# y < 0
			li a4, 39	# a4 = 00.10.01.11 ( esquerda, cima, direita, baixo )  
			j moveGot
		gotXLessUpDown:		# y >= 0
			li a4, 27 	# a4 = 00.01.10.11 ( esquerda, direita, cima, baixo )
			j moveGot
	gotXLessDown:		# t3 == 3    	
		bltz t2, gotXLessDownUp
		bgez t2, gotXLessDownDown
		gotXLessDownUp:		# y < 0
			li a4, 30 	# a4 = 00.01.11.10 ( esquerda, direita, baixo, cima )
		 	j moveGot
		gotXLessDownDown: 	# y < 0
			li a4, 54	# a4 = 00.11.01.10 ( esquerda, baixo, direita, cima )
			j moveGot
gotTouch:
	lw t0, 16(s11)
	
	beqz t0, gotKillFuleco
		li a1, 154			# posXGot = 154
		li a2, 128			# posYGot = 128
		li t1, -131
		sw t1, 56(s1)			# gotTimeout = -131
		li t0, 0
		lw t1, 68(s1)			# t1 = LeftOrRightGot
		beqz t1, gotIsDeadAndLeft	
		addi s6, s6, -528		# s6 -= 528, se tiver pra direita 
		sw t0, 68(s1)			# LeftOrRightGot = 0 = esquerda
		gotIsDeadAndLeft:
		lw t1, 64(s1)			# t1 = frameAnimacaoGot
		bgtz t1, gotIsDeadAndFrame0	
		addi s6, s6, -264		# s6 -= 264, se tiver no frame 1
		sw zero, 64(s1)			# frameGot = 0
		gotIsDeadAndFrame0:
		j gotHasMoved

	gotKillFuleco:			# superState == 0
		addi s0, s0, -1
		bgtz s0, restartGame  
		li a7, 10
		ecall
		
moveGot:
	srli t0, a4, 6			# t0 = ultimos 2 bits d a4 (xx.--.--.--)
	slli t1, t0, 6
	sub a4, a4, t1
	slli a4, a4, 2			# a4 = xx.xx.xx.00

	mv a0, s8			# a0 = collisionMap
	
	bnez t0, moveGotRight		# t0 == 0
	addi a1, a1, -4			# update temporario da posicao para 4 pixels para esquerda
	call checkCollision		# check da colisao superior esquerda
	li t0, 0			# t0 = 0
	addi a1, a1, 4			# cancela o update temporario do eixo X
	beq t1, t0, moveGot		# se ha colisao, pula para "moveGot"
	
	addi a1, a1, -4			# update da posicao para 4 pixels para esquerda
	addi a2, a2, 15			# update da posicao para 15 pixels para baixo
	call checkCollision		# check da colisao inferior esquerda
	li t0, 0			# t0 = 0
	addi a1, a1, 4			# cancela o update temporario do eixo X
	addi a2, a2, -15		# cancela o update temporario do eixo Y
	beq t1, t0, moveGot		# se ha colisao, pula para "moveGot"
	
	li t0, 0			# t0 = 0
	lw t1, 68(s1)			# t1 = LeftOrRightGot
	beq t0, t1, gotIsLeft	
	addi s6, s6, -528		# s6 -= 528, se tiver pra direita
	sw t0, 68(s1)			# LeftOrRightGot = 0 = esquerda
	gotIsLeft:
	sw t0, 60(s1)			# RunningStateGot = 0 = equerda
	
	addi a1, a1, -4			# update da posicao para 4 pixels para a esquerda
	
	li t1, 0			# t1 = 0
	bne a1, t1, dontTeleportLeftGot	# se posX != 0, pula pra "dontTeleportLeftGot"
	li t1, 0			# t1 = 0
	lw t0, 60(s1)			# t0 = runningStateGot
	bne t0, t1, dontTeleportLeftGot	# se movState == right, pula pra "dontTeleportLeftGot" 
	li a1, 288			# usa o teleporte da esquerda
	dontTeleportLeftGot:
	j gotHasMoved
	
moveGotRight:
	li t1, 1
	bne t0, t1, moveGotUp		# t0 == 1
	
	addi a1, a1, 16			# update temporario do eixo X para a direita 
	call checkCollision		# check de colisao superior direita
	addi a1, a1, -16		# cancela o update temporario do eixo X para a direita
	li t0, 0			# t0 = 0
	beq t1, t0, moveGot		# se ha colisao, pula para "moveGot"
	
	addi a1, a1, 16			# update temporario do eixo X para a diereita
	addi a2, a2, 15			# update temporario do eixo Y para baixo
	call checkCollision		# check de colisao inferior direita
	addi a1, a1, -16		# cancela o update temporario do eixo X para a direita
	addi a2, a2, -15		# cancela o update temporario do eixo Y para a esquerda
	li t0, 0			# t0 = 0
	beq t1, t0, moveGot		# se ha colisao, pula para "moveGot"
	
	li t0, 1			# t0 = 1
	lw t1, 68(s1)			# t1 = gotLeftOrRight
	beq t0, t1, gotIsRight	 
	addi s6, s6, 528		# s6 += 528, se estiver pra esquerda
	sw t0, 68(s1)			# gotLeftOrRight = 1 = direita
	gotIsRight:
	sw t0, 60(s1)			# gotRunningState = 1 = direita
	
	addi a1, a1, 4			# update da posicao para 4 pixels para a direita
	
	li t1, 300			# t1 = 300
	bne a1, t1, dontTeleportRightGot# se posX != 300, pula pra "dontTeleportRightGot"
	li t1, 1
	lw t0, 60(s1)			# t0 = runningStateGot
	bne t0, t1, dontTeleportRightGot# se movState == left, pula pra "dontTeleportRightGot"
	li a1, 0			# usa o teleporte da direita
	dontTeleportRightGot:
	j gotHasMoved
	
moveGotUp:
	li t1, 2
	bne t0, t1, moveGotDown		# t0 == 2
	
	addi a2, a2, -4			# update temporario do eixo Y para cima
	call checkCollision		# check de colisao superior equerda
	addi a2, a2, 4			# cancela o update temporario do eixo Y
	li t0, 0			# t0 = 0
	beq t1, t0, moveGotUp		# se ha colisao, pula para "moveGotUp"
	
	addi a2, a2, -4			# update temporario do eixo Y para cima
	addi a1, a1, 12			# update temporario do eixo X para direita
	call checkCollision		# check de colisao superior direito
	addi a2, a2, 4			# cancela update temporario do eixo Y para cima
	addi a1, a1, -12		# cancela update temporario do eixo X para direita
	li t0, 0			# t0 = 0
	beq t0, t1, moveGotUp		# se ha colisao, pula para "moveGotUp"
	
	li t0, 2
	sw t0, 60(s1)			# runningStateGot = 2 = up
	
	addi a2, a2, -4			# update da posicao para 4 pixels para a cima
	
	li t1, 12
	bge a2, t1, dontTeleportUpGot
	li a2, 228
	dontTeleportUpGot:
	j gotHasMoved
	
moveGotDown:
	addi a2, a2, 16			# update temporario do eixo Y para baixo
	call checkCollision		# check de colisao inferior equerda
	addi a2, a2, -16		# cancela o update temporario do eixo Y
	li t0, 0			# t0 = 0
	beq t1, t0, moveGot		# se ha colisao, pula para "moveGot"
	
	addi a2, a2, 16			# update temporario do eixo Y para baixo
	addi a1, a1, 12			# update temporario do eixo X para direita
	call checkCollision		# check de colisao superior direito
	addi a2, a2, -16		# cancela o update temporario do eixo Y 
	addi a1, a1, -12		# cancela o update temporario do eixo X
	li t0, 0			# t0 = 0
	beq t0, t1, moveGot		# se ha colisao, pula para "moveGot"
	
	li t0, 3
	sw t0, 60(s1)
	
	addi a2, a2, 4			# update da posicao para 4 pixels para a baixo
	
	li t1, 228
	bne a2, t1, gotHasMoved
	li a2, 12 
	
gotHasMoved:
	mv a0, s6				# a0 = spriteGotze
	sw a1, 48(s1)				# posXGot = a1
    	sw a2, 52(s1)				# posYgot = a2
    	call print
    	
    	lw t1, 0(s11)
    	lw t2, 4(s11)
    	
    	lw t3, 56(s1)				# t3 = timeOutGot
    	bltz t3, kross
  	
    	blt a1, t1, gotDontTouch  	
    	addi t1, t1, 15	
    	bgt a1, t1, gotDontTouch
    	blt a2, t2, gotDontTouch	
    	addi t2, t2, 15
    	bgt a2, t2, gotDontTouch
    	j gotTouch
    	gotDontTouch:
		lw t0, 64(s1)			# t0 = frameAnimacaoGot
		li t1, 264			# t1 = 264
		mul t1, t1, t0			# t0 = +/- 264
		add s6, s6, t1			# muda o sprite do Gotze para ser animado
		li t1, -1			# t1= -1
		mul t0, t0, t1			# t0 *= -1
		sw t0, 64(s1)			# guarda t0 em frameAnimacaoGot

kross:
	lw a1, 72(s1)			# a1 = posXKross
	lw a2, 76(s1)			# a2 = posYKross
	
	lw t0, 80(s1)			# t0 = timeOutKro
	bgtz t0, dontStartKro		
	addi t0, t0, 1
	sw t0, 80(s1)
	bnez t0, kroHasMoved
	li t1, 144			
    	li t2, 96
    	li t3, 1
    	sw t1, 72(s1)			# posXKro = 144
    	sw t2, 76(s1)			# posYKro = 96
    	sw t3, 84(s1)			# runningStateKro = 1 (left)
    	sw t3, 88(s1)			# frameAnimacaoKro = 1
	dontStartKro:
	lw a1, 24(s1)			# a1 = posXMul
    	lw a2, 28(s1)			# a2 = posYMul		
    	lw t0, 0(s11)			# t0 = posXFuleco			
    	lw t1, 4(s11)			# t1 = posYFuleco
    	
    	add t0, t0, t0			# t0 = 2*posXFul
    	sub t0, t0, a1			# t0 = 2*posXFul - posXBoa
    	add t1, t1, t1			# t1 = 2*posYFul
    	sub t2, t1, a2			# t2 = 2*posYFul - posYBoa

    	
    	lw a1, 72(s1)			# a1 = posXKro
	lw a2, 76(s1)			# a2 = posYKro
    	sub t0, t0, a1			# t0 = t0 - posXGot
    	sub t2, t2, a2			# t2 = t2 - posYGot	

    	mv a0, s8			# a0 = collisionMap
    	
    	lw t3, 84(s1)			# t3 = runningStateKro
    	
    	lw t4, 16(s11)			# t4 = superState
    	
	bnez t4, kroIsAfraid
	beqz t2, kroYZero
	bgtz t2, kroYGreater
	bltz t2, kroYLess
	
kroIsAfraid:
	beqz t3, kroIsAfraidLeft		
	addi t3, t3, -1
	beqz t3, kroIsAfraidRight
	addi t3, t3, -1
	beqz t3, kroIsAfraidUp
	j kroIsAfraidDown
	kroIsAfraidLeft:
		li a4, 177 		# a4 = 10.11.00.01 ( cima, baixo, esquerda, direita )
		j moveKro
	kroIsAfraidRight:	
		li a4, 228 		# a4 = 11.10.01.00 ( baixo, cima, direita, esquerda )
		j moveKro
	kroIsAfraidUp:
		li a4, 75 		# a4 = 01.00.10.11 ( direita, esquerda, cima, baixo )
		j moveKro
	kroIsAfraidDown:
		li a4, 30		# a4 = 00.01.11.10 ( esquerda, direita, baixo, cima )
		j moveKro
		
kroYZero:
	beqz t3, kroYZeroLeft		
	addi t3, t3, -1
	beqz t3, kroYZeroRight
	addi t3, t3, -1
	beqz t3, kroYZeroUp
	j kroYZeroDown
	kroYZeroLeft:	 
		bltz t0, kroYZeroLeftLeft
		beqz t0, kroTouch
		bgtz t0, kroYZeroLeftRight
		kroYZeroLeftLeft:
			li a4, 45		# a4 = 00.10.11.01 ( esquerda, cima, baixo, direita ) 
			j moveKro
		kroYZeroLeftRight:
			li a4, 225		# a4 = 11.10.00.01 ( baixo, cima, esquerda, direita ) 
			j moveKro
	kroYZeroRight:
		bltz t0, kroYZeroRightLeft
		beqz t0, kroTouch
		bgtz t0, kroYZeroRightRight
		kroYZeroRightLeft:
			li a4, 180 		# a4 = 10.11.01.00 ( cima, baixo, direita, esquerda )
			j moveKro
		kroYZeroRightRight:
			li a4, 120 		# a4 = 01.11.10.00 ( direita, baixo, cima, esquerda )
			j moveKro
	kroYZeroUp:
		bltz t0, kroYZeroUpLeft
		beqz t0, kroTouch
		bgtz t0, kroYZeroUpRight
		kroYZeroUpLeft:
			li a4, 39		# a4 = 00.10.01.11 ( esquerda, cima, direita, baixo )
			j moveKro
		kroYZeroUpRight:
			li a4, 99		# a4 = 01.10.00.11 ( direita, cima, esquerda, baixo )
			j moveKro
	kroYZeroDown:
		bltz t0, kroYZeroDownLeft
		beqz t0, kroTouch
		bgtz t0, kroYZeroDownRight
		kroYZeroDownLeft:
			li a4, 54 		# a4 = 00.11.01.10 ( esquerda, baixo, direita, cima )
			j moveKro
		kroYZeroDownRight:
			li a4, 114		# a4 = 01.11.00.10 ( direita, baixo, esquerda, cima )
			j moveKro
kroYGreater:
	beqz t3, kroYGreaterLeft		
	addi t3, t3, -1
	beqz t3, kroYGreaterRight
	addi t3, t3, -1
	beqz t3, kroYGreaterUp
	j kroYGreaterDown
	kroYGreaterLeft:
		bltz t0, kroYGreaterLeftLeft
		bgez t0, kroYGreaterLeftRight
		kroYGreaterLeftLeft:
			li a4, 201 		# a4 = 11.00.10.01 ( baixo, esquerda, cima, direita )
			j moveKro
		kroYGreaterLeftRight:
			li a4, 225		# a4 = 11.10.00.01 ( baixo, cima, esquerda, direita )
			j moveKro
	kroYGreaterRight:
		bltz t0, kroYGreaterRightLeft
		bgez t0, kroYGreaterRightRight
		kroYGreaterRightLeft:
			li a4, 228 		# a4 = 11.10.01.00 ( baixo, cima, direita, esquerda )
			j moveKro
		kroYGreaterRightRight:
			li a4, 216		# a4 = 11.01.10.00 ( baixo, direita, cima, esquerda )
			j moveKro
	kroYGreaterUp:
		bltz t0, kroYGreaterUpLeft
		bgez t0, kroYGreaterUpRight
		kroYGreaterUpLeft:
			li a4, 27		# a4 = 00.01.10.11 ( esquerda, direita, cima, baixo )
			j moveKro
		kroYGreaterUpRight:
			li a4, 75		# a4 = 01.00.10.11 ( direita, esquerda, cima, baixo ) 
			j moveKro
	kroYGreaterDown:
		bltz t0, kroYGreaterDownLeft
		bgtz t0, kroYGreaterDownRight
		kroYGreaterDownLeft:
			li a4, 198 		# a4 = 11.00.01.10 ( baixo, esquerda, direita, cima ) 
			j moveKro
		kroYGreaterDownRight:
			li a4, 210 		# a4 = 11.01.00.10 ( baixo, direita, esquerda, cima )
			j moveKro
kroYLess:
	beqz t3, kroYLessLeft		
	addi t3, t3, -1
	beqz t3, kroYLessRight
	addi t3, t3, -1
	beqz t3, kroYLessUp
	j kroYLessDown
	kroYLessLeft:
		bltz t0, kroYLessLeftLeft
		bgez t0, kroYLessLeftRight
		kroYLessLeftLeft:
			li a4, 141 		# a4 = 10.00.11.01 ( cima, esquerda, baixo, direita )
			j moveKro
		kroYLessLeftRight:
			li a4, 177		# a4 = 10.11.00.01 ( cima, baixo, esquerda, direita )
			j moveKro
	kroYLessRight:
		bltz t0, kroYLessRightLeft
		bgez t0, kroYLessRightRight
		kroYLessRightLeft:
			li a4, 180		# a4 = 10.11.01.00 ( cima, baixo, direita, esquerda )
			j moveKro
		kroYLessRightRight:
			li a4, 156		# a4 = 10.01.11.00 ( cima, direita, baixo, esquerda )
			j moveKro
	kroYLessUp: 
		bltz t0, kroYLessUpLeft
		bgez t0, kroYLessUpRight
		kroYLessUpLeft:
			li a4, 135		# a4 = 10.00.01.11 ( cima, esquerda, direita, baixo )
			j moveKro
		kroYLessUpRight:
			li a4, 147 		# a4 = 10.01.00.11 ( cima, direita, esquerda, baixo )
			j moveKro
	kroYLessDown:
		bltz t0, kroYLessDownLeft
		bgez t0, kroYLessDownRight
		kroYLessDownLeft:
			li a4, 30		# a4 = 00.01.11.10 ( esquerda, direita, baixo, cima )
			j moveKro
		kroYLessDownRight:
			li a4, 78 		# a4 = 01.00.11.10 ( direita, esquerda, baixo, cima )
			j moveKro
kroTouch:	
	lw t0, 16(s11)
	
	beqz t0, kroKillFuleco
		li a1, 174			# posXKro = 174
		li a2, 128			# posYKro = 128
		li t1, -131
		sw t1, 80(s1)			# timeOutKro = -131
		li t0, 0
		lw t1, 92(s1)			# t1 = leftOrRightKro
		beqz t1, kroIsDeadAndLeft	
		addi s7, s7, -528		# s7 -= 528, se tiver pra direita 
		sw t0, 92(s1)			# leftOrRightKro = 0 = esquerda
		kroIsDeadAndLeft:
		lw t1, 88(s1)			# t1 = frameAnimacaoKro
		bgtz t1, kroIsDeadAndFrame0	
		addi s7, s7, -264		# s7 -= 264, se tiver no frame 1
		sw zero, 88(s1)			# frameAnimacaoKro = 0
		kroIsDeadAndFrame0:
		j kroHasMoved

	kroKillFuleco:			# superState == 0
		addi s0, s0, -1
		bgtz s0, restartGame  
		li a7, 10
		ecall		

moveKro:
	srli t0, a4, 6			# t0 = ultimos 2 bits d a4 (xx.--.--.--)
	slli t1, t0, 6
	sub a4, a4, t1
	slli a4, a4, 2			# a4 = xx.xx.xx.00

	mv a0, s8			# a0 = collisionMap
	
	bnez t0, moveKroRight		# t0 == 0
	addi a1, a1, -4			# update temporario da posicao para 4 pixels para esquerda
	call checkCollision		# check da colisao superior esquerda
	li t0, 0			# t0 = 0
	addi a1, a1, 4			# cancela o update temporario do eixo X
	beq t1, t0, moveKro		# se ha colisao, pula para "moveKro"
	
	addi a1, a1, -4			# update da posicao para 4 pixels para esquerda
	addi a2, a2, 15			# update da posicao para 15 pixels para baixo
	call checkCollision		# check da colisao inferior esquerda
	li t0, 0			# t0 = 0
	addi a1, a1, 4			# cancela o update temporario do eixo X
	addi a2, a2, -15		# cancela o update temporario do eixo Y
	beq t1, t0, moveKro		# se ha colisao, pula para "moveKro"
	
	li t0, 0			# t0 = 0
	lw t1, 92(s1)			# t1 = leftOrRightKro
	beq t0, t1, kroIsLeft	
	addi s7, s7, -528		# s7 -= 528, se tiver pra direita
	sw t0, 92(s1)			# leftOrRightKro = 0 = esquerda
	kroIsLeft:
	sw t0, 84(s1)			# runningStateKro = 0 = equerda
	
	addi a1, a1, -4			# update da posicao para 4 pixels para a esquerda
	
	li t1, 0			# t1 = 0
	bne a1, t1, dontTeleportLeftKro	# se posX != 0, pula pra "dontTeleportLeftKro"
	li t1, 0			# t1 = 0
	lw t0, 84(s1)
	bne t0, t1, dontTeleportLeftKro	# se movState == right, pula pra "dontTeleportLeftKro" 
	li a1, 288			# usa o teleporte da esquerda
	dontTeleportLeftKro:
	j kroHasMoved
	
moveKroRight:
	li t1, 1
	bne t0, t1, moveKroUp		# t0 == 1
	
	addi a1, a1, 16			# update temporario do eixo X para a direita 
	call checkCollision		# check de colisao superior direita
	addi a1, a1, -16		# cancela o update temporario do eixo X para a direita
	li t0, 0			# t0 = 0
	beq t1, t0, moveKro		# se ha colisao, pula para "moveKro"
	
	addi a1, a1, 16			# update temporario do eixo X para a diereita
	addi a2, a2, 15			# update temporario do eixo Y para baixo
	call checkCollision		# check de colisao inferior direita
	addi a1, a1, -16		# cancela o update temporario do eixo X para a direita
	addi a2, a2, -15		# cancela o update temporario do eixo Y para a esquerda
	li t0, 0			# t0 = 0
	beq t1, t0, moveKro		# se ha colisao, pula para "moveKro"
	
	li t0, 1			# t0 = 1
	lw t1, 92(s1)			# t1 = leftOrRightKro
	beq t0, t1, kroIsRight	 
	addi s7, s7, 528		# s7 += 528, se estiver pra esquerda
	sw t0, 92(s1)			# leftOrRightKro = 1 = direita
	kroIsRight:
	sw t0, 84(s1)			# runningStateKro = 1 = direita
	
	addi a1, a1, 4			# update da posicao para 4 pixels para a direita
	
	li t1, 300			# t1 = 300
	bne a1, t1, dontTeleportRightKro# se posX != 300, pula pra "dontTeleportRightKro"
	li t1, 1
	lw t0, 84(s1)
	bne t0, t1, dontTeleportRightKro# se movState == left, pula pra "dontTeleportRightKro"
	li a1, 0			# usa o teleporte da direita
	dontTeleportRightKro:
	j kroHasMoved
	
moveKroUp:
	li t1, 2
	bne t0, t1, moveKroDown		# t0 == 2
	
	addi a2, a2, -4			# update temporario do eixo Y para cima
	call checkCollision		# check de colisao superior equerda
	addi a2, a2, 4			# cancela o update temporario do eixo Y
	li t0, 0			# t0 = 0
	beq t1, t0, moveKro		# se ha colisao, pula para "moveKro"
	
	addi a2, a2, -4			# update temporario do eixo Y para cima
	addi a1, a1, 12			# update temporario do eixo X para direita
	call checkCollision		# check de colisao superior direito
	addi a2, a2, 4			# cancela update temporario do eixo Y para cima
	addi a1, a1, -12		# cancela update temporario do eixo X para direita
	li t0, 0			# t0 = 0
	beq t0, t1, moveKro		# se ha colisao, pula para "moveKro"
	
	li t0, 2
	sw t0, 84(s1)
	
	addi a2, a2, -4			# update da posicao para 4 pixels para a cima
	
	li t1, 12
	bge a2, t1, dontTeleportUpKro
	li a2, 228
	dontTeleportUpKro:
	j kroHasMoved
	
moveKroDown:
	addi a2, a2, 16			# update temporario do eixo Y para baixo
	call checkCollision		# check de colisao inferior equerda
	addi a2, a2, -16		# cancela o update temporario do eixo Y
	li t0, 0			# t0 = 0
	beq t1, t0, moveKro		# se ha colisao, pula para "moveKro"
	
	addi a2, a2, 16			# update temporario do eixo Y para baixo
	addi a1, a1, 12			# update temporario do eixo X para direita
	call checkCollision		# check de colisao superior direito
	addi a2, a2, -16		# cancela o update temporario do eixo Y 
	addi a1, a1, -12		# cancela o update temporario do eixo X
	li t0, 0			# t0 = 0
	beq t0, t1, moveKro		# se ha colisao, pula para "moveKro"
	
	li t0, 3
	sw t0, 84(s1)
	
	addi a2, a2, 4			# update da posicao para 4 pixels para a baixo
	
	li t1, 228
	bne a2, t1, kroHasMoved
	li a2, 12 
	
	
kroHasMoved:
	mv a0, s7				# a0 = spriteKross
	sw a1, 72(s1)				# posXkro = a1
    	sw a2, 76(s1)				# posYKro = a2
    	call print
    	    	
    	lw t1, 0(s11)
    	lw t2, 4(s11)
    	
    	lw t3, 80(s1)
    	bltz t3, endGermany
  	
    	blt a1, t1, kroDontTouch  	
    	addi t1, t1, 15	
    	bgt a1, t1, kroDontTouch
    	blt a2, t2, kroDontTouch	
    	addi t2, t2, 15
    	bgt a2, t2, kroDontTouch
    	j kroTouch
    	kroDontTouch:
		lw t0, 88(s1)			# t0 = frameAnimacaoKro
		li t1, 264			# t1 = 264
		mul t1, t1, t0			# t0 = +/- 264
		add s7, s7, t1			# muda o sprite do Kross para ser animado
		li t1, -1			# t1= -1
		mul t0, t0, t1			# t0 *= -1
		sw t0, 88(s1)			# guarda t0 em frameAnimacaoKro

endGermany:
	li a0,76			# pausa de 76m segundos
	li a7,32
	ecall
	
	j loopgame
	
endGame:
	mv ra, a6		
	ret
restartGame:
	mv ra, a6
	addi ra, ra, -32
	ret
	
.include "src/print.s"
.include "src/checkCollision.s"
.include "src/printProps.s"

.data
fulecoInfo: .word 144, 176, 0, 0, 0, 1, 0	# posX, posY, runningState, points, superState, frameAnimacao, leftOrRight
germanyInfo: .word 114, 128, -130, 0, 0, 0, 134, 128, -180, 0, 0, 0, 154, 128, -230, 0, 0, 0, 174, 128, -280, 0, 0, 0 
	# posXBoa(0), posYBoa(4), timeOutBoa(8), runningStateBoa(12), frameAnimacaoBoa(16), leftorRightBoa(20)
	# posXMul(24), posYMul(28), timeOutMul(32), runningStateMul(36), frameAnimacaoMul(40), leftOrRightMul(44)
	# posXGot(48), posYGot(52), timeOutGot(56), runningStateGot(60), frameAnimacaoGot(64), leftOrRightGot(68)
	# posXKro(72), posYKro(76), timeOutKro(80), runningStateGot(84), frameAnimacaoKro(88), leftOrRightKro(92)
									
space: .string " "
ae: .string "moveu\n"
be: .string "b\n"
ce: .string "c\n"
de: .string "afraid "
.include "sprites/props/arquivos .data/dot.data"
.include "sprites/props/arquivos .data/brazuca.data"
 
	
