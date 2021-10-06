ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 ;===================================================================================================================================================
                              2 ; CPCTelera functions
                              3 ;===================================================================================================================================================
                              4 .globl cpct_getScreenPtr_asm
                              5 .globl cpct_setVideoMode_asm
                              6 .globl cpct_setPALColour_asm
                              7 .globl cpct_drawSprite_asm
                              8 
                              9 ;===================================================================================================================================================
                             10 ; Public functions
                             11 ;===================================================================================================================================================
                             12 .globl _man_entityForAllMatching
                             13 
                             14 ;===================================================================================================================================================
                             15 ; Public data
                             16 ;===================================================================================================================================================
                             17 .globl _m_functionMemory
                             18 .globl _m_matchedEntity
                             19 
                             20 
                             21 ;===================================================================================================================================================
                             22 ; FUNCION _sys_init_render
                             23 ; Se encarga de iniciar el color y el modo de video de Amstrad(?)
                             24 ; NO llega ningun dato
                             25 ;===================================================================================================================================================
   436E                      26 _sys_init_render::
                             27    ;;Destroyed : HL 
   436E 0E 00         [ 7]   28    ld    c,#0x00
   4370 CD E6 44      [17]   29    call  cpct_setVideoMode_asm
                             30    ;;Destroyed : AF & BC & HL 
   4373 21 10 14      [10]   31    ld hl , #0x1410
   4376 CD 2E 44      [17]   32    call  cpct_setPALColour_asm
                             33    ;;Destroyed : F & BC & HL  
                             34 
   4379 21 00 14      [10]   35    ld hl , #0x1400
   437C CD 2E 44      [17]   36    call  cpct_setPALColour_asm
                             37    ;;Destroyed : F & BC & HL  
   437F C9            [10]   38    ret
                             39 
                             40 ;===================================================================================================================================================
                             41 ; FUNCION _sys_render_update
                             42 ; Llama a la inversión de control para renderizar los sprites de cada entidad que coincida con e_type_render
                             43 ; NO llega ningun dato
                             44 ;===================================================================================================================================================
   4380                      45 _sys_render_update::
   4380 21 8F 43      [10]   46     ld hl, #_sys_render_renderOneEntity
   4383 22 FC 40      [16]   47     ld (_m_functionMemory), hl
   4386 21 FE 40      [10]   48     ld hl , #_m_matchedEntity 
   4389 36 01         [10]   49     ld (hl), #0x01   ; e_type_render
   438B CD 32 41      [17]   50     call _man_entityForAllMatching
   438E C9            [10]   51     ret
                             52 
                             53 
                             54 ;===================================================================================================================================================
                             55 ; FUNCION _sys_render_renderOneEntity
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                             56 ; Renderiza los sprites de las entidades renderizables
                             57 ; HL : Entidad a renderizar
                             58 ;===================================================================================================================================================
   438F                      59 _sys_render_renderOneEntity:: ;;TODO : Ver de hacer esto con el reg IX
                             60     ;; Si es una entidad marcada para destruir no se renderiza
   438F 7E            [ 7]   61     ld a, (hl)
   4390 E6 80         [ 7]   62     and #0x80    
   4392 20 23         [12]   63     jr NZ, noRender
                             64 
                             65     ;; Conseguimos la direccion de memoria donde dibujar con las pos de la entity
   4394 E5            [11]   66     push hl
   4395 E5            [11]   67     push hl
   4396 11 00 C0      [10]   68     ld de, #0xC000
   4399 23            [ 6]   69     inc hl
   439A 4E            [ 7]   70     ld c,(hl)
   439B 23            [ 6]   71     inc hl
   439C 46            [ 7]   72     ld b,(hl)
   439D CD 17 45      [17]   73     call cpct_getScreenPtr_asm
                             74     
                             75     ;; Con la direccion de memoria dibujamos el sprite de la entidad 
   43A0 5D            [ 4]   76     ld e, l
   43A1 54            [ 4]   77     ld d, h
   43A2 E1            [10]   78     pop hl
   43A3 23            [ 6]   79     inc hl
   43A4 23            [ 6]   80     inc hl
   43A5 23            [ 6]   81     inc hl
   43A6 4E            [ 7]   82     ld c,(hl)
   43A7 23            [ 6]   83     inc hl
   43A8 46            [ 7]   84     ld b,(hl)
   43A9 23            [ 6]   85     inc hl
   43AA 23            [ 6]   86     inc hl
   43AB 23            [ 6]   87     inc hl
   43AC 7E            [ 7]   88     ld a,(hl)
   43AD F5            [11]   89     push af
   43AE 23            [ 6]   90     inc hl
   43AF 7E            [ 7]   91     ld a,(hl)
   43B0 67            [ 4]   92     ld h,a
   43B1 F1            [10]   93     pop af
   43B2 6F            [ 4]   94     ld l,a
                             95 
   43B3 CD 38 44      [17]   96     call cpct_drawSprite_asm
   43B6 E1            [10]   97     pop hl
   43B7                      98     noRender:
                             99 
   43B7 C9            [10]  100     ret
