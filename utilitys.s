
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
  cmp.b             #$30,d6                  ; Check value if it's below our threshold >= 0x30 '0'
  blt               .failure
  cmp.b             #$39,d6                  ; Check value if it's below our threshold <= 0x39 '9'
  bgt               .failure
  .conversion:
  move.b            d6,d7
  subi.b            #$30,d7                  ; Subtract the lowest Symbol of the Ascii Digit Table (0x30 '0') from our input
  rts                                        ; Done the result should be inside our d7 register
  .failure:
  move.l            #$FFFFFFFF,d7
  rts

;;String to Value
;; Converts a given string into it's corosponding value, depends on AsciiToInt
;; Arguments:
;;  a7 -> String Pointer
;; Returns:
;;  d6 -> Value
;;  d7 -> Count Characters Consumed
StringToValue:
  clr.l             d2
  clr.l             d5
  move.b            #10,d2
.iter:
  clr.l             d7
  move.b            (a0)+,d6
  jsr               AsciiToInt
  cmp.l             #$FFFFFFFF,d7
  beq               .end
  ;; Naaahh 38-70 Cycles for a mulu instruction is not gonna fly here...we only have a few mhz available

  mulu              d2,d5 
  add.l             d7,d5
  jmp               .iter
.end:
  rts

ascii_to_int_tests:
  lea               zero,a0
  lea               result_zero,a1
  lea               end_of_checks,a3
.test_loop:
  move.b            (a0)+,d6
  move.b            (a1)+,d5
  jsr               AsciiToInt
  cmp.b             d5,d7
  bne               .failure
  cmp.l             a1,a3
  beq               .win
  jmp               .test_loop               ;This is fine for now but later on i should check if we reached the end of the testing range and just get the fuck out

.failure:
  nop
  jmp               .failure                 ;Stuck here but there is a bug that needs fixing so that's good :)
  
.win:
  rts                                        ;Huge win everything was as expected AWESOME :D 


string_to_value_tests:
  lea               value_ex_mixed,a0
  jsr               StringToValue
  move.l            #12349,d1
  jsr               .check_values
  
  lea               value_ex_tst_a,a0
  jsr               StringToValue
  move.l            #1,d1
  jsr               .check_values

  lea               value_ex_tst_b,a0
  jsr               StringToValue
  move.l            #10,d1
  jsr               .check_values

  lea               value_ex_tst_c,a0
  jsr               StringToValue
  move.l            #100,d1
  jsr               .check_values

  lea               value_ex_tst_d,a0
  jsr               StringToValue
  move.l            #1000,d1
  jsr               .check_values

  lea               value_ex_tst_e,a0
  jsr               StringToValue
  move.l            #10000,d1
  jsr               .check_values

  lea               value_ex_tst_f,a0
  jsr               StringToValue
  move.l            #100000,d1
  jsr               .check_values

  lea               value_ex_tst_g,a0
  jsr               StringToValue
  move.l            #1000000,d1
  jsr               .check_values

  lea               value_ex_tst_h,a0
  jsr               StringToValue
  move.l            #10000000,d1
  jsr               .check_values

  lea               value_ex_tst_i,a0
  jsr               StringToValue
  move.l            #10000000,d1
  jsr               .check_values

  jmp .huge_win

.failure:
  nop
  jmp               .failure
  rts
  jmp               string_to_value_tests

.huge_win:
  rts

.check_values:  
  cmp.w             d1,d5
  bne               .failure
  clr.l             d1
  rts


  section           "ASCII_DATA",data
  zero              : dc.b '0'
  one               : dc.b '1'
  two               : dc.b '2'
  three             : dc.b '3'
  four              : dc.b '4'
  five              : dc.b '5'
  six               : dc.b '6'
  seven             : dc.b '7'
  eight             : dc.b '8'
  nine              : dc.b '9'
  even

  inv_a             : dc.b 'a'

  result_zero       : dc.b 0
  result_one        : dc.b 1
  result_two        : dc.b 2
  result_three      : dc.b 3
  result_four       : dc.b 4
  result_five       : dc.b 5
  result_six        : dc.b 6
  result_seven      : dc.b 7
  result_eight      : dc.b 8
  result_nine       : dc.b 9
  result_inv        : dc.b $FFFFFFFF
  end_of_checks     : dc.b $FF
  even

  value_ex_mixed    : dc.b "12349",0
  even
  value_ex_tst_a    : dc.b "1",0
  even
  value_ex_tst_b    : dc.b "10",0
  even
  value_ex_tst_c    : dc.b "100",0
  even
  value_ex_tst_d    : dc.b "1000",0
  even
  value_ex_tst_e    : dc.b "10000",0
  even
  value_ex_tst_f    : dc.b "100000",0
  even
  value_ex_tst_g    : dc.b "1000000",0
  even
  value_ex_tst_h    : dc.b "10000000",0
  even
  value_ex_tst_i    : dc.b "100000000",0
  even

  even