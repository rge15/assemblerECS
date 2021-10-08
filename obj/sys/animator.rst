ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 ;===================================================================================================================================================
                              2 ; Public functions
                              3 ;===================================================================================================================================================
                              4 .globl _man_entityForAllMatching
                              5 .globl _m_functionMemory
                              6 .globl _m_matchedEntity
                              7 
                              8 
                              9 ;===================================================================================================================================================
                             10 ; Sprites
                             11 ;===================================================================================================================================================
                             12 .globl _sprite_player01
                             13 .globl _sprite_player02
                             14 
                             15 ;===================================================================================================================================================
                             16 ; Animations
                             17 ;===================================================================================================================================================
   435B                      18 _man_anim_player:
   435B 0A                   19     .db #0x0A
   435C 09 40                20     .dw #_sprite_player01
   435E 0A                   21     .db #0x0A
   435F 39 40                22     .dw #_sprite_player02
   4361 00                   23     .db #0x00
   4362 5B 43                24     .dw #_man_anim_player
                             25 
                             26 ;===================================================================================================================================================
                             27 ; FUNCION _sys_animator_update   
                             28 ; Llama a la inversión de control para updatear las animaciones de cada entidad que coincida con e_type_animator
                             29 ; NO llega ningun dato
                             30 ;===================================================================================================================================================
   4364                      31 _sys_animator_update::
   4364 21 73 43      [10]   32     ld hl, #_sys_animator_updateOneEntity
   4367 22 70 41      [16]   33     ld (_m_functionMemory), hl
   436A 21 72 41      [10]   34     ld hl , #_m_matchedEntity 
   436D 36 10         [10]   35     ld (hl), #0x10  ; e_type_animator
   436F CD A2 41      [17]   36     call _man_entityForAllMatching
   4372 C9            [10]   37     ret
                             38 
                             39 
                             40 
                             41 ;===================================================================================================================================================
                             42 ; FUNCION _sys_animator_updateOneEntity   
                             43 ; Si toca cambiar el sprite de la animacion establece el siguiente sprite como el nuevo y,
                             44 ; pone tambien el counter de la animacion con la duración del nuevo sprite.
                             45 ; En caso de que no haya sprite y sea la dirección de memoria de la animacion, 
                             46 ; resetea la animación y establece los datos como el paso descrito antes.
                             47 ; HL : Entidad a updatear
                             48 ;===================================================================================================================================================
   4373                      49 _sys_animator_updateOneEntity::    
                             50 
   4373 3E 0F         [ 7]   51     ld a,#0x0F
   4375                      52     searchCounter:
   4375 23            [ 6]   53         inc hl
   4376 3D            [ 4]   54         dec a
   4377 20 FC         [12]   55         jr NZ, searchCounter
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                             56     
   4379 35            [11]   57     dec (hl)
   437A C0            [11]   58     ret NZ
                             59 
                             60     ;; TODO : Aqui me falta asignar en la entidad la siguiente anim 
                             61 
   437B 2B            [ 6]   62     dec hl
   437C 56            [ 7]   63     ld d,(hl)
   437D 2B            [ 6]   64     dec hl
   437E 5E            [ 7]   65     ld e,(hl)
                             66 
   437F 13            [ 6]   67     inc de
   4380 13            [ 6]   68     inc de
   4381 13            [ 6]   69     inc de
                             70 
   4382 73            [ 7]   71     ld (hl), e
   4383 23            [ 6]   72     inc hl
   4384 72            [ 7]   73     ld (hl), d
   4385 2B            [ 6]   74     dec hl
                             75 
   4386 EB            [ 4]   76     ex de,hl 
                             77     ;HL tiene la direccion de la anim
                             78     ;Aqui HL llega apuntando al tiempo de la animacion en memoria 
                             79     ;DE tiene la primera posicion de la animacion de la memoria de entity
   4387 D5            [11]   80     push de
   4388 35            [11]   81     dec (hl)
   4389 34            [11]   82     inc (hl)
   438A 20 09         [12]   83     jr NZ, noRepeatAnim
                             84 
                             85     ; Aqui HL llega apuntando al tiempo de la nueva anim
                             86     ; Aqui hay q hacer una cosas setear la animacion (direccion del sprite de inicio)
   438C D5            [11]   87     push de
   438D 23            [ 6]   88     inc hl
   438E 5E            [ 7]   89     ld e, (hl)
   438F 23            [ 6]   90     inc hl
   4390 56            [ 7]   91     ld d, (hl)
   4391 E1            [10]   92     pop hl
   4392 73            [ 7]   93     ld (hl),e
   4393 23            [ 6]   94     inc hl
   4394 72            [ 7]   95     ld (hl),d
                             96     ;;AQui ya está en la Entity asignado el inicio de la anim
                             97 
   4395                      98     noRepeatAnim:
   4395 E1            [10]   99     pop hl   ;;Aqui en HL está el inicio de la animacion en la memoria de la entity
   4396 5E            [ 7]  100     ld e,(hl)
   4397 23            [ 6]  101     inc hl
   4398 56            [ 7]  102     ld d,(hl)
   4399 23            [ 6]  103     inc hl
   439A EB            [ 4]  104     ex de,hl ;;Aqui en HL está la direcion de memoria del tiempo nuevo en la anim
                            105              ;;y en DE queda el counter del tiempo de la entity
                            106 
                            107     ; Aqui HL llega apuntando al tiempo de la nueva anim
   439B 7E            [ 7]  108     ld a, (hl) ; a = newTIME
   439C 23            [ 6]  109     inc hl
   439D EB            [ 4]  110     ex de, hl
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



   439E 77            [ 7]  111     ld (hl),a
                            112     ;;Seteado el tiempo en la entity
   439F 2B            [ 6]  113     dec hl
   43A0 2B            [ 6]  114     dec hl
   43A1 2B            [ 6]  115     dec hl
   43A2 2B            [ 6]  116     dec hl
   43A3 2B            [ 6]  117     dec hl
   43A4 2B            [ 6]  118     dec hl
   43A5 EB            [ 4]  119     ex de, hl ; Tengo en HL el inicio del nuevo sprite en la anim
   43A6 4E            [ 7]  120     ld c,(hl)
   43A7 23            [ 6]  121     inc hl
   43A8 46            [ 7]  122     ld b,(hl)
   43A9 EB            [ 4]  123     ex de, hl ;Tengo en BC el nuevo sprite, y en HL el segundo Byte del sprite de la entity
   43AA 70            [ 7]  124     ld (hl), b
   43AB 2B            [ 6]  125     dec hl
   43AC 71            [ 7]  126     ld (hl),c
                            127     
   43AD C9            [10]  128    ret
