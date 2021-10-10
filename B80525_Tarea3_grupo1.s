########################################################################################################################################
#                                                                                                                                      #
# Gabriel Araya Mora B80525                                                                                                            #
# El siguiente codigo pretende resolver la tarea03 del curso de  Estructuras de computadores 1                                         #
#                                                                                                                                      #
# Se implementa un menu que funciona como un while infinito que va a preguntar el valor que el usuario desea darle a cada cateto.      #
# El programa solo tiene capacidad de aceptar opciones en forma de numeros.                                                            #
#                                                                                                                                      #
# El programa va a calcular usando pitagoras, la hipotenusa del triangulo rectangulo, con los catetos proporcionados por el usuario    #
# Seguidamente se calcula el angulo utilizando el seno inverso con taylor.                                                             #
# Usando el valor del angulo y usando taylor se obtiene el valor del seno del angulo.                                                  #
# Lo mismo para el coseno                                                                                                              #                                                                                                             
#                                                                                                                                      #
# Nota: la cantidad de iteraciones que se hacen de taylor son 7 (linea 60)                                                             #
#       Todos los valores se dan en Radianes                                                                                           #
#                                                                                                                                      #
# El programa tiene la limitacion de que si se ingresan catetos muy grandes devuelve NaN ya que no le alcanzan los registros para      #
# guardar un valor con tantos decimales                                                                                                #
########################################################################################################################################


.data
	blanco: 	.asciiz "\n"
	catMay1: 	.asciiz "Por favor ingrese el valor del primer cateto:"
	catMay2: 	.asciiz "Por favor ingrese el valor del segundo cateto:"
	hipotenusa:     .asciiz "\nEl valor de la hipotenusa es: "
	senoinverso: 	.asciiz "\nEl valor del seno inverso es: "
	seno:           .asciiz "\nEl valor del Seno es: "
	coseno:         .asciiz "\nEl valor del Coseno es: "
	resultado:      .asciiz "\n\nLos resultados obtenidos para las identidades trigonometricas fueron:\n"

