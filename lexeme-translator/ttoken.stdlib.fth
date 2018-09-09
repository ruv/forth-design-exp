\ rvm 2006, 2007, 2018-08-09

\ Token translators

\ The 'TT-' prefix stands for "token translator" (and also for "token-type")

\ Managing postponing level.
\ This general implementation just keeps sync with standard STATE variable.
\ A native implementation should be far simpler.

VARIABLE SL \ state of postponing level

: STATE-LEVEL ( -- level )
  \ It syncs SL with STATE (if any) and returns the proper level value
  SL @
  STATE @ IF
    DUP IF EXIT THEN 1+ DUP SL ! EXIT
  THEN
  DUP 0= IF EXIT THEN
  0 SL ! 1 = IF 0 EXIT THEN
  -22 THROW \ "control structure mismatch"
;
: INC-STATE ( -- )
  STATE-LEVEL
  DUP 0 = IF ] THEN
  1+ SL !
;
: DEC-STATE ( -- )
  STATE-LEVEL
  DUP 0 = IF -22 THROW THEN \ "control structure mismatch"
  DUP 1 = IF [COMPILE] [ THEN
  1- SL !
;




\ Standard tokens translators

DEFER TT-LIT  ' TT-LIT

\ "execution token" translator
: TT-XT ( i*x xt -- j*x | i*x )
  STATE-LEVEL
  0 =? IF EXECUTE EXIT THEN
  1 =? IF COMPILE, EXIT THEN
  2 =? IF LIT,  ['] COMPILE, COMPILE, EXIT THEN
  DROP
  DEC-STATE  TT-LIT  ['] COMPILE, RECURSE  INC-STATE
;

\ helper for all literlas
: TT-LITERAL-WITH ( i*x xt -- i*x | )
  STATE-LEVEL
  0 =? IF DROP EXIT THEN
  1 =? IF EXECUTE EXIT THEN
  2 =? IF DUP >R EXECUTE R> COMPILE, EXIT THEN
  DROP
  DEC-STATE  DUP >R RECURSE  R> TT-XT  INC-STATE
;

\ NB: Now in these recursive definitions the cases 1 and 2 may be just removed
\ without any functionality lost. They was left for performance optimization only.


\ standard literals
: TT-LIT    ( x     -- x      | )   ['] LIT,    TT-LITERAL-WITH ;
: TT-2LIT   ( x x   -- x x    | )   ['] 2LIT,   TT-LITERAL-WITH ;
: TT-SLIT   ( d-txt -- d-txt  | )   ['] SLIT,   TT-LITERAL-WITH ;
[DEFINED] FLIT, [IF]
: TT-FLIT   ( F: x -- x       | )   ['] FLIT,   TT-LITERAL-WITH ;
[THEN]

( xt-defer-tt-lit ) ' TT-LIT SWAP DEFER!




\ A resolver has technical ability to do full translating of a lexeme by themself.
\ Perhaps such usage should be specified and limited.
\ In such case this designated "noop token" translator shall be returned.
: TT-NOOP ( -- ) ; \ it does nothing



\ Token translator for the classic xt with immediate flag
: TT-WORD ( i*x xt imm-flag -- j*x )
  STATE-LEVEL
  0 =? IF DROP EXECUTE EXIT THEN
  1 =  IF IF EXECUTE EXIT THEN COMPILE, EXIT THEN
  IF DEC-STATE TT-XT INC-STATE EXIT THEN
  TT-XT
  \ To be on the safe side in the case of this general implementation,
  \ the state is decremented on the higher levels only.
;

\ Token translator for the new "name token"
[DEFINED] NAME>COMPILE [IF]
: TT-NT ( i*x nt -- j*x )
  STATE-LEVEL
  0 =? IF NAME>INTERPRET  EXECUTE EXIT THEN
  1 =  IF NAME>COMPILE    EXECUTE EXIT THEN
  NAME>COMPILE ( w xt ) >R TT-LIT R> TT-XT
;
[THEN]
