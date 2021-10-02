.globl _man_entityForAll
.globl _man_entityDestroy
.globl _m_functionMemory
.globl _man_setEntity4Destroy

;;
;; Llama a la inversión de control para updatear las fisicas de cada entidad
;;
_sys_physics_update::
    ld hl, #_sys_physics_updateOneEntity
    ld (_m_functionMemory), hl
    call _man_entityForAll
    ret


;;
;; Hace los calculos de la posicion de las entidades con la velocidad de cada entidad
;;
_sys_physics_updateOneEntity::    
;Preparo los dos valores para ser restados,
;si hay acarreo , el newx es mayor que e->x
    ld  d,h
    ld  e,l 
    inc hl
    ld  a,(hl)
    inc hl
    inc hl
    add a,(hl) ; a = newx
    
    dec hl
    dec hl
    push af
    add a, (hl)
    pop af

    ;; e->x = newx;
    ld (hl), a
    ld h, d
    ld l, e 

    ;Si el resultado de la suma se pasa de 255 acarrea y por lo tanto se debe destuir
    ;y se marca para destruirse
    jr NC, destroy
    ret
    destroy:
        call _man_setEntity4Destroy
    ret