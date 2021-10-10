########################################################################################################################################
#                                                                                                                                      #
# Gabriel Araya Mora B80525                                                                                                            #
# El siguiente codigo pretende resolver la tarea01 del curso de  Estructuras de computadores 1                                         #
# La funcion llamada "funcPares" se encarga de hacer dos operaciones fundamentales                                                     #
# primero va a preguntar si el numero es mayor que cero para impedir que entren numeros negativos al arreglo de salida                 #
# hecho esco pregunta si el modulo del valor en A[i] con 2 es cero o uno de forma que ahora se sabe si el numero es par o impar        #
# Por ultimo guarda el valor A[i] en B[j] cuando el valor pasa las pruebas.                                                            #
#                                                                                                                                      #
########################################################################################################################################

.data 
	listA: .word 1,2,7,-8,4,5,12,11,-2,6,3,2,0                      # valor de entrada de la funcion.
	listB: .space 48 	                                        # Reserva un bloque de memoria de 1000  bytes.    
	myString: .asciiz "\nLa longitud de B es de:  "                      

.text 
main:
	la $a0,listA     #Carga en $a0 la direccion de la lista A
	la $a1,listB     #Carga en $a1 la direccion de la lista vacia B
	jal funcPares    #Salta a la funcion funcPares
	add $t0,$v1,$0   #Mete en $t0 el valor de salida de la funcion funcPares
	
	# Print String
    	li $v0, 4
    	# a0 = string
    	la $a0, myString # load adress
    	syscall

    	# Print INT
    	li $v0, 1
    	add $a0, $t0, $zero
    	syscall
	
	li $v0,10        #Termina el programa
	syscall


# i se matepea en $t0
# A entra como parametro en $a0
# B entra como parametro en $a1
funcPares:
	and $t0,$zero,$zero           #int i = 0
	and $t8,$zero,$zero           #int j = 0
	WhileLoop:
		sll $t1,$t0,2          #ix4
		add $t1,$t1,$a0        #A+ix4
		lw  $t2,0($t1)         #Guarda el primer valor del arreglo A
		beq $t2,0,endWhile     #Si el elemento es 0 termina la ejecucion del while
		
		
		# if (A[i]>0 and A[i]%2 == 0)
		
		slt  $t3,$0,$t2        #Guarda en $t3 un 1 si $t2 es positivo y un 0 si es negativo. 
		beq  $t3,$0, else
		andi $t4,$t2,1         # si es un 1 es impar y si es 0 es par
		bne  $t4,$0,else
		
		sw   $t2,listB($t8)   #Guarda en B el valor par encontrado en A.
		addi $t8,$t8,4        #Se pasa al siguiente valor de B para que cuando haya que guardar uno valor no le caiga encima al anterior.
		addi $v1,$v1,1        #Variable que va a devolver la longitud de B
		else:
		addi $t0,$t0,1        # i=i+1
		j WhileLoop           
	endWhile:
		jr $ra                # Devuelve control a la funcion main.
	
		 
		 
