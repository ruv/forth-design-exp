
\ Let's use tick prefix to quote a single word.
\ E.g. in place of ['] XXX inside definitons or ' XXX outside definitions
\ just always use 'XXX
: I-NATIVE-QUOTED ( c-addr u -- c-addr u 0 | xt tt-lit )
  [CHAR] ' MATCH-HEAD-CHAR ?E0 I-NATIVE IF ['] TT-LIT EXIT THEN -1 CHARS /STRING  0
;

\ Let's support character literals in form 'x'
: I-CHAR-FORM-TICK ( c-addr u -- c-addr u 0 | xt tt-slit )
  DUP 3 CHARS = ?E0
  [CHAR] ' MATCH-TAIL-CHAR ?E0
  [CHAR] ' MATCH-HEAD-CHAR IF DROP C@ ['] TT-LIT EXIT THEN CHAR+ 0
;

\ Let's support strings literals in form "abc def" (on single line, in SOURCE)
: I-STRING-SOURCE ( c-addr u -- c-addr u 0 | xt tt-slit )
  [CHAR] " MATCH-HEAD-CHAR ?E0
  [CHAR] " MATCH-TAIL-CHAR IF ['] TT-SLIT EXIT THEN
  DROP \ ensure that (c-addr) inside SOURCE
  DUP SOURCE OVER + WITHIN 0= IF -11 THROW THEN \ "result out of range"
  [CHAR] " PARSE + OVER - ['] TT-SLIT
;



: I-LITERAL-COMMON
  I-NATIVE-QUOTED       ?ET
  I-CHAR-FORM-TICK      ?ET
  I-STRING-SOURCE       ?ET
  FALSE
; ' I-LITERAL-COMMON ENQUEUE-INTERPRETER