.text
	main:
		sub.s $f10, $f10, $f10
		sub.s $f28, $f28, $f28
		sub.s $f29, $f29, $f29
		sub.s $f30, $f30, $f30
		addi $t9, $t9, 0
		addi, $t8, $t8, 0
		
		#Se digita el valor del primer catMay:
		ori $v0, $0, 4
		la $a0, catMay1
		syscall
		#Agarra el valor ingresado por el usuario
		ori $v0, $0, 6
		syscall 
		add.s $f1, $f0, $f10

		#Se digita el valor del segundo catMay:
		ori $v0, $0, 4
		la $a0, catMay2
		syscall
		#Agarra el valor ingresado por el usuario
		ori $v0, $0, 6
		syscall 
		add.s $f2, $f0, $f10

		#Se cierra el programa si los catetos son iguales a cero. 
		c.eq.s $f1, $f10 
		bc1t END
		c.eq.s $f2, $f10
		bc1t END

	continuar:
		#Se guarda el valor de la cantidad iteraciones a realizar en las series de taylor:
		addi $t9, $t9, 5
		addi, $t8, $t8, 5
		sub.s $f0, $f0, $f0 #cargar cero en $f0
		jal catMay
	
		#Calculando la suma dentro de la hip1
		addi $sp, $sp, -8
		s.s $f1, 4($sp)
		s.s $f2, 0($sp)
		jal hip1 
		l.s $f12, 0($sp)
		addi $sp, $sp, 8
	
		#Calculando el valor de la hip1
		addi $sp, $sp, -4
		s.s $f12, 0($sp)
		jal hip12 
		l.s $f12, 0($sp)
		addi $sp, $sp, 4
		
		#imprime el valor de la pitagoras de la suma
		ori $v0, $0, 4
		la $a0, blanco
		syscall
		
		ori $v0,$zero,4     #Imprime el valor de la hipotenusa, punto 1
     		la $a0,hipotenusa
     		syscall

		li $v0, 2
		syscall	
	
		ori $v0, $0, 4
		la $a0, blanco
		syscall
		
	div:
		div.s $f4, $f3, $f12
		add.s $f12, $f4, $f10							
																																																																																							
	resultados:
		#Se hace el calculo de los factoriales. 
		# n!	
		addi $a0, $t9, 0		
		jal fact
		mtc1 $v0, $f11 		#se transfiere un valor de un registro entero a uno flotante
		cvt.s.w $f11, $f11  	#Convierte un valor entero en un registro punto flotante en un valor en punto flotante
		mul.s $f1, $f11, $f11
	
		# 2n!
		mul $a0, $t9, 2
		mtc1 $a0, $f7 
		cvt.s.w $f7, $f7  		
		jal fact
		mtc1 $v0, $f13 		
		cvt.s.w $f13, $f13  	
		
		#x^2n
		addi $sp, $sp, -20
		s.s $f7, 16($sp)
		s.s $f6, 12($sp)
		s.s $f4, 8($sp)
		s.s $f3, 4($sp)
		s.s $f0, 0($sp)
		jal powerfloat
		l.s $f12, 0($sp)
		addi $sp, $sp, 20
		mov.s $f18, $f12

		#2n+1
		mul $a0, $t9, 2
		addi $a0, $a0, 1
		mtc1 $a0, $f2 
		cvt.s.w $f2, $f2 
		
		#x^2n+1
		addi $sp, $sp, -20
		s.s $f2, 16($sp)
		s.s $f6, 12($sp)
		s.s $f4, 8($sp)
		s.s $f3, 4($sp)
		s.s $f0, 0($sp)
		jal powerfloat
		l.s $f12, 0($sp)
		addi $sp, $sp, 20
		mov.s $f19, $f12

		# 4^n
		addi $sp, $sp, -12
		sw $v0, 8($sp)
		sw $t0, 4($sp)
		sw $a0, 0($sp)
		jal power
		lw $v0, 8($sp)
		addi $sp, $sp, 12
		
		addi $a0, $v0, 0
		mtc1 $a0, $f3 
		cvt.s.w $f3, $f3 	
	
		# 1 o -1
		addi $sp, $sp, -12
		sw $t9, 8($sp)
		sw $t0, 4($sp)
		sw $v0, 0($sp)
		jal powerONE
		lw $v0, 0($sp)
		addi $sp, $sp, 12
		addi, $a0, $v0, 0
		mtc1 $a0, $f5 
		cvt.s.w $f5, $f5 
	
		# Calculo de seno inverso:
		addi $sp, $sp, -24
		s.s $f19, 20($sp)
		s.s $f13, 16($sp)
		s.s $f3, 12($sp)
		s.s $f2, 8($sp)
		s.s $f1, 4($sp)
		s.s $f25, 0($sp)
		jal arcSine
		l.s $f12, 0($sp)
		addi $sp, $sp, 24
		add.s $f28, $f28, $f12
		
	if:	
		slti $t2, $t9, 1 
		bne $t2, $0, nueve
		addi $t9, $t9, -1
		j resultados		

	nueve:
		addi $t9, $t8, 0

	sencosine:	
		# 2n!
		mul $a0, $t9, 2
		mtc1 $a0, $f7 
		cvt.s.w $f7, $f7  	
		jal fact
		mtc1 $v0, $f13 
		cvt.s.w $f13, $f13  
	
		#x^2n
		addi $sp, $sp, -20
		s.s $f7, 16($sp)
		s.s $f6, 12($sp)
		s.s $f28, 8($sp)
		s.s $f3, 4($sp)
		s.s $f0, 0($sp)
		jal powerfloat
		l.s $f12, 0($sp)
		addi $sp, $sp, 20
		mov.s $f18, $f12
	
		# (2n+1)!
		mul $a0, $t9, 2
		addi $a0, $a0, 1
		mtc1 $a0, $f7 
		cvt.s.w $f7, $f7  
		jal fact
		mtc1 $v0, $f14 
		cvt.s.w $f14, $f14  	
				
		# x^2n+1
		addi $sp, $sp, -20
		s.s $f7, 16($sp)
		s.s $f6, 12($sp)
		s.s $f28, 8($sp)
		s.s $f3, 4($sp)
		s.s $f0, 0($sp)
		jal powerfloat
		l.s $f12, 0($sp)
		addi $sp, $sp, 20
		mov.s $f19, $f12			
	
		# Calculando si el valor es 1 o -1
		addi $sp, $sp, -12
		sw $t9, 8($sp)
		sw $t0, 4($sp)
		sw $v0, 0($sp)
		jal powerONE
		lw $v0, 0($sp)
		addi $sp, $sp, 12
		addi, $a0, $v0, 0
		mtc1 $a0, $f5 
		cvt.s.w $f5, $f5 	

		# Calculo del seno:
		addi $sp, $sp, -16
		s.s $f19, 12($sp)
		s.s $f14, 8($sp)
		s.s $f5, 4($sp)
		s.s $f25, 0($sp)
		jal sine
		l.s $f12, 0($sp)
		addi $sp, $sp, 16
		add.s $f29, $f29, $f12
	
		#Calculo del coseno:
		addi $sp, $sp, -16
		s.s $f18, 12($sp)
		s.s $f13, 8($sp)
		s.s $f5, 4($sp)
		s.s $f25, 0($sp)
		jal sine
		l.s $f12, 0($sp)
		addi $sp, $sp, 16
		add.s $f30, $f30, $f12
		slti $t2, $t9, 1 
		bne $t2, $0, fin
		addi $t9, $t9, -1
		j sencosine		
					
	fin:	
		#Imprime el promt para los resultados
		ori $v0, $0, 4
		la $a0, resultado
		syscall
	
		#Imprime el valor del seno inverso	
		ori $v0, $0, 4
		la $a0, senoinverso
		syscall	
		add.s $f12, $f28, $f10
		ori, $v0, $0, 2
		syscall

		#Imprime el valor del seno
		ori $v0, $0, 4
		la $a0, seno
		syscall
		add.s $f12, $f29, $f10
		ori, $v0, $0, 2
		syscall

		#Imprime el valor del coseno
		ori $v0, $0, 4
		la $a0, coseno
		syscall
		add.s $f12, $f30, $f10
		ori, $v0, $0, 2
		syscall
	
		#Imprime dos espacios en blanco
		ori $v0, $0, 4
		la $a0, blanco
		syscall
		ori $v0, $0, 4
		la $a0, blanco
		syscall
	
		#Vuelve a saltar al main
		j main
	
	
	END:	
		#Termina el programa
		ori $v0, $0, 10
		syscall
																														
	
	#Funcion que hace el calculo del catMay mayor	
	catMay:
		c.lt.s $f1, $f2
		bc1t mayor
		add.s $f3, $f1, $f10
		jr $ra
		mayor:
		add.s $f3, $f2, $f10
		jr $ra	
	

	#Para obtener la hiponesua se hacen dos funciones 
	# ----------------------------------------------------- Hipotenusa ---------------------------------------- #
	#Funcion que hace la suma dentro de la hip1
	hip1:			
		addi $sp, $sp, -12 
		s.s $f0, 8($sp)
		s.s $f1, 4($sp)
		s.s $f2, 0($sp)
		l.s $f2, 12($sp)
		l.s $f1, 16($sp)
		mul.s $f1, $f1, $f1
		mul.s $f2, $f2, $f2
		add.s $f0, $f1, $f2
		s.s $f0, 12($sp)
		l.s $f2, 0($sp)
		l.s $f1, 4($sp)
		l.s $f0, 8($sp)
		addi $sp, $sp, 12
		jr $ra
	#Funcion que hace propiamente la hip1
	hip12:			
		addi $sp, $sp, -16
		s.s $f0, 12($sp)
		s.s $f1, 8($sp)
		s.s $f2, 4($sp)
		s.s $f3, 0($sp)
		l.s $f0, 16($sp)
		addi $t0, $0, 2
		mtc1 $t0, $f1 		
		cvt.s.w  $f1, $f1  		
		div.s $f2, $f0, $f1	
		addi $t0, $0, 20 
	# ----------------------------------------------------- Fin Hipotenusa ---------------------------------------- #

	iterRaiz:
		div.s $f3, $f0, $f2 #$f3=N/x
		add.s $f3, $f2, $f3 #$f3=x+N/x
		div.s $f2, $f3, $f1 ##$f2=(x+N/x)/2
		beq $t0, $0, retRaiz
		addi $t0, $t0, -1
		j iterRaiz

	retRaiz:
		s.s $f2, 16($sp)
		l.s $f3, 0($sp)
		l.s $f2, 4($sp)
		l.s $f1, 8($sp)
		l.s $f0, 12($sp) 
		addi $sp,$sp, 16
		jr $ra	

	#Funcion para el calculo del factorial	
	fact:
		addi $sp, $sp, -8
		sw $ra, 4($sp)
		sw $a0, 0($sp)
		slti $t0, $a0, 1
		beq $t0, $0, L1
		addi $v0, $0, 1
		addi $sp, $sp, 8
		jr $ra
	
		L1:
			addi $a0, $a0, -1
			jal fact
			lw $a0, 0($sp)
			lw $ra, 4($sp)
			addi $sp, $sp, 8
			mul $v0, $a0, $v0
			jr $ra

	#4^n
	power:
		addi $sp, $sp, -8
		sw $t0, 4($sp)
		sw $a0, 0($sp)
		add   $t0,$0,$0        # initialize $t0 = 0, $t0 is used to record how many times we do the operations of multiplication
        	addi $v0,$0,1          # set initial value of $v0 = 1
		addi $a0, $0, 4
	
		again: 
			beq $t0, $t9, salir    
        		mul $v0,$v0,$a0         # multiple $v0 and $a0 into $v0 
        		addi $t0,$t0,1          # update the value of $t0   
       			j again
	
		salir:
			sw $v0,16($sp) 	
			lw $a0, 0($sp)
			lw $t0, 4($sp)
			addi $sp, $sp, 8
			jr  $ra
	#Funcion encargada de elevar cosineas
	powerfloat:
		addi $sp, $sp, -20
		s.s $f7, 16($sp)
		s.s $f6, 12($sp)
		s.s $f4, 8($sp)
		s.s $f3, 4($sp)
		s.s $f0, 0($sp)
		l.s $f0, 20($sp)
		l.s $f3, 24($sp)
		l.s $f4, 28($sp)
		l.s $f6, 32($sp)
		l.s $f7, 36($sp)
		sub.s $f6, $f6, $f6
		sub.s $f0, $f0, $f0
		div.s $f3, $f3, $f3  	# initialize $t0 = 0, $t0 is used to record how many times we do the operations of multiplication
       		add.s $f0, $f0, $f3     # set initial value of $v0 = 1
	
		againf: 
			c.eq.s $f6, $f7
			bc1t salirf  
       			mul.s $f0,$f0,$f4         # multiple $v0 and $a0 into $v0 
       			add.s $f6,$f6,$f3          # update the value of $t0   
        		j againf
	
		salirf:
			s.s $f0,20($sp) 
			l.s $f0, 0($sp)
			l.s $f3, 4($sp)
			l.s $f4, 8($sp)
			l.s $f6, 12($sp)
			l.s $f19, 16($sp)
			addi $sp, $sp, 20
			jr  $ra
	#Funcion encargada de elevar el menos 1
	powerONE:
		addi $sp, $sp, -12
		sw $t9, 8($sp)
		sw $t0, 4($sp)
		sw $v0, 0($sp)
		lw $v0, 12($sp)
		lw $t0, 16($sp)
		lw $t9, 20($sp)
		ori $v0, $0, 1
		andi $t0, $t9, 1
		beq $t0, $0, sali
		mul $v0, $v0, -1
		sali:
			sw $v0, 12($sp)
			lw $v0, 0($sp)
			lw $t0, 4($sp)
			lw $t9, 8($sp)  
			addi $sp, $sp, 12
			jr $ra

			
	arcSine:
		addi $sp, $sp, -24
		s.s $f19, 20($sp)
		s.s $f13, 16($sp)
		s.s $f3, 12($sp)
		s.s $f2, 8($sp)
		s.s $f1, 4($sp)
		s.s $f25, 0($sp)
		l.s $f1, 28($sp)
		l.s $f2, 32($sp)
		l.s $f3, 36($sp)
		l.s $f13, 40($sp)
		l.s $f19, 44($sp)
		#Hace el calculo para todo lo relacionado con el seno inverso
		mul.s $f23, $f13, $f19
		mul.s $f24, $f1, $f3
		mul.s $f24, $f24, $f2
		div.s $f25, $f23, $f24
		s.s $f25, 24($sp)
		s.s $f25, 0($sp)
		l.s $f1, 4($sp)
		l.s $f2, 8($sp)
		l.s $f3, 12($sp)
		l.s $f13, 16($sp)
		l.s $f19, 20($sp)
		addi $sp, $sp, 24
		jr $ra

	sine:
		addi $sp, $sp, -16
		s.s $f19, 12($sp)
		s.s $f14, 8($sp)
		s.s $f5, 4($sp)
		s.s $f25, 0($sp)
		l.s $f5, 20($sp) #-1^n
		l.s $f14, 24($sp) # 2n+1!
		l.s $f19, 28($sp) # x^2n+1
		mul.s $f23, $f5, $f19
		div.s $f25, $f23, $f14
		s.s $f25, 16($sp)
		s.s $f25, 0($sp)
		l.s $f5, 4($sp)
		l.s $f14, 8($sp)
		l.s $f19, 12($sp)
		addi $sp, $sp, 16
		jr $ra

	cosine:
		addi $sp, $sp, -16
		s.s $f18, 12($sp)
		s.s $f13, 8($sp)
		s.s $f5, 4($sp)
		s.s $f25, 0($sp)
		l.s $f5, 20($sp) # -1^n
		l.s $f13, 24($sp) # 2n!
		l.s $f18, 28($sp) # x^2n
		mul.s $f23, $f5, $f18
		div.s $f25, $f23, $f13
		s.s $f25, 16($sp)
		s.s $f25, 0($sp)
		l.s $f5, 4($sp)
		l.s $f13, 8($sp)
		l.s $f18, 12($sp)
		addi $sp, $sp, 16	
		jr $ra
