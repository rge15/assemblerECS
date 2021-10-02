.globl cpct_memset_asm
.globl cpct_memcpy_asm
.globl _sys_physics_updateOneEntity


;; Array de entidades
_m_entities::
    .ds 140

;; Memoria vacia al final del array para controlar su final
_m_emptyMemCheck::
    .ds 1

;; Direccion de memoria con la siguiente posicion del array libre 
_m_next_free_entity::
    .ds 2

;; Direccion de memoria donde este la funcion de inversion de control
_m_functionMemory::
    .ds 2

;; Numero de entidades creadas
_m_numEntities::
    .ds 1

;;
;; Iniciamos las entidades y sus valores iniciales
;;
_man_entityInit::
    ld  DE, #_m_entities
    ld  A,  #0x00
    ld  (_m_emptyMemCheck), a
    ld  (_m_numEntities), a
    ld  BC, #0x008C
    call    cpct_memset_asm
    ;;Destroyed: AF & BC & DE & HL
    
    ld  hl, #_m_entities
    ld  (_m_next_free_entity), hl
    
    ret


;;
;; Crea una entidad
;;
_man_createEntity::
    ld  de, (_m_next_free_entity)
    ld  hl, #0x0007
    add hl,de
    ld  (_m_next_free_entity),hl
    ld  hl, #_m_numEntities
    inc (hl)
    ld  l,e
    ld  h,d
    ld  (hl), #0x7F
    ret

;;
;; Ejecuta la funcion de _m_functionMemory por cada entidad valida
;;
_man_entityForAll::
    ld  hl, #_m_entities
    ld  a,(hl)
    or a,a
    ret Z
    not_invalid:
        ld ix, #next_entity
        push ix

        ld ix, (#_m_functionMemory)
        jp (ix)

        next_entity:
        ld  c,#0x07
        ld  b,#0x00

        add hl,bc

        ld  a,(hl)
        or a,a 
        jr  NZ, not_invalid
    ret


;;
;; Marca a la entidad para ser destruida
;;
_man_setEntity4Destroy::
    ld a, #0x80
    or (hl)
    ld (hl),a
ret

;;
;; Destruye la entidad que llega en el registro HL
;; Prerequisitos -> Cargar en HL la entidad a destruir (e)
;;
_man_entityDestroy::
    ld de, (#_m_next_free_entity)
    ex de, hl
    ;; HL = _m_next_free_entity
    ;; DE = entity to destroy

    ld a, #0x07
    setLast:
        dec hl
        dec a
        jr NZ, setLast
    ;; de = e && hl = last

    ; if( e != last)
    ld a, e
    sub l
    jr Z, checkMemory

    jr copy
    checkMemory:
    ld a,d
    sub h
    jr Z, no_copy 

    copy:

    ; cpct_memcpy(e,last,sizeof(Entity_t));
    ld bc, #0x0007
    call cpct_memcpy_asm

    ; Volvemos a asignar a hl el valor de la ultima entity
    ld hl, #_m_next_free_entity
    ld a, #0x07
    setLast2:
        dec hl
        dec a
        jr NZ, setLast2

    no_copy:
    ;  last->type = e_type_invalid;
    ld (hl),#0x00
    ;    m_next_free_entity = last;
    ld de, #_m_next_free_entity
    ex de, hl
    ld (hl), e
    inc hl
    ld (hl), d
    ;    --m_num_entities;      
    ld  hl, #_m_numEntities
    dec (hl)
    ret


;;
;; Se encarga de destruir todas las entidades marcadas para ser destruidas
;;
_man_entityUpdate::
    ld hl, #_m_entities

    inc (hl)
    dec (hl)
    ret Z 
    ld c, #0x07
    ld b, #0x00    
    ld a, #0x80    
    valid:
        and (hl)
        jr Z, _next_entity
        jr NZ, _man_entityDestroy
        jr continue

        _next_entity:
            add hl, bc
            ; jr continue
        continue:
            ld a, #0x80
            inc (hl)
            dec (hl)
            jr NZ, valid
    ret


;;
;; Metodo que devuelve en el reg. A el espacio restante para generar entidades
;;
_man_entity_freeSpace::
        ld hl, #_m_numEntities
        ld a, #0x14
        sub (hl)
    ret






