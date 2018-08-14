\ rvm 2006, 2007, 2018-08-09

\ Token translators

\ The 'TT-' prefix stands for "token translator" (and also for "token-type")

\ Useful factor
: =? ( x1 x2 -- x1 false | true )
  OVER = DUP IF NIP THEN
;


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
  -29 THROW \ "compiler nesting" error
;
: INC-STATE ( -- )
  STATE-LEVEL
  DUP 0 = IF ] THEN
  1+ SL !
;
: DEC-STATE ( -- )
  STATE-LEVEL
  DUP 0 = IF -14 THROW THEN \ "interpreting a compile-only word" just as the nearest code
  DUP 1 = IF [COMPILE] [ THEN
  1- SL !
;




\ Standard tokens translators

\ "execution token" translator
: TT-XT ( i*x xt -- j*x | i*x )
  STATE-LEVEL
  0 =? IF EXECUTE EXIT THEN
  1 =? IF COMPILE, EXIT THEN
  2 =? IF LIT,  ['] COMPILE, COMPILE, EXIT THEN
  -29 THROW \ 	"compiler nesting" error
  \ deeper nesting can be implemented via recursion or quotation
;

\ helper for all literlas
: TT-LITERAL-WITH ( i*x xt -- i*x | )
  STATE-LEVEL
  0 =? IF DROP EXIT THEN
  1 =? IF EXECUTE EXIT THEN
  2 =? IF DUP >R EXECUTE R> COMPILE, EXIT THEN
  -29 THROW \ 	"compiler nesting" error
  \ deeper nesting can be implemented via recursion or quotation
;

\ standard literals
: TT-LIT    ( x     -- x      | )   ['] LIT,    TT-LITERAL-WITH ;
: TT-2LIT   ( x x   -- x x    | )   ['] 2LIT,   TT-LITERAL-WITH ;
: TT-SLIT   ( d-txt -- d-txt  | )   ['] SLIT,   TT-LITERAL-WITH ;
[DEFINED] FLIT, [IF]
: TT-FLIT   ( F: x -- x       | )   ['] FLIT,   TT-LITERAL-WITH ;
[THEN]

\ One interesting side effect of this approach is that an interpreter
\ for the new literals can return just a compiler for this literals
\ and TT-LITERAL-WITH
\ For example:
\ I-NUM-TRIPLE-FORM ( addr u -- 3*x '3LIT, 'TT-LITERAL-WITH | addr u 0 )
\ where "'3LIT," is defined as ": 3LIT, >R 2LIT, R> LIT, ;"
\ and can be even a quotation.



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
  DUP TT-LIT NAME>COMPILE TT-XT
  \ NB: no need to keep nt before TT-LIT
;
[THEN]
