;===================================================================================================================================================
; CPCTelera functions
;===================================================================================================================================================
.globl cpct_waitHalts_asm
.globl cpct_waitVSYNC_asm
.globl cpct_memcpy_asm

;===================================================================================================================================================
; Includes
;===================================================================================================================================================
.include "resources/macros.s"

;===================================================================================================================================================
; Public functions
;===================================================================================================================================================
.globl _man_entityInit
.globl _man_entityDestroy
.globl _man_entityUpdate
.globl _man_createEntity
.globl _sys_physics_update
.globl _sys_init_render
.globl _sys_render_update
.globl _sys_animator_update
.globl _sys_ai_update


;===================================================================================================================================================
; Templates
;===================================================================================================================================================
.globl _player_template_e
.globl _mothership_template_e
.globl _enemy_template_e
.globl _playerLife_template_e
.globl _shot_template_e


;===================================================================================================================================================
; Manager data
;===================================================================================================================================================
_enemyOnLane:
   .db #0x00

_m_playerShot:
   .db #0x00

_m_playerEntity:
   .dw #0x0000
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
   ld bc,#0x0010
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
   CREATE_ENTITY_FROM_TEMPLATE _mothership_template_e

   ; Create Lifes
   ld a,#0x0F
   createLife:
   push af

   CREATE_ENTITY_FROM_TEMPLATE _playerLife_template_e
   inc hl
   inc hl
   pop af
   ld (hl), a

   sub #0x05
   jr NZ, createLife

   ; CreatePlayer
   CREATE_ENTITY_FROM_TEMPLATE _player_template_e
   ex de,hl
   ld hl, #_m_playerEntity
   ld (hl), d
   inc hl
   ld (hl), e
   ex de,hl
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
   CREATE_ENTITY_FROM_TEMPLATE _enemy_template_e

   ret


;===================================================================================================================================================
; FUNCION _m_game_destroyEntity
; Funcion que destruye la entidad indicada
; HL : Llega el valor de la entidad
;===================================================================================================================================================
_m_game_destroyEntity::
   push hl
   ld a,(hl)
   and #0x08
   jr Z, notBullet

   ld hl,#_m_playerShot
   dec (hl)

   notBullet:
   pop hl
   call _man_entityDestroy
   ret


;===================================================================================================================================================
; FUNCION _m_game_playerShot
; Funcion que dispara si puede
; NO llega nada
;===================================================================================================================================================
_m_game_playerShot::
   ; Create Shot

   ld hl,#_m_playerShot
   dec (hl)
   inc (hl)
   ret NZ

   ld bc, #_shot_template_e   
   call _m_game_createInitTemplate

   inc hl
   inc hl      ;; HL lo subo a x del shoot
   ex de,hl

   ld hl, #_m_playerEntity ;; Recojo la posicion de la entidad jugador
   ld b,(hl)
   inc hl
   ld c,(hl)
   ld h,b
   ld l,c
   inc hl
   inc hl  ;; Una vez obtenida la direccion del inicio del jugador, cojo si x y le sumo 2 y se la guardo al shoot
   ld a,(hl)
   add #0x02
   ex de,hl
   ld (hl),a

   ld hl,#_m_playerShot
   inc (hl)

   ret



;===================================================================================================================================================
; FUNCION _m_game_tryDownEnemy
; Funcion que intenta bajar a un enemigo de carril
; HL : Llega el valor de la entidad
;===================================================================================================================================================
_m_game_tryDownEnemy::
   ;;TODO : No lo hago por ahorrar tiempo
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