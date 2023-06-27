.ifndef graficos_s

.equ SCREEN_WIDTH,      640
.equ SCREEN_HEIGH,      480
.equ BITS_PER_PIXEL,    32
.equ MEDIA_WIDTH,       320
.equ MEDIA_HEIGH,       240
.equ FILA_DEG,          10
.equ CENTRO,            100
.equ NOCHE_SUP,         384
.equ NOCHE_INF,         103

/* ================================== FUNCIONES ======================================= */
/*----------------------------- NOCHE ---------------------------*/
Noche:

    movz x10, 0x00, lsl 16      // color elegido para la noche.
    movk x10, 0x0033, lsl 00
    mov x3, 0

    mov x2,SCREEN_HEIGH     // Y Size 
fila:
    mov x1,SCREEN_WIDTH     // X Size
columna:
    stur x10,[x0]           // Set color of pixel N
    add x0,x0, 4            // Next pixel
    sub x1,x1, 1            // decrement X counter
    cbnz x1, columna        // If not end row jump
    sub x2,x2, 1            // Decrement Y counter

    add x3,x3, 1
    cmp x3, FILA_DEG        // Se compara si x3 es igual a FILA_DEG para hacer un degradado equiespaciado por FILA_DEG.
    b.eq deg                /* Si la comparacion anterior es correcta empezaremos a degradar, 
                               de lo contrario seguira pintando con el mismo color*/
end_deg:

    cmp x2, CENTRO          // Pintara hasta la posicion Y que elegimos para el punto central.
    b.eq end_atardecer
    b fila

deg:                        // Se encarga de hacer el degradado.
    add x10,x10, 2          // Le va restando a x10 0010 bits.
    sub x3,x3, FILA_DEG     // Reiniciamos el contador.
    b end_deg

end_atardecer:

//------------------------------------------ SUELO ---------------------------------------------//
    movz x10, 0x20, lsl 16
    movk x10, 0x2020, lsl 00

    mov x2, SCREEN_HEIGH    // Y Size 
loop1_c:
    mov x1, SCREEN_WIDTH    // X Size
loop0_c:
    stur x10,[x0]           // Set color of pixel N
    add x0,x0, 4            // Next pixel
    sub x1,x1, 1            // decrement X counter
    cbnz x1, loop0_c        // If not end row jump
    sub x2,x2, 1            // Decrement Y counter
    cbnz x2, loop1_c        // if not last row, jump
    br lr
/* --------------------------------------------------------------------------------------------- */

/* ------------------------------------------- NOCHE AUXILIAR ---------------------------------- */
Noche1:
    sub sp, sp, 48
    stur x4, [sp,40]
    stur x3, [sp,32]
    stur x2, [sp,24]
    stur x1, [sp,16]
    stur x0, [sp, 8]
    stur lr, [sp, 0]
    
    movz x10, 0x00, lsl 16      // color elegido para la noche.
    movk x10, 0x0033, lsl 00
    mov x3, 0
    mov x0, x20

    mov x2,SCREEN_HEIGH     // Y Size 
fila1:
    mov x1,SCREEN_WIDTH     // X Size
columna1:
    cmp x2, x27             // compara si llega al limite inferior para no pintar
    b.lt continuar_recorrido 
    cmp x2, x26             // compara si llego al limite superior para pintar
    b.le pintar_cielo
continuar_recorrido:
    add x0,x0, 4            // Next pixel
    sub x1,x1, 1            // decrement X counter
    cbnz x1, columna1       // If not end row jump
    sub x2,x2, 1            // Decrement Y counter

    add x3,x3, 1
    cmp x3, FILA_DEG        // Se compara si x3 es igual a FILA_DEG para hacer un degradado equiespaciado por FILA_DEG.
    b.eq degrada            /* Si la comparacion anterior es correcta empezaremos a degradar, 
                               de lo contrario seguira pintando con el mismo color*/
end_degrades:
    cmp x2, CENTRO          // Pintara hasta la posicion Y que elegimos para el punto central.
    b.eq end_noche
    b fila1

pintar_cielo:
    stur x10,[x0]           // Set color of pixel N
    b continuar_recorrido

degrada:                    // Se encarga de hacer el degradado.
    add x10,x10, 2          // Le va restando a x10 0010 bits.
    sub x3,x3, FILA_DEG     // Reiniciamos el contador.
    b end_degrades

end_noche:

    stur x4, [sp,40]
    stur x3, [sp,32]
    stur x2, [sp,24]
    stur x1, [sp,16]
    stur x0, [sp, 8]
    stur lr, [sp, 0]
    add sp, sp, 48
    
    br lr
//------------------------------------------------------------------------------------------

/* ------------------------------------ EDIFICIO ----------------------------------------  */
// Los registros inicializados en las funciones de edificoX contienen: 
// - la posicion del primer rectangulo (abajo y a la izquierda),
// - los valores de base y altura de cada rectangulo, y el color.

/* Se dibuja a los edificiosX llamando secuencialmente a sus funciones y por dentro de ellas 
   se llama a las funciones rectangulo y ventanas para que formen la figura. */

