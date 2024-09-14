
	#################################################
	#	a0 = endereço colisao			#
	#	a1 = x					#
	#	a2 = y					#
	#################################################

printProps:	
	mv a7, a0			# salva o endereco do mapa de colisoes no a7
	
loopPrintProps:
	li t0, 320			# t0 = 320	
	
	add t2, a7, a1			# t2 = endereco + a1
	mul t3, a2, t0			# t3 = a2*320
	add t2, t2, t3			# t2 = t2 + t3 = endereco + a1 + a2*320
	
	lw t3, 8(t2)			# t3 = word no endereco t2
	andi t3, t3, 0x000FF
		
	li t4, 7			# t4 = 7
	bne t3, t4, jDot		# se t3 != t4, pula para "jDot"
	la a0, dot			# a0 = endereco do pontinho
	call print			# printa pontinho
	li t3, 7			# volta o t3 para 7 (pra ter a outra verificacao)
	
jDot:
	li t4, 192			# t4 = 192
	bne t3, t4, jBrazuca		# se t3 != t4, pula para "jBrazuca"
	la a0, brazuca			# a0 = endereco da brazuca
	call print			# printa brazuca
	
jBrazuca:
	li t0, 320			# t0 = 320
	li t1, 240			# t1 = 240
		
	addi a1, a1, 16			# a1 += 1	
	blt a1, t0, loopPrintProps	# se a1 > 320, pula para "loopPrintProps"
	li a1, 0			# a1 = 0
	addi a2, a2, 16			# a2 += 1
	blt a2, t1, loopPrintProps	# se a2 > 240, pula para "loopPrintProps"
	
	j printHeart		# retorna
