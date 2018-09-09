\ rvm 2006, 2007, 2018,

\ Explanations and illustrations


\ This file can be included after ../lexeme-translator/index.fth
q \ To support the new lexeme resolvers during translation of this file

WORDLIST DUP CONSTANT approach1 PUSH-DEVELOP


(
  The following slightly longer TT-* definitions,
  that use CASE-like testing of the level,
  are still useful for illustration how they work.
)

DEFER TT-LIT  ' TT-LIT ( xt-defer-tt-lit )

\ "execution token" translator
: TT-XT ( i*x xt -- j*x | i*x )
  STATE-LEVEL
  0 =? IF EXECUTE EXIT THEN
  1 =? IF COMPILE, EXIT THEN
  2 =? IF LIT,  'COMPILE, COMPILE, EXIT THEN
  DROP DEC-STATE  TT-LIT  'COMPILE, RECURSE  INC-STATE
;
\ single-cell number translator (the token for a number is this number itself)
: TT-LIT ( i*x -- i*x | )
  STATE-LEVEL
  0 =? IF EXIT THEN
  1 =? IF LIT, EXIT THEN
  2 =? IF LIT, 'LIT, COMPILE, EXIT THEN
  DROP DEC-STATE  RECURSE  'LIT, TT-XT  INC-STATE
;

( xt-defer-tt-lit ) ' TT-LIT SWAP DEFER!

(
  Evidently, the last line in these TT-* definitions
  correctly handles the cases of level 1 and level 2 by themself.

  Using the corresponding names in place of RECURSE keyword,
  we can express this line as the following:

  - for TT-XT word:
    DEC-STATE  TT-LIT  'COMPILE,  TT-XT  INC-STATE

  - for TT-LIT word:
    DEC-STATE  TT-LIT  'LIT,      TT-XT  INC-STATE
)

(
  Translating the tokens for literals can be easy made general.
)

\ generalisation of literal token translator
: TT-LITERAL-WITH ( i*x xt -- i*x | )
  STATE-LEVEL
  0 =? IF DROP EXIT THEN
  1 =? IF EXECUTE EXIT THEN
  2 =? IF DUP >R EXECUTE R> COMPILE, EXIT THEN
  DROP DEC-STATE  DUP >R RECURSE  R> TT-XT  INC-STATE
;

\ Usage example
: TT-2LIT   ( x x   -- x x    | )   '2LIT,  TT-LITERAL-WITH ;
: TT-SLIT   ( d-txt -- d-txt  | )   'SLIT,  TT-LITERAL-WITH ;


\ One interesting side effect of this approach is that a resolver
\ for the new literals can return just a compiler for this literals
\ and TT-LITERAL-WITH
\ For example:
\ RESOLVE-3N ( addr u -- 3*x '3LIT, 'TT-LITERAL-WITH | addr u 0 )
\ where "'3LIT," is defined as ": 3LIT, >R 2LIT, R> LIT, ;"
\ and can be even a quotation.


DROP-DEVELOP




WORDLIST DUP CONSTANT approach2 PUSH-DEVELOP

(
  Even without extra cases 1 and 2, the basic definitions can still
  be a little bit simplified, if the level will be pass as the top argument.
)

DEFER TTS-LIT  ' TTS-LIT ( xt-defer-tts-lit )

\ Translate a given "execution token" according a given level
: TTS-XT ( i*x xt s -- i*x | j*x )
  DUP 0= IF DROP EXECUTE EXIT THEN
  1- DUP >R  TTS-LIT  'COMPILE, R> RECURSE
;
\ Translate a given number according a given level
: TTS-LIT ( x s -- x | )
  DUP 0= IF DROP EXIT THEN
  1- DUP >R  RECURSE  'LIT, R> TTS-XT
;

( xt-defer-tts-lit ) ' TTS-LIT SWAP DEFER!

\ A helper for all literlas
: TTS-LITERAL-WITH ( x xt s -- x | )
  0 =? IF DROP EXIT THEN
  1- 2DUP 2>R  RECURSE  2R> TTS-XT
;

(
  Sometimes these words can be useful, e.g. to postpone the translating themeself,
  but in the most cases we need to translate the tokens according the current state.
  So, let's define the conventional TT-* words via the defined factors.
)

\ "execution token" translator
: TT-XT ( i*x xt -- j*x | i*x )         STATE-LEVEL TTS-XT ;

\ a helper for all literlas
: TT-LITERAL-WITH ( i*x xt -- i*x | )   STATE-LEVEL TTS-LITERAL-WITH ;

\ translators for some standard literals
: TT-2LIT   ( x x   -- x x    | )   '2LIT,  TT-LITERAL-WITH ;
: TT-SLIT   ( d-txt -- d-txt  | )   'SLIT,  TT-LITERAL-WITH ;


DROP-DEVELOP




CR .( NB: approach1 and approach2 wordlists have been added ) CR
