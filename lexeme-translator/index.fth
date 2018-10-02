\ rvm 2018-08-09

\ configure for SP-Forth v4.*
:NONAME ( -- flag-spforth-v4 flag-spforth )
  S" FORTH-SYS" ENVIRONMENT? DUP IF DROP S" SP-FORTH" COMPARE 0= THEN
  DUP IF S" VERSION" EVALUATE  100000 / 4 = ELSE 0 THEN  SWAP  \ NB: U/ is unstandard word
; EXECUTE  CONSTANT system-spforth  CONSTANT system-spforth-v4

system-spforth-v4 CHAR | AND PARSE | : REQUIRE-WORD REQUIRE ; REQUIRE-WORD [IF] lib/include/tools.f
2DROP
system-spforth-v4 [IF]
  REQUIRE-WORD ANSI-FILE     lib/include/ansi-file.f
  REQUIRE-WORD /STRING       lib/include/string.f
  REQUIRE-WORD DEFER!        lib/include/defer.f
  REQUIRE-WORD NAME>COMPILE  lib/include/wordlist-tools.f
[THEN]



\ Some well known words
S" ./lib/kernel.compat.fth"               INCLUDED




\ Level 1 (minimal level of supporting)
S" ./resolver.api.L1.fth"                 INCLUDED

\ Level 2 - managing the resolvers
S" ./lib/control-flow.fth"                INCLUDED
S" ./lib/compiler.compat.fth"             INCLUDED
S" ./lib/combinator.fth"                  INCLUDED
S" ./lib/stack-effect.fth"                INCLUDED
S" ./resolver.api.L2.fth"                 INCLUDED

\ Level 3 - standard library
S" ./ttoken.stdlib.fth"                   INCLUDED
S" ./lib/string-match.fth"                INCLUDED
S" ./resolver.stdlib.fth"                 INCLUDED



\ Example definitions for some standard words
S" ./core.example.fth"                    INCLUDED

\ Example definitions for some well-known literals formats
S" ./lib/wordlist.fth"                    INCLUDED
S" ./common.example.fth"                  INCLUDED

\ Example of some advanced techniques
S" ./advanced.example.fth"                INCLUDED
