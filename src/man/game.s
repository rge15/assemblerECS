


;===================================================================================================================================================
; CPCTelera functions
;===================================================================================================================================================

.globl cpct_waitHalts_asm
.globl cpct_waitVSYNC_asm
.globl cpct_memcpy_asm


;===================================================================================================================================================
; Public functions
;===================================================================================================================================================
.globl _man_entityInit
.globl _man_createEntity
.globl _man_entityUpdate
.globl _sys_physics_update
.globl _sys_render_update
.globl _sys_animator_update
.globl _sys_init_render
.globl _sys_ai_update
.globl _sys_ai_behaviourLeftRight
.globl _sys_ai_behaviourMothership


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
  

;===================================================================================================================================================
; Templates
;===================================================================================================================================================
_mothership_template_e:
   .db #0x0B   ; type
   .db #0x26   ; x
   .db #0x0A   ; y
   .db #0x04   ; width
   .db #0x06   ; heigth
   .db #0xFF   ; vx
   .db #0x00   ; vy
   .dw #_sprite_mothership ; sprite
   .dw #_sys_ai_behaviourMothership ;ai_behaviour
   .dw #0x0000 ;animator
   .db #0x00   ;anim. counter

_enemy_template_e:
   .db #0x0B   ; type
   .db #0x26   ; x
   .db #0x1E   ; y
   .db #0x06   ; width
   .db #0x06   ; heigth
   .db #0x01   ; vx
   .db #0x00   ; vy
   .dw #_sprite_enemy ; sprite
   .dw #_sys_ai_behaviourLeftRight ;ai_behaviour
   .dw #0x0000 ;animator
   .db #0x00   ;anim. counter


_playerLife_template_e:
   .db #0x01   ; type
   .db #0x00   ; x
   .db #0xC0   ; y
   .db #0x06   ; width
   .db #0x08   ; heigth
   .db #0x00   ; vx
   .db #0x00   ; vy
   .dw #_sprite_player01 ; sprite
   .dw #0x0000 ;ai_behaviour
   .dw #0x0000 ;animator
   .db #0x00   ;anim. counter

_player_template_e:
   .db #0x17   ; type
   .db #0x26   ; x
   .db #0xB0   ; y
   .db #0x06   ; width
   .db #0x08   ; heigth
   .db #0x00   ; vx
   .db #0x00   ; vy
   .dw #_sprite_player01 ; sprite
   .dw #0x0000 ;ai_behaviour
   .dw #_man_anim_player ;animator
   .db #0x10   ;anim. counter



;===================================================================================================================================================
; Manager data
;===================================================================================================================================================
_enemyOnLane:
   .db #0x00

;===================================================================================================================================================
; FUNCION _m_game_createInitTemplate   
; Crea la entidad con el template indicado
; BC : Valor de template a crear
;===================================================================================================================================================
_m_game_createInitTemplate::
   call _man_createEntity
   push hl
   ex de,hl
   ld h, b
   ld l, c
   ld bc,#0x000E
   call cpct_memcpy_asm
   pop hl
   ret


;===================================================================================================================================================
; FUNCION _m_game_init   
; Inicializa el juego y sus entidades
; NO llega ningun dato
;===================================================================================================================================================
_m_game_init::
   call  _sys_init_render
   call  _man_entityInit


   ; Create MotherBoard
   ld bc, #_mothership_template_e   
   call _m_game_createInitTemplate

   ; Create Lifes
   ld a,#0x0F
   createLife:
   push af
   ld bc, #_playerLife_template_e
   call _m_game_createInitTemplate
   inc hl
   pop af
   ld (hl), a

   sub #0x05
   jr NZ, createLife

   ; CreatePlayer
   ld bc, #_player_template_e
   call _m_game_createInitTemplate
ret


;===================================================================================================================================================
; FUNCION _m_game_play   
; Bucle del juego
; NO llega ningun dato
;===================================================================================================================================================
_m_game_play::
   updates:
      call _sys_ai_update
      call _sys_physics_update
      call _sys_animator_update
      call _sys_render_update
      
      call _man_entityUpdate
      call _wait
   jr updates

ret

;===================================================================================================================================================
; FUNCION _m_game_createEnemy   
; Crea un enemigo
; NO llega ningun dato
;===================================================================================================================================================
_m_game_createEnemy::
   ld hl, #_enemyOnLane
   dec (hl)
   inc (hl)
   ret NZ
   inc (hl)

   ; Create Enemy
   ld bc, #_enemy_template_e   
   call _m_game_createInitTemplate   
   
   ret

;===================================================================================================================================================
; FUNCION _wait   
; Espera un tiempo antes de realizar otra iteracion del bucle de juego
; NO llega ningun dato
;===================================================================================================================================================

_wait::
   ld h, #0x05
      waitLoop:
         ld b, #0x02
         call cpct_waitHalts_asm
         call cpct_waitVSYNC_asm
         dec h
         jr NZ, waitLoop
   ret