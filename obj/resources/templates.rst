ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 ;===================================================================================================================================================
                              2 ; Public functions
                              3 ;===================================================================================================================================================
                              4 .globl _sys_ai_behaviourLeftRight
                              5 .globl _sys_ai_behaviourMothership
                              6 .globl _sys_ai_behaviourEnemy
                              7 .globl _sys_ai_behaviourAutoDestroy
                              8 
                              9 
                             10 ;===================================================================================================================================================
                             11 ; Public data
                             12 ;===================================================================================================================================================
                             13 ;;Animations
                             14 .globl _man_anim_player
                             15 ;;Sprites
                             16 .globl _sprite_player01
                             17 .globl _sprite_player02
                             18 .globl _sprite_mothership
                             19 .globl _sprite_enemy
                             20 .globl _sprite_shot
                             21   
                             22 
                             23 ;===================================================================================================================================================
                             24 ; Templates
                             25 ;===================================================================================================================================================
   40AD                      26 _mothership_template_e:
   40AD 04                   27    .db #0x04   ; type
   40AE 0B                   28    .db #0x0B   ; cmp
   40AF 26                   29    .db #0x26   ; x
   40B0 0A                   30    .db #0x0A   ; y
   40B1 04                   31    .db #0x04   ; width
   40B2 06                   32    .db #0x06   ; heigth
   40B3 FF                   33    .db #0xFF   ; vx
   40B4 00                   34    .db #0x00   ; vy
   40B5 69 40                35    .dw #_sprite_mothership ; sprite
   40B7 15 43                36    .dw #_sys_ai_behaviourMothership ;ai_behaviour
   40B9 00                   37    .db #0x00   ;ai_counter
   40BA 00 00                38    .dw #0x0000 ;animator
   40BC 00                   39    .db #0x00   ;anim. counter
                             40 
   40BD                      41 _enemy_template_e:
   40BD 02                   42    .db #0x02   ; type
   40BE 0B                   43    .db #0x0B   ; cmp
   40BF 26                   44    .db #0x26   ; x
   40C0 1E                   45    .db #0x1E   ; y
   40C1 06                   46    .db #0x06   ; width
   40C2 06                   47    .db #0x06   ; heigth
   40C3 01                   48    .db #0x01   ; vx
   40C4 00                   49    .db #0x00   ; vy
   40C5 81 40                50    .dw #_sprite_enemy ; sprite
   40C7 25 43                51    .dw #_sys_ai_behaviourEnemy ;ai_behaviour
   40C9 00                   52    .db #0x00   ;ai_counter
   40CA 00 00                53    .dw #0x0000 ;animator
   40CC 00                   54    .db #0x00   ;anim. counter
                             55 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



   40CD                      56 _shot_template_e:
   40CD 08                   57    .db #0x08   ; type
   40CE 0B                   58    .db #0x0B   ; cmp
   40CF 00                   59    .db #0x00   ; x
   40D0 A7                   60    .db #0xA7   ; y
   40D1 01                   61    .db #0x01   ; width
   40D2 08                   62    .db #0x08   ; heigth
   40D3 00                   63    .db #0x00   ; vx
   40D4 F7                   64    .db #0xF7   ; vy
   40D5 A5 40                65    .dw #_sprite_shot ; sprite
   40D7 48 43                66    .dw #_sys_ai_behaviourAutoDestroy ;ai_behaviour
   40D9 0B                   67    .db #0x0B   ;ai_counter
   40DA 00 00                68    .dw #0x0000 ;animator
   40DC 00                   69    .db #0x00   ;anim. counter
                             70 
                             71 
   40DD                      72 _playerLife_template_e:
   40DD 10                   73    .db #0x10   ; type
   40DE 01                   74    .db #0x01   ; cmp
   40DF 00                   75    .db #0x00   ; x
   40E0 C0                   76    .db #0xC0   ; y
   40E1 06                   77    .db #0x06   ; width
   40E2 08                   78    .db #0x08   ; heigth
   40E3 00                   79    .db #0x00   ; vx
   40E4 00                   80    .db #0x00   ; vy
   40E5 09 40                81    .dw #_sprite_player01 ; sprite
   40E7 00 00                82    .dw #0x0000 ;ai_behaviour
   40E9 00                   83    .db #0x00   ;ai_counter
   40EA 00 00                84    .dw #0x0000 ;animator
   40EC 00                   85    .db #0x00   ;anim. counter
                             86 
   40ED                      87 _player_template_e:
   40ED 01                   88    .db #0x01   ; type
   40EE 17                   89    .db #0x17   ; cmp
   40EF 26                   90    .db #0x26   ; x
   40F0 B0                   91    .db #0xB0   ; y
   40F1 06                   92    .db #0x06   ; width
   40F2 08                   93    .db #0x08   ; heigth
   40F3 00                   94    .db #0x00   ; vx
   40F4 00                   95    .db #0x00   ; vy
   40F5 09 40                96    .dw #_sprite_player01 ; sprite
   40F7 00 00                97    .dw #0x0000 ;ai_behaviour
   40F9 00                   98    .db #0x00   ;ai_counter
   40FA 5B 43                99    .dw #_man_anim_player ;animator
   40FC 10                  100    .db #0x10   ;anim. counter
