.equ SCREEN_WIDTH,      640
.equ SCREEN_HEIGH,      480
.equ BITS_PER_PIXEL,    32
.equ MEDIA_WIDTH,       320
.equ MEDIA_HEIGH,       240
.equ FILA_DEG,          10
.equ CENTRO,            103 
.include "grafico.s"

.globl main
main:
    // X0 contiene la direccion base del framebuffer
    mov x20, x0 // Save framebuffer base address to x20 


/* ---------------------- PROGRAMA PRINCIPAL ------------------------------------ */
    
    bl Noche 
    bl Edificio
    bl pos_col_aliens
    bl nave1
    
    
    
    b InfLoop

/* -------------------------------------------------------------------- */


FIN:
InfLoop: 
    b InfLoop

