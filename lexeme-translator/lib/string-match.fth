\ rvm 2007, 2018-08-16


\ Functions Based on Substring Matching

\ Naming convention was taken from the similar XPath functions.
\ String length is calculated in the address units.

\ Check compatibility wrt working with character units.
1 CHARS 1 <> [IF]
  PAD 1 CHARS 1 /STRING DROP PAD - 1 <> [IF]
    .( Sorry, chars handling in this programme is incompatible with the host Forth system. Abort. ) CR
    ABORT
  [THEN]
[THEN]


: MATCH-HEAD-CHAR ( c-addr u c -- c-addr2 u2 true | c-addr u false )
  OVER 0= IF DROP FALSE EXIT THEN
  >R OVER C@ R> = ?E0 1 /STRING TRUE
;

: MATCH-TAIL-CHAR ( c-addr u c -- c-addr u2 true | c-addr u false )
  OVER 0= IF DROP FALSE EXIT THEN
  >R 2DUP + CHAR- C@  R> = ?E0 CHAR- TRUE
;



: EQUALS ( c-addr1 u1 c-addr2 u2 -- flag )
  DUP 3 PICK <> IF 2DROP 2DROP FALSE EXIT THEN
  COMPARE 0=
;
: MATCH-HEAD ( a u a-key u-key -- a-right u-right true | a u false )
  2 PICK OVER U< IF  2DROP FALSE EXIT THEN
  DUP >R
  3 PICK R@ COMPARE IF  RDROP FALSE EXIT THEN
  SWAP R@ + SWAP R> - TRUE
;
: MATCH-TAIL ( a u a-key u-key -- a-left u-left true | a u false )
  2 PICK OVER U< IF  2DROP FALSE EXIT THEN
  DUP >R
  2OVER R@ - + R@ COMPARE IF  RDROP FALSE EXIT THEN
  R> - TRUE
;
: CONTAINS ( a u a-key u-key -- flag )
  SEARCH NIP NIP
;
: STARTS-WITH ( a u a-key u-key -- flag )
  ROT OVER U< IF  2DROP DROP FALSE EXIT THEN
  TUCK COMPARE 0=
;
: ENDS-WITH ( a u a-key u-key -- flag )
  DUP >R 2SWAP DUP R@ U< IF  2DROP 2DROP RDROP FALSE EXIT THEN
  R@ - + R> COMPARE 0=
;
: SUBSTRING-AFTER ( a u a-key u-key -- a2 u2 )
  DUP >R SEARCH IF  SWAP R@ + SWAP R> - EXIT THEN  RDROP 2DROP 0 0
;
: SUBSTRING-BEFORE ( a u a-key u-key -- a2 u2 )
  3 PICK >R  SEARCH  IF  DROP R> TUCK - EXIT THEN   RDROP 2DROP 0 0
;
