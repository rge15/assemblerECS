ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 ;;Cargar crear entidades con el template indicado
                              2 .macro CREATE_ENTITY_FROM_TEMPLATE _template
                              3     ld bc, #_template
                              4     call _m_game_createInitTemplate
                              5 .endm
