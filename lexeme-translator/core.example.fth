\ rvm 2018-08-09

\ Definitons of some standard words via the lexeme interpreter mechanism

\ Print a note to explain warnings regarding redefinitions
CR .( # --- Example definitions for some standard words ) CR

: S"        ( " name" -- i*x  )   [CHAR] " PARSE TT-SLIT ; IMMEDIATE
: '         ( " name" -- xt   )   PARSE-NAME I-NATIVE ?NF  ;
: [']       ( " name" -- xt | )   '                       TT-LIT ; IMMEDIATE
: [COMPILE] ( " name" --      )   '                       TT-XT  ; IMMEDIATE
: POSTPONE  ( " name" --      )   PARSE-NAME INC-STATE T-LEXEME DEC-STATE ?NF ; IMMEDIATE
