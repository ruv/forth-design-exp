
\ Simple REPL

: (q)
  SOURCE-ID IF BEGIN REFILL WHILE TRANSLATE-SOURCE-SURELY REPEAT EXIT THEN
  BEGIN ." q> " REFILL WHILE ." #> " TRANSLATE-SOURCE-SURELY ."  -- S: " .S CR REPEAT
;
: q
  ['] (q) CATCH DUP IF SL 0! THEN THROW
;




[DEFINED] N>R [IF]

\ Let's define one cool thing using the new text translator 'q'

q \ (!!!) it will work to the end of this file

: EXECUTE-EFFECT ( i*x xt -- j*x n ) DEPTH 1- >R EXECUTE DEPTH R> - ;

DEFAULT-MARKUP PUSH-CURRENT

  : P{ ( -- )
    STATE-LEVEL 0= -14 AND THROW \ "interpreting a compile-only word" \ STATE0 is not supported yet
    ':NONAME TT-LIT 'EXECUTE-EFFECT TT-XT 'N>R TT-XT
    INC-STATE
  ;

  : }P ( -- xt )
    STATE-LEVEL 2 < -22 AND THROW \ "control structure mismatch"
    DEC-STATE
    'NR> TT-XT 'DROP TT-XT '; TT-XT
  ;

DROP-CURRENT


\ test
: foo P{ LIT{ DUP }LIT . LIT{ 7 + }LIT }P ;    123 foo EXECUTE CR ( -- n ) \ should print 123 and return 130
130 = [IF] .( test passed! ) [ELSE] .( test failed! ) [THEN] CR

[THEN]
