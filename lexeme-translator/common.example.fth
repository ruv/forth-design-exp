\ rvm 2007, 2018-08-16

\ Let's use tick prefix to quote a single word.
\ E.g. in place of ['] XXX inside definitons or ' XXX outside definitions
\ just always use 'XXX
: RESOLVE-NATIVE-QUOTED ( c-addr u -- c-addr u 0 | xt tt-lit )
  [CHAR] ' MATCH-HEAD-CHAR ?E0 RESOLVE-NATIVE IF ['] TT-LIT EXIT THEN -1 CHARS /STRING  0
;

\ Let's support single lexeme string in form `abc
: RESOLVE-SLIT-SHORT ( c-addr u -- c-addr u 0 | xt tt-slit )
  DUP 1 CHARS > ?E0  [CHAR] ` MATCH-HEAD-CHAR ?E0  ['] TT-SLIT
;

\ Let's support character literals in form 'x'
: RESOLVE-CHAR-TICK ( c-addr u -- c-addr u 0 | xt tt-slit )
  DUP 3 CHARS = ?E0
  [CHAR] ' MATCH-TAIL-CHAR ?E0
  [CHAR] ' MATCH-HEAD-CHAR IF DROP C@ ['] TT-LIT EXIT THEN CHAR+ 0
;

\ Let's support strings literals in form "abc def" (on single line, in SOURCE)
: RESOLVE-STRING-SOURCE ( c-addr u -- c-addr u 0 | xt tt-slit )
  [CHAR] " MATCH-HEAD-CHAR ?E0
  [CHAR] " MATCH-TAIL-CHAR IF ['] TT-SLIT EXIT THEN
  DROP \ ensure that (c-addr) inside SOURCE
  DUP  SOURCE DROP  DUP >IN @ + 1+  WITHIN 0= IF -11 THROW THEN \ "result out of range"
  [CHAR] " PARSE + OVER - ['] TT-SLIT
;





\ Let's involve the "markup words" that form a markup language.
\ These words are always executed immediately independent on mode (state),
\ so they will have a parsing-only action.

\ The designated wordlist for markup words.
\ - the variable for current markup wordlist
VARIABLE MARKUP
\ - the default markup
WORDLIST DUP CONSTANT DEFAULT-MARKUP MARKUP !

\ Resolver for the markup words
: RESOLVE-MAKRUP-IMMEDIATE ( c-addr u -- c-addr u 0 | tt-noop )
  MARKUP @ OBEY ?E0 ['] TT-NOOP
;

\ That is all.



\ Now let's add the well known ']]' and '[[' words as markup words,
\ and also add they synonymes: POSTPONE{  }POSTPONE
\
DEFAULT-MARKUP PUSH-CURRENT

  : ]]        INC-STATE ;   : [[        DEC-STATE ;
  \ synonymes for readability
  : POSTPONE{ INC-STATE ;   : }POSTPONE DEC-STATE ;
  : DIRECT{   DEC-STATE ;   : }DIRECT   DEC-STATE ;

  \ postpone{ ... direct{ ... }direct ... }postpone

  \ NB: standard '[' and ']' words will be postponed
  \ if they are used inside postpone{ }postpone
  \ Moreover, they will be postponed on different level
  \ due to they different immediacy.

  \ Also the immediate parsing words can be executed (and do parsing)
  \ or postponed depending on the current level. So it is better to avoid
  \ using of the parsing words at all inside postpone{ }postpone
  \ if you are not sure.


  \ Yet more sugar

  : CALL{ DEC-STATE ;   : }CALL ( xt | -- ) ['] COMPILE,  TT-XT  INC-STATE ;
  : LIT{  DEC-STATE ;   : }LIT  ( x  | -- ) ['] LIT,      TT-XT  INC-STATE ;

  \ Example:
  \ lit{ 50 20 * }lit
  \ : foo lit{ 10 20 + }lit . ; foo
  \ call{ ( some calculations or just ) '; }call

  \ Comments also should be mentioned here.
  \ They should not be postponed inside postpone{ }postpone
  \ but immediately executed.
  : \  POSTPONE \  ;
  : (  POSTPONE (  ;

DROP-CURRENT


\ The markup words can not be "ticket" or postponed in usual way.
\ They work but absent in the search order context.
\ To manage these words the MARKUP wordlist should be used.

\ Markup words shell not be shadowed by any other words.
\ So, let's put their resolver into the head of chain.
' RESOLVE-MAKRUP-IMMEDIATE PREEMPT-RESOLVER




: RESOLVE-LITERAL-COMMON
  RESOLVE-NATIVE-QUOTED     ?ET
  RESOLVE-SLIT-SHORT        ?ET
  RESOLVE-CHAR-TICK         ?ET
  RESOLVE-STRING-SOURCE     ?ET
  FALSE
; ' RESOLVE-LITERAL-COMMON ENQUEUE-RESOLVER
