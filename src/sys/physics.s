;===================================================================================================================================================
; CPCTelera functions
;===================================================================================================================================================
.globl cpct_scanKeyboard_f_asm
.globl cpct_isKeyPressed_asm

;===================================================================================================================================================
; Public functions
;===================================================================================================================================================
.globl _man_entityForAllMatching
.globl _man_entityDestroy
.globl _man_setEntity4Destroy
.globl _m_game_playerShot

;===================================================================================================================================================
; Public data
;===================================================================================================================================================
.globl _m_functionMemory
.globl _m_matchedEntity

;===================================================================================================================================================
; FUNCION _sys_physics_update
; Llama a la inversión de control para updatear las fisicas de cada entidad que coincida con e_type_movable
; NO llega ningun dato
;===================================================================================================================================================
_sys_physics_update::
    ld hl, #_sys_physics_updateOneEntity
    ld (_m_functionMemory), hl
    ld hl , #_m_matchedEntity 
    ld (hl), #0x02  ; e_type_movable
    call _man_entityForAllMatching
    ret


;===================================================================================================================================================
; FUNCION _sys_physics_checkKeyboard
; Cambia el valor de la velocidad en x si se pulsa la tecla : O o P
; Y manda la orden de disparar si pulsa Espacio
; HL : LA entidad a updatear
;===================================================================================================================================================
_sys_physics_checkKeyboard::
    inc hl
    inc hl
    inc hl
    inc hl
    inc hl
    inc hl
    push hl

    call cpct_scanKeyboard_f_asm
    
    ld hl, #0x0404  ;;Key O
    call cpct_isKeyPressed_asm
    jr NZ, leftPressed

    ld hl, #0x0803 ;;Key P
    call cpct_isKeyPressed_asm
    jr NZ, rightPressed

    pop hl
    ld (hl), #0x00

    jp stopCheckMovement
    leftPressed:
        pop hl
        ld (hl), #0xFF
        jp stopCheckMovement
    rightPressed:
        pop hl
        ld (hl), #0x01

    stopCheckMovement:

    ld hl, #0x8005 ;;Key SpaceBar
    call cpct_isKeyPressed_asm
    jr Z, dontShoot
    call _m_game_playerShot

    dontShoot:
    ret





;===================================================================================================================================================
; FUNCION _sys_physics_updateOneEntity
; Updatea las posiciones de las entidades en funcion de 
; los valores de sus velocidades
; HL : Entidad a updatear
;===================================================================================================================================================
_sys_physics_updateOneEntity::    
    push hl
    inc hl
    ld a,(hl) 
    dec hl
    and #0x04
    ld b,h
    ld c,l
    jr Z,noInput
    call _sys_physics_checkKeyboard
    noInput:
    pop hl

    inc hl
    inc hl
    ld  b,(hl) ; posX
    inc hl
    ld  d,(hl) ; posY 

    inc hl
    inc hl
    inc hl
    ld c,(hl) ; velX
    inc hl
    ld e,(hl) ; vely

    ld a, #0x05
    setHLposX:
        dec hl
        dec a
        jr NZ, setHLposX

    ld a,b
    add a,c
    ld (hl),a

    inc hl
    
    ld a,d
    add a,e
    ld (hl),a
    
   ret