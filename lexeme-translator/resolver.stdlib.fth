\ rvm 2006, 2007, 2018-08-09, 2018-09-03

\ Resolvers for the common literals
\ (partial list)

\ double-cell number unsigned plain
: RESOLVE-DUN ( c-addr u -- x x tt | c-addr u 0 )
  DUP ?E0 \ empty string is not a number
  2DUP 0 0 2SWAP >NUMBER NIP IF 2DROP 0 EXIT THEN 2NIP ['] TT-2LIT
;
\ double-cell number plain with optional sign
: RESOLVE-DN ( c-addr u -- x x tt | c-addr u 0 )
  [CHAR] - MATCH-CHAR-HEAD >R
  RESOLVE-DUN DUP IF R> IF >R DNEGATE R> THEN EXIT THEN
  DROP R> IF -1 CHARS /STRING THEN  0
;
\ double-cell number with trailing dot and optional sign
: RESOLVE-DN-DOT ( c-addr u -- x x tt | c-addr u 0 )
  [CHAR] . MATCH-CHAR-TAIL ?E0 RESOLVE-DN ?ET CHAR+ 0
;
\ single-cell number unsigned plain
: RESOLVE-UN ( c-addr u -- x tt | c-addr u 0 )
  RESOLVE-DUN DUP IF 2DROP ['] TT-LIT THEN
;
\ single-cell number with optional sign
: RESOLVE-N ( c-addr u -- x tt | c-addr u 0 )
  RESOLVE-DN DUP IF 2DROP ['] TT-LIT THEN
;
\ single-cell number with optional prefix of radix code
: EXTRACT-RADIX ( c-addr u -- c-addr u 0 | c-addr2 u2 radix )
  DUP 1 U> ?E0  OVER C@
  [CHAR] $ =? IF 16 ELSE
  [CHAR] # =? IF 10 ELSE
  [CHAR] % =? IF 2  ELSE
    DROP S" 0x" MATCH-HEAD 16 AND EXIT
  THEN THEN THEN >R 1 CHARS /STRING R>
;
: EXECUTE-WITH-BASE ( i*x base xt -- j*x )
  BASE @ >R SWAP BASE ! EXECUTE R> BASE !
;
: RESOLVE-N-PREFIXED ( c-addr u -- x tt | c-addr u 0 )
  2DUP EXTRACT-RADIX ?DUP 0= IF 2DROP RESOLVE-N EXIT THEN
  ['] RESOLVE-N EXECUTE-WITH-BASE DUP IF 2NIP EXIT THEN NIP NIP
;
: RESOLVE-DN-PREFIXED ( c-addr u -- x x tt | c-addr u 0 )
  2DUP EXTRACT-RADIX ?DUP 0= IF 2DROP RESOLVE-DN EXIT THEN
  ['] RESOLVE-DN EXECUTE-WITH-BASE DUP IF >R 2NIP R> EXIT THEN NIP NIP
;
: RESOLVE-DN-DOT-PREFIXED ( c-addr u -- x tt | c-addr u 0 )
  [CHAR] . MATCH-CHAR-TAIL ?E0 RESOLVE-DN-PREFIXED ?ET CHAR+ 0
;

[DEFINED] TT-FLIT   [IF]
[DEFINED] >FLOAT    [IF]
\ float number in standard 'E' format
: RESOLVE-FN-E ( c-addr u -- tt | c-addr u 0 ) ( F: -- f | )
  2DUP S" E" CONTAINS ?E0
  2DUP >FLOAT IF 2DROP ['] TT-FLIT EXIT THEN  0
;
[THEN] [THEN]



\ A helper to use the old fashioned stanard FIND word.
\ Retun the given string as counted string in PAD buffer.
: CARBON-COUNTED-PAD ( c-addr u -- c-addr2 )
  DUP 82 > IF -19 THROW THEN \ "definition name too long"; PAD buffer is 84 characters at least
  DUP PAD C! PAD CHAR+ SWAP MOVE PAD
;

\ Resolve a lexeme as a Forth word,
\ represent the result as "execution token" xt and immediate flag
: RESOLVE-WORD ( c-addr u -- xt imm-flag tt | c-addr u 0 )
  2DUP CARBON-COUNTED-PAD FIND DUP IF 2NIP 1 = ['] TT-WORD EXIT THEN NIP
  \ NB: the result depends on STATE in the general case #issue
;

\ Resolve a lexeme as a Forth word,
\ represent the result as "execution token" xt
\ The immediate flag is ignored (if any).
: RESOLVE-NATIVE ( c-addr u -- xt tt | c-addr u 0 )
  RESOLVE-WORD DUP IF 2DROP ['] TT-XT THEN
;


[DEFINED] TT-NT     [IF]
[DEFINED] FIND-NAME [IF] \ find-name ( c-addr u -- nt|0 )
\ Resolve a lexeme as a Forth word,
\ represent the result as "name token" nt
: RESOLVE-NATIVE-NT ( c-addr u -- nt tt | c-addr u 0 )
  2DUP FIND-NAME DUP IF NIP NIP ['] TT-NT EXIT THEN
;
[THEN] [THEN]




\ Resolve a PQName — a partially qualified name (rvm, 2007)
\ It is a name that is qualified by the path of wordlists separated by '::'
\ Example:  S" test passed" MY-WORDLIST::STDIO::TYPE
\ NB: PQName is translated as a regular word regardless of its immediate flag.
: (RESOLVE-PQNAME-IN) ( d-txt-name wid -- xt tt | 0 )
  BEGIN >R S" ::" SPLIT- -ROT R> SEARCH-WORDLIST WHILE
    ( ... flag-of-split xt ) SWAP WHILE EXECUTE-BALANCED(+1)
  REPEAT ['] TT-XT EXIT
  THEN ( d-txt-right true | 0 ) ?E0 2DROP 0
;
: RESOLVE-PQNAME ( c-addr u -- xt tt-xt | c-addr u 0 )
  2DUP S" ::" SPLIT-    0= IF  2DROP 0 EXIT THEN
  RESOLVE-NATIVE  0= IF  2DROP 2DROP 0 EXIT THEN
  EXECUTE-BALANCED(+1) ( d-txt-orig  d-txt-pathname wid )
  (RESOLVE-PQNAME-IN) 0?E 2NIP
;

\ Resolve a native or partially qualified name
: RESOLVE-NATIVE-PQ ( c-addr u -- xt tt-xt | c-addr u 0 )
  RESOLVE-NATIVE ?ET RESOLVE-PQNAME
;






\ A mechanism for chaining the resolvers is not fixed yet.
\ Any data structure can be used as well as just a code.
\ The one simplest variant is following.


: RESOLVE-NUMBER-ANY ( c-addr u -- i*x tt | c-addr u 0 )
  RESOLVE-DN-DOT-PREFIXED   ?ET
  RESOLVE-N-PREFIXED        ?ET

  [DEFINED] RESOLVE-FN-E    [IF]
  RESOLVE-FN-E      ?ET     [THEN]

  FALSE
;

: RESOLVE-LEXEME-DEFAULT ( c-addr u -- i*x tt | c-addr u 0 )
  RESOLVE-WORD          ?ET
  RESOLVE-PQNAME        ?ET
  RESOLVE-NUMBER-ANY    ?ET
  FALSE
;

\ Set initial resolver

' RESOLVE-LEXEME-DEFAULT SET-RESOLVER