Edificio:
    sub sp, sp, 40
    stur x4, [sp, 32]
    stur x3, [sp, 24]
    stur x2, [sp, 16]
    stur x1, [sp, 8]
    stur lr, [sp, 0]    //en 0: se guarda la direccion inicial del lr

    bl Edificio1        // La distancia entre cada edificio es de 130 pixeles.
    bl Edificio2
    bl Edificio3
    bl Edificio4
    bl Edificio5

    stur x4, [sp, 32]
    stur x3, [sp, 24]
    stur x2, [sp, 16]
    stur x1, [sp, 8]
    ldur lr, [sp, 0]
    add sp, sp, 40

    br lr

//-----------------------------------------------------------------------

Edificio1:
    sub sp, sp, 8
    stur lr, [sp, 0]
    
    movz x11, 0x00, lsl 16    // Color edificios
    movk x11, 0x2233, lsl 00

    mov x1, 70      // base(columnas)    
    mov x2, 140     // altura(filas)
    mov x3, 25      // COLUMNA X (donde empieza en la pantalla)
    mov x4, 240     // FILA Y (pantalla)    
    bl rectangulo
    bl ventanas

    ldur lr, [sp, 0]
    add sp, sp, 8    
    br lr

Edificio2:
    sub sp, sp, 8
    stur lr, [sp, 0]    
    
    movz x11, 0x00, lsl 16
    movk x11, 0x2233, lsl 00

    mov x1, 70      // base(columnas)    
    mov x2, 140     // altura(filas)
    mov x3, 155     // COLUMNA X (donde empieza en la pantalla)
    mov x4, 240     // FILA Y (pantalla)    
    bl rectangulo
    bl ventanas

    ldur lr, [sp, 0]
    add sp, sp, 8    
    br lr

Edificio3:
    sub sp, sp, 8
    stur lr, [sp, 0]    
    
    movz x11, 0x00, lsl 16
    movk x11, 0x2233, lsl 00

    mov x1, 70      // base(columnas)    
    mov x2, 140     // altura(filas)
    mov x3, 285     // COLUMNA X (donde empieza en la pantalla)
    mov x4, 240     // FILA Y (pantalla)    
    bl rectangulo
    bl ventanas

    ldur lr, [sp, 0]
    add sp, sp, 8    
    br lr

Edificio4:
    sub sp, sp, 8
    stur lr, [sp, 0]

    movz x11, 0x00, lsl 16
    movk x11, 0x2233, lsl 00

    mov x1, 70      // base(columnas)    
    mov x2, 140     // altura(filas)
    mov x3, 415     // COLUMNA X (donde empieza en la pantalla)
    mov x4, 240     // FILA Y (pantalla)    
    bl rectangulo
    bl ventanas

    ldur lr, [sp, 0]
    add sp, sp, 8    

    br lr

Edificio5:
    sub sp, sp, 8
    stur lr, [sp, 0]

    movz x11, 0x00, lsl 16
    movk x11, 0x2233, lsl 00

    mov x1, 70      // base(columnas)    
    mov x2, 140     // altura(filas)
    mov x3, 545     // COLUMNA X (donde empieza en la pantalla)
    mov x4, 240     // FILA Y (pantalla)    
    bl rectangulo
    bl ventanas

    ldur lr, [sp, 0]
    add sp, sp, 8    
    br lr

//-------------------------------------------------------------------

/* ------------------------------------- VENTANAS -------------------------------------- */
ventanas:
    /* Guardamos temporalmente lo valores iniciales en el registo x28(sp) */
    sub sp, sp, 48
    stur x11, [sp, 40]
    stur lr, [sp, 32]
    stur x1, [sp, 24]
    stur x2, [sp, 16] 
    stur x4, [sp, 8]
    stur x3, [sp, 0]
    mov x27, x14

    movz x11, 0xFF, lsl 16    // Color ventans
    movk x11, 0xFF66, lsl 00

    mov x1, 1      // base(columnas)    
    mov x2, 1      // altura(filas)
    mov x4, 248    // FILA Y (pantalla)

    /* Repeticion de las ventanitas */
loop_v_horizontal:
    add x3, x3, 7   // inicio de la ventana
    mov x14, 12     // por cada fila hay 12 ventanas por edificio.
loop_V_columna:
    bl rectangulo     
    sub x14, x14, 1
    add x3, x3, 5     // Distancia entre las ventanas
    cbnz x14, loop_V_columna
    ldur x3, [sp, 0]
    add x4, x4, 5
    cmp x4, 360
    b.lt loop_v_horizontal

    /* Reestablecemos los valores iniciales que estan en el registro x28(sp) */
    mov x14, x27
    mov x15, x26
    ldur x11, [sp,40]
    ldur lr, [sp, 32]
    ldur x1, [sp,24]
    ldur x2, [sp, 16] 
    ldur x4, [sp, 8]
    ldur x3, [sp, 0]
    add sp, sp, 48
    br lr

//------------------------------------------ MOVIMIENTO DE LA NAVE ------------------------------------------//

mover_nave:

    sub sp, sp, 48
    stur x11, [sp, 40]
	stur lr, [sp, 32] 
    stur x22, [sp, 24]
    stur x5, [sp, 16] 
    stur x4, [sp, 8]
    stur x3, [sp, 0]
	mov x22, 200
    mov x23, 600
    mov x21, 0
    mov x24, 0
    mov x19, 0
    mov x18, 0
    mov x17, 0
    mov x5, 50 // altura
	mov x3, 300 // posicion esquina X
	mov x4, 385 // posicion esquina Y
    b derecha

