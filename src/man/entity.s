;===================================================================================================================================================
; CPCTelera functions
;===================================================================================================================================================
.globl cpct_memset_asm
.globl cpct_memcpy_asm

;===================================================================================================================================================
; Entity types   
;===================================================================================================================================================
; #define e_type_invalid     0x00
; #define e_type_motherBoard 0x04
; #define e_type_enemy       0x02
; #define e_type_player      0x01
; #define e_type_shoot       0x08
; #define e_type_playerLife  0x10
; #define e_type_default     0x02 
; #define e_type_dead        0x80

;===================================================================================================================================================
; Component types   
;===================================================================================================================================================
; #define e_cmp_render   0x01
; #define e_cmp_movable  0x02
; #define e_cmp_input    0x04
; #define e_cmp_ai       0x08
; #define e_cmp_animated 0x10
; #define e_cmp_collider 0x20

;===================================================================================================================================================
; Manager data   
;===================================================================================================================================================
;; Descripcion : Array de entidades
_m_entities::
    .ds 112

;; Descripcion : Memoria vacia al final del array para controlar su final
_m_emptyMemCheck::
    .ds 1

;; Descripcion : Direccion de memoria con la siguiente posicion del array libre 
_m_next_free_entity::
    .ds 2

;; Descripcion : Direccion de memoria donde este la funcion de inversion de control
_m_functionMemory::
    .ds 2

;; Descripcion : Signature para comprobar entidades en el forAllMatching 
_m_matchedEntity::
    .ds 1

;; Descripcion : Numero de entidades que caben en el array _m_entities
_m_numEntities::
    .ds 1

;; Descripcion : TAmaño en bytes de 1 entity
_m_sizeOfEntity::
    .db #0x10


;===================================================================================================================================================
; FUNCION _man_entityInit   
; Inicializa el manager de entidades y sus datos
; NO llega ningun dato
;===================================================================================================================================================
_man_entityInit::
    ld  DE, #_m_entities
    ld  A,  #0x00
    ld  (_m_emptyMemCheck), a
    ld  (_m_numEntities), a
    ld  BC, #0x0070
    call    cpct_memset_asm
    ;;Destroyed: AF & BC & DE & HL
    
    ld  hl, #_m_entities
    ld  (_m_next_free_entity), hl
    
    ret


;===================================================================================================================================================
; FUNCION _man_createEntity   
; Crea una entidad
; NO llega ningun dato
;===================================================================================================================================================
_man_createEntity::
    ld  de, (_m_next_free_entity)
    ld  h, #0x00
    ;;TODO:Ver si esto está guay
    ld  a, (#_m_sizeOfEntity)
    ld  l, a
    add hl,de
    ld  (_m_next_free_entity),hl
    ld  hl, #_m_numEntities
    inc (hl)


    ld  l,e
    ld  h,d
    ret



;===================================================================================================================================================
; FUNCION _man_entityForAllMatching
; Ejecuta la funcion  de _m_functionMemory por cada entidad que cumpla con el tipo designado en  _m_matchedEntity
; NO llega ningun dato
;===================================================================================================================================================
_man_entityForAllMatching::
    ld  hl, #_m_entities
    
    ld  a,(hl)
    
    or a,a
    ret Z
    push hl
    jp checkSignature
    not_invalid2:
        pop hl
        push hl
        ld ix, #next_entity2
        push ix

        ld ix, (#_m_functionMemory)
        jp (ix)

        next_entity2:
        pop hl
        ld  a, (#_m_sizeOfEntity)
        ld  c, a
        ld  b, #0x00

        add hl,bc
        push hl
        ld  a,(hl)
        or a,a 
        jr  Z, allDone
        checkSignature:
        ld a,(#_m_matchedEntity)
        inc hl
        and (hl)
        ld hl , #_m_matchedEntity
        sub (hl)
        jr Z, not_invalid2
        jp next_entity2
    allDone:
    pop hl
    ret


;===================================================================================================================================================
; FUNCION _man_setEntity4Destroy
; Establece la entidad para ser destruida
; HL : La entidad para ser marcada
;===================================================================================================================================================
_man_setEntity4Destroy::
    ld a, #0x80
    or (hl)
    ld (hl),a
ret

;===================================================================================================================================================
; FUNCION _man_entityDestroy
; Elimina de las entidades la entidad de HL y arregla el array de entidades 
; para establecer la ultima entidad al espacio liberado por la entidad destruida 
; HL : La entidad para ser destruida
;===================================================================================================================================================
_man_entityDestroy::
    ld de, (#_m_next_free_entity)
    ex de, hl
    ;; HL = _m_next_free_entity
    ;; DE = entity to destroy


    ;; Buscamos la ultima entidad
    ld  a, (#_m_sizeOfEntity)
    setLast:
        dec hl
        dec a
        jr NZ, setLast
    ;; de = e && hl = last


    ;;Comprobamos que la ultima entidad libre y la entidad a destruir no sea la misma
    ;;if( e != last)
    ld a, e
    sub l
    jr Z, checkMemory

    jr copy
    checkMemory:
    ld a,d
    sub h
    jr Z, no_copy 

    ;;Si no es la misma copiamos la ultima entidad al espacio de la entidad a destruir
    copy:
    ; cpct_memcpy(e,last,sizeof(Entity_t));
    ld b, #0x00
    ld  a, (#_m_sizeOfEntity)
    ld c, a
    call cpct_memcpy_asm

    ;;Volvemos a asignar a hl el valor de la ultima entity
    ld hl, #_m_next_free_entity
    ld  a, (#_m_sizeOfEntity)
    setLast2:
        dec hl
        dec a
        jr NZ, setLast2


    ;;Aquí liberamos el ultimo espacio del array de entidades y lo seteamos como el proximo espacio libre 
    no_copy:
    ;last->type = e_type_invalid;
    ld (hl),#0x00
    ;m_next_free_entity = last;
    ld de, #_m_next_free_entity
    ex de, hl
    ld (hl), e
    inc hl
    ld (hl), d
    ;    --m_num_entities;      
    ld  hl, #_m_numEntities
    dec (hl)
    ret


;===================================================================================================================================================
; FUNCION _man_entityUpdate
; Recorre todas las entidades y destruye las entidades marcadas
; NO llega ningun dato 
;===================================================================================================================================================
_man_entityUpdate::
    ld hl, #_m_entities

    inc (hl)
    dec (hl)
    ret Z 
    ld a, (#_m_sizeOfEntity)
    ld c, a
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


;===================================================================================================================================================
; FUNCION _man_entity_freeSpace
; Devuelve en a si hay espacio libre en las entidades para poder generar
; NO llega ningun dato 
;===================================================================================================================================================
_man_entity_freeSpace::
        ld hl, #_m_numEntities
        ld a, (#_m_numEntities)
        sub (hl)
    ret






