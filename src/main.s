.include "cpctelera.h.s"

;;
;; Start of _DATA area 
;;  SDCC requires at least _DATA and _CODE areas to be declared, but you may use
;;  any one of them for any purpose. Usually, compiler puts _DATA area contents
;;  right after _CODE area contents.
;;
.area _DATA

.area _CODE

.globl cpct_disableFirmware_asm
;;
;; Métodos globales 
;;
.globl _m_game_init 
.globl _m_game_play

;;
;;MAIN
;;
_main::
   call	cpct_disableFirmware_asm

   call _m_game_init
   call _m_game_play




