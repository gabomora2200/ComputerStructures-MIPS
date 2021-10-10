########################################################################################################################################
#                                                                                                                                      #
# Gabriel Araya Mora B80525                                                                                                            #
# El siguiente codigo pretende resolver la tarea04 del curso de  Estructuras de computadores 1                                         #
#                                                                                                                                      #
# Se implementa un menu que funciona como un while infinito que va a preguntar el valor y la operacion que el usuario desea realizar.  #
# El programa solo tiene capacidad de aceptar opciones en forma de numeros y operadores matematicos (+,-,/,*).                         #
# Para limpiar la pila se ingresa el operando 'C' o 'c'.                                                                               #
# Para salir del programa se ingresa el operando 'E' o 'e'                                                                             #
#                                                                                                                                      #
# El programa imprime la pila en todo momento por lo que no se considera necesario implementar la impresion con el caracter de espacio.#
# Las operaciones se deben ingresar de forma secuencial, es decir operando + enter, operando + entre, operador + enter.                #                                                                           #
#                                                                                                                                      #
# El programa tiene la limitacion de que no imprime el ultimo valor de la pila cuando se ingresa el operador de espacio.               #
#                                                                                                                                      #
########################################################################################################################################


.data
	menu: 		.asciiz "Calculadora RPN \n\nPara resetear la calculadora ingrese \"C\" o \"c\" \nPara cerrar el programa ingrese \"E\" o \"e\" \n\nIngrese la operacion a realizar:\n "
	word: 		.word 0 
	pila: 		.asciiz "Pila: \n"
	Blanco: 	.asciiz "\n"

