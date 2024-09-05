
	#################################################
	#	a0 = endereço das colisoes		#
	#	a1 = x					#
	#	a2 = y					#
	#################################################

	#################################################
	
checkCollision:
	mv t0, a1
	li t1, 320
	mul t1, a2, t1
	add t0, t0, t1
	
	add t3, a0, t0
	lb t1, 11(t3)
	#srli t1, t1, 24
	
	li t0, -1
	beq t1, t0, block
	li t1, 1
	ret
	
block:	li t1, 0
	ret
