########################################################################################################################################
#                                                                                                                                      #
# Gabriel Araya Mora B80525                                                                                                            #
# El siguiente codigo pretende resolver la tarea02 del curso de  Estructuras de computadores 1                                         #
# Se implementa un menu que funciona como un while infinito que va a preguntar la opcion deseada para ejecutar el programa             #
# El programa solo tiene capacidad de aceptar opciones en forma de numeros. Si se meten letras entonces se cierra el ciclo.            #
# El programa consta de 5 funciones                                                                                                    #
# 1.Recibe una palabra a la que se le quieren aplicar las otras funciones.                                                             #
# 2.Pasa todas las primeras letras de la palabra ingresada a mayusculas y el resto las pasa a minuscula                                #
# 3.Para la primera letra a mayuscula y el resto a minuscula                                                                           #
# 4.Pasa todas las letras a mayuscula                                                                                                  #
# 5.Pasa todas a minuscula                                                                                                             #
#                                                                                                                                      #
########################################################################################################################################

.data
	Menu:     	.asciiz "Hola, Se le presenta un menu de opciones \n\n 1. Leer una frase \n 2. Primera Letra De Cada Palabra En Mayúscula Las Demás En Minúscula\n 3. Primera letra en mayúscula y todas las demás en minúscula\n 4. CAMBIAR TODO A MAYÚSCULAS \n 5. cambiar todo a minúsculas \n\n"
	SEL:            .asciiz "Por favor seleccione una opcion para correr el programa:"
	opcion:   	.space 4 
	
	#Le pide la palabra a ingresar cuando hay opcion 1
	palabra:        .asciiz "Ingrese una palabra: "
	EntradaUsuario: .space 100 
	
	
	default:  	.asciiz "Hola esto es una palabra de Prueba\n"
	   
