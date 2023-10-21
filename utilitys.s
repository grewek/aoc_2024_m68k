
;;Ascii Symbol To Integer 
;; Converts a given Character into it's corosponding value
;;  i.e. ('0' => 0) ('1' => 1) ('2' => 2)...('9' => 9)
;; Arguments:
;;      d6 -> Character to Convert
;; Returns:
;;      d7 -> Character Value (0xFFFFFFFF when the Character cannot be converted)
;;TODO: Does not handle Negative values :[
;;TODO: There is potential for optimization here and i should defenitly check what 
;;      could be done better as the aoc problems will be taxing enough without waiting for hours
;;      for the string conversion !
AsciiToInt:
  cmp.b            #$30,d6              ; Check value if it's below our threshold >= 0x30 '0'
  blt              .failure
  cmp.b            #$39,d6              ; Check value if it's below our threshold <= 0x39 '9'
  bgt              .failure
  .conversion:
  move.b           d6,d7
  subi.b           #$30,d7              ; Subtract the lowest Symbol of the Ascii Digit Table (0x30 '0') from our input
  rts                                   ; Done the result should be inside our d7 register
  .failure:
  move.l           #$FFFFFFFF,d7
  rts


ascii_to_int_tests:
  lea              zero,a0
  lea              result_zero,a1
  lea              end_of_checks,a3
.test_loop:
  move.b           (a0)+,d6
  move.b           (a1)+,d5
  jsr              AsciiToInt
  cmp.b            d5,d7
  bne              .failure
  cmp.l            a1,a3
  beq              .win
  jmp              .test_loop           ;This is fine for now but later on i should check if we reached the end of the testing range and just get the fuck out

.failure:
  nop
  jmp              .failure             ;Stuck here but there is a bug that needs fixing so that's good :)
  
.win:
  rts                                   ;Huge win everything was as expected AWESOME :D 


  section          "ASCII_DATA",data
  zero             : dc.b '0'
  one              : dc.b '1'
  two              : dc.b '2'
  three            : dc.b '3'
  four             : dc.b '4'
  five             : dc.b '5'
  six              : dc.b '6'
  seven            : dc.b '7'
  eight            : dc.b '8'
  nine             : dc.b '9'
  even

  inv_a            : dc.b 'a'

  result_zero      : dc.b 0
  result_one       : dc.b 1
  result_two       : dc.b 2
  result_three     : dc.b 3
  result_four      : dc.b 4
  result_five      : dc.b 5
  result_six       : dc.b 6
  result_seven     : dc.b 7
  result_eight     : dc.b 8
  result_nine      : dc.b 9
  result_inv       : dc.b $FFFFFFFF
  end_of_checks    : dc.b $FF
  even