llego_hastamitadDer:
    mov x22,230
    bl crearmDelay
    bl destruir_alien3
    bl crearmDelay
    b izquierda

llego_hastamitadIzq:
    mov x23,200
    mov x22,250
    bl crearmDelay
    bl destruir_alien2
    bl crearmDelay
    b derecha

llego_hastafinalDer:
    mov x22,530
    bl crearmDelay
    bl destruir_alien1
    bl crearmDelay
    b izquierda

llego_hastafinalIzq:
   
    mov x24,320
    bl crearmDelay
    bl destruir_alien4
    bl crearmDelay
    b derecha

otra_parada:
    mov x18,130
    bl crearmDelay
    bl destruir_alien5
    bl crearmDelay
    b izquierda

otra_parada2:
    mov x17, 300
    bl crearmDelay
    bl destruir_alien6
    bl crearmDelay
    b derecha

otra_parada3:
    mov x19, 350
    bl crearmDelay
    bl destruir_alien7
    bl crearmDelay
    b izquierda

otra_parada4:
    mov x21,120
    bl crearmDelay
    bl destruir_alien8
    bl crearmDelay
    b derecha

izquierda:

	bl crearmDelay

    mov x5, 50 // altura
	movz x11, 0x20, lsl 16
	movk x11, 0x2020, lsl 00
    BL nave1

    movz x11, 0x33, lsl 16
	movk x11, 0x44ff, lsl 00
	mov x5, 50 // altura
	sub x3,x3,1 // posicion esquina X
	BL nave1

    sub x22,x22,1
    cbz x22, llego_hastafinalIzq
    
    sub x23,x23,1
    cbz x23, llego_hastamitadIzq

    sub x18,x18,1
    cbz x18, otra_parada2

    sub x19,x19,1
    cbz x19, otra_parada4
    b izquierda

derecha:
    
    bl crearmDelay

    mov x5, 50 // altura
	movz x11, 0x20, lsl 16
	movk x11, 0x2020, lsl 00
    BL nave1

    movz x11, 0x33, lsl 16
	movk x11, 0x44ff, lsl 00
	
	mov x5, 50 // altura
	add x3,x3,1 // posicion esquina X
	BL nave1
    
    sub x22,x22,1
    cbz x22, llego_hastafinalDer

    sub x23,x23,1
    cbz x23, llego_hastamitadDer
    
    sub x24,x24,1
    cbz x24, otra_parada

    sub x17,x17,1
    cbz x17, otra_parada3

    sub x21,x21,1
    cbz x21, fin

    b derecha

    
fin:
    bl crearmDelay
    bl destruir_alien9
    bl crearmDelay
    ldur x11, [sp,40]
    ldur lr, [sp, 32]
    ldur x22, [sp,24]
    ldur x5, [sp, 16] 
    ldur x4, [sp, 8]
    ldur x3, [sp, 0]
    add sp, sp, 48

    br lr

//--------------------------------------------------------------------------------------//

//------------------------------------- DESTRUCCION DE ALIENS COMPLETO -----------------------------//
destruir_alien1:
    sub sp, sp, 32 
    stur x11, [sp, 24]
    stur x3, [sp, 16] 
    stur x4, [sp, 8]
    stur lr, [sp, 0]
 
    movz x11, 0x00, lsl 16
    movk x11, 0x0033, lsl 00
    mov x12, x11
    bl crearDelay
    mov x3, 470
    mov x4, 60
    bl bala_nave
    bl alienf
    bl crearDelay

    ldur x11, [sp,24]
    ldur x3, [sp, 16] 
    ldur x4, [sp, 8]
    ldur lr, [sp, 0]
    add sp, sp, 32

    br lr

destruir_alien2:
    sub sp, sp, 32 
    stur x11, [sp, 24]
    stur x3, [sp, 16] 
    stur x4, [sp, 8]
    stur lr, [sp, 0]
    bl crearDelay
    movz x11, 0x00, lsl 16
    movk x11, 0x0033, lsl 00
    mov x12, x11
    mov x3, 110
    mov x4, 60
    bl bala_nave         
    bl alienf
    bl crearDelay
    
    ldur x11, [sp,24]
    ldur x3, [sp, 16] 
    ldur x4, [sp, 8]
    ldur lr, [sp, 0]
    add sp, sp, 32

    br lr

destruir_alien3:
    sub sp, sp, 32 
    stur x11, [sp, 24]
    stur x3, [sp, 16] 
    stur x4, [sp, 8]
    stur lr, [sp, 0]
    bl crearDelay
    movz x11, 0x00, lsl 16
    movk x11, 0x0033, lsl 00
    mov x12, x11

    mov x3,290
    mov x4,60
    bl bala_nave
    bl alienf
    bl crearDelay

    ldur x11, [sp,24]
    ldur x3, [sp, 16] 
    ldur x4, [sp, 8]
    ldur lr, [sp, 0]
    add sp, sp, 32

    br lr

