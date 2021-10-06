;===================================================================================================================================================
; CPCTelera functions
;===================================================================================================================================================
.globl cpct_scanKeyboard_f_asm
.globl cpct_isKeyPressed_asm

;===================================================================================================================================================
; Public functions
;===================================================================================================================================================
.globl _man_entityForAllMatching
.globl _m_game_createEnemy

.globl _m_functionMemory
.globl _m_matchedEntity


;===================================================================================================================================================
; Manager data
;===================================================================================================================================================
_sys_ai_behaviourMemory::
    .ds 2

;===================================================================================================================================================
; FUNCION _sys_ai_update
; Llama a la inversión de control para updatear el comportamiento de 
; las entidades que coincida con e_type_movable
; NO llega ningun dato
;===================================================================================================================================================
_sys_ai_update::
    ld hl, #_sys_ai_updateOneEntity
    ld (_m_functionMemory), hl
    ld hl , #_m_matchedEntity 
    ld (hl), #0x0A ;;  e_type_movable | e_type_ai
    call _man_entityForAllMatching
    ret

;===================================================================================================================================================
; FUNCION _sys_ai_updateOneEntity
; Busca el comportamiento de la entidad y lo ejecuta 
; HL : LA entidad a updatear
;===================================================================================================================================================
_sys_ai_updateOneEntity::    
    ; ex de, hl
    ld a,#0x09
    searchBehaviour:
        inc hl
        dec a
        jr NZ, searchBehaviour
    
    ld ix, #updatedOneEntity
    push ix

    ;ex de, hl
    push hl
    ld a, (hl)
    ld hl, #_sys_ai_behaviourMemory
    ld (hl),a
    pop hl
    push hl
    inc hl
    ld a, (hl)
    ld hl, #_sys_ai_behaviourMemory
    inc hl
    ld (hl),a
    pop hl

    ld a,#0x09
    searchType:
        dec hl
        dec a
        jr NZ, searchType

    ld ix, (#_sys_ai_behaviourMemory)
    jp (ix)

    updatedOneEntity:
    
    ret


;===================================================================================================================================================
; FUNCION _sys_ai_behaviourMothership
; Comportamiento de la MotherShip
; 1º Intenta crear un enemigo hijo
; 2º Se mueve de derecha a izquierda hasta los bordes
; HL : Entidad a updatear
;===================================================================================================================================================
_sys_ai_behaviourMothership::

    ;;Si esta en x=20(decimal) intenta crear un enemigo
    inc hl
    ld a,(hl)
    dec hl
    sub #0x14
    jr NZ,notCreateEnemy

    call _m_game_createEnemy
    notCreateEnemy: 
    call _sys_ai_behaviourLeftRight

    ret


;===================================================================================================================================================
; FUNCION _sys_ai_behaviourLeftRight
; Si llega a alguno de los bordes establece su velocidad en la direccion contraria
; HL : Entidad a updatear
;===================================================================================================================================================
_sys_ai_behaviourLeftRight::
    ld a, #0x50
    inc hl
    ld b,(hl) ;; b = x
    inc hl
    inc hl
    sub (hl)  ;; a = right bound
    inc hl
    inc hl 
    inc b
    dec b
    jr Z, leftPart

    ld c,a
    ld a,b
    ld b,c

    sub b
    jr Z, rightPart

    jp exitUpdate
    leftPart:
        ld (hl), #0x01
        jp exitUpdate

    rightPart:
        ld (hl), #0xFF

    exitUpdate:
    ret
