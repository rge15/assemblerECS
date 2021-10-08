ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 ;===================================================================================================================================================
                              2 ; CPCTelera functions
                              3 ;===================================================================================================================================================
                              4 .globl cpct_waitHalts_asm
                              5 .globl cpct_waitVSYNC_asm
                              6 .globl cpct_memcpy_asm
                              7 
                              8 ;===================================================================================================================================================
                              9 ; Includes
                             10 ;===================================================================================================================================================
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                             11 .include "resources/macros.s"
                              1 ;;Cargar crear entidades con el template indicado
                              2 .macro CREATE_ENTITY_FROM_TEMPLATE _template
                              3     ld bc, #_template
                              4     call _m_game_createInitTemplate
                              5 .endm
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



                             12 
                             13 ;===================================================================================================================================================
                             14 ; Public functions
                             15 ;===================================================================================================================================================
                             16 .globl _man_entityInit
                             17 .globl _man_entityDestroy
                             18 .globl _man_entityUpdate
                             19 .globl _man_createEntity
                             20 .globl _sys_physics_update
                             21 .globl _sys_init_render
                             22 .globl _sys_render_update
                             23 .globl _sys_animator_update
                             24 .globl _sys_ai_update
                             25 
                             26 
                             27 ;===================================================================================================================================================
                             28 ; Templates
                             29 ;===================================================================================================================================================
                             30 .globl _player_template_e
                             31 .globl _mothership_template_e
                             32 .globl _enemy_template_e
                             33 .globl _playerLife_template_e
                             34 .globl _shot_template_e
                             35 
                             36 
                             37 ;===================================================================================================================================================
                             38 ; Manager data
                             39 ;===================================================================================================================================================
   4238                      40 _enemyOnLane:
   4238 00                   41    .db #0x00
                             42 
   4239                      43 _m_playerShot:
   4239 00                   44    .db #0x00
                             45 
   423A                      46 _m_playerEntity:
   423A 00 00                47    .dw #0x0000
                             48 ;===================================================================================================================================================
                             49 ; FUNCION _m_game_createInitTemplate   
                             50 ; Crea la entidad con el template indicado
                             51 ; BC : Valor de template a crear
                             52 ;===================================================================================================================================================
   423C                      53 _m_game_createInitTemplate::
   423C CD 8D 41      [17]   54    call _man_createEntity
   423F E5            [11]   55    push hl
   4240 EB            [ 4]   56    ex de,hl
   4241 60            [ 4]   57    ld h, b
   4242 69            [ 4]   58    ld l, c
   4243 01 10 00      [10]   59    ld bc,#0x0010
   4246 CD B0 45      [17]   60    call cpct_memcpy_asm
   4249 E1            [10]   61    pop hl
   424A C9            [10]   62    ret
                             63 
                             64 
                             65 ;===================================================================================================================================================
                             66 ; FUNCION _m_game_init   
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



                             67 ; Inicializa el juego y sus entidades
                             68 ; NO llega ningun dato
                             69 ;===================================================================================================================================================
   424B                      70 _m_game_init::
   424B CD 19 44      [17]   71    call  _sys_init_render
   424E CD 75 41      [17]   72    call  _man_entityInit
                             73 
                             74 
                             75    ; Create MotherBoard
   0019                      76    CREATE_ENTITY_FROM_TEMPLATE _mothership_template_e
   4251 01 AD 40      [10]    1     ld bc, #_mothership_template_e
   4254 CD 3C 42      [17]    2     call _m_game_createInitTemplate
                             77 
                             78    ; Create Lifes
   4257 3E 0F         [ 7]   79    ld a,#0x0F
   4259                      80    createLife:
   4259 F5            [11]   81    push af
                             82 
   0022                      83    CREATE_ENTITY_FROM_TEMPLATE _playerLife_template_e
   425A 01 DD 40      [10]    1     ld bc, #_playerLife_template_e
   425D CD 3C 42      [17]    2     call _m_game_createInitTemplate
   4260 23            [ 6]   84    inc hl
   4261 23            [ 6]   85    inc hl
   4262 F1            [10]   86    pop af
   4263 77            [ 7]   87    ld (hl), a
                             88 
   4264 D6 05         [ 7]   89    sub #0x05
   4266 20 F1         [12]   90    jr NZ, createLife
                             91 
                             92    ; CreatePlayer
   0030                      93    CREATE_ENTITY_FROM_TEMPLATE _player_template_e
   4268 01 ED 40      [10]    1     ld bc, #_player_template_e
   426B CD 3C 42      [17]    2     call _m_game_createInitTemplate
   426E EB            [ 4]   94    ex de,hl
   426F 21 3A 42      [10]   95    ld hl, #_m_playerEntity
   4272 72            [ 7]   96    ld (hl), d
   4273 23            [ 6]   97    inc hl
   4274 73            [ 7]   98    ld (hl), e
   4275 EB            [ 4]   99    ex de,hl
   4276 C9            [10]  100 ret
                            101 
                            102 
                            103 ;===================================================================================================================================================
                            104 ; FUNCION _m_game_play   
                            105 ; Bucle del juego
                            106 ; NO llega ningun dato
                            107 ;===================================================================================================================================================
   4277                     108 _m_game_play::
   4277                     109    updates:
   4277 CD DD 42      [17]  110       call _sys_ai_update
   427A CD AE 43      [17]  111       call _sys_physics_update
   427D CD 64 43      [17]  112       call _sys_animator_update
   4280 CD 2B 44      [17]  113       call _sys_render_update
                            114       
   4283 CD 13 42      [17]  115       call _man_entityUpdate
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 5.
Hexadecimal [16-Bits]



   4286 CD CD 42      [17]  116       call _wait
   4289 18 EC         [12]  117    jr updates
                            118 
   428B C9            [10]  119 ret
                            120 
                            121 ;===================================================================================================================================================
                            122 ; FUNCION _m_game_createEnemy   
                            123 ; Crea un enemigo
                            124 ; NO llega ningun dato
                            125 ;===================================================================================================================================================
   428C                     126 _m_game_createEnemy::
   428C 21 38 42      [10]  127    ld hl, #_enemyOnLane
   428F 35            [11]  128    dec (hl)
   4290 34            [11]  129    inc (hl)
   4291 C0            [11]  130    ret NZ
   4292 34            [11]  131    inc (hl)
                            132 
                            133    ; Create Enemy
   005B                     134    CREATE_ENTITY_FROM_TEMPLATE _enemy_template_e
   4293 01 BD 40      [10]    1     ld bc, #_enemy_template_e
   4296 CD 3C 42      [17]    2     call _m_game_createInitTemplate
                            135 
   4299 C9            [10]  136    ret
                            137 
                            138 
                            139 ;===================================================================================================================================================
                            140 ; FUNCION _m_game_destroyEntity
                            141 ; Funcion que destruye la entidad indicada
                            142 ; HL : Llega el valor de la entidad
                            143 ;===================================================================================================================================================
   429A                     144 _m_game_destroyEntity::
   429A E5            [11]  145    push hl
   429B 7E            [ 7]  146    ld a,(hl)
   429C E6 08         [ 7]  147    and #0x08
   429E 28 04         [12]  148    jr Z, notBullet
                            149 
   42A0 21 39 42      [10]  150    ld hl,#_m_playerShot
   42A3 35            [11]  151    dec (hl)
                            152 
   42A4                     153    notBullet:
   42A4 E1            [10]  154    pop hl
   42A5 CD DC 41      [17]  155    call _man_entityDestroy
   42A8 C9            [10]  156    ret
                            157 
                            158 
                            159 ;===================================================================================================================================================
                            160 ; FUNCION _m_game_playerShot
                            161 ; Funcion que dispara si puede
                            162 ; NO llega nada
                            163 ;===================================================================================================================================================
   42A9                     164 _m_game_playerShot::
                            165    ; Create Shot
                            166 
   42A9 21 39 42      [10]  167    ld hl,#_m_playerShot
   42AC 35            [11]  168    dec (hl)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 6.
