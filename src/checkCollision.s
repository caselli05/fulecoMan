
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
	
	add a0, a0, t0
	lw t1, 0(a0)
	srli t1, t1, 4
	
	li a7,1
	mv a0, t1
	ecall
	
	li t0, 255
	beq t1, t0, block
	li t1, 1
	ret
	
block:	li t1, 0
	ret