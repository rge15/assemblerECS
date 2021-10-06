ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 
                              2 
                              3 
                              4 ;===================================================================================================================================================
                              5 ; CPCTelera functions
                              6 ;===================================================================================================================================================
                              7 
                              8 .globl cpct_waitHalts_asm
                              9 .globl cpct_waitVSYNC_asm
                             10 .globl cpct_memcpy_asm
                             11 
                             12 
                             13 ;===================================================================================================================================================
                             14 ; Public functions
                             15 ;===================================================================================================================================================
                             16 .globl _man_entityInit
                             17 .globl _man_createEntity
                             18 .globl _man_entityUpdate
                             19 .globl _sys_physics_update
                             20 .globl _sys_render_update
                             21 .globl _sys_animator_update
                             22 .globl _sys_init_render
                             23 .globl _sys_ai_update
                             24 .globl _sys_ai_behaviourLeftRight
                             25 .globl _sys_ai_behaviourMothership
                             26 
                             27 
                             28 ;===================================================================================================================================================
                             29 ; Public data
                             30 ;===================================================================================================================================================
                             31 ;;Animations
                             32 .globl _man_anim_player
                             33 ;;Sprites
                             34 .globl _sprite_player01
                             35 .globl _sprite_player02
                             36 .globl _sprite_mothership
                             37 .globl _sprite_enemy
                             38   
                             39 
                             40 ;===================================================================================================================================================
                             41 ; Templates
                             42 ;===================================================================================================================================================
   41BE                      43 _mothership_template_e:
   41BE 0B                   44    .db #0x0B   ; type
   41BF 26                   45    .db #0x26   ; x
   41C0 0A                   46    .db #0x0A   ; y
   41C1 04                   47    .db #0x04   ; width
   41C2 06                   48    .db #0x06   ; heigth
   41C3 FF                   49    .db #0xFF   ; vx
   41C4 00                   50    .db #0x00   ; vy
   41C5 69 40                51    .dw #_sprite_mothership ; sprite
   41C7 94 42                52    .dw #_sys_ai_behaviourMothership ;ai_behaviour
   41C9 00 00                53    .dw #0x0000 ;animator
   41CB 00                   54    .db #0x00   ;anim. counter
                             55 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



   41CC                      56 _enemy_template_e:
   41CC 0B                   57    .db #0x0B   ; type
   41CD 26                   58    .db #0x26   ; x
   41CE 1E                   59    .db #0x1E   ; y
   41CF 06                   60    .db #0x06   ; width
   41D0 06                   61    .db #0x06   ; heigth
   41D1 01                   62    .db #0x01   ; vx
   41D2 00                   63    .db #0x00   ; vy
   41D3 81 40                64    .dw #_sprite_enemy ; sprite
   41D5 A2 42                65    .dw #_sys_ai_behaviourLeftRight ;ai_behaviour
   41D7 00 00                66    .dw #0x0000 ;animator
   41D9 00                   67    .db #0x00   ;anim. counter
                             68 
                             69 
   41DA                      70 _playerLife_template_e:
   41DA 01                   71    .db #0x01   ; type
   41DB 00                   72    .db #0x00   ; x
   41DC C0                   73    .db #0xC0   ; y
   41DD 06                   74    .db #0x06   ; width
   41DE 08                   75    .db #0x08   ; heigth
   41DF 00                   76    .db #0x00   ; vx
   41E0 00                   77    .db #0x00   ; vy
   41E1 09 40                78    .dw #_sprite_player01 ; sprite
   41E3 00 00                79    .dw #0x0000 ;ai_behaviour
   41E5 00 00                80    .dw #0x0000 ;animator
   41E7 00                   81    .db #0x00   ;anim. counter
                             82 
   41E8                      83 _player_template_e:
   41E8 17                   84    .db #0x17   ; type
   41E9 26                   85    .db #0x26   ; x
   41EA B0                   86    .db #0xB0   ; y
   41EB 06                   87    .db #0x06   ; width
   41EC 08                   88    .db #0x08   ; heigth
   41ED 00                   89    .db #0x00   ; vx
   41EE 00                   90    .db #0x00   ; vy
   41EF 09 40                91    .dw #_sprite_player01 ; sprite
   41F1 00 00                92    .dw #0x0000 ;ai_behaviour
   41F3 C0 42                93    .dw #_man_anim_player ;animator
   41F5 10                   94    .db #0x10   ;anim. counter
                             95 
                             96 
                             97 
                             98 ;===================================================================================================================================================
                             99 ; Manager data
                            100 ;===================================================================================================================================================
   41F6                     101 _enemyOnLane:
   41F6 00                  102    .db #0x00
                            103 
                            104 ;===================================================================================================================================================
                            105 ; FUNCION _m_game_createInitTemplate   
                            106 ; Crea la entidad con el template indicado
                            107 ; BC : Valor de template a crear
                            108 ;===================================================================================================================================================
   41F7                     109 _m_game_createInitTemplate::
   41F7 CD 1D 41      [17]  110    call _man_createEntity
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



   41FA E5            [11]  111    push hl
   41FB EB            [ 4]  112    ex de,hl
   41FC 60            [ 4]  113    ld h, b
   41FD 69            [ 4]  114    ld l, c
   41FE 01 0E 00      [10]  115    ld bc,#0x000E
   4201 CD 03 45      [17]  116    call cpct_memcpy_asm
   4204 E1            [10]  117    pop hl
   4205 C9            [10]  118    ret
                            119 
                            120 
                            121 ;===================================================================================================================================================
                            122 ; FUNCION _m_game_init   
                            123 ; Inicializa el juego y sus entidades
                            124 ; NO llega ningun dato
                            125 ;===================================================================================================================================================
   4206                     126 _m_game_init::
   4206 CD 6E 43      [17]  127    call  _sys_init_render
   4209 CD 05 41      [17]  128    call  _man_entityInit
                            129 
                            130 
                            131    ; Create MotherBoard
   420C 01 BE 41      [10]  132    ld bc, #_mothership_template_e   
   420F CD F7 41      [17]  133    call _m_game_createInitTemplate
                            134 
                            135    ; Create Lifes
   4212 3E 0F         [ 7]  136    ld a,#0x0F
   4214                     137    createLife:
   4214 F5            [11]  138    push af
   4215 01 DA 41      [10]  139    ld bc, #_playerLife_template_e
   4218 CD F7 41      [17]  140    call _m_game_createInitTemplate
   421B 23            [ 6]  141    inc hl
   421C F1            [10]  142    pop af
   421D 77            [ 7]  143    ld (hl), a
                            144 
   421E D6 05         [ 7]  145    sub #0x05
   4220 20 F2         [12]  146    jr NZ, createLife
                            147 
                            148    ; CreatePlayer
   4222 01 E8 41      [10]  149    ld bc, #_player_template_e
   4225 CD F7 41      [17]  150    call _m_game_createInitTemplate
   4228 C9            [10]  151 ret
                            152 
                            153 
                            154 ;===================================================================================================================================================
                            155 ; FUNCION _m_game_play   
                            156 ; Bucle del juego
                            157 ; NO llega ningun dato
                            158 ;===================================================================================================================================================
   4229                     159 _m_game_play::
   4229                     160    updates:
   4229 CD 5C 42      [17]  161       call _sys_ai_update
   422C CD 12 43      [17]  162       call _sys_physics_update
   422F CD C9 42      [17]  163       call _sys_animator_update
   4232 CD 80 43      [17]  164       call _sys_render_update
                            165       
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



   4235 CD 9C 41      [17]  166       call _man_entityUpdate
   4238 CD 4C 42      [17]  167       call _wait
   423B 18 EC         [12]  168    jr updates
                            169 
   423D C9            [10]  170 ret
                            171 
                            172 ;===================================================================================================================================================
                            173 ; FUNCION _m_game_createEnemy   
                            174 ; Crea un enemigo
                            175 ; NO llega ningun dato
                            176 ;===================================================================================================================================================
   423E                     177 _m_game_createEnemy::
   423E 21 F6 41      [10]  178    ld hl, #_enemyOnLane
   4241 35            [11]  179    dec (hl)
   4242 34            [11]  180    inc (hl)
   4243 C0            [11]  181    ret NZ
   4244 34            [11]  182    inc (hl)
                            183 
                            184    ; Create Enemy
   4245 01 CC 41      [10]  185    ld bc, #_enemy_template_e   
   4248 CD F7 41      [17]  186    call _m_game_createInitTemplate   
                            187    
   424B C9            [10]  188    ret
                            189 
                            190 ;===================================================================================================================================================
                            191 ; FUNCION _wait   
                            192 ; Espera un tiempo antes de realizar otra iteracion del bucle de juego
                            193 ; NO llega ningun dato
                            194 ;===================================================================================================================================================
                            195 
   424C                     196 _wait::
   424C 26 05         [ 7]  197    ld h, #0x05
   424E                     198       waitLoop:
   424E 06 02         [ 7]  199          ld b, #0x02
   4250 CD E2 44      [17]  200          call cpct_waitHalts_asm
   4253 CD F3 44      [17]  201          call cpct_waitVSYNC_asm
   4256 25            [ 4]  202          dec h
   4257 20 F5         [12]  203          jr NZ, waitLoop
   4259 C9            [10]  204    ret
