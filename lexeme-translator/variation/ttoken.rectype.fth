\ rvm 2018-09-27

\ Definition of Recognizer RFD v4 API
\ where rectype is an xt of token translator


[UNDEFINED] NOOP [IF] : NOOP ; [THEN]


: TRANSLATE-TOKEN-VMT ( i*x k*x vmt -- j*x )
  STATE @ IF CELL+ THEN @ EXECUTE
;
: (RECTYPE) ( xt-executer xt-compiler xt-quoter "name" -- )
  CREATE
    SWAP ROT , , ,
  DOES> TRANSLATE-TOKEN-VMT
;

\ Create a token type (that is an xt of the token translator that is defined via CREATE DOES> )
: RECTYPE: ( xt-executer xt-compiler xt-quoter "name" -- )
  >IN @ >R
    (RECTYPE)
  R@ >IN !
    ' \ we need the xt of last defined word
  R> >IN !
    CONSTANT
;


\ helper for literals
: RECTYPE-LITERAL: ( xt-compiler "name" -- )
  ['] NOOP SWAP DUP RECTYPE:
;



[DEFINED] NAME>COMPILE [IF]

\ helpers for "name token" nt
: EXECUTE-NT  ( nt -- ) NAME>INTERPRET  EXECUTE ;
: COMPILE-NT  ( nt -- ) NAME>COMPILE    EXECUTE ;

\ "name token" type
' EXECUTE-NT  ' COMPILE-NT  ' LIT,    RECTYPE: RECTYPE-NT

[THEN]


' LIT,    RECTYPE-LITERAL: RECTYPE-NUM
' 2LIT,   RECTYPE-LITERAL: RECTYPE-DNUM

[DEFINED] FLIT, [IF]
' FLIT,   RECTYPE-LITERAL: RECTYPE-FLOAT
[THEN]





\ Better variant of 'rectype' based naming
: RECTYPE>EXECUTER  ( tt -- xt ) >BODY @ ;
: RECTYPE>COMPILER  ( tt -- xt ) >BODY CELL+ @ ;
: RECTYPE>QUOTER    ( tt -- xt ) >BODY 2 CELLS + @ ;

\ The naming from Recognizer RFD v4
: RECTYPE>INT   ( tt -- xt ) RECTYPE>EXECUTER ;
: RECTYPE>COMP  ( tt -- xt ) RECTYPE>COMPILER ;
: RECTYPE>POST  ( tt -- xt ) RECTYPE>QUOTER ;

:NONAME -1 ABORT" FAILED" ; DUP DUP RECTYPE: RECTYPE-NULL

: FORTH-RECOGNIZER ( -- xt ) RESOLVER ;
: SET-FORTH-RECOGNIZER ( xt -- ) SET-RESOLVER ;

: RECOGNIZE ( c-addr u xt|0 -- k*x tt )
  DUP IF EXECUTE DUP IF EXIT THEN THEN
  DROP 2DROP RECTYPE-NULL
;

\ The definitions is taken as is from Recognizer RFD v4
: POSTPONE ( "name" -- )
  PARSE-NAME FORTH-RECOGNIZER RECOGNIZE DUP >R
  RECTYPE>POST EXECUTE R> RECTYPE>COMP COMPILE,
;
