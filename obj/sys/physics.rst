ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 ;===================================================================================================================================================
                              2 ; CPCTelera functions
                              3 ;===================================================================================================================================================
                              4 .globl cpct_scanKeyboard_f_asm
                              5 .globl cpct_isKeyPressed_asm
                              6 
                              7 ;===================================================================================================================================================
                              8 ; Public functions
                              9 ;===================================================================================================================================================
                             10 .globl _man_entityForAllMatching
                             11 .globl _man_entityDestroy
                             12 .globl _man_setEntity4Destroy
                             13 
                             14 ;===================================================================================================================================================
                             15 ; Public data
                             16 ;===================================================================================================================================================
                             17 .globl _m_functionMemory
                             18 .globl _m_matchedEntity
                             19 
                             20 ;===================================================================================================================================================
                             21 ; FUNCION _sys_physics_update
                             22 ; Llama a la inversión de control para updatear las fisicas de cada entidad que coincida con e_type_movable
                             23 ; NO llega ningun dato
                             24 ;===================================================================================================================================================
   4312                      25 _sys_physics_update::
   4312 21 4A 43      [10]   26     ld hl, #_sys_physics_updateOneEntity
   4315 22 FC 40      [16]   27     ld (_m_functionMemory), hl
   4318 21 FE 40      [10]   28     ld hl , #_m_matchedEntity 
   431B 36 02         [10]   29     ld (hl), #0x02  ; e_type_movable
   431D CD 32 41      [17]   30     call _man_entityForAllMatching
   4320 C9            [10]   31     ret
                             32 
                             33 
                             34 ;;
                             35 ;; Hace los calculos de la posicion de las entidades con la velocidad de cada entidad
                             36 ;;
                             37 
                             38 
                             39 ;===================================================================================================================================================
                             40 ; FUNCION _sys_physics_checkKeyboard
                             41 ; Cambia el valor de la velocidad en x si se pulsa la tecla : O o P
                             42 ; HL : LA entidad a updatear
                             43 ;===================================================================================================================================================
   4321                      44 _sys_physics_checkKeyboard::
   4321 23            [ 6]   45     inc hl
   4322 23            [ 6]   46     inc hl
   4323 23            [ 6]   47     inc hl
   4324 23            [ 6]   48     inc hl
   4325 23            [ 6]   49     inc hl
   4326 E5            [11]   50     push hl
                             51 
   4327 CD B8 43      [17]   52     call cpct_scanKeyboard_f_asm
                             53     
   432A 21 04 04      [10]   54     ld hl, #0x0404  ;;Key O
   432D CD 22 44      [17]   55     call cpct_isKeyPressed_asm
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



   4330 20 0E         [12]   56     jr NZ, leftPressed
                             57 
   4332 21 03 08      [10]   58     ld hl, #0x0803 ;;Key P
   4335 CD 22 44      [17]   59     call cpct_isKeyPressed_asm
   4338 20 0C         [12]   60     jr NZ, rightPressed
                             61 
   433A E1            [10]   62     pop hl
   433B 36 00         [10]   63     ld (hl), #0x00
                             64 
   433D C3 49 43      [10]   65     jp stopCheck
   4340                      66     leftPressed:
                             67         
   4340 E1            [10]   68         pop hl
   4341 36 FF         [10]   69         ld (hl), #0xFF
   4343 C3 49 43      [10]   70         jp stopCheck
   4346                      71     rightPressed:
   4346 E1            [10]   72         pop hl
   4347 36 01         [10]   73         ld (hl), #0x01
                             74 
   4349                      75     stopCheck:
   4349 C9            [10]   76     ret
                             77 
                             78 
                             79 
                             80 
                             81 
                             82 ;===================================================================================================================================================
                             83 ; FUNCION _sys_physics_updateOneEntity
                             84 ; Updatea las posiciones de las entidades en funcion de 
                             85 ; los valores de sus velocidades
                             86 ; HL : Entidad a updatear
                             87 ;===================================================================================================================================================
   434A                      88 _sys_physics_updateOneEntity::    
   434A E5            [11]   89     push hl
   434B 7E            [ 7]   90     ld a,(hl)
   434C E6 04         [ 7]   91     and #0x04
   434E 44            [ 4]   92     ld b,h
   434F 4D            [ 4]   93     ld c,l
   4350 28 03         [12]   94     jr Z,noInput
   4352 CD 21 43      [17]   95     call _sys_physics_checkKeyboard
   4355                      96     noInput:
   4355 E1            [10]   97     pop hl
                             98 
   4356 23            [ 6]   99     inc hl
   4357 46            [ 7]  100     ld  b,(hl) ; posX
   4358 23            [ 6]  101     inc hl
   4359 56            [ 7]  102     ld  d,(hl) ; posY 
                            103 
   435A 23            [ 6]  104     inc hl
   435B 23            [ 6]  105     inc hl
   435C 23            [ 6]  106     inc hl
   435D 4E            [ 7]  107     ld c,(hl) ; velX
   435E 23            [ 6]  108     inc hl
   435F 5E            [ 7]  109     ld e,(hl) ; vely
                            110 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



   4360 3E 05         [ 7]  111     ld a, #0x05
   4362                     112     setHLposX:
   4362 2B            [ 6]  113         dec hl
   4363 3D            [ 4]  114         dec a
   4364 20 FC         [12]  115         jr NZ, setHLposX
                            116 
   4366 78            [ 4]  117     ld a,b
   4367 81            [ 4]  118     add a,c
   4368 77            [ 7]  119     ld (hl),a
                            120 
   4369 23            [ 6]  121     inc hl
                            122     
   436A 7A            [ 4]  123     ld a,d
   436B 83            [ 4]  124     add a,e
   436C 77            [ 7]  125     ld (hl),a
                            126     
   436D C9            [10]  127    ret
