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
   4419                      26 _sys_init_render::
                             27    ;;Destroyed : HL 
   4419 0E 00         [ 7]   28    ld    c,#0x00
   441B CD 93 45      [17]   29    call  cpct_setVideoMode_asm
                             30    ;;Destroyed : AF & BC & HL 
   441E 21 10 14      [10]   31    ld hl , #0x1410
   4421 CD DB 44      [17]   32    call  cpct_setPALColour_asm
                             33    ;;Destroyed : F & BC & HL  
                             34 
   4424 21 00 14      [10]   35    ld hl , #0x1400
   4427 CD DB 44      [17]   36    call  cpct_setPALColour_asm
                             37    ;;Destroyed : F & BC & HL  
   442A C9            [10]   38    ret
                             39 
                             40 ;===================================================================================================================================================
                             41 ; FUNCION _sys_render_update
                             42 ; Llama a la inversi??n de control para renderizar los sprites de cada entidad que coincida con e_type_render
                             43 ; NO llega ningun dato
                             44 ;===================================================================================================================================================
   442B                      45 _sys_render_update::
   442B 21 3A 44      [10]   46     ld hl, #_sys_render_renderOneEntity
   442E 22 70 41      [16]   47     ld (_m_functionMemory), hl
   4431 21 72 41      [10]   48     ld hl , #_m_matchedEntity 
   4434 36 01         [10]   49     ld (hl), #0x01   ; e_type_render
   4436 CD A2 41      [17]   50     call _man_entityForAllMatching
   4439 C9            [10]   51     ret
                             52 
                             53 
                             54 ;===================================================================================================================================================
                             55 ; FUNCION _sys_render_renderOneEntity
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                             56 ; Renderiza los sprites de las entidades renderizables
                             57 ; HL : Entidad a renderizar
                             58 ;===================================================================================================================================================
   443A                      59 _sys_render_renderOneEntity:: ;;TODO : Ver de hacer esto con el reg IX
                             60     ;; Si es una entidad marcada para destruir no se renderiza
   443A 7E            [ 7]   61     ld a, (hl)
   443B E6 80         [ 7]   62     and #0x80    
   443D 20 25         [12]   63     jr NZ, noRender
                             64 
                             65     ;; Conseguimos la direccion de memoria donde dibujar con las pos de la entity
   443F E5            [11]   66     push hl
   4440 E5            [11]   67     push hl
   4441 11 00 C0      [10]   68     ld de, #0xC000
   4444 23            [ 6]   69     inc hl
   4445 23            [ 6]   70     inc hl
   4446 4E            [ 7]   71     ld c,(hl)
   4447 23            [ 6]   72     inc hl
   4448 46            [ 7]   73     ld b,(hl)
   4449 CD C4 45      [17]   74     call cpct_getScreenPtr_asm
                             75     
                             76     ;; Con la direccion de memoria dibujamos el sprite de la entidad 
   444C 5D            [ 4]   77     ld e, l
   444D 54            [ 4]   78     ld d, h
   444E E1            [10]   79     pop hl
   444F 23            [ 6]   80     inc hl
   4450 23            [ 6]   81     inc hl
   4451 23            [ 6]   82     inc hl
   4452 23            [ 6]   83     inc hl
   4453 4E            [ 7]   84     ld c,(hl) ;Cargamos el width
   4454 23            [ 6]   85     inc hl
   4455 46            [ 7]   86     ld b,(hl) ;Cargamos el height
   4456 23            [ 6]   87     inc hl
   4457 23            [ 6]   88     inc hl
   4458 23            [ 6]   89     inc hl
   4459 7E            [ 7]   90     ld a,(hl)
   445A F5            [11]   91     push af
   445B 23            [ 6]   92     inc hl
   445C 7E            [ 7]   93     ld a,(hl)
   445D 67            [ 4]   94     ld h,a
   445E F1            [10]   95     pop af
   445F 6F            [ 4]   96     ld l,a
                             97 
   4460 CD E5 44      [17]   98     call cpct_drawSprite_asm
   4463 E1            [10]   99     pop hl
   4464                     100     noRender:
                            101 
   4464 C9            [10]  102     ret
