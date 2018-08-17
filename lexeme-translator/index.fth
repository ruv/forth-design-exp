\ rvm 2018-08-09

\ configure for SP-Forth
:NONAME ( -- flag )
  CREATE  S" FORTH-SYS" ENVIRONMENT? DUP 0= IF , ELSE DROP S" SP-FORTH" COMPARE 0= , THEN  DOES> @
; EXECUTE system-spforth

:NONAME \ once init
  system-spforth IF
      S" [IF]" S" SFIND" EVALUATE IF DROP ELSE 2DROP
        S" lib/include/tools.f" INCLUDED
      THEN
  THEN
; EXECUTE



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
S" ./interpreter.stdlib.fth"              INCLUDED



\ Eexample definitions for some standard words
S" ./core.example.fth"                    INCLUDED