destruir_alien4:
    sub sp, sp, 32 
    stur x11, [sp, 24]
    stur x3, [sp, 16] 
    stur x4, [sp, 8]
    stur lr, [sp, 0]
 
    movz x11, 0x00, lsl 16
    movk x11, 0x0033, lsl 00
    mov x12, x11
    bl crearDelay
    mov x3, 50
    mov x4, 60
    bl bala_nave
    bl alienf
    bl crearDelay
    
    ldur x11, [sp,24]
    ldur x3, [sp, 16] 
    ldur x4, [sp, 8]
    ldur lr, [sp, 0]
    add sp, sp, 32

    br lr


destruir_alien6:
    sub sp, sp, 32 
    stur x11, [sp, 24]
    stur x3, [sp, 16] 
    stur x4, [sp, 8]
    stur lr, [sp, 0]
 
    movz x11, 0x00, lsl 16
    movk x11, 0x0033, lsl 00
    mov x12, x11
    bl crearDelay
    mov x3, 230
    mov x4, 60
    bl bala_nave
    bl alienf
    bl crearDelay

    ldur x11, [sp,24]
    ldur x3, [sp, 16] 
    ldur x4, [sp, 8]
    ldur lr, [sp, 0]
    add sp, sp, 32

    br lr

destruir_alien5:
    sub sp, sp, 32 
    stur x11, [sp, 24]
    stur x3, [sp, 16] 
    stur x4, [sp, 8]
    stur lr, [sp, 0]
 
    movz x11, 0x00, lsl 16
    movk x11, 0x0033, lsl 00
    mov x12, x11
    bl crearDelay
    mov x3, 410
    mov x4, 60
    bl bala_nave
    bl alienf
    bl crearDelay

    ldur x11, [sp,24]
    ldur x3, [sp, 16] 
    ldur x4, [sp, 8]
    ldur lr, [sp, 0]
    add sp, sp, 32

    br lr


destruir_alien7:
    sub sp, sp, 32 
    stur x11, [sp, 24]
    stur x3, [sp, 16] 
    stur x4, [sp, 8]
    stur lr, [sp, 0]
 
    movz x11, 0x00, lsl 16
    movk x11, 0x0033, lsl 00
    mov x12, x11
    bl crearDelay
    mov x3, 530
    mov x4, 60
    bl bala_nave
    bl alienf
    bl crearDelay

    ldur x11, [sp,24]
    ldur x3, [sp, 16] 
    ldur x4, [sp, 8]
    ldur lr, [sp, 0]
    add sp, sp, 32

    br lr


destruir_alien8:
    sub sp, sp, 32 
    stur x11, [sp, 24]
    stur x3, [sp, 16] 
    stur x4, [sp, 8]
    stur lr, [sp, 0]
 
    movz x11, 0x00, lsl 16
    movk x11, 0x0033, lsl 00
    mov x12, x11
    bl crearDelay
    mov x3, 170
    mov x4, 60
    bl bala_nave
    bl alienf
    bl crearDelay

    ldur x11, [sp,24]
    ldur x3, [sp, 16] 
    ldur x4, [sp, 8]
    ldur lr, [sp, 0]
    add sp, sp, 32

    br lr


destruir_alien9:
    sub sp, sp, 32 
    stur x11, [sp, 24]
    stur x3, [sp, 16] 
    stur x4, [sp, 8]
    stur lr, [sp, 0]
 
    movz x11, 0x00, lsl 16
    movk x11, 0x0033, lsl 00
    mov x12, x11
    bl crearDelay
    mov x3, 350
    mov x4, 60
    bl bala_nave
    bl alienf
    bl crearDelay

    ldur x11, [sp,24]
    ldur x3, [sp, 16] 
    ldur x4, [sp, 8]
    ldur lr, [sp, 0]
    add sp, sp, 32

    br lr
//----------------------------------------------------------------------------------------//

/*----------------------------------------------- METEORITOS ------------------------------*/
Meteorito: 

    sub sp, sp, 48
    stur x11, [sp, 40]
	stur lr, [sp, 32] 
    stur x22, [sp, 24]
    stur x5, [sp, 16] 
    stur x4, [sp, 8]
    stur x3, [sp, 0]
    mov x22,630        //tiempo transcurrido del meteorito
    mov x3, 10
    mov x4, 20    


movimientoM:
    bl crearsDelay
    mov x2, 10 // largo
	mov x1, 10 // ancho
	bl pos_col_aliens
    movz x11, 0x00, lsl 16
	movk x11, 0x0033, lsl 00
    BL rectangulo //ojo
    sub x22,x22,1
    cbz x22, termina
    add x3,x3,1
    movz x11, 0xff, lsl 16
	movk x11, 0xff33, lsl 00
    BL rectangulo //ojo
    
    bl movimientoM


termina:
    ldur x11, [sp,40]
    ldur lr, [sp, 32]
    ldur x22, [sp,24]
    ldur x5, [sp, 16] 
    ldur x4, [sp, 8]
    ldur x3, [sp, 0]
    add sp, sp, 48

    br lr


