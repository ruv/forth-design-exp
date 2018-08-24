\ rvm 2018-08-09

\ configure for SP-Forth
:NONAME ( -- flag )
  S" FORTH-SYS" ENVIRONMENT? DUP IF DROP S" SP-FORTH" COMPARE 0= THEN   CONSTANT
; EXECUTE system-spforth

:NONAME \ once init
  system-spforth IF
      S" [IF]" S" SFIND" EVALUATE IF DROP ELSE 2DROP
        S" lib/include/tools.f" INCLUDED
      THEN
  THEN
; EXECUTE

system-spforth [IF] VERSION 100000 U/ 4 = [IF]
  REQUIRE ANSI-FILE     lib/include/ansi-file.f
  REQUIRE /STRING       lib/include/string.f
[THEN] [THEN]



\ Some well known words
S" ./lib/kernel.compat.fth"               INCLUDED




\ Level 1 (minimal level of supporting)
S" ./interpreter-kernel.basic.fth"        INCLUDED

\ Level 2 - managing the interpreters
S" ./lib/control-flow.fth"                INCLUDED
S" ./lib/compiler.compat.fth"             INCLUDED
S" ./lib/combinator.fth"                  INCLUDED
S" ./interpreter-kernel.stdlib.fth"       INCLUDED

\ Level 3 - standard library
S" ./ttoken.stdlib.fth"                   INCLUDED
S" ./lib/string-match.fth"                INCLUDED
S" ./interpreter.stdlib.fth"              INCLUDED



\ Example definitions for some standard words
S" ./core.example.fth"                    INCLUDED

\ Example definitions for some well-known literals formats
S" ./lib/wordlist.fth"                    INCLUDED
S" ./common.example.fth"                  INCLUDED




\ Simple REPL
: (q)
  SOURCE-ID IF BEGIN REFILL WHILE TRANSLATE-SOURCE REPEAT EXIT THEN
  BEGIN ." q> " REFILL WHILE ." #> " TRANSLATE-SOURCE ."  -- S: " .S CR REPEAT
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
    STATE-LEVEL 1 <> -29 AND THROW \ "compiler nesting" \ we do not support another levels yet
    POSTPONE{ ':NONAME EXECUTE-EFFECT N>R }POSTPONE
    INC-STATE
  ;

  : }P ( -- xt )
    STATE-LEVEL 2 <> -22 AND THROW \ "control structure mismatch"
    DEC-STATE
    POSTPONE{ NR> DROP '; EXECUTE }POSTPONE
  ;

DROP-CURRENT


\ test
: foo P{ LIT{ DUP }LIT . LIT{ 7 + }LIT }P ;    123 foo EXECUTE CR ( -- n ) \ should print 123 and return 130
130 = [IF] .( test passed! ) [ELSE] .( test failed! ) [THEN] CR

[THEN]
