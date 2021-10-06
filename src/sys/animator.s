;===================================================================================================================================================
; Public functions
;===================================================================================================================================================
.globl _man_entityForAllMatching
.globl _m_functionMemory
.globl _m_matchedEntity


;===================================================================================================================================================
; Public data
;===================================================================================================================================================
;;Sprites
.globl _sprite_player01
.globl _sprite_player02


;===================================================================================================================================================
; Manager data
;===================================================================================================================================================
_man_anim_player:
    .db #0x0A
    .dw #_sprite_player01
    .db #0x0A
    .dw #_sprite_player02
    .db #0x00
    .dw #_man_anim_player

;===================================================================================================================================================
; FUNCION _sys_animator_update   
; Llama a la inversión de control para updatear las animaciones de cada entidad que coincida con e_type_animator
; NO llega ningun dato
;===================================================================================================================================================
_sys_animator_update::
    ld hl, #_sys_animator_updateOneEntity
    ld (_m_functionMemory), hl
    ld hl , #_m_matchedEntity 
    ld (hl), #0x10  ; e_type_animator
    call _man_entityForAllMatching
    ret



;===================================================================================================================================================
; FUNCION _sys_animator_updateOneEntity   
; Si toca cambiar el sprite de la animacion establece el siguiente sprite como el nuevo y,
; pone tambien el counter de la animacion con la duración del nuevo sprite.
; En caso de que no haya sprite y sea la dirección de memoria de la animacion, 
; resetea la animación y establece los datos como el paso descrito antes.
; HL : Entidad a updatear
;===================================================================================================================================================
_sys_animator_updateOneEntity::    

    ld a,#0x0D
    searchCounter:
        inc hl
        dec a
        jr NZ, searchCounter
    
    dec (hl)
    ret NZ

    ;; TODO : Aqui me falta asignar en la entidad la siguiente anim 

    dec hl
    ld d,(hl)
    dec hl
    ld e,(hl)

    inc de
    inc de
    inc de

    ld (hl), e
    inc hl
    ld (hl), d
    dec hl

    ex de,hl 
    ;HL tiene la direccion de la anim
    ;Aqui HL llega apuntando al tiempo de la animacion en memoria 
    ;DE tiene la primera posicion de la animacion de la memoria de entity
    push de
    dec (hl)
    inc (hl)
    jr NZ, noRepeatAnim

    ; Aqui HL llega apuntando al tiempo de la nueva anim
    ; AQui hay q hacer una cosas setear la animacion (direccion del sprite de inicio)
    push de
    inc hl
    ld e, (hl)
    inc hl
    ld d, (hl)
    pop hl
    ld (hl),e
    inc hl
    ld (hl),d
    ;;AQui ya está en la Entity asignado el inicio de la anim

    noRepeatAnim:
    pop hl   ;;Aqui en HL está el inicio de la animacion en la memoria de la entity
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ex de,hl ;;Aqui en HL está la direcion de memoria del tiempo nuevo en la anim
             ;;y en DE queda el counter del tiempo de la entity

    ; Aqui HL llega apuntando al tiempo de la nueva anim
    ld a, (hl) ; a = newTIME
    inc hl
    ex de, hl
    ld (hl),a
    ;;Seteado el tiempo en la entity
    dec hl
    dec hl
    dec hl
    dec hl
    dec hl
    ex de, hl ; Tengo en HL el inicio del nuevo sprite en la anim
    ld c,(hl)
    inc hl
    ld b,(hl)
    ex de, hl ;Tengo en BC el nuevo sprite, y en HL el segundo Byte del sprite de la entity
    ld (hl), b
    dec hl
    ld (hl),c
    
   ret