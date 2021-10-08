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
                             13 .globl _m_game_playerShot
                             14 
                             15 ;===================================================================================================================================================
                             16 ; Public data
                             17 ;===================================================================================================================================================
                             18 .globl _m_functionMemory
                             19 .globl _m_matchedEntity
                             20 
                             21 ;===================================================================================================================================================
                             22 ; FUNCION _sys_physics_update
                             23 ; Llama a la inversión de control para updatear las fisicas de cada entidad que coincida con e_type_movable
                             24 ; NO llega ningun dato
                             25 ;===================================================================================================================================================
   43AE                      26 _sys_physics_update::
   43AE 21 F2 43      [10]   27     ld hl, #_sys_physics_updateOneEntity
   43B1 22 70 41      [16]   28     ld (_m_functionMemory), hl
   43B4 21 72 41      [10]   29     ld hl , #_m_matchedEntity 
   43B7 36 02         [10]   30     ld (hl), #0x02  ; e_type_movable
   43B9 CD A2 41      [17]   31     call _man_entityForAllMatching
   43BC C9            [10]   32     ret
                             33 
                             34 
                             35 ;===================================================================================================================================================
                             36 ; FUNCION _sys_physics_checkKeyboard
                             37 ; Cambia el valor de la velocidad en x si se pulsa la tecla : O o P
                             38 ; Y manda la orden de disparar si pulsa Espacio
                             39 ; HL : LA entidad a updatear
                             40 ;===================================================================================================================================================
   43BD                      41 _sys_physics_checkKeyboard::
   43BD 23            [ 6]   42     inc hl
   43BE 23            [ 6]   43     inc hl
   43BF 23            [ 6]   44     inc hl
   43C0 23            [ 6]   45     inc hl
   43C1 23            [ 6]   46     inc hl
   43C2 23            [ 6]   47     inc hl
   43C3 E5            [11]   48     push hl
                             49 
   43C4 CD 65 44      [17]   50     call cpct_scanKeyboard_f_asm
                             51     
   43C7 21 04 04      [10]   52     ld hl, #0x0404  ;;Key O
   43CA CD CF 44      [17]   53     call cpct_isKeyPressed_asm
   43CD 20 0E         [12]   54     jr NZ, leftPressed
                             55 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



   43CF 21 03 08      [10]   56     ld hl, #0x0803 ;;Key P
   43D2 CD CF 44      [17]   57     call cpct_isKeyPressed_asm
   43D5 20 0C         [12]   58     jr NZ, rightPressed
                             59 
   43D7 E1            [10]   60     pop hl
   43D8 36 00         [10]   61     ld (hl), #0x00
                             62 
   43DA C3 E6 43      [10]   63     jp stopCheckMovement
   43DD                      64     leftPressed:
   43DD E1            [10]   65         pop hl
   43DE 36 FF         [10]   66         ld (hl), #0xFF
   43E0 C3 E6 43      [10]   67         jp stopCheckMovement
   43E3                      68     rightPressed:
   43E3 E1            [10]   69         pop hl
   43E4 36 01         [10]   70         ld (hl), #0x01
                             71 
   43E6                      72     stopCheckMovement:
                             73 
   43E6 21 05 80      [10]   74     ld hl, #0x8005 ;;Key SpaceBar
   43E9 CD CF 44      [17]   75     call cpct_isKeyPressed_asm
   43EC 28 03         [12]   76     jr Z, dontShoot
   43EE CD A9 42      [17]   77     call _m_game_playerShot
                             78 
   43F1                      79     dontShoot:
   43F1 C9            [10]   80     ret
                             81 
                             82 
                             83 
                             84 
                             85 
                             86 ;===================================================================================================================================================
                             87 ; FUNCION _sys_physics_updateOneEntity
                             88 ; Updatea las posiciones de las entidades en funcion de 
                             89 ; los valores de sus velocidades
                             90 ; HL : Entidad a updatear
                             91 ;===================================================================================================================================================
   43F2                      92 _sys_physics_updateOneEntity::    
   43F2 E5            [11]   93     push hl
   43F3 23            [ 6]   94     inc hl
   43F4 7E            [ 7]   95     ld a,(hl) 
   43F5 2B            [ 6]   96     dec hl
   43F6 E6 04         [ 7]   97     and #0x04
   43F8 44            [ 4]   98     ld b,h
   43F9 4D            [ 4]   99     ld c,l
   43FA 28 03         [12]  100     jr Z,noInput
   43FC CD BD 43      [17]  101     call _sys_physics_checkKeyboard
   43FF                     102     noInput:
   43FF E1            [10]  103     pop hl
                            104 
   4400 23            [ 6]  105     inc hl
   4401 23            [ 6]  106     inc hl
   4402 46            [ 7]  107     ld  b,(hl) ; posX
   4403 23            [ 6]  108     inc hl
   4404 56            [ 7]  109     ld  d,(hl) ; posY 
                            110 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



   4405 23            [ 6]  111     inc hl
   4406 23            [ 6]  112     inc hl
   4407 23            [ 6]  113     inc hl
   4408 4E            [ 7]  114     ld c,(hl) ; velX
   4409 23            [ 6]  115     inc hl
   440A 5E            [ 7]  116     ld e,(hl) ; vely
                            117 
   440B 3E 05         [ 7]  118     ld a, #0x05
   440D                     119     setHLposX:
   440D 2B            [ 6]  120         dec hl
   440E 3D            [ 4]  121         dec a
   440F 20 FC         [12]  122         jr NZ, setHLposX
                            123 
   4411 78            [ 4]  124     ld a,b
   4412 81            [ 4]  125     add a,c
   4413 77            [ 7]  126     ld (hl),a
                            127 
   4414 23            [ 6]  128     inc hl
                            129     
   4415 7A            [ 4]  130     ld a,d
   4416 83            [ 4]  131     add a,e
   4417 77            [ 7]  132     ld (hl),a
                            133     
   4418 C9            [10]  134    ret
