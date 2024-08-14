
	#################################################
	#	a0 = endereço colisao			#
	#	a1 = x					#
	#	a2 = y					#
	#	a3 = frame (0 ou 1)			#
	#################################################
	#	t0 = endereco do bitfundo display	#
	#	t1 = endereco da imagem			#
	#	t2 = contador de linha			#
	# 	t3 = contador de coluna			#
	#	t4 = largura				#
	#	t5 = altura				#
	#################################################

printProps:	
	mv a7, a0
	
	
loopPrintProps:
	li t0, 320
	li t1, 240
	
	add t2, a7, a1
	mul t3, a2, t0
	add t2, t2, t3
	
	lw t3, 0(t2)
	srli t3, t3, 24
	
	li t4, 7
	bne t3, t4, jDot
	la a0, dot
	call print
	li t3, 7
jDot:
	li t4, 192
	bne t3, t4, jBrazuca
	la a0, brazuca
	call print
jBrazuca:
	li t0, 320
	li t1, 240
	
	addi a1, a1, 1
	bne a1, t0, loopPrintProps
	li a1, 0
	addi a2, a2, 1
	bne a2, t1, loopPrintProps
	
	j input		# retorna
