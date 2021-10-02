.globl _man_entityForAll
.globl _m_functionMemory
.globl cpct_getScreenPtr_asm
.globl cpct_setVideoMode_asm
.globl cpct_setPALColour_asm
.globl cpct_disableFirmware_asm



;;
;; Metodo que inicializa el render con cpc_telera
;;
_sys_init_render::
   call	cpct_disableFirmware_asm
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

;;
;; Llama a la inversión de control para renderizar cada entidad
;;
_sys_render_update::
    ld hl, #_sys_render_renderOneEntity
    ld (_m_functionMemory), hl
    call _man_entityForAll
    ret



;;
;; Renderiza cada entity en su nueva posición y borra el frame anterior
;;
_sys_render_renderOneEntity:: ;;TODO : Cambiar el render con los prevptr
    ;Buscamos en la entidad su antigua posición en la mem. de video
    ;para borrarla
    ld a, #0x05
    searchPrevPTR:
        inc hl
        dec a
        jr NZ, searchPrevPTR

    dec (hl)
    inc (hl)
    jr Z,noDelete
    
    ld c, (hl)
    inc hl
    ld b, (hl)
    dec hl
    push hl

    ld h, b
    ld l, c
    
    ld (hl), #0x00
    pop hl
    noDelete:

    ;Comprobamos con el tipo de la entidad si tenemos que renderizarla o no
    ld a, #0x05
    searchType:
        dec hl
        dec a
        jr NZ, searchType

    ld a, (hl)
    and #0x80
    jr NZ, noRender


    push hl
    ld de, #0xC000
    inc hl
    ld c,(hl)
    inc hl
    ld b,(hl)
    call cpct_getScreenPtr_asm
    ld (hl), #0x88
    ld e, l
    ld d, h
    pop hl

    ;En caso de renderizar se guarda en la entidad la nueva posicion de video
    ;para borrarla en la siguiente iteracion
    ld a, #0x05
    searchPrevPTR2:
        inc hl
        dec a
        jr NZ, searchPrevPTR2
    
    ld (hl), e
    inc hl
    ld (hl),d

    ld a, #0x06
    backToStartOfTheStar:
        dec hl
        dec a
        jr NZ, backToStartOfTheStar

    noRender:

    ret
