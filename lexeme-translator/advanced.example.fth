
\ Simple REPL

VARIABLE ASSEMBLING

: (q)
  SOURCE-ID IF BEGIN TRANSLATE-SOURCE-SURELY REFILL 0= UNTIL EXIT THEN
  BEGIN ." #> " TRANSLATE-SOURCE-SURELY ."  -- S: " .S CR ." q> " REFILL 0= UNTIL
;
: q
  ['] (q) CATCH DUP IF SL 0! ASSEMBLING 0! THEN THROW
;



q \ (!!!) it will work to the end of this file
\ NB: don't cross [IF] ... [THEN]

[DEFINED] N>R [IF]

\ Let's define one cool thing using the new text translator 'q'


: NEXT-LEXEME ( -- addr u|0 )
  BEGIN PARSE-NAME ?ET ( addr ) REFILL ?E0 DROP AGAIN
;
: TEST-LEXEME-MARKUP-CURLY ( d-txt-lexeme -- d-txt-lexeme n )
  2DUP `}   STARTS-WITH   IF -1 ELSE
  2DUP `{   ENDS-WITH     IF  1 ELSE
    0 EXIT
  THEN THEN ( d-txt-lexeme n )
  2 PICK 2 PICK MARKUP @ SEARCH-WORDLIST NIP ?E0
;
: TRANSLATE-INPUT-TILL-CURLY ( i*x d-txt-lexeme -- j*x )
  2>R 1 >R BEGIN NEXT-LEXEME DUP WHILE
    TEST-LEXEME-MARKUP-CURLY R> + 0 =? IF 2R> EQUALS ?E -22 THROW THEN >R
    TRANSLATE-LEXEME ?NF ?STACK
  REPEAT -22 THROW \ control structure mismatch
;


: (CONCEIVE) ( -- i*x i )
  ASSEMBLING DUP @ 0<>  -29 AND THROW 1+! \ "compiler nesting"
  ':NONAME EXECUTE-BALANCE
;
: (BIRTH) ( i*x i -- xt )
  ASSEMBLING DUP @ 0=   -22 AND THROW 1-! \ "control structure mismatch"
  DROP POSTPONE ;
;

DEFAULT-MARKUP PUSH-CURRENT

  : lit{}   GET-CURRENT::lit{   GET-CURRENT::}lit   ;
  : call{}  GET-CURRENT::call{  GET-CURRENT::}call  ;

  : p{ ( -- )
    STATE-LEVEL 0= -14 AND THROW \ "interpreting a compile-only word"
    '(CONCEIVE) TT-XT 'N>R TT-XT
    INC-STATE
  ;

  : }p ( -- xt )
    STATE-LEVEL 2 < -22 AND THROW \ "control structure mismatch"
    DEC-STATE
    'NR> TT-XT '(BIRTH) TT-XT
  ;

  \ Redefine 'p{' to support STATE0
  : p{
    STATE-LEVEL IF GET-CURRENT::p{ EXIT THEN
    p{ direct{ `}p TRANSLATE-INPUT-TILL-CURLY }direct }p
  ;

DROP-CURRENT


\ test
CR .( # --- Testing of p{ ... }p markup ) CR
: foo p{ lit{ DUP }lit . lit{ 7 + }lit }p ;    123 foo EXECUTE CR ( -- n ) \ should print 123 and return 130
130 = [IF] .( test passed! ) [ELSE] .( test failed! ) [THEN] CR

456 p{ lit{} . ." test2 passed" CR }p EXECUTE

[THEN]
