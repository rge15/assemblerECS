ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 .globl cpct_memset_asm
                              2 .globl cpct_memcpy_asm
                              3 
                              4 
                              5 ;===================================================================================================================================================
                              6 ; Entity types   
                              7 ;===================================================================================================================================================
                              8 ; #define e_type_invalid  0x00
                              9 ; #define e_type_render   0x01
                             10 ; #define e_type_movable  0x02
                             11 ; #define e_type_input    0x04
                             12 ; #define e_type_ai       0x08
                             13 ; #define e_type_animated 0x10
                             14 ; #define e_type_default  0x7F
                             15 ; #define e_type_dead     0x80
                             16 
                             17 
                             18 ;===================================================================================================================================================
                             19 ; Manager data   
                             20 ;===================================================================================================================================================
                             21 
                             22 ;; Array de entidades
   40A5                      23 _m_entities::
   40A5                      24     .ds 84
                             25 
                             26 ;; Memoria vacia al final del array para controlar su final
   40F9                      27 _m_emptyMemCheck::
   40F9                      28     .ds 1
                             29 
                             30 ;; Direccion de memoria con la siguiente posicion del array libre 
   40FA                      31 _m_next_free_entity::
   40FA                      32     .ds 2
                             33 
                             34 ;; Direccion de memoria donde este la funcion de inversion de control
   40FC                      35 _m_functionMemory::
   40FC                      36     .ds 2
                             37 
   40FE                      38 _m_matchedEntity::
   40FE                      39     .ds 1
                             40 
                             41 ;; Numero de entidades creadas
   40FF                      42 _m_numEntities::
   40FF                      43     .ds 6
                             44 
                             45 
                             46 ;===================================================================================================================================================
                             47 ; FUNCION _man_entityInit   
                             48 ; Inicializa el manager de entidades y sus datos
                             49 ; NO llega ningun dato
                             50 ;===================================================================================================================================================
   4105                      51 _man_entityInit::
   4105 11 A5 40      [10]   52     ld  DE, #_m_entities
   4108 3E 00         [ 7]   53     ld  A,  #0x00
   410A 32 F9 40      [13]   54     ld  (_m_emptyMemCheck), a
   410D 32 FF 40      [13]   55     ld  (_m_numEntities), a
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



   4110 01 54 00      [10]   56     ld  BC, #0x0054
   4113 CD FB 44      [17]   57     call    cpct_memset_asm
                             58     ;;Destroyed: AF & BC & DE & HL
                             59     
   4116 21 A5 40      [10]   60     ld  hl, #_m_entities
   4119 22 FA 40      [16]   61     ld  (_m_next_free_entity), hl
                             62     
   411C C9            [10]   63     ret
                             64 
                             65 
                             66 ;===================================================================================================================================================
                             67 ; FUNCION _man_createEntity   
                             68 ; Crea una entidad
                             69 ; NO llega ningun dato
                             70 ;===================================================================================================================================================
   411D                      71 _man_createEntity::
   411D ED 5B FA 40   [20]   72     ld  de, (_m_next_free_entity)
   4121 26 00         [ 7]   73     ld  h, #0x00
   4123 2E 0E         [ 7]   74     ld  l, #0x0E
   4125 19            [11]   75     add hl,de
   4126 22 FA 40      [16]   76     ld  (_m_next_free_entity),hl
   4129 21 FF 40      [10]   77     ld  hl, #_m_numEntities
   412C 34            [11]   78     inc (hl)
   412D 6B            [ 4]   79     ld  l,e
   412E 62            [ 4]   80     ld  h,d
   412F 36 7F         [10]   81     ld  (hl), #0x7F
   4131 C9            [10]   82     ret
                             83 
                             84 
                             85 
                             86 ;===================================================================================================================================================
                             87 ; FUNCION _man_entityForAllMatching
                             88 ; Ejecuta la funcion  de _m_functionMemory por cada entidad que cumpla con el tipo designado en  _m_matchedEntity
                             89 ; NO llega ningun dato
                             90 ;===================================================================================================================================================
   4132                      91 _man_entityForAllMatching::
   4132 21 A5 40      [10]   92     ld  hl, #_m_entities
                             93     
   4135 7E            [ 7]   94     ld  a,(hl)
                             95     
   4136 B7            [ 4]   96     or a,a
   4137 C8            [11]   97     ret Z
   4138 E5            [11]   98     push hl
   4139 C3 55 41      [10]   99     jp checkSignature
   413C                     100     not_invalid2:
   413C E1            [10]  101         pop hl
   413D E5            [11]  102         push hl
   413E DD 21 4A 41   [14]  103         ld ix, #next_entity2
   4142 DD E5         [15]  104         push ix
                            105 
   4144 DD 2A FC 40   [20]  106         ld ix, (#_m_functionMemory)
   4148 DD E9         [ 8]  107         jp (ix)
                            108 
   414A                     109         next_entity2:
   414A E1            [10]  110         pop hl
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



   414B 0E 0E         [ 7]  111         ld  c,#0x0E
   414D 06 00         [ 7]  112         ld  b,#0x00
                            113 
   414F 09            [11]  114         add hl,bc
   4150 E5            [11]  115         push hl
   4151 7E            [ 7]  116         ld  a,(hl)
   4152 B7            [ 4]  117         or a,a 
   4153 28 0D         [12]  118         jr  Z, allDone
   4155                     119         checkSignature:
   4155 3A FE 40      [13]  120         ld a,(#_m_matchedEntity)
   4158 A6            [ 7]  121         and (hl)
   4159 21 FE 40      [10]  122         ld hl , #_m_matchedEntity
   415C 96            [ 7]  123         sub (hl)
   415D 28 DD         [12]  124         jr Z, not_invalid2
   415F C3 4A 41      [10]  125         jp next_entity2
   4162                     126     allDone:
   4162 E1            [10]  127     pop hl
   4163 C9            [10]  128     ret
                            129 
                            130 
                            131 ;===================================================================================================================================================
                            132 ; FUNCION _man_setEntity4Destroy
                            133 ; Establece la entidad para ser destruida
                            134 ; HL : La entidad para ser marcada
                            135 ;===================================================================================================================================================
   4164                     136 _man_setEntity4Destroy::
   4164 3E 80         [ 7]  137     ld a, #0x80
   4166 B6            [ 7]  138     or (hl)
   4167 77            [ 7]  139     ld (hl),a
   4168 C9            [10]  140 ret
                            141 
                            142 ;===================================================================================================================================================
                            143 ; FUNCION _man_entityDestroy
                            144 ; Elimina de las entidades la entidad de HL y arregla el array de entidades 
                            145 ; para establecer la ultima entidad al espacio liberado por la entidad destruida 
                            146 ; HL : La entidad para ser destruida
                            147 ;===================================================================================================================================================
   4169                     148 _man_entityDestroy::
   4169 ED 5B FA 40   [20]  149     ld de, (#_m_next_free_entity)
   416D EB            [ 4]  150     ex de, hl
                            151     ;; HL = _m_next_free_entity
                            152     ;; DE = entity to destroy
                            153 
                            154 
                            155     ;; Buscamos la ultima entidad
   416E 3E 0E         [ 7]  156     ld a, #0x0E
   4170                     157     setLast:
   4170 2B            [ 6]  158         dec hl
   4171 3D            [ 4]  159         dec a
   4172 20 FC         [12]  160         jr NZ, setLast
                            161     ;; de = e && hl = last
                            162 
                            163 
                            164     ;;Comprobamos que la ultima entidad libre y la entidad a destruir no sea la misma
                            165     ;;if( e != last)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



   4174 7B            [ 4]  166     ld a, e
   4175 95            [ 4]  167     sub l
   4176 28 02         [12]  168     jr Z, checkMemory
                            169 
   4178 18 04         [12]  170     jr copy
   417A                     171     checkMemory:
   417A 7A            [ 4]  172     ld a,d
   417B 94            [ 4]  173     sub h
   417C 28 10         [12]  174     jr Z, no_copy 
                            175 
                            176     ;;Si no es la misma copiamos la ultima entidad al espacio de la entidad a destruir
   417E                     177     copy:
                            178     ; cpct_memcpy(e,last,sizeof(Entity_t));
   417E 06 00         [ 7]  179     ld b, #0x00
   4180 0E 0E         [ 7]  180     ld c, #0x0E
   4182 CD 03 45      [17]  181     call cpct_memcpy_asm
                            182 
                            183     ;;Volvemos a asignar a hl el valor de la ultima entity
   4185 21 FA 40      [10]  184     ld hl, #_m_next_free_entity
   4188 3E 0E         [ 7]  185     ld a, #0x0E
   418A                     186     setLast2:
   418A 2B            [ 6]  187         dec hl
   418B 3D            [ 4]  188         dec a
   418C 20 FC         [12]  189         jr NZ, setLast2
                            190 
                            191 
                            192     ;;Aquí liberamos el ultimo espacio del array de entidades y lo seteamos como el proximo espacio libre 
   418E                     193     no_copy:
                            194     ;last->type = e_type_invalid;
   418E 36 00         [10]  195     ld (hl),#0x00
                            196     ;m_next_free_entity = last;
   4190 11 FA 40      [10]  197     ld de, #_m_next_free_entity
   4193 EB            [ 4]  198     ex de, hl
   4194 73            [ 7]  199     ld (hl), e
   4195 23            [ 6]  200     inc hl
   4196 72            [ 7]  201     ld (hl), d
                            202     ;    --m_num_entities;      
   4197 21 FF 40      [10]  203     ld  hl, #_m_numEntities
   419A 35            [11]  204     dec (hl)
   419B C9            [10]  205     ret
                            206 
                            207 
                            208 ;===================================================================================================================================================
                            209 ; FUNCION _man_entityUpdate
                            210 ; Recorre todas las entidades y destruye las entidades marcadas
                            211 ; NO llega ningun dato 
                            212 ;===================================================================================================================================================
   419C                     213 _man_entityUpdate::
   419C 21 A5 40      [10]  214     ld hl, #_m_entities
                            215 
   419F 34            [11]  216     inc (hl)
   41A0 35            [11]  217     dec (hl)
   41A1 C8            [11]  218     ret Z 
   41A2 0E 0E         [ 7]  219     ld c, #0x0E
   41A4 06 00         [ 7]  220     ld b, #0x00    
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 5.
Hexadecimal [16-Bits]



   41A6 3E 80         [ 7]  221     ld a, #0x80    
   41A8                     222     valid:
   41A8 A6            [ 7]  223         and (hl)
   41A9 28 04         [12]  224         jr Z, _next_entity
   41AB 20 BC         [12]  225         jr NZ, _man_entityDestroy
   41AD 18 01         [12]  226         jr continue
                            227 
   41AF                     228         _next_entity:
   41AF 09            [11]  229             add hl, bc
                            230             ; jr continue
   41B0                     231         continue:
   41B0 3E 80         [ 7]  232             ld a, #0x80
   41B2 34            [11]  233             inc (hl)
   41B3 35            [11]  234             dec (hl)
   41B4 20 F2         [12]  235             jr NZ, valid
   41B6 C9            [10]  236     ret
                            237 
                            238 
                            239 ;===================================================================================================================================================
                            240 ; FUNCION _man_entity_freeSpace
                            241 ; Devuelve en a si hay espacio libre en las entidades para poder generar
                            242 ; NO llega ningun dato 
                            243 ;===================================================================================================================================================
   41B7                     244 _man_entity_freeSpace::
   41B7 21 FF 40      [10]  245         ld hl, #_m_numEntities
   41BA 3E 06         [ 7]  246         ld a, #0x06
   41BC 96            [ 7]  247         sub (hl)
   41BD C9            [10]  248     ret
                            249 
                            250 
                            251 
                            252 
                            253 
                            254 
