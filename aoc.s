;------------------------------
; Example inspired by Photon's Tutorial:
;  https://www.youtube.com/user/ScoopexUs
;
;---------- Includes ----------
              INCLUDE "utilitys.s"
;---------- Const ----------

CIAA            = $00bfe001
COPPERLIST_SIZE = 1000                                   ;Size of the copperlist
LINE            = 100                                    ;<= 255

init:
              move.w        #1,d0                        ;TODO: Build the Solutions
******************************************************************	
mainloop:
              nop
              jmp           mainloop                     ;TODO: :]
