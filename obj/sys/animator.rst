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
                             10 ; Public data
                             11 ;===================================================================================================================================================
                             12 ;;Sprites
                             13 .globl _sprite_player01
                             14 .globl _sprite_player02
                             15 
                             16 
                             17 ;===================================================================================================================================================
                             18 ; Manager data
                             19 ;===================================================================================================================================================
   42C0                      20 _man_anim_player:
   42C0 0A                   21     .db #0x0A
   42C1 09 40                22     .dw #_sprite_player01
   42C3 0A                   23     .db #0x0A
   42C4 39 40                24     .dw #_sprite_player02
   42C6 00                   25     .db #0x00
   42C7 C0 42                26     .dw #_man_anim_player
                             27 
                             28 ;===================================================================================================================================================
                             29 ; FUNCION _sys_animator_update   
                             30 ; Llama a la inversión de control para updatear las animaciones de cada entidad que coincida con e_type_animator
                             31 ; NO llega ningun dato
                             32 ;===================================================================================================================================================
   42C9                      33 _sys_animator_update::
   42C9 21 D8 42      [10]   34     ld hl, #_sys_animator_updateOneEntity
   42CC 22 FC 40      [16]   35     ld (_m_functionMemory), hl
   42CF 21 FE 40      [10]   36     ld hl , #_m_matchedEntity 
   42D2 36 10         [10]   37     ld (hl), #0x10  ; e_type_animator
   42D4 CD 32 41      [17]   38     call _man_entityForAllMatching
   42D7 C9            [10]   39     ret
                             40 
                             41 
                             42 
                             43 ;===================================================================================================================================================
                             44 ; FUNCION _sys_animator_updateOneEntity   
                             45 ; Si toca cambiar el sprite de la animacion establece el siguiente sprite como el nuevo y,
                             46 ; pone tambien el counter de la animacion con la duración del nuevo sprite.
                             47 ; En caso de que no haya sprite y sea la dirección de memoria de la animacion, 
                             48 ; resetea la animación y establece los datos como el paso descrito antes.
                             49 ; HL : Entidad a updatear
                             50 ;===================================================================================================================================================
   42D8                      51 _sys_animator_updateOneEntity::    
                             52 
   42D8 3E 0D         [ 7]   53     ld a,#0x0D
   42DA                      54     searchCounter:
   42DA 23            [ 6]   55         inc hl
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



   42DB 3D            [ 4]   56         dec a
   42DC 20 FC         [12]   57         jr NZ, searchCounter
                             58     
   42DE 35            [11]   59     dec (hl)
   42DF C0            [11]   60     ret NZ
                             61 
                             62     ;; TODO : Aqui me falta asignar en la entidad la siguiente anim 
                             63 
   42E0 2B            [ 6]   64     dec hl
   42E1 56            [ 7]   65     ld d,(hl)
   42E2 2B            [ 6]   66     dec hl
   42E3 5E            [ 7]   67     ld e,(hl)
                             68 
   42E4 13            [ 6]   69     inc de
   42E5 13            [ 6]   70     inc de
   42E6 13            [ 6]   71     inc de
                             72 
   42E7 73            [ 7]   73     ld (hl), e
   42E8 23            [ 6]   74     inc hl
   42E9 72            [ 7]   75     ld (hl), d
   42EA 2B            [ 6]   76     dec hl
                             77 
   42EB EB            [ 4]   78     ex de,hl 
                             79     ;HL tiene la direccion de la anim
                             80     ;Aqui HL llega apuntando al tiempo de la animacion en memoria 
                             81     ;DE tiene la primera posicion de la animacion de la memoria de entity
   42EC D5            [11]   82     push de
   42ED 35            [11]   83     dec (hl)
   42EE 34            [11]   84     inc (hl)
   42EF 20 09         [12]   85     jr NZ, noRepeatAnim
                             86 
                             87     ; Aqui HL llega apuntando al tiempo de la nueva anim
                             88     ; AQui hay q hacer una cosas setear la animacion (direccion del sprite de inicio)
   42F1 D5            [11]   89     push de
   42F2 23            [ 6]   90     inc hl
   42F3 5E            [ 7]   91     ld e, (hl)
   42F4 23            [ 6]   92     inc hl
   42F5 56            [ 7]   93     ld d, (hl)
   42F6 E1            [10]   94     pop hl
   42F7 73            [ 7]   95     ld (hl),e
   42F8 23            [ 6]   96     inc hl
   42F9 72            [ 7]   97     ld (hl),d
                             98     ;;AQui ya está en la Entity asignado el inicio de la anim
                             99 
   42FA                     100     noRepeatAnim:
   42FA E1            [10]  101     pop hl   ;;Aqui en HL está el inicio de la animacion en la memoria de la entity
   42FB 5E            [ 7]  102     ld e,(hl)
   42FC 23            [ 6]  103     inc hl
   42FD 56            [ 7]  104     ld d,(hl)
   42FE 23            [ 6]  105     inc hl
   42FF EB            [ 4]  106     ex de,hl ;;Aqui en HL está la direcion de memoria del tiempo nuevo en la anim
                            107              ;;y en DE queda el counter del tiempo de la entity
                            108 
                            109     ; Aqui HL llega apuntando al tiempo de la nueva anim
   4300 7E            [ 7]  110     ld a, (hl) ; a = newTIME
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



   4301 23            [ 6]  111     inc hl
   4302 EB            [ 4]  112     ex de, hl
   4303 77            [ 7]  113     ld (hl),a
                            114     ;;Seteado el tiempo en la entity
   4304 2B            [ 6]  115     dec hl
   4305 2B            [ 6]  116     dec hl
   4306 2B            [ 6]  117     dec hl
   4307 2B            [ 6]  118     dec hl
   4308 2B            [ 6]  119     dec hl
   4309 EB            [ 4]  120     ex de, hl ; Tengo en HL el inicio del nuevo sprite en la anim
   430A 4E            [ 7]  121     ld c,(hl)
   430B 23            [ 6]  122     inc hl
   430C 46            [ 7]  123     ld b,(hl)
   430D EB            [ 4]  124     ex de, hl ;Tengo en BC el nuevo sprite, y en HL el segundo Byte del sprite de la entity
   430E 70            [ 7]  125     ld (hl), b
   430F 2B            [ 6]  126     dec hl
   4310 71            [ 7]  127     ld (hl),c
                            128     
   4311 C9            [10]  129    ret
