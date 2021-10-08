ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 ;===================================================================================================================================================
                              2 ; CPCTelera functions
                              3 ;===================================================================================================================================================
                              4 .globl cpct_memset_asm
                              5 .globl cpct_memcpy_asm
                              6 
                              7 ;===================================================================================================================================================
                              8 ; Entity types   
                              9 ;===================================================================================================================================================
                             10 ; #define e_type_invalid     0x00
                             11 ; #define e_type_motherBoard 0x04
                             12 ; #define e_type_enemy       0x02
                             13 ; #define e_type_player      0x01
                             14 ; #define e_type_shoot       0x08
                             15 ; #define e_type_playerLife  0x10
                             16 ; #define e_type_default     0x02 
                             17 ; #define e_type_dead        0x80
                             18 
                             19 ;===================================================================================================================================================
                             20 ; Component types   
                             21 ;===================================================================================================================================================
                             22 ; #define e_cmp_render   0x01
                             23 ; #define e_cmp_movable  0x02
                             24 ; #define e_cmp_input    0x04
                             25 ; #define e_cmp_ai       0x08
                             26 ; #define e_cmp_animated 0x10
                             27 ; #define e_cmp_collider 0x20
                             28 
                             29 ;===================================================================================================================================================
                             30 ; Manager data   
                             31 ;===================================================================================================================================================
                             32 ;; Descripcion : Array de entidades
   40FD                      33 _m_entities::
   40FD                      34     .ds 112
                             35 
                             36 ;; Descripcion : Memoria vacia al final del array para controlar su final
   416D                      37 _m_emptyMemCheck::
   416D                      38     .ds 1
                             39 
                             40 ;; Descripcion : Direccion de memoria con la siguiente posicion del array libre 
   416E                      41 _m_next_free_entity::
   416E                      42     .ds 2
                             43 
                             44 ;; Descripcion : Direccion de memoria donde este la funcion de inversion de control
   4170                      45 _m_functionMemory::
   4170                      46     .ds 2
                             47 
                             48 ;; Descripcion : Signature para comprobar entidades en el forAllMatching 
   4172                      49 _m_matchedEntity::
   4172                      50     .ds 1
                             51 
                             52 ;; Descripcion : Numero de entidades que caben en el array _m_entities
   4173                      53 _m_numEntities::
   4173                      54     .ds 1
                             55 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                             56 ;; Descripcion : TAmaño en bytes de 1 entity
   4174                      57 _m_sizeOfEntity::
   4174 10                   58     .db #0x10
                             59 
                             60 
                             61 ;===================================================================================================================================================
                             62 ; FUNCION _man_entityInit   
                             63 ; Inicializa el manager de entidades y sus datos
                             64 ; NO llega ningun dato
                             65 ;===================================================================================================================================================
   4175                      66 _man_entityInit::
   4175 11 FD 40      [10]   67     ld  DE, #_m_entities
   4178 3E 00         [ 7]   68     ld  A,  #0x00
   417A 32 6D 41      [13]   69     ld  (_m_emptyMemCheck), a
   417D 32 73 41      [13]   70     ld  (_m_numEntities), a
   4180 01 70 00      [10]   71     ld  BC, #0x0070
   4183 CD A8 45      [17]   72     call    cpct_memset_asm
                             73     ;;Destroyed: AF & BC & DE & HL
                             74     
   4186 21 FD 40      [10]   75     ld  hl, #_m_entities
   4189 22 6E 41      [16]   76     ld  (_m_next_free_entity), hl
                             77     
   418C C9            [10]   78     ret
                             79 
                             80 
                             81 ;===================================================================================================================================================
                             82 ; FUNCION _man_createEntity   
                             83 ; Crea una entidad
                             84 ; NO llega ningun dato
                             85 ;===================================================================================================================================================
   418D                      86 _man_createEntity::
   418D ED 5B 6E 41   [20]   87     ld  de, (_m_next_free_entity)
   4191 26 00         [ 7]   88     ld  h, #0x00
                             89     ;;TODO:Ver si esto está guay
   4193 3A 74 41      [13]   90     ld  a, (#_m_sizeOfEntity)
   4196 6F            [ 4]   91     ld  l, a
   4197 19            [11]   92     add hl,de
   4198 22 6E 41      [16]   93     ld  (_m_next_free_entity),hl
   419B 21 73 41      [10]   94     ld  hl, #_m_numEntities
   419E 34            [11]   95     inc (hl)
                             96 
                             97 
   419F 6B            [ 4]   98     ld  l,e
   41A0 62            [ 4]   99     ld  h,d
   41A1 C9            [10]  100     ret
                            101 
                            102 
                            103 
                            104 ;===================================================================================================================================================
                            105 ; FUNCION _man_entityForAllMatching
                            106 ; Ejecuta la funcion  de _m_functionMemory por cada entidad que cumpla con el tipo designado en  _m_matchedEntity
                            107 ; NO llega ningun dato
                            108 ;===================================================================================================================================================
   41A2                     109 _man_entityForAllMatching::
   41A2 21 FD 40      [10]  110     ld  hl, #_m_entities
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



                            111     
   41A5 7E            [ 7]  112     ld  a,(hl)
                            113     
   41A6 B7            [ 4]  114     or a,a
   41A7 C8            [11]  115     ret Z
   41A8 E5            [11]  116     push hl
   41A9 C3 C7 41      [10]  117     jp checkSignature
   41AC                     118     not_invalid2:
   41AC E1            [10]  119         pop hl
   41AD E5            [11]  120         push hl
   41AE DD 21 BA 41   [14]  121         ld ix, #next_entity2
   41B2 DD E5         [15]  122         push ix
                            123 
   41B4 DD 2A 70 41   [20]  124         ld ix, (#_m_functionMemory)
   41B8 DD E9         [ 8]  125         jp (ix)
                            126 
   41BA                     127         next_entity2:
   41BA E1            [10]  128         pop hl
   41BB 3A 74 41      [13]  129         ld  a, (#_m_sizeOfEntity)
   41BE 4F            [ 4]  130         ld  c, a
   41BF 06 00         [ 7]  131         ld  b, #0x00
                            132 
   41C1 09            [11]  133         add hl,bc
   41C2 E5            [11]  134         push hl
   41C3 7E            [ 7]  135         ld  a,(hl)
   41C4 B7            [ 4]  136         or a,a 
   41C5 28 0E         [12]  137         jr  Z, allDone
   41C7                     138         checkSignature:
   41C7 3A 72 41      [13]  139         ld a,(#_m_matchedEntity)
   41CA 23            [ 6]  140         inc hl
   41CB A6            [ 7]  141         and (hl)
   41CC 21 72 41      [10]  142         ld hl , #_m_matchedEntity
   41CF 96            [ 7]  143         sub (hl)
   41D0 28 DA         [12]  144         jr Z, not_invalid2
   41D2 C3 BA 41      [10]  145         jp next_entity2
   41D5                     146     allDone:
   41D5 E1            [10]  147     pop hl
   41D6 C9            [10]  148     ret
                            149 
                            150 
                            151 ;===================================================================================================================================================
                            152 ; FUNCION _man_setEntity4Destroy
                            153 ; Establece la entidad para ser destruida
                            154 ; HL : La entidad para ser marcada
                            155 ;===================================================================================================================================================
   41D7                     156 _man_setEntity4Destroy::
   41D7 3E 80         [ 7]  157     ld a, #0x80
   41D9 B6            [ 7]  158     or (hl)
   41DA 77            [ 7]  159     ld (hl),a
   41DB C9            [10]  160 ret
                            161 
                            162 ;===================================================================================================================================================
                            163 ; FUNCION _man_entityDestroy
                            164 ; Elimina de las entidades la entidad de HL y arregla el array de entidades 
                            165 ; para establecer la ultima entidad al espacio liberado por la entidad destruida 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



                            166 ; HL : La entidad para ser destruida
                            167 ;===================================================================================================================================================
   41DC                     168 _man_entityDestroy::
   41DC ED 5B 6E 41   [20]  169     ld de, (#_m_next_free_entity)
   41E0 EB            [ 4]  170     ex de, hl
                            171     ;; HL = _m_next_free_entity
                            172     ;; DE = entity to destroy
                            173 
                            174 
                            175     ;; Buscamos la ultima entidad
   41E1 3A 74 41      [13]  176     ld  a, (#_m_sizeOfEntity)
   41E4                     177     setLast:
   41E4 2B            [ 6]  178         dec hl
   41E5 3D            [ 4]  179         dec a
   41E6 20 FC         [12]  180         jr NZ, setLast
                            181     ;; de = e && hl = last
                            182 
                            183 
                            184     ;;Comprobamos que la ultima entidad libre y la entidad a destruir no sea la misma
                            185     ;;if( e != last)
   41E8 7B            [ 4]  186     ld a, e
   41E9 95            [ 4]  187     sub l
   41EA 28 02         [12]  188     jr Z, checkMemory
                            189 
   41EC 18 04         [12]  190     jr copy
   41EE                     191     checkMemory:
   41EE 7A            [ 4]  192     ld a,d
   41EF 94            [ 4]  193     sub h
   41F0 28 13         [12]  194     jr Z, no_copy 
                            195 
                            196     ;;Si no es la misma copiamos la ultima entidad al espacio de la entidad a destruir
   41F2                     197     copy:
                            198     ; cpct_memcpy(e,last,sizeof(Entity_t));
   41F2 06 00         [ 7]  199     ld b, #0x00
   41F4 3A 74 41      [13]  200     ld  a, (#_m_sizeOfEntity)
   41F7 4F            [ 4]  201     ld c, a
   41F8 CD B0 45      [17]  202     call cpct_memcpy_asm
                            203 
                            204     ;;Volvemos a asignar a hl el valor de la ultima entity
   41FB 21 6E 41      [10]  205     ld hl, #_m_next_free_entity
   41FE 3A 74 41      [13]  206     ld  a, (#_m_sizeOfEntity)
   4201                     207     setLast2:
   4201 2B            [ 6]  208         dec hl
   4202 3D            [ 4]  209         dec a
   4203 20 FC         [12]  210         jr NZ, setLast2
                            211 
                            212 
                            213     ;;Aquí liberamos el ultimo espacio del array de entidades y lo seteamos como el proximo espacio libre 
   4205                     214     no_copy:
                            215     ;last->type = e_type_invalid;
   4205 36 00         [10]  216     ld (hl),#0x00
                            217     ;m_next_free_entity = last;
   4207 11 6E 41      [10]  218     ld de, #_m_next_free_entity
   420A EB            [ 4]  219     ex de, hl
   420B 73            [ 7]  220     ld (hl), e
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 5.
Hexadecimal [16-Bits]



   420C 23            [ 6]  221     inc hl
   420D 72            [ 7]  222     ld (hl), d
                            223     ;    --m_num_entities;      
   420E 21 73 41      [10]  224     ld  hl, #_m_numEntities
   4211 35            [11]  225     dec (hl)
   4212 C9            [10]  226     ret
                            227 
                            228 
                            229 ;===================================================================================================================================================
                            230 ; FUNCION _man_entityUpdate
                            231 ; Recorre todas las entidades y destruye las entidades marcadas
                            232 ; NO llega ningun dato 
                            233 ;===================================================================================================================================================
   4213                     234 _man_entityUpdate::
   4213 21 FD 40      [10]  235     ld hl, #_m_entities
                            236 
   4216 34            [11]  237     inc (hl)
   4217 35            [11]  238     dec (hl)
   4218 C8            [11]  239     ret Z 
   4219 3A 74 41      [13]  240     ld a, (#_m_sizeOfEntity)
   421C 4F            [ 4]  241     ld c, a
   421D 06 00         [ 7]  242     ld b, #0x00    
   421F 3E 80         [ 7]  243     ld a, #0x80    
   4221                     244     valid:
   4221 A6            [ 7]  245         and (hl)
   4222 28 04         [12]  246         jr Z, _next_entity
   4224 20 B6         [12]  247         jr NZ, _man_entityDestroy
   4226 18 01         [12]  248         jr continue
                            249 
   4228                     250         _next_entity:
   4228 09            [11]  251             add hl, bc
                            252             ; jr continue
   4229                     253         continue:
   4229 3E 80         [ 7]  254             ld a, #0x80
   422B 34            [11]  255             inc (hl)
   422C 35            [11]  256             dec (hl)
   422D 20 F2         [12]  257             jr NZ, valid
   422F C9            [10]  258     ret
                            259 
                            260 
                            261 ;===================================================================================================================================================
                            262 ; FUNCION _man_entity_freeSpace
                            263 ; Devuelve en a si hay espacio libre en las entidades para poder generar
                            264 ; NO llega ningun dato 
                            265 ;===================================================================================================================================================
   4230                     266 _man_entity_freeSpace::
   4230 21 73 41      [10]  267         ld hl, #_m_numEntities
   4233 3A 73 41      [13]  268         ld a, (#_m_numEntities)
   4236 96            [ 7]  269         sub (hl)
   4237 C9            [10]  270     ret
                            271 
                            272 
                            273 
                            274 
                            275 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 6.
Hexadecimal [16-Bits]



                            276 
