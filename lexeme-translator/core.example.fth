\ rvm 2018-08-09

\ Definitons of some standard words via the lexeme resolver mechanism

\ Print a note to explain warnings regarding redefinitions
CR .( # --- Example definitions for some standard words ) CR

: S"        ( " name" -- i*x  )   [CHAR] " PARSE TT-SLIT ; IMMEDIATE
: '         ( " name" -- xt   )   PARSE-NAME RESOLVE-NATIVE ?NF  ;
: [']       ( " name" -- xt | )   '    TT-LIT ; IMMEDIATE
: [COMPILE] ( " name" --      )   '    TT-XT  ; IMMEDIATE
: POSTPONE  ( " name" --      )   PARSE-NAME INC-STATE TRANSLATE-LEXEME DEC-STATE ?NF ; IMMEDIATE


[DEFINED] TT-NT [IF]

\ Example of more clever tick "'" word
\ See: http://amforth.sourceforge.net/pr/Recognizer-rfc-D.html#and

: TOKEN-XT? ( k*x tt -- xt true | k*x tt false )
  ['] TT-XT     =? ?ET
  ['] TT-WORD   =? IF DROP TRUE EXIT THEN
  ['] TT-NT     =? IF NAME>INTERPRET TRUE EXIT THEN
  FALSE
;

: '         ( " name" -- xt   )
  PARSE-NAME RESOLVE-LEXEME TOKEN-XT? IF EXIT THEN ?NF ( k*x ) -32 THROW \ "invalid name argument"
;

[THEN]
