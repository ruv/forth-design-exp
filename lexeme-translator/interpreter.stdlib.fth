\ rvm 2006, 2007, 2018-08-09

\ A useful factor.
\ Return control to the calling definition if the top value is not zero,
\ otherwise drop the top value (that is zero).
: ?ET ( 0 -- | x -- x ) \ Exit on True returning this true
  POSTPONE DUP POSTPONE IF POSTPONE EXIT POSTPONE THEN POSTPONE DROP
; IMMEDIATE



\ Interpreters for the common literals

: I-NUM-DU ( c-add u -- x x tt | c-add u 0 ) \ double cell number simple
  2DUP 0 0 2SWAP >NUMBER NIP IF 2DROP 0 EXIT THEN 2NIP ['] TT-2LIT
;
: I-NUM-U ( c-add u -- x tt | c-add u 0 ) \ single cell number simple
  I-NUM-DU DUP IF 2DROP ['] TT-LIT THEN
;
: I-NUM-DU-FORM-DOT ( c-add u -- x x tt | c-add u 0 ) \ double number with trailing dot
  DUP 2 CHARS U< IF  0 EXIT THEN
  2DUP + CHAR- C@ [CHAR] . =
  IF  CHAR- I-NUM-DU ?ET CHAR+  THEN  0
;
[DEFINED] TT-FLIT   [IF]
[DEFINED] >FLOAT    [IF]
: I-FLOAT-FORM-E ( c-addr u -- tt | c-addr u 0 ) \ float number in 'E' format
  2DUP >FLOAT IF 2DROP ['] TT-FLIT EXIT THEN  0
;
[THEN] [THEN]



\ A helper to use the old fashioned stanard FIND word.
\ Retun the given string as counted string in PAD buffer.
: CARBON-COUNTED-PAD ( c-addr u -- c-addr2 )
  DUP 82 > IF -19 THROW THEN \ PAD buffer is 84 characters at least
  DUP PAD C! PAD CHAR+ SWAP MOVE PAD
;

\ Interpret a lexem as Forth word,
\ represent the result as "execution token" xt and immediate flag
: I-WORD ( c-addr u -- xt imm-flag tt | c-addr u 0 )
  2DUP CARBON-COUNTED-PAD FIND 0 =? IF DROP FALSE EXIT THEN 2NIP ( xt flag )
  1 = ['] TT-WORD
;

\ Interpret a lexem as Forth word,
\ represent the result as "execution token" xt
\ The immediate flag is ignored (if any).
: I-NATIVE ( c-addr u -- xt tt | c-addr u 0 )
  I-WORD DUP IF 2DROP ['] TT-XT THEN
;


[DEFINED] TT-NT     [IF]
[DEFINED] FIND-NAME [IF] \ find-name ( c-addr u -- nt|0 )
\ Interpret a lexem as Forth word,
\ represent the result as "name token" nt
: I-NATIVE-NT ( c-addr u -- nt tt | c-addr u 0 )
  2DUP FIND-NAME DUP IF NIP NIP ['] TT-NT EXIT THEN
;
[THEN] [THEN]






\ A mechanism for chaining the interpreters is not fixed yet.
\ Any data structure can be used as well as just a code.
\ The one simplest variant is following.


: I-NUMBER-ANY ( c-add u -- i*x tt | c-add u 0 )
  I-NUM-DU-FORM-DOT  ?ET
  I-NUM-U            ?ET
  FALSE
;

: I-LEXEM-DEFAULT ( c-add u -- i*x tt | c-add u 0 )
  I-WORD             ?ET
  I-NUMBER-ANY       ?ET
  FALSE
;

\ Set initial interpreter

' I-LEXEM-DEFAULT SET-INTERPRETER