Meteorito2: 

    sub sp, sp, 48
    stur x11, [sp, 40]
	stur lr, [sp, 32] 
    stur x22, [sp, 24]
    stur x5, [sp, 16] 
    stur x4, [sp, 8]
    stur x3, [sp, 0]
    mov x22,630
    mov x3, 10
    mov x4, 30    


movimientoM2:
    bl crearsDelay
	
    mov x2, 10 // largo
	mov x1, 10 // ancho
	
	
	bl pos_col_aliens
    
    movz x11, 0x00, lsl 16
	movk x11, 0x0033, lsl 00
    BL rectangulo //ojo
    sub x22,x22,1
    cbz x22, termina2
    add x3,x3,1
    movz x11, 0xbb, lsl 16
	movk x11, 0x4433, lsl 00
    BL rectangulo //ojo
    bl movimientoM2

termina2:
    ldur x11, [sp,40]
    ldur lr, [sp, 32]
    ldur x22, [sp,24]
    ldur x5, [sp, 16] 
    ldur x4, [sp, 8]
    ldur x3, [sp, 0]
    add sp, sp, 48

    br lr

//--------------------------------------------------------------------------------------------------------

/*------------------------------------------------ BALA -------------------------------------------- */

bala_aliens:

    sub sp, sp, 32
    stur x11, [sp, 24]
    stur x2, [sp,16]
    stur x1, [sp,8]
    stur lr, [sp, 0]
    
    mov x1, 2         // base(columnas)    
    mov x2, 5         // altura(filas)
    // Al x3 y x4 se lo pasa la funcion bala
    bl rectangulo

    stur x11, [sp, 24]
    ldur x2, [sp,16]
    ldur x1, [sp,8]
    ldur lr, [sp, 0]
    add sp, sp, 32   

    br lr

//--------------------------------------- MOVIMINETO DE LA BALA --------------------------------------

bala_nave:
    sub sp, sp, 40
    stur x22, [sp, 32]
    stur x11, [sp, 24]
	stur lr, [sp, 16] 
    stur x4, [sp, 8]
    stur x3, [sp, 0]
    // Que vaya de abajo hacia arriba:
    mov x4, 373     // piso  
    mov x22, 96     // limite de fila aliens 1
    mov x13, 7

sube:
    bl crearbDelay
    // borra la bala
    bl laser

    
    // restablece la bala
    movz x11, 0xff, lsl 16    // Color de la bala
    movk x11, 0xffff, lsl 00
    mov x1, 2       // base(columnas)    
    mov x2, 5       // altura(filas)
    sub x4, x4, 1   // FILA Y (pantalla)
    bl bala_aliens
    cmp x4, x22
    b.ne sube

    // delay de la explosion
    mov x12, 20     // tiempo de duracion de la explosion
loop_explosion:
    bl crearbDelay
    ldur x3, [sp, 0]
    ldur x4, [sp, 8]
    bl explosion
    sub x12, x12, 1
    cbnz x12, loop_explosion

    // restablece el fondo 
    mov x26, NOCHE_SUP    // limite superior noche(es fila 96)
    mov x27, NOCHE_INF    // limite inferior noche(es fila 103)
    bl Noche1
    bl Edificio
    
    ldur x22, [sp, 32]
    ldur x11, [sp, 24]
	ldur lr, [sp, 16] 
    ldur x4, [sp, 8]
    ldur x3, [sp, 0]
    add sp, sp, 40

    br lr

//--------------------------------- LASER --------------------------------------//

laser:
    sub sp, sp, 32
    stur x22, [sp, 24]
    stur x11, [sp, 16]
	stur lr, [sp, 8] 
    stur x4, [sp, 0]

    mov x4, 373                // fila donde comienza (pantalla)
    movz x11, 0xff, lsl 16     // color del laser
    movk x11, 0x3333, lsl 00
    mov x22, 96                // fila donde termina

loop_laser:
    sub x4, x4, 1
    bl bala_aliens
    cmp x4, x22
    b.ne loop_laser

    ldur x22, [sp, 24]
    ldur x11, [sp, 16]
	ldur lr, [sp, 8] 
    ldur x4, [sp, 0]
    add sp, sp, 32

    br lr

//----------------------------------------------------------------------------------------//

/* ------------------------------ EXPLOSION ---------------------------------------------  */

explosion:
    sub sp, sp, 32
    stur x11, [sp, 24]
    stur x2, [sp, 16]
    stur x1, [sp, 8]
    stur lr, [sp, 0]

    movz x11, 0xff, lsl 16
    movk x11, 0x5500, lsl 00
    mov x1, 23      // base(columnas)    
    mov x2, 20     // altura(filas)
    bl rectangulo

    movz x11, 0xff, lsl 16
    movk x11, 0xc400, lsl 00
    mov x1, 16          
    mov x2, 13      
    add x3, x3, 3 //473
    add x4, x4, 3 //63        
    bl rectangulo

    movz x11, 0xff, lsl 16
    movk x11, 0x5500, lsl 00
    mov x1, 11          
    mov x2, 8      
    add x3, x3, 3 //476         
    add x4, x4, 3 //66
    bl rectangulo

    movz x11, 0xff, lsl 16
    movk x11, 0xc400, lsl 00
    mov x1, 6          
    mov x2, 6      
    add x3, x3, 3 //479    
    add x4, x4, 2 //68        
    bl rectangulo

    movz x11, 0xff, lsl 16
    movk x11, 0x5500, lsl 00
    mov x1, 2          
    mov x2, 2      
    add x3, x3, 2 //481    
    add x4, x4, 2 //70        
    bl rectangulo

    stur x11, [sp, 24]
    stur x2, [sp, 16]
    stur x1, [sp, 8]
    ldur lr, [sp, 0]
    add sp, sp, 32

    br lr
