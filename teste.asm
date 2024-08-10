.data
.include "sprites/Mapas/arquivos .data/map1.data"		# inclui o .data com a imagem
.include "sprites/fuleco/arquivos .data/fixedFuleco0.data"		# inclui o .data com a imagem
.include "sprites/Mapas/arquivos .data/collisionmap1.data"



.text
	la s8, collisionmap1
	la s9, map1
	la s10, fixedFuleco0
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
	li a1, 144
	li a2, 176
	call print
	
	
	li s0, 0			# s0 = runing state : 0 = stop // 1 = left // 2 = right // 3 = up // 4 = down
loopgame:
	xori a3, a3, 1			# change frame 0 <--> 1
    # print map1
    	mv a0, s9
    	li a1, 0
    	li a2, 0
    	call print
	
	mv a1, s3
	mv a2, s4
	
	li t1,0xFF200000		# load KDMMIO andress
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
	beq t0,zero, goLeft  		# Se nao ha tecla pressionada entao vai pula
	lw t2,4(t1)  			# le o valor da tecla tecla
	sw t2,12(t1)  			# escreve a tecla pressionada no display
	
	
clcikLeft:
	li t1, 'a'
	bne t2, t1, clickRight
	li s0, 1
clickRight:
	li t1, 'd'
	bne t2, t1, clickUp
	li s0, 2
clickUp:	
	li t1, 'w'
	bne t2, t1, clickDown
	li s0, 3
clickDown:
	li t1, 's'
	bne t2, t1, goLeft
	li s0, 4

	mv a0, s8
goLeft:
	li t1, 1
	bne s0, t1, goRight
	addi a1, a1, -4
	call checkCollision
	li t0, 1
	beq t1, t0, pass
	addi a1, a1, 4
goRight:
	li t1, 2
	bne s0, t1, goUp
	addi a1, a1, 4
	call checkCollision
	li t0, 1
	beq t1, t0, pass
	addi a1, a1, -4
goUp:	
	li t1, 3
	bne s0, t1, goDown
	addi a2, a2, -4
	call checkCollision
	li t0, 1
	beq t1, t0, pass
	addi a2, a2, 4
goDown:
	li t1, 4
	bne s0, t1, pass
	addi a2, a2, 4
	call checkCollision
	li t0, 1
	beq t1, t0, pass
	addi a2, a2, -4		
pass:	
	li t1, 0
	bne a1, t1, dontTeleportLeft
	li t1, 64
	#bne a2, t1, dontTeleportLeft
	li t1, 2
	beq s0, t1, dontTeleportLeft
	li a1, 288
dontTeleportLeft:
	li t1, 300
	bne a1, t1, dontTeleportRight
	li t1, 64
	#bne a2, t1, dontTeleportLeft
	li t1, 1
	beq s0, t1, dontTeleportRight
	li a1, 0
dontTeleportRight:
	mv a0, s10
	mv s3, a1
	mv s4, a2
	call print
	
	li a0,76		# pausa de 76m segundos
	li a7,32
	ecall
	
	j loopgame
	
	
	
	
	
	
	
	
		
	li a7, 10
	#ecall
	
	
	
	#	a0 = endereço imagem			#
	#	a1 = x					#
	#	a2 = y					#
	#	a3 = frame (0 ou 1)
	
.include "src/print.s"
.include "src/checkCollision.s"
	


