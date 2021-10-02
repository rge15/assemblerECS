.include "cpctelera.h.s"

;;
;; Start of _DATA area 
;;  SDCC requires at least _DATA and _CODE areas to be declared, but you may use
;;  any one of them for any purpose. Usually, compiler puts _DATA area contents
;;  right after _CODE area contents.
;;
.area _DATA
_init_e:
   .db #0x01
   .db #0x4F
   .db #0x03
   .db #0xFF 
   .db #0x80
   .dw #0x0000


.area _CODE

.globl cpct_disableFirmware_asm
.globl cpct_memcpy_asm
.globl cpct_getRandom_mxor_u8_asm
.globl _cpct_getRandom_mxor_u8
.globl _cpct_memcpy
;;
;; Métodos globales 
;;
.globl  _man_entityInit
.globl  _man_createEntity
.globl  _man_entity_freeSpace
.globl  _m_next_free_entity


;;
;; Metodo que crea una entidad y establece todos los valores
;; aleatorios
;;
_sys_gen_generateNewStar::
 ;Entity_t* e = man_entity_create();
	call	_man_createEntity
	ld	c, l
	ld	b, h
;cpct_memcpy(e , &init_e, sizeof(Entity_t));
	ld	e, c
	ld	d, b
	push	bc
	ld	hl, #0x0007
	push	hl
	ld	hl, #_init_e
	push	hl
	push	de
	call	_cpct_memcpy
	pop	bc
;e->vx = -1-(cpct_rand() & 0x03); 
	ld	e, c
	ld	d, b
	inc	de
	inc	de
	inc	de
	push	bc
	push	de
	call	_cpct_getRandom_mxor_u8
	pop	de
	pop	bc
	ld	a, l
	and	a, #0x03
	ld	l, a
	ld	a, #0xff
	sub	a, l
	ld	(de), a
;e->y = cpct_rand() & 0x50;
	inc	bc
	inc	bc
	push	bc
	call	_cpct_getRandom_mxor_u8
	pop	bc
	ld	a, l
	and	a, #0x50
	ld	(bc), a
	ret


;;
;; Metodo encargado de generar estrellas cuando hay espacio libre en el array de _m_entities
;;
_sys_gen_update::

   call _man_entity_freeSpace
   dec a
   inc a
   jr Z, noGenerate

   call _sys_gen_generateNewStar
   noGenerate:
   ret


















