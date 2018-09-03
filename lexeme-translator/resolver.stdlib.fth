\ rvm 2006, 2007, 2018-08-09, 2018-09-03

\ Resolvers for the common literals
\ (partial list)

\ double-cell number unsigned plain
: RESOLVE-DUN ( c-addr u -- x x tt | c-addr u 0 )
  2DUP 0 0 2SWAP >NUMBER NIP IF 2DROP 0 EXIT THEN 2NIP ['] TT-2LIT
;
\ double-cell number plain with optinal sign
: RESOLVE-DN ( c-addr u -- x x tt | c-addr u 0 )
  [CHAR] - MATCH-HEAD-CHAR >R
  RESOLVE-DUN DUP IF R> IF >R DNEGATE R> THEN EXIT THEN
  DROP R> IF -1 CHARS /STRING THEN  0
;
\ double-cell number with trailing dot and optinal sign
: RESOLVE-DN-DOT ( c-addr u -- x x tt | c-addr u 0 )
  [CHAR] . MATCH-TAIL-CHAR ?E0 RESOLVE-DN ?ET CHAR+ 0
;
\ single-cell number unsigned plain
: RESOLVE-UN ( c-addr u -- x tt | c-addr u 0 )
  RESOLVE-DUN DUP IF 2DROP ['] TT-LIT THEN
;
\ single-cell number with optinal sign
: RESOLVE-N ( c-addr u -- x tt | c-addr u 0 )
  RESOLVE-DN DUP IF 2DROP ['] TT-LIT THEN
;

[DEFINED] TT-FLIT   [IF]
[DEFINED] >FLOAT    [IF]
\ float number in standard 'E' format
: RESOLVE-FN-E ( c-addr u -- tt | c-addr u 0 ) ( F: -- f | )
  2DUP >FLOAT IF 2DROP ['] TT-FLIT EXIT THEN  0
;
[THEN] [THEN]



\ A helper to use the old fashioned stanard FIND word.
\ Retun the given string as counted string in PAD buffer.
: CARBON-COUNTED-PAD ( c-addr u -- c-addr2 )
  DUP 82 > IF -19 THROW THEN \ "definition name too long"; PAD buffer is 84 characters at least
  DUP PAD C! PAD CHAR+ SWAP MOVE PAD
;

\ Resolve a lexem as a Forth word,
\ represent the result as "execution token" xt and immediate flag
: RESOLVE-WORD ( c-addr u -- xt imm-flag tt | c-addr u 0 )
  2DUP CARBON-COUNTED-PAD FIND 0 =? IF DROP FALSE EXIT THEN 2NIP ( xt flag )
  1 = ['] TT-WORD
;

\ Resolve a lexem as a Forth word,
\ represent the result as "execution token" xt
\ The immediate flag is ignored (if any).
: RESOLVE-NATIVE ( c-addr u -- xt tt | c-addr u 0 )
  RESOLVE-WORD DUP IF 2DROP ['] TT-XT THEN
;


[DEFINED] TT-NT     [IF]
[DEFINED] FIND-NAME [IF] \ find-name ( c-addr u -- nt|0 )
\ Resolve a lexem as a Forth word,
\ represent the result as "name token" nt
: RESOLVE-NATIVE-NT ( c-addr u -- nt tt | c-addr u 0 )
  2DUP FIND-NAME DUP IF NIP NIP ['] TT-NT EXIT THEN
;
[THEN] [THEN]






\ A mechanism for chaining the resolvers is not fixed yet.
\ Any data structure can be used as well as just a code.
\ The one simplest variant is following.


: RESOLVE-NUMBER-ANY ( c-addr u -- i*x tt | c-addr u 0 )
  RESOLVE-DN-DOT    ?ET
  RESOLVE-N         ?ET

  [DEFINED] RESOLVE-FN-E    [IF]
  RESOLVE-FN-E      ?ET     [THEN]

  FALSE
;

: RESOLVE-LEXEM-DEFAULT ( c-addr u -- i*x tt | c-addr u 0 )
  RESOLVE-WORD          ?ET
  RESOLVE-NUMBER-ANY    ?ET
  FALSE
;

\ Set initial resolver

' RESOLVE-LEXEM-DEFAULT SET-RESOLVER
