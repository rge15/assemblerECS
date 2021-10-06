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
                             12 
                             13 .globl _m_functionMemory
                             14 .globl _m_matchedEntity
                             15 
                             16 
                             17 ;===================================================================================================================================================
                             18 ; Manager data
                             19 ;===================================================================================================================================================
   425A                      20 _sys_ai_behaviourMemory::
   425A                      21     .ds 2
                             22 
                             23 ;===================================================================================================================================================
                             24 ; FUNCION _sys_ai_update
                             25 ; Llama a la inversión de control para updatear el comportamiento de 
                             26 ; las entidades que coincida con e_type_movable
                             27 ; NO llega ningun dato
                             28 ;===================================================================================================================================================
   425C                      29 _sys_ai_update::
   425C 21 6B 42      [10]   30     ld hl, #_sys_ai_updateOneEntity
   425F 22 FC 40      [16]   31     ld (_m_functionMemory), hl
   4262 21 FE 40      [10]   32     ld hl , #_m_matchedEntity 
   4265 36 0A         [10]   33     ld (hl), #0x0A ;;  e_type_movable | e_type_ai
   4267 CD 32 41      [17]   34     call _man_entityForAllMatching
   426A C9            [10]   35     ret
                             36 
                             37 ;===================================================================================================================================================
                             38 ; FUNCION _sys_ai_updateOneEntity
                             39 ; Busca el comportamiento de la entidad y lo ejecuta 
                             40 ; HL : LA entidad a updatear
                             41 ;===================================================================================================================================================
   426B                      42 _sys_ai_updateOneEntity::    
                             43     ; ex de, hl
   426B 3E 09         [ 7]   44     ld a,#0x09
   426D                      45     searchBehaviour:
   426D 23            [ 6]   46         inc hl
   426E 3D            [ 4]   47         dec a
   426F 20 FC         [12]   48         jr NZ, searchBehaviour
                             49     
   4271 DD 21 93 42   [14]   50     ld ix, #updatedOneEntity
   4275 DD E5         [15]   51     push ix
                             52 
                             53     ;ex de, hl
   4277 E5            [11]   54     push hl
   4278 7E            [ 7]   55     ld a, (hl)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



   4279 21 5A 42      [10]   56     ld hl, #_sys_ai_behaviourMemory
   427C 77            [ 7]   57     ld (hl),a
   427D E1            [10]   58     pop hl
   427E E5            [11]   59     push hl
   427F 23            [ 6]   60     inc hl
   4280 7E            [ 7]   61     ld a, (hl)
   4281 21 5A 42      [10]   62     ld hl, #_sys_ai_behaviourMemory
   4284 23            [ 6]   63     inc hl
   4285 77            [ 7]   64     ld (hl),a
   4286 E1            [10]   65     pop hl
                             66 
   4287 3E 09         [ 7]   67     ld a,#0x09
   4289                      68     searchType:
   4289 2B            [ 6]   69         dec hl
   428A 3D            [ 4]   70         dec a
   428B 20 FC         [12]   71         jr NZ, searchType
                             72 
   428D DD 2A 5A 42   [20]   73     ld ix, (#_sys_ai_behaviourMemory)
   4291 DD E9         [ 8]   74     jp (ix)
                             75 
   4293                      76     updatedOneEntity:
                             77     
   4293 C9            [10]   78     ret
                             79 
                             80 
                             81 ;===================================================================================================================================================
                             82 ; FUNCION _sys_ai_behaviourMothership
                             83 ; Comportamiento de la MotherShip
                             84 ; 1º Intenta crear un enemigo hijo
                             85 ; 2º Se mueve de derecha a izquierda hasta los bordes
                             86 ; HL : Entidad a updatear
                             87 ;===================================================================================================================================================
   4294                      88 _sys_ai_behaviourMothership::
                             89 
                             90     ;;Si esta en x=20(decimal) intenta crear un enemigo
   4294 23            [ 6]   91     inc hl
   4295 7E            [ 7]   92     ld a,(hl)
   4296 2B            [ 6]   93     dec hl
   4297 D6 14         [ 7]   94     sub #0x14
   4299 20 03         [12]   95     jr NZ,notCreateEnemy
                             96 
   429B CD 3E 42      [17]   97     call _m_game_createEnemy
   429E                      98     notCreateEnemy: 
   429E CD A2 42      [17]   99     call _sys_ai_behaviourLeftRight
                            100 
   42A1 C9            [10]  101     ret
                            102 
                            103 
                            104 ;===================================================================================================================================================
                            105 ; FUNCION _sys_ai_behaviourLeftRight
                            106 ; Si llega a alguno de los bordes establece su velocidad en la direccion contraria
                            107 ; HL : Entidad a updatear
                            108 ;===================================================================================================================================================
   42A2                     109 _sys_ai_behaviourLeftRight::
   42A2 3E 50         [ 7]  110     ld a, #0x50
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



   42A4 23            [ 6]  111     inc hl
   42A5 46            [ 7]  112     ld b,(hl) ;; b = x
   42A6 23            [ 6]  113     inc hl
   42A7 23            [ 6]  114     inc hl
   42A8 96            [ 7]  115     sub (hl)  ;; a = right bound
   42A9 23            [ 6]  116     inc hl
   42AA 23            [ 6]  117     inc hl 
   42AB 04            [ 4]  118     inc b
   42AC 05            [ 4]  119     dec b
   42AD 28 09         [12]  120     jr Z, leftPart
                            121 
   42AF 4F            [ 4]  122     ld c,a
   42B0 78            [ 4]  123     ld a,b
   42B1 41            [ 4]  124     ld b,c
                            125 
   42B2 90            [ 4]  126     sub b
   42B3 28 08         [12]  127     jr Z, rightPart
                            128 
   42B5 C3 BF 42      [10]  129     jp exitUpdate
   42B8                     130     leftPart:
   42B8 36 01         [10]  131         ld (hl), #0x01
   42BA C3 BF 42      [10]  132         jp exitUpdate
                            133 
   42BD                     134     rightPart:
   42BD 36 FF         [10]  135         ld (hl), #0xFF
                            136 
   42BF                     137     exitUpdate:
   42BF C9            [10]  138     ret