.text
	main:
		li $v0, 4 		#imprimir el menu del programa
		la $a0, menu
		syscall
		la $a0, word 		#Se inicia el programa en $a0
		li $a1, 0x7fffffff 
		and $t9, $t9, 0 	#Se hace una variable que sirve como contador
		jal LOOP	

	LOOP:
		li $v0, 8 		#Leer string que mete el usuario
		syscall
	
		#Switch Case para saltar a la funcion dependiendo de lo que quiera hacer el usuario
		lh $t1, 0($a0)
		beq $t1, 2661, Exit 	#Cierra el programa
		beq $t1, 2629, Exit 
		beq $t1, 2627, Vaciar 	#Limpia la pila
		beq $t1, 2659, Vaciar 
		beq $t1, 2603, SUM 	#Hace una suma
		beq $t1, 2605, RES 	#Hace una resta
		beq $t1, 2602, MULT 	#Hace una multiplicacion
		beq $t1, 2607, DIV 	#Hace la division
	
		addi $sp, $sp, -4 	#Se alista la pila 
		sw $ra, 0($sp) 		
	
		jal PUSH 		#Funcion que apila cosas en el stack
		lw $ra, 0($sp) 		
		addi $sp, $sp,4 
		addi $sp, $sp,-4 
		sw $t5, 0($sp)
		li $t5, 0 
	
		jal PrintStack 		#Imprime la pila para ver que todo este bien
		j LOOP 			#Salta al ciclo para ingresar numeros u operadores

	Vaciar:
		mul $t9, $t9, 4 	#El contador se multiplica por 4, ya que el puntero de pila se mueve de 4 en 4
		sub $sp, $sp, $t9	#Borra la pila 	
		sw $zero, ($sp) 	
		addi $t9, $zero,1

		jal PrintStack 
		j LOOP 
	
	PrintStack:
		addi $sp, $sp, -8 	# Alista la pila
		sw $ra, 0($sp) 		# Guarda la direccion de retorno
		sw $a0, 4($sp) 
	
		li $v0, 4 		#Imprimir un string
		la $a0, pila
		syscall
		li $v0, 4 		#Imprime salto de linea
		la $a0, Blanco
		syscall
	
		and $t0, $t0, 0 	
		addi $sp, $sp, 8
		jal PrintLOOP 		#Salta a imprimir la pila
	
		li $v0, 4 		#Salto de linea
		la $a0, Blanco 
		syscall
	
		mul $t0, $t0, 4 	#Se alista la PILA
		sub $sp, $sp, $t0 	
		addi $sp, $sp, -8 	
	
		lw $ra, 0($sp) 		#Saca cosas de la pila
		lw $a0, 4($sp) 		
		addi $sp, $sp, 8 
	
		jr $ra 			#Devuelve control al Callee
	
	PrintLOOP:
		beq $t0, $t9, SALIR
		lw $t1, 0($sp)
		move $a0, $t1
		li $v0, 1
		syscall
		li $v0, 4		#Imprime un espacio en blanco
		la $a0, Blanco
		syscall
		addi $t0, $t0, 1
		addi $sp, $sp, 4
		j PrintLOOP
		
		SALIR:
			jr $ra		#Devuelve control al Callee

	SUM:
		lw $t1, 0($sp) 		#Saca cosas de la PILA
		addi $sp, $sp, 4 	
		lw $t2, 0($sp)
		add $t3, $t1, $t2 	#Hace la suma y la guarda en t3

		sw $t3, 0($sp) 		#Apila t3
	
		#Devuelve todo a cero 
		add $t1, $0, $0
		add $t2, $0, $0
		add $t3, $0, $0
		sub $t9, $t9, 1 	#Se resta un elemento al contador de pila
	
		jal PrintStack 
		j LOOP
	
	RES:
		lw $t1, 0($sp)  	#Saca cosasa de la PILA
		addi $sp, $sp, 4 
		lw $t2, 0($sp) 
		sub $t3, $t1, $t2 	#Hace la resta y la guarda en t3
		
		sw $t3, 0($sp) 		#Se mete a la pila t3
	
		#Devuelve todo a cero
		add $t1, $0, $0
		add $t2, $0, $0
		add $t3, $0, $0
	
		sub $t9, $t9, 1 	# Se resta uno al contador de elementos en la pila
	
		jal PrintStack 
		j LOOP 
	
	MULT:
		lw $t1, 0($sp) 		#Saca cosas de la PILA
		addi $sp, $sp, 4 
		lw $t2, 0($sp) 
		mul $t3, $t1, $t2 	#Hace la multiplicacion y la guarda en t3

		sw $t3, 0($sp) 		#Se mete a la pila t3
	
		#Devuelve todo a cero 
		add $t1, $0, $0
		add $t2, $0, $0
		add $t3, $0, $0
	
		sub $t9, $t9, 1 	#Se le resta uno al contador de elementos en la pila
	
		jal PrintStack 
		j LOOP 
	
	DIV:
		lw $t1, 0($sp) 		#Saca cosas de la pila
		addi $sp, $sp, 4 
		lw $t2, 0($sp) 	
		div $t3, $t1, $t2 	#Hace la division y la guarda en t3

		sw $t3, 0($sp) 		#Guarda t3 en la pila
	
		#Se devuelve todo a cero
		and $t1, $t1, $0
		and $t2, $t2, $0
		and $t3, $t3, $0
	
		sub $t9, $t9, 1 
	
		jal PrintStack 
		j LOOP
		
	Exit:
		li $v0, 10 		# Finalizar el programa
		syscall	
			
	PUSH:
		addi $sp, $sp, -8  	#Se Alista el espacio en la pila 
		sw $ra, 0($sp) 
		sw $a0, 4($sp) 
	
		sub $t0, $t0, $t0 	
		jal Contador 		#Salta a la funcion que cuenta los caracteres 
	
		li $v0, 4 		#Imprime un espacio en blanco
		la $a0, Blanco		
		syscall
	
		lw $a0, 4($sp) 

		jal PROC  	#Salta a la funcion de procesamiento
	
		#Devuelve todo a cero 
		and $t2, $t2, $0
		and $t3, $t3, $0
		and $t4, $t4, $0
		and $t7, $t7, $0
	
		lw $ra, 0($sp) 		#Saca cosas de la pila
		lw $a0, 4($sp) 
		addi $sp, $sp, 8 
	
		addi $t9, $t9, 1 	#Se incrementa el valor de la pila en uno
	
		jr $ra			#Devuelve control al callee
	
	PROC:
		sub $t2, $t0, 2 	
		add $t2, $t2, $a0 	
		addi $t3, $t3, 1 	
		addi $t5, $t5, 0
		j PROCLOOP 		
	
		PROCLOOP:
			lbu $t4, ($t2)
			beq $t4, 45, Neg #Si la entrada es negativa salta a NEG para multiplicarla por menos 1
			sub $t4, $t4, 48
			mul $t4, $t4, $t3
			add $t5, $t5, $t4
			beq $t2, $a0, PROCEND
			addi $t2, $t2, -1
			mul $t3, $t3, 10
			j PROCLOOP
	
		Neg:
			addi $t7, $t7, 1 
			j PROCEND 
	
		PROCEND:
			beq $t7, 1, MULTMIN 
			jr $ra 		#Devuelve Control al Callee
	
		MULTMIN:
			mul $t5, $t5,-1 # Se multiplica por -1 si el numero es negativo
			jr $ra 		#Devuelve Control al Callee
	
	Contador:
		addi $sp, $sp, -8 	#INICIA la pila
		sw $ra, 4($sp) 
		sw $a0, 0($sp) 
		jal ContadorLOOP
		lw $ra, 4($sp) 
		lw $a0, 0($sp) 
		addi $sp, $sp, 8 
		jr $ra 			#Devuelve el control al callee
	
		ContadorLOOP:
			lb $t1, 0($a0)  
 			beq $t1, 0, ContadorEND 	
 			addi $t0, $t0, 1  		
 			addi $a0, $a0, 1 	# Se actualiza el puntero
 			j Contador
 	
		ContadorEND:
			jr $ra 		#Devuelve el control al callee
