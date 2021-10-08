;===================================================================================================================================================
; Public functions
;===================================================================================================================================================
.globl _sys_ai_behaviourLeftRight
.globl _sys_ai_behaviourMothership
.globl _sys_ai_behaviourEnemy
.globl _sys_ai_behaviourAutoDestroy


;===================================================================================================================================================
; Public data
;===================================================================================================================================================
;;Animations
.globl _man_anim_player
;;Sprites
.globl _sprite_player01
.globl _sprite_player02
.globl _sprite_mothership
.globl _sprite_enemy
.globl _sprite_shot
  

;===================================================================================================================================================
; Templates
;===================================================================================================================================================
_mothership_template_e:
   .db #0x04   ; type
   .db #0x0B   ; cmp
   .db #0x26   ; x
   .db #0x0A   ; y
   .db #0x04   ; width
   .db #0x06   ; heigth
   .db #0xFF   ; vx
   .db #0x00   ; vy
   .dw #_sprite_mothership ; sprite
   .dw #_sys_ai_behaviourMothership ;ai_behaviour
   .db #0x00   ;ai_counter
   .dw #0x0000 ;animator
   .db #0x00   ;anim. counter

_enemy_template_e:
   .db #0x02   ; type
   .db #0x0B   ; cmp
   .db #0x26   ; x
   .db #0x1E   ; y
   .db #0x06   ; width
   .db #0x06   ; heigth
   .db #0x01   ; vx
   .db #0x00   ; vy
   .dw #_sprite_enemy ; sprite
   .dw #_sys_ai_behaviourEnemy ;ai_behaviour
   .db #0x00   ;ai_counter
   .dw #0x0000 ;animator
   .db #0x00   ;anim. counter

_shot_template_e:
   .db #0x08   ; type
   .db #0x0B   ; cmp
   .db #0x00   ; x
   .db #0xA7   ; y
   .db #0x01   ; width
   .db #0x08   ; heigth
   .db #0x00   ; vx
   .db #0xF7   ; vy
   .dw #_sprite_shot ; sprite
   .dw #_sys_ai_behaviourAutoDestroy ;ai_behaviour
   .db #0x0B   ;ai_counter
   .dw #0x0000 ;animator
   .db #0x00   ;anim. counter


_playerLife_template_e:
   .db #0x10   ; type
   .db #0x01   ; cmp
   .db #0x00   ; x
   .db #0xC0   ; y
   .db #0x06   ; width
   .db #0x08   ; heigth
   .db #0x00   ; vx
   .db #0x00   ; vy
   .dw #_sprite_player01 ; sprite
   .dw #0x0000 ;ai_behaviour
   .db #0x00   ;ai_counter
   .dw #0x0000 ;animator
   .db #0x00   ;anim. counter

_player_template_e:
   .db #0x01   ; type
   .db #0x17   ; cmp
   .db #0x26   ; x
   .db #0xB0   ; y
   .db #0x06   ; width
   .db #0x08   ; heigth
   .db #0x00   ; vx
   .db #0x00   ; vy
   .dw #_sprite_player01 ; sprite
   .dw #0x0000 ;ai_behaviour
   .db #0x00   ;ai_counter
   .dw #_man_anim_player ;animator
   .db #0x10   ;anim. counter