Hexadecimal [16-Bits]



   42AD 34            [11]  169    inc (hl)
   42AE C0            [11]  170    ret NZ
                            171 
   42AF 01 CD 40      [10]  172    ld bc, #_shot_template_e   
   42B2 CD 3C 42      [17]  173    call _m_game_createInitTemplate
                            174 
   42B5 23            [ 6]  175    inc hl
   42B6 23            [ 6]  176    inc hl      ;; HL lo subo a x del shoot
   42B7 EB            [ 4]  177    ex de,hl
                            178 
   42B8 21 3A 42      [10]  179    ld hl, #_m_playerEntity ;; Recojo la posicion de la entidad jugador
   42BB 46            [ 7]  180    ld b,(hl)
   42BC 23            [ 6]  181    inc hl
   42BD 4E            [ 7]  182    ld c,(hl)
   42BE 60            [ 4]  183    ld h,b
   42BF 69            [ 4]  184    ld l,c
   42C0 23            [ 6]  185    inc hl
   42C1 23            [ 6]  186    inc hl  ;; Una vez obtenida la direccion del inicio del jugador, cojo si x y le sumo 2 y se la guardo al shoot
   42C2 7E            [ 7]  187    ld a,(hl)
   42C3 C6 02         [ 7]  188    add #0x02
   42C5 EB            [ 4]  189    ex de,hl
   42C6 77            [ 7]  190    ld (hl),a
                            191 
   42C7 21 39 42      [10]  192    ld hl,#_m_playerShot
   42CA 34            [11]  193    inc (hl)
                            194 
   42CB C9            [10]  195    ret
                            196 
                            197 
                            198 
                            199 ;===================================================================================================================================================
                            200 ; FUNCION _m_game_tryDownEnemy
                            201 ; Funcion que intenta bajar a un enemigo de carril
                            202 ; HL : Llega el valor de la entidad
                            203 ;===================================================================================================================================================
   42CC                     204 _m_game_tryDownEnemy::
                            205    ;;TODO : No lo hago por ahorrar tiempo
   42CC C9            [10]  206    ret
                            207 
                            208 ;===================================================================================================================================================
                            209 ; FUNCION _wait   
                            210 ; Espera un tiempo antes de realizar otra iteracion del bucle de juego
                            211 ; NO llega ningun dato
                            212 ;===================================================================================================================================================
                            213 
   42CD                     214 _wait::
   42CD 26 05         [ 7]  215    ld h, #0x05
   42CF                     216       waitLoop:
   42CF 06 02         [ 7]  217          ld b, #0x02
   42D1 CD 8F 45      [17]  218          call cpct_waitHalts_asm
   42D4 CD A0 45      [17]  219          call cpct_waitVSYNC_asm
   42D7 25            [ 4]  220          dec h
   42D8 20 F5         [12]  221          jr NZ, waitLoop
   42DA C9            [10]  222    ret
