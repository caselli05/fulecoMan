###############################################
#  Programa de exemplo para Syscall MIDI      #
#  ISC Abr 2018				      			  #
#  Marcus Vinicius Lamar		     		  #
###############################################

.data
# Numero de Notas a tocar
NUM: .word 160
NUM2: .word 20
# lista de nota,duração,nota,duração,nota,duração,...
NOTAS: 64, 200, 52, 200, 64, 200, 64, 200, 62, 200, 52, 200, 60, 200, 52, 200, 55, 200, 53, 200, 52, 200, 50, 200, 48, 200, 50, 200, 52, 200, 55, 200, 64, 200, 52, 200, 64, 200, 64, 200, 62, 200, 52, 200, 60, 200, 52, 200, 62, 200, 59, 200, 57, 200, 55, 200, 60, 200, 55, 200, 59, 200, 55, 200, 64, 200, 52, 200, 50, 200, 60, 200, 48, 200, 47, 200, 60, 200, 50, 200, 65, 200, 53, 200, 52, 200, 60, 200, 50, 200, 48, 200, 60, 200, 52, 200, 67, 200, 55, 200, 52, 200, 65, 200, 50, 200, 48, 200, 64, 200, 52, 200, 62, 200, 59, 200, 57, 200, 55, 200, 60, 200, 55, 200, 59, 200, 55, 200, 64, 200, 52, 200, 50, 200, 60, 200, 48, 200, 47, 200, 60, 200, 50, 200, 65, 200, 53, 200, 52, 200, 60, 200, 50, 200, 48, 200, 60, 200, 52, 200, 67, 200, 55, 200, 52, 200, 65, 200, 50, 200, 48, 200, 64, 200, 52, 200, 62, 200, 59, 200, 57, 200, 64, 200, 62, 200, 55, 200, 60, 200, 59, 200, 64, 200, 52, 200, 50, 200, 52, 200, 55, 200, 52, 200, 72, 200, 55, 200, 69, 200, 57, 200, 55, 200, 69, 200, 69, 200, 67, 200, 64, 200, 62, 200, 64, 200, 52, 200, 60, 200, 48, 200, 62, 200, 50, 200, 64, 200, 52, 200, 62, 200, 59, 200, 57, 200, 55, 200, 53, 200, 52, 200, 50, 200, 48, 200, 64, 200, 52, 200, 50, 200, 52, 200, 55, 200, 52, 200, 72, 200, 55, 200, 69, 200, 57, 200, 55, 200, 69, 200, 69, 200, 67, 200, 64, 200, 62, 200, 64, 200, 52, 200, 60, 200, 48, 200, 62, 200, 50, 200, 64, 200, 52, 200, 62, 200, 59, 200, 57, 200, 64, 200, 62, 200, 50, 200, 60, 200, 59, 200 
NOTAS2: 36, 1600, 41, 1600, 33, 1600, 43, 1600, 36, 1600, 38, 1600, 40, 1600, 43, 1600, 36, 1600, 38, 1600, 40, 1600, 43, 1600, 36, 1600, 41, 1600, 33, 1600, 43, 1600, 36, 1600, 41, 1600, 33, 1600, 43, 1600 

.text
    la s0, NUM       # define o endereço do número de notas
    lw s1, 0(s0)     # le o numero de notas
    la s0, NOTAS     # define o endereço das notas
    li t0, 0         # zera o contador de notas

    la s2, NUM2      # define o endereço do número de notas2
    lw s3, 0(s2)     # le o numero de notas2
    la s2, NOTAS2    # define o endereço de notas2
    li t1, 0         # zera o contador de notas2

    li a2, 32        # define o instrumento para notas
    li a4, 128       # define o instrumento para notas2
    li a3, 127       # define o volume para notas
    li s4, 0	     # 16 para contagem de notas2
    
DOIS:
    # Play the note from NOTAS2 
    lw a6, 0(s2)     # le o valor da segunda nota
    lw a7, 4(s2)     # le a duracao da segunda nota
    mv a0, a6        # move valor da segunda nota para a0
    mv a1, a7        # move duracao da segunda nota para a1
    li a7, 31        # define a chamada de syscall para tocar nota
    ecall            # toca a segunda nota
    
    # Increment counters and pointers
    addi s4, s4, 8  # zera o contador de notas2
    addi s2, s2, 8   # incrementa para o endereço da próxima nota
    addi t1, t1, 1   # incrementa o contador de notas

LOOP:   
    beq t0, s1, FIM     # se o contador chegou no final, vá para FIM
    beq t0, s4, DOIS    # se o contador2 chegou em 16, vá para DOIS
    
    # Play note from NOTAS
    lw a0, 0(s0)        # le o valor da nota
    lw a1, 4(s0)        # le a duracao da nota
    li a7, 31           # define a chamada de syscall para tocar nota
    ecall               # toca a nota

    # Pause for note duration
    addi a1, a1, -5	    # reduzir a pausa pra evitar pausa abrupta nas notas
    mv a0, a1           # move duracao da nota para a pausa
    li a7, 32           # define a chamada de syscal para pausa
    ecall               # realiza uma pausa de a0 ms

    # Increment counters and pointers
    addi s0, s0, 8      # incrementa para o endereço da próxima nota
    addi t0, t0, 1      # incrementa o contador de notas

    j LOOP              # volta ao loop

FIM:
    li a7, 10           # define o syscall Exit
    ecall               # exit