//----------------------------------------------------------------------------------------------//

// --------------------------------- ALIENS Y NAVE -------------------------------------------- //

pos_col_aliens:
    sub sp, sp, 48
    stur x11, [sp, 40]
	stur lr, [sp, 32] 
    stur x22, [sp, 24]
    stur x5, [sp, 16] 
    stur x4, [sp, 8]
    stur x3, [sp, 0]
    movz x11, 0x00, lsl 16
    movk x11, 0x3300, lsl 00
    mov x12, x11
	mov x3, 20 // posicion esquina X
	mov x4, 10 // posicion esquina y
    bl alien 
    movz x11, 0x00, lsl 16
    movk x11, 0x6600, lsl 00
    mov x12, x11
	mov x3, 80 // posicion esquina X
	mov x4, 10 // posicion esquina y
	bl alien
    movz x11, 0x00, lsl 16
    movk x11, 0x9900, lsl 00
    mov x12, x11
	mov x3, 140 // posicion esquina X
	mov x4, 10 // posicion esquina y
	bl alien
    movz x11, 0x00, lsl 16
    movk x11, 0xCC00, lsl 00
    mov x12, x11
	mov x3, 200 // posicion esquina X
	mov x4, 10 // posicion esquina y
	bl alien
    movz x11, 0x00, lsl 16
    movk x11, 0xff00, lsl 00
    mov x12, x11
	mov x3, 260 // posicion esquina X
	mov x4, 10 // posicion esquina y
	bl alien
    movz x11, 0x33, lsl 16
    movk x11, 0xff33, lsl 00
    mov x12, x11
	mov x3, 320 // posicion esquina X
	mov x4, 10 // posicion esquina y
	bl alien
    movz x11, 0x66, lsl 16
    movk x11, 0xff66, lsl 00
    mov x12, x11
	mov x3, 380 // posicion esquina X
	mov x4, 10 // posicion esquina y
	bl alien
    movz x11, 0x99, lsl 16
    movk x11, 0xff99, lsl 00
    mov x12, x11
	mov x3, 440 // posicion esquina X
	mov x4, 10 // posicion esquina y
	bl alien
    movz x11, 0xAA, lsl 16
    movk x11, 0xffAA, lsl 00
    mov x12, x11
	mov x3, 500 // posicion esquina X
	mov x4, 10 // posicion esquina y
	bl alien
    movz x11, 0xCC, lsl 16
    movk x11, 0xffCC, lsl 00
    mov x12, x11
	mov x3, 560 // posicion esquina X
	mov x4, 10 // posicion esquina y
	bl alien
    movz x11, 0x00, lsl 16
    movk x11, 0x6633, lsl 00
    mov x12, x11
	mov x3, 50 // posicion esquina X
	mov x4, 60 // posicion esquina y
	bl alien
    movz x11, 0x00, lsl 16
    movk x11, 0x994C, lsl 00
    mov x12, x11
	mov x3, 110 // posicion esquina X
	mov x4, 60 // posicion esquina y
	bl alien
    movz x11, 0x00, lsl 16
    movk x11, 0xCC66, lsl 00
    mov x12, x11
	mov x3, 170 // posicion esquina X
	mov x4, 60 // posicion esquina y
	bl alien
    movz x11, 0x00, lsl 16
    movk x11, 0xff80, lsl 00
    mov x12, x11
	mov x3, 230 // posicion esquina X
	mov x4, 60 // posicion esquina y
	bl alien
    movz x11, 0x33, lsl 16
    movk x11, 0xff99, lsl 00
    mov x12, x11
	mov x3, 290 // posicion esquina X
	mov x4, 60 // posicion esquina y
	bl alien
    movz x11, 0x66, lsl 16
    movk x11, 0xffB2, lsl 00
    mov x12, x11
	mov x3, 350 // posicion esquina X
	mov x4, 60 // posicion esquina y
	bl alien
    movz x11, 0x77, lsl 16
    movk x11, 0xffCC, lsl 00
    mov x12, x11
	mov x3, 410 // posicion esquina X
	mov x4, 60 // posicion esquina y
	bl alien
    movz x11, 0x88, lsl 16
    movk x11, 0xff99, lsl 00
    mov x12, x11
	mov x3, 470 // posicion esquina X
	mov x4, 60 // posicion esquina y
	bl alien
    movz x11, 0x99, lsl 16
    movk x11, 0xff99, lsl 00
    mov x12, x11
	mov x3, 530 // posicion esquina X
	mov x4, 60 // posicion esquina y
	bl alien

    ldur x11, [sp,40]
    ldur lr, [sp, 32]
    ldur x22, [sp,24]
    ldur x5, [sp, 16] 
    ldur x4, [sp, 8]
    ldur x3, [sp, 0]
    add sp, sp, 48

    br lr

