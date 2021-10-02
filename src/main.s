.include "cpctelera.h.s"

;;
;; Start of _DATA area 
;;  SDCC requires at least _DATA and _CODE areas to be declared, but you may use
;;  any one of them for any purpose. Usually, compiler puts _DATA area contents
;;  right after _CODE area contents.
;;
.area _DATA

.area _CODE

.globl cpct_getScreenPtr_asm
.globl cpct_setDrawCharM1_asm
.globl cpct_drawStringM1_asm
.globl cpct_memcpy_asm
.globl cpct_waitHalts_asm
.globl cpct_waitVSYNC_asm
;;
;; Métodos globales 
;;
.globl _man_entityInit
.globl _man_createEntity
.globl _sys_physics_update
.globl _sys_render_update
.globl _sys_init_render
.globl _man_entityUpdate
.globl _sys_gen_update


;;
;;MAIN
;;
_main::
   call _sys_init_render

   call  _man_entityInit
   ;;Destroyed : A & BC & DE && HL
   updates:
      call _sys_physics_update
      call _sys_gen_update    
      call _sys_render_update
      
      call _man_entityUpdate
      call _wait
   jr updates




; ;
; ;WAIT
; ;
_wait::
   ld h, #0x05
      waitLoop:
         ld b, #0x02
         call cpct_waitHalts_asm
         call cpct_waitVSYNC_asm
         dec h
         jr NZ, waitLoop
   ret