.text
	main:
		#carga las opciones en registros para poder compararlos
		addi $t8,$t8,1
		addi $t7,$t7,2
		addi $t6,$t6,3
		addi $t5,$t5,4
		addi $t4,$t4,5
		#Muestra el menu en terminal
		li $v0,4
		la $a0,Menu
		syscall 
		
		la $s0,default   #guarda la palabra por Default
		
		
		#El siguiente snip de codigo emula lo que es un Switch/Case en un lenguaje en alto nivel. 
		opciones:
			#Le dice al sistema que agarre el input del teclado como texto (Selecciona una opcion)
			li $v0,4
			la $a0,SEL
			syscall 
			
			# (Selecciona una opcion) como entero.
			li $v0,5
			syscall 
				
			beq $v0,1,caso1
			beq $v0,2,caso2
			beq $v0,3,caso3
			beq $v0,4,caso4
			beq $v0,5,caso5
		#Casos
		caso1:
			jal funcion1
			j   opciones
		caso2:
			jal funcion2
			#Cuando se devuelve imprime
			move $v0,$t0
			li $v0,4
			syscall 
			j   opciones
		caso3:
			jal funcion3
			#Cuando se devuelve imprime
			move $v0,$t0
			li $v0,4
			syscall 
			j   opciones
		caso4:
			jal funcion4
			#Cuando se devuelve imprime
			move $v0,$t0
			li $v0,4
			syscall 
			j opciones	
		caso5:
			jal funcion5
			#Cuando se devuelve imprime
			move $v0,$t0
			li $v0,4
			syscall 
			j opciones			
		#EndOfSwitchCase
			
		
		#End of Main
		li $v0, 10
		syscall 
		
	#Definicion de las funciones.
	#Recibe una palabra
	funcion1:
		#Le dice al usuario que ingrese una palabra
		li $v0,4
		la $a0,palabra
		syscall 
		
		#Agarra la palabra del usuario
		li $v0,8
		la $a0,EntradaUsuario
		li $a1,100                                       
		syscall 
		
		#Guarda la nueva palabra
		la $s0,($a0)
		
		#Devuelve control al callee
		jr $ra
		
	#Pone una mayuscula al inicio de cada palabra	
	funcion2:
		la $a0,($s0)                    #Se carga la palabra 
     	     	addi $t0, $a0, 0                #Se define el iterador 
     	     	la $t8, ' '                     #Se carga el espacio en ascii en t8
     	     	
     	     	mayus:
     	     	       addi $t3, $0, 'z'        #se carga en ascii la z minuscula
     	               lbu $t1, 0($t0)
     	               beq $t1,$0,end
     	               beq $t1,$t8,blanco
     	               sltiu $t4, $t1,'a'       #se carga en ascii la a minuscula
     	               bne $t4,$0,iterador
                       sltu $t4,$t3,$t1
     	               bne $t4,$0,iterador
     	               andi $t1,$t1,0xDF
     	               sb $t1, 0($t0)
     	               j iterador
     	     
     	     	text:
     	     	       addi $t9,$t9,'Z'         #se carga en ascii la Z mayuscula
     	               lbu $t1, 0($t0)     	                   
     	               beq $t1,$0,end
     	               beq $t1,$t8,blanco       #se carga en ascii la A mayuscula
     	               sltiu $t4,$t1,'A'
     	               bne $t4,$0,iterador
     	               sltu $t4,$t9,$t1
     	               bne $t4,$0,iterador
     	               ori $t1,$t1, 0x20
     	               sb $t1,0($t0)     	                   
     	               j iterador
     	               
     	    	blanco:
     	               addi $t0, $t0, 1
     	               j mayus
     	    
     	    	iterador:
     	               addi $t0, $t0, 1
     	               j text
     	    	end:
     	               jr $ra
     	     	
	#Funcion que solo pone la primera letra en mayuscula	
	funcion3:
		la $a0,($s0)
		addi $t3,$0,'z'
		add $t0,$0,$a0
		
		#Bloque que pasa a mayuscula la primer letra
		lbu $t1,0($t0)  #$t1 = str[i]
		beq $t1,$0,EndF3
		sltiu $t2,$t1,'a'
		bne $t2,$0,INCF3
		sltu $t2,$t3,$t1
		bne $t2,$0,INCF3
		andi $t1,$t1,0xDF
		sb $t1,0($t0)
		addi $t0,$t0,1
		
		LWC:
			addi $t3,$0,'Z'
			lbu $t1,0($t0)
			beq $t1,$0,EndF3
			sltiu $t2,$t1,'A'
			bne $t2,$0,INCF3
			sltu $t2,$t3,$t1
			bne $t2,$0,INCF3
			ori $t1,$t1,0x20
			sb $t1,0($t0)
			
		INCF3:
			addi $t0,$t0,1
			j LWC
		EndF3:
			jr $ra
		
		
	#Pasa todo a Mayuscula	
	funcion4:
		la $a0,($s0)
		addi $t3,$0,'z'
		add $t0,$0,$a0
		Loop:
			lbu $t1,0($t0)  #$t1 = str[i]
			beq $t1,$0,End
			sltiu $t2,$t1,'a'
			bne $t2,$0,INC
			sltu $t2,$t3,$t1
			bne $t2,$0,INC
			andi $t1,$t1,0xDF
			sb $t1,0($t0)
		INC:
			addi $t0,$t0,1
			j Loop
		End:
			jr $ra
			
	#Pasa todo a minuscula		
	funcion5:
		la $a0,($s0)
		addi $t3,$0,'Z'
		add $t0,$0,$a0
		LoopMinus:
			lbu $t1,0($t0)  #$t1 = str[i]
			beq $t1,$0,EndMinus
			sltiu $t2,$t1,'A'
			bne $t2,$0,INCMinus
			sltu $t2,$t3,$t1
			bne $t2,$0,INCMinus
			ori $t1,$t1,0x20
			sb $t1,0($t0)
		INCMinus:
			addi $t0,$t0,1
			j LoopMinus
		EndMinus:
			jr $ra
		
		
		
		
	
		