//---------------------------------------------------------------------------//

alien:
	
    sub sp, sp, 48
    stur x5, [sp, 40]
    stur x4, [sp, 32]
    stur lr, [sp, 24]
    stur x3, [sp, 16] 
    stur x2, [sp, 8]
    stur x1, [sp, 0]

	mov x2, 20 // largo
	mov x1, 30 // ancho

	
	BL rectangulo

	mov x2, 30 // largo
	mov x1, 5 // ancho
	BL rectangulo // brazo

	mov x2, 30 // largo
	mov x1, 5 // ancho
	add x3,x3,30
	BL rectangulo // brazo

	movz x11, 0x00, lsl 16
	movk x11, 0x0000, lsl 00
	mov x2, 4 // largo
	mov x1, 4 // ancho
	sub x3,x3,3
	add x4,x4,5
	BL rectangulo //ojo

	mov x2, 4 // largo
	mov x1, 4	 // ancho
	sub x3,x3,22
	BL rectangulo // ojo



	mov x11,x12
	mov x2, 4 // largo
	mov x1, 7 // ancho
	add x3,x3,17
	add x4,x4,25
	BL rectangulo // boca?

	mov x2, 4 // largo
	mov x1, 7 // ancho
	sub x3,x3,16
	BL rectangulo //boca ?

	mov x2, 15
	mov x1, 3
	sub x4,x4,20
	sub x3, x3,15
	BL rectangulo

	mov x2, 4
	mov x1, 5
	add x3,x3,3
	sub x4,x4,4
	BL rectangulo

	mov x2, 15
	mov x1, 3
	add x3, x3,47
	add x4,x4,4
	BL rectangulo

	mov x2, 5
	mov x1, 5
	sub x3,x3,5
	sub x4,x4,4
	BL rectangulo

	
	ldur x5, [sp, 40]
    ldur x4, [sp, 32]
    ldur lr, [sp,24]
    ldur x3, [sp,16]
    ldur x2, [sp,8]
    ldur x1, [sp,0]
    add sp, sp, 48
    

	br lr

//---------------------------------------------------- NAVE --------------------------------------------------------//

nave1:
	
    sub sp, sp, 48
    stur x11, [sp, 40]
	stur lr, [sp, 32] 
    stur x1, [sp, 24]
    stur x2, [sp, 16] 
    stur x4, [sp, 8]
    stur x3, [sp, 0]
	
	
	BL triangulo

    mov x5, 30 // altura

    
	add x3, x3, 30 // posicion esquina X
	add x4,x4,20 // posicion esquina Y
    BL triangulo


    mov x5, 30 // altura
    sub x3, x3, 60 // posicion esquina X
	
    BL triangulo


    mov x2, 35 // largo
	mov x1, 3 // ancho
    add x3,x3,57 // posicion esquina X
	sub x4,x4,20 // posicion esquina y
    BL rectangulo

    mov x2, 35 // largo
	mov x1, 3 // ancho
    sub x3,x3,60     
    BL rectangulo
    
    

    mov x5, 30 // altura
	movz x11, 0x20, lsl 16
	movk x11, 0x2020, lsl 00
    add x3,x3,33
    add x4,x4,30
    BL triangulo
    
    

    ldur x11, [sp,40]
    ldur lr, [sp, 32]
    ldur x1, [sp,24]
    ldur x2, [sp, 16] 
    ldur x4, [sp, 8]
    ldur x3, [sp, 0]
    add sp, sp, 48

    br lr
//-------------------------------------------------------------------------------------------------------

/*-------------------------------------- ELIMINACION DE ALIENS_F ------------------------------------------ */

alienf:
	
    sub sp, sp, 48
    stur x5, [sp, 40]
    stur x4, [sp, 32]
    stur lr, [sp, 24]
    stur x3, [sp, 16] 
    stur x2, [sp, 8]
    stur x1, [sp, 0]

	mov x2, 20 // largo
	mov x1, 30 // ancho

	
	BL rectangulo

	mov x2, 30 // largo
	mov x1, 5 // ancho
	BL rectangulo // brazo

	mov x2, 30 // largo
	mov x1, 5 // ancho
	add x3,x3,30
	BL rectangulo // brazo

	
	mov x2, 4 // largo
	mov x1, 4 // ancho
	sub x3,x3,3
	add x4,x4,5
	BL rectangulo //ojo

	mov x2, 4 // largo
	mov x1, 4	 // ancho
	sub x3,x3,22
	BL rectangulo // ojo

	
	mov x2, 4 // largo
	mov x1, 7 // ancho
	add x3,x3,17
	add x4,x4,25
	BL rectangulo // boca?

	mov x2, 4 // largo
	mov x1, 7 // ancho
	sub x3,x3,16
	BL rectangulo //boca ?

	mov x2, 15
	mov x1, 3
	sub x4,x4,20
	sub x3, x3,15
	BL rectangulo

	mov x2, 4
	mov x1, 5
	add x3,x3,3
	sub x4,x4,4
	BL rectangulo

	mov x2, 15
	mov x1, 3
	add x3, x3,47
	add x4,x4,4
	BL rectangulo

	mov x2, 5
	mov x1, 5
	sub x3,x3,5
	sub x4,x4,4
	BL rectangulo

	
	ldur x5, [sp, 40]
    ldur x4, [sp, 32]
    ldur lr, [sp,24]
    ldur x3, [sp,16]
    ldur x2, [sp,8]
    ldur x1, [sp,0]
    add sp, sp, 48
    

	br lr

