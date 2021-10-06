;===================================================================================================================================================
; CPCTelera functions
;===================================================================================================================================================
.globl cpct_getScreenPtr_asm
.globl cpct_setVideoMode_asm
.globl cpct_setPALColour_asm
.globl cpct_drawSprite_asm

;===================================================================================================================================================
; Public functions
;===================================================================================================================================================
.globl _man_entityForAllMatching

;===================================================================================================================================================
; Public data
;===================================================================================================================================================
.globl _m_functionMemory
.globl _m_matchedEntity


;===================================================================================================================================================
; FUNCION _sys_init_render
; Se encarga de iniciar el color y el modo de video de Amstrad(?)
; NO llega ningun dato
;===================================================================================================================================================
_sys_init_render::
   ;;Destroyed : HL 
   ld    c,#0x00
   call  cpct_setVideoMode_asm
   ;;Destroyed : AF & BC & HL 
   ld hl , #0x1410
   call  cpct_setPALColour_asm
   ;;Destroyed : F & BC & HL  

   ld hl , #0x1400
   call  cpct_setPALColour_asm
   ;;Destroyed : F & BC & HL  
   ret

;===================================================================================================================================================
; FUNCION _sys_render_update
; Llama a la inversión de control para renderizar los sprites de cada entidad que coincida con e_type_render
; NO llega ningun dato
;===================================================================================================================================================
_sys_render_update::
    ld hl, #_sys_render_renderOneEntity
    ld (_m_functionMemory), hl
    ld hl , #_m_matchedEntity 
    ld (hl), #0x01   ; e_type_render
    call _man_entityForAllMatching
    ret


;===================================================================================================================================================
; FUNCION _sys_render_renderOneEntity
; Renderiza los sprites de las entidades renderizables
; HL : Entidad a renderizar
;===================================================================================================================================================
_sys_render_renderOneEntity:: ;;TODO : Ver de hacer esto con el reg IX
    ;; Si es una entidad marcada para destruir no se renderiza
    ld a, (hl)
    and #0x80    
    jr NZ, noRender

    ;; Conseguimos la direccion de memoria donde dibujar con las pos de la entity
    push hl
    push hl
    ld de, #0xC000
    inc hl
    ld c,(hl)
    inc hl
    ld b,(hl)
    call cpct_getScreenPtr_asm
    
    ;; Con la direccion de memoria dibujamos el sprite de la entidad 
    ld e, l
    ld d, h
    pop hl
    inc hl
    inc hl
    inc hl
    ld c,(hl)
    inc hl
    ld b,(hl)
    inc hl
    inc hl
    inc hl
    ld a,(hl)
    push af
    inc hl
    ld a,(hl)
    ld h,a
    pop af
    ld l,a

    call cpct_drawSprite_asm
    pop hl
    noRender:

    ret
