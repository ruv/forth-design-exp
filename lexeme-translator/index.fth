\ rvm 2018-08-09

\ configure for SP-Forth
:NONAME \ once init
  S" FORTH-SYS" ENVIRONMENT? IF
    S" SP-FORTH" COMPARE 0= IF
      S" [IF]" SFIND IF DROP ELSE 2DROP
        S" lib\include\tools.f" INCLUDED
      THEN
    THEN
  THEN
; EXECUTE



\ Some well known words
S" ./lib/kernel.compat.fth"               INCLUDED




\ Level 1 (minimal level of supporting)
S" ./iterpreter-kernel.basic.fth"         INCLUDED

\ Level 2 - managing the interpreters
S" ./lib/compiler.compat.fth"             INCLUDED
S" ./lib/combinator.fth"                  INCLUDED
S" ./iterpreter-kernel.stdlib.fth"        INCLUDED