/*----------------------------------------------------------------------------*/

/* ------------------------------ RECTANGULO o CUADRADO -----------------------------------------  */
/* Dibuja un rectangulo, los parametros que necesita estan en los registros x1,x2,x3,x4 
   siendo estos valores el x1 -> base, 
                           x2 -> altura, 
                           x3 -> posicion inicial en el eje x, 
                           x4 -> posicion inicial en el eje y; respectivamente.
*/

/* Guarda en x15, x16 los limites finales del rectangulo siendo 
   x15 = base + posicion inicial en el eje x,
   x16 = altura + posicion inicial en el eje y
*/
// Uso estos valores para saber cuando vuelvo a entrar a un ciclo y cuando no.
// Por cada iteracion encuentra un pixel dentro del cuadrado y lo pinta

rectangulo:
    /* Guardamos temporalmente lo valores iniciales en el registo x28(sp) */
    sub sp, sp, 48
    stur x5, [sp, 40]
    stur x13, [sp, 32]
    stur lr, [sp, 24]
    stur x7, [sp, 16] 
    stur x4, [sp, 8]
    stur x3, [sp, 0]
    
    add x15, x3, x1  
    add x16, x4, x2  
    mov x9, x3      
    mov x13, 3
    
c_loopy:
    mov x3, x9
c_loopx:
    stur w11, [x7]
    add x3, x3, 1
    bl setpixel     // Encuentra según x2 y x3, el pixel en esa posicion de la pantalla
    cmp x3, x15
    b.LE c_loopx
    add x4, x4, 1
    cmp x4, x16
    b.LE c_loopy

    stur w11, [x7]

    /* Reestablecemos los valores iniciales que estan en el registro x28(sp) */
    ldur x5, [sp, 40]
    ldur x13, [sp, 32]
    ldur lr, [sp,24]
    ldur x7, [sp,16]
    ldur x4, [sp,8]
    ldur x3, [sp,0]
    add sp, sp, 48
    br lr
//------------------------------------------------------------------------------------

/* -------------------------------------------- TRIANGULO --------------------------------------------  */

triangulo:
	sub sp, sp, 24
	stur lr, [sp]	
	stur x3, [sp, 8]
	stur x4, [sp, 16]
	
	mov x9, x3
	mov x1, x3
	mov x2, x4
	
t_loopy:
	mov x3, x9
t_loopx:
	bl setpixel
	stur w11, [x7]
	add x3, x3, 1
	cmp x3, x1
	b.le t_loopx
	sub x9, x9, 1
	add x1, x1, 1
	add x4, x4, 1
	sub x5, x5, 1
	cbnz x5, t_loopy

	ldur lr, [sp]
	ldur x3, [sp, 8]
	ldur x4, [sp, 16]
	add sp, sp, 24
	br lr
//-----------------------------------------------------------------------------------------------

/* -------------------------------- Set Pixel --------------------------------------- */
// calcula el valor correspondiente a un pixel dadas coordenas (x, y) guardados en x3 y x4 respectivamente
// realiza la siguiente operacion:
// pixel = 4 * [x + (y * 640)] + posicion cero del frame_buffer
// no pinta el pixel, solo lo encuentra y lo retorna en el registro x7 para ser usado en otra funcion

setpixel:
    sub sp, sp, 48
    stur x6, [sp, 40]
    stur x9, [sp, 32]
    stur lr, [sp, 24] 
    stur x4, [sp, 8]
    stur x3, [sp, 0]    
    
    mov x9, 640
    mul x6, x4, x9
    add x7, x6, x3
    mov x9, 4 
    mul x7, x7, x9              
    add x7, x7, x20
    
    ldur x6, [sp, 40]
    ldur x9, [sp, 32]
    ldur lr, [sp, 24]
    ldur x4, [sp, 8]
    ldur x3, [sp, 0]
    add sp, sp, 48   
    br lr
//-------------------------------------------------------------------------------------//

/* ------------------------------------------------ DELAYS ------------------------------------------------------- */

delay: .dword 0xBD3E27F

crearDelay:
    ldr x9, delay

loop_crearDelay:

    subs x9, x9, 1
    b.ne loop_crearDelay

    br lr 

//--------------------------------------//

minidelay: .dword 0x39A2BF

crearmDelay:
    ldr x9, minidelay

loop_crearmDelay:

    subs x9, x9, 1
    b.ne loop_crearmDelay

    br lr 

//--------------------------------------------//

baladelay: .dword 0x1502BF//0x3002BF

crearbDelay:
    ldr x9, baladelay

loop_crearbDelay:

    subs x9, x9, 1
    b.ne loop_crearbDelay

    br lr 

//---------------------------------------------//

superdelay: .dword 0xfffff

crearsDelay:
    ldr x9, superdelay

loop_crearsDelay:

    subs x9, x9, 1
    b.ne loop_crearsDelay

    br lr 



.endif


