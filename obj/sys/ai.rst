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
                             11 .globl _m_game_createEnemy
                             12 .globl _m_game_destroyEntity
                             13 
                             14 .globl _m_functionMemory
                             15 .globl _m_matchedEntity
                             16 
                             17 
                             18 ;===================================================================================================================================================
                             19 ; Manager data
                             20 ;===================================================================================================================================================
   42DB                      21 _sys_ai_behaviourMemory::
   42DB                      22     .ds 2
                             23 
                             24 ;===================================================================================================================================================
                             25 ; FUNCION _sys_ai_update
                             26 ; Llama a la inversión de control para updatear el comportamiento de 
                             27 ; las entidades que coincida con e_type_movable
                             28 ; NO llega ningun dato
                             29 ;===================================================================================================================================================
   42DD                      30 _sys_ai_update::
   42DD 21 EC 42      [10]   31     ld hl, #_sys_ai_updateOneEntity
   42E0 22 70 41      [16]   32     ld (_m_functionMemory), hl
   42E3 21 72 41      [10]   33     ld hl , #_m_matchedEntity 
   42E6 36 0A         [10]   34     ld (hl), #0x0A ;;  e_type_movable | e_type_ai
   42E8 CD A2 41      [17]   35     call _man_entityForAllMatching
   42EB C9            [10]   36     ret
                             37 
                             38 ;===================================================================================================================================================
                             39 ; FUNCION _sys_ai_updateOneEntity
                             40 ; Busca el comportamiento de la entidad y lo ejecuta 
                             41 ; HL : LA entidad a updatear
                             42 ;===================================================================================================================================================
   42EC                      43 _sys_ai_updateOneEntity::    
                             44     ; ex de, hl
   42EC 3E 0A         [ 7]   45     ld a,#0x0A
   42EE                      46     searchBehaviour:
   42EE 23            [ 6]   47         inc hl
   42EF 3D            [ 4]   48         dec a
   42F0 20 FC         [12]   49         jr NZ, searchBehaviour
                             50     
   42F2 DD 21 14 43   [14]   51     ld ix, #updatedOneEntity
   42F6 DD E5         [15]   52     push ix
                             53 
                             54     ;ex de, hl
   42F8 E5            [11]   55     push hl
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



   42F9 7E            [ 7]   56     ld a, (hl)
   42FA 21 DB 42      [10]   57     ld hl, #_sys_ai_behaviourMemory
   42FD 77            [ 7]   58     ld (hl),a
   42FE E1            [10]   59     pop hl
   42FF E5            [11]   60     push hl
   4300 23            [ 6]   61     inc hl
   4301 7E            [ 7]   62     ld a, (hl)
   4302 21 DB 42      [10]   63     ld hl, #_sys_ai_behaviourMemory
   4305 23            [ 6]   64     inc hl
   4306 77            [ 7]   65     ld (hl),a
   4307 E1            [10]   66     pop hl
                             67 
   4308 3E 0A         [ 7]   68     ld a,#0x0A
   430A                      69     searchEntityType:
   430A 2B            [ 6]   70         dec hl
   430B 3D            [ 4]   71         dec a
   430C 20 FC         [12]   72         jr NZ, searchEntityType
                             73 
   430E DD 2A DB 42   [20]   74     ld ix, (#_sys_ai_behaviourMemory)
   4312 DD E9         [ 8]   75     jp (ix)
                             76 
   4314                      77     updatedOneEntity:
                             78     
   4314 C9            [10]   79     ret
                             80 
                             81 
                             82 ;===================================================================================================================================================
                             83 ; FUNCION _sys_ai_behaviourMothership
                             84 ; Comportamiento de la MotherShip
                             85 ; 1º Intenta crear un enemigo hijo
                             86 ; 2º Se mueve de derecha a izquierda hasta los bordes
                             87 ; HL : Entidad a updatear
                             88 ;===================================================================================================================================================
   4315                      89 _sys_ai_behaviourMothership::
                             90 
                             91     ;;Si esta en x=20(decimal) intenta crear un enemigo
   4315 23            [ 6]   92     inc hl
   4316 23            [ 6]   93     inc hl
   4317 7E            [ 7]   94     ld a,(hl)
   4318 2B            [ 6]   95     dec hl
   4319 2B            [ 6]   96     dec hl
   431A D6 14         [ 7]   97     sub #0x14
   431C 20 03         [12]   98     jr NZ,notCreateEnemy
                             99 
   431E CD 8C 42      [17]  100     call _m_game_createEnemy
   4321                     101     notCreateEnemy: 
   4321 CD 29 43      [17]  102     call _sys_ai_behaviourLeftRight
                            103 
   4324 C9            [10]  104     ret
                            105 
                            106 
                            107 ;===================================================================================================================================================
                            108 ; FUNCION _sys_ai_behaviourEnemy
                            109 ; Comportamiento de la MotherShip
                            110 ; 1º Intenta crear un enemigo hijo
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



                            111 ; 2º Se mueve de derecha a izquierda hasta los bordes
                            112 ; HL : Entidad a updatear
                            113 ;===================================================================================================================================================
   4325                     114 _sys_ai_behaviourEnemy::
                            115 
                            116     ;; TODO : IA del enemigo , no la hago por aprovechar tiempo 
                            117     ; inc hl
                            118     ; ld a,(hl)
                            119     ; dec hl
                            120     
                            121     ; sub #0x07
                            122     ; jr NZ,notTryDown
                            123 
                            124     ; push hl
                            125     ; call _m_game_tryDownEnemy
                            126     ; pop hl 
                            127     ; notTryDown:
                            128 
   4325 CD 29 43      [17]  129     call _sys_ai_behaviourLeftRight
                            130 
   4328 C9            [10]  131     ret
                            132 
                            133 
                            134 
                            135 
                            136 ;===================================================================================================================================================
                            137 ; FUNCION _sys_ai_behaviourLeftRight
                            138 ; Si llega a alguno de los bordes establece su velocidad en la direccion contraria
                            139 ; HL : Entidad a updatear
                            140 ;===================================================================================================================================================
   4329                     141 _sys_ai_behaviourLeftRight::
   4329 3E 50         [ 7]  142     ld a, #0x50
   432B 23            [ 6]  143     inc hl
   432C 23            [ 6]  144     inc hl
   432D 46            [ 7]  145     ld b,(hl) ;; b = x
   432E 23            [ 6]  146     inc hl
   432F 23            [ 6]  147     inc hl
   4330 96            [ 7]  148     sub (hl)  ;; a = right bound
   4331 23            [ 6]  149     inc hl
   4332 23            [ 6]  150     inc hl 
   4333 04            [ 4]  151     inc b
   4334 05            [ 4]  152     dec b
   4335 28 09         [12]  153     jr Z, leftPart
                            154 
   4337 4F            [ 4]  155     ld c,a
   4338 78            [ 4]  156     ld a,b
   4339 41            [ 4]  157     ld b,c
                            158 
   433A 90            [ 4]  159     sub b
   433B 28 08         [12]  160     jr Z, rightPart
                            161 
   433D C3 47 43      [10]  162     jp exitUpdate
   4340                     163     leftPart:
   4340 36 01         [10]  164         ld (hl), #0x01
   4342 C3 47 43      [10]  165         jp exitUpdate
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



                            166 
   4345                     167     rightPart:
   4345 36 FF         [10]  168         ld (hl), #0xFF
                            169 
   4347                     170     exitUpdate:
   4347 C9            [10]  171     ret
                            172 
                            173 
                            174 
                            175 ;===================================================================================================================================================
                            176 ; FUNCION _sys_ai_behaviourAutoDestroy
                            177 ; Destruye la entidad pasado el tiempo del contador de la IA
                            178 ; HL : Entidad a updatear
                            179 ;===================================================================================================================================================
                            180 
   4348                     181 _sys_ai_behaviourAutoDestroy::
   4348 3E 0C         [ 7]  182     ld a,#0x0C
   434A                     183     searchAICounter:
   434A 23            [ 6]  184         inc hl
   434B 3D            [ 4]  185         dec a
   434C 20 FC         [12]  186         jr NZ, searchAICounter
                            187     
   434E 35            [11]  188     dec (hl)
   434F 20 09         [12]  189     jr NZ, dontDestroy
                            190     
   4351 3E 0C         [ 7]  191     ld a,#0x0C
   4353                     192     searchType:
   4353 2B            [ 6]  193         dec hl
   4354 3D            [ 4]  194         dec a
   4355 20 FC         [12]  195         jr NZ, searchType
                            196 
   4357 CD 9A 42      [17]  197     call _m_game_destroyEntity
                            198     
   435A                     199     dontDestroy:
                            200     
   435A C9            [10]  201     ret
