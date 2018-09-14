\ rvm 2018-09-14


\ If we need the getters that return a method from a token type,
\ we could use CREATE DOES> mechanism to have access to vmt from xt.
\ But there is no a convenient standard way to define an anonymous "CREATE".
\ Hence we cannot easy define a non-parsing factor.
\ But there should be an easy way to define a non-parsing factor
\ in a Forth system specific implementation.

\ For illustration, let's use standard CREATE word

\ Create a token type (that is a token translator defined via CREATE DOES> )
: CREATE-TT ( xt-executer xt-compiler xt-quoter "name" -- )
  2DUP BUILD-POSTPONER SWAP
  CREATE ( xt-executer xt-compiler xt-postponer xt-quoter )
    2>R SWAP , , R> R> , ,
  DOES> TT-VMT
;

\ helper for literals
: CREATE-TT-LITERAL ( xt-compiler "name" -- )
  ['] NOOP SWAP DUP CREATE-TT
;


\ Now the getters can be defined as
: TT>EXECUTER  ( tt -- xt ) >BODY @ ;
: TT>COMPILER  ( tt -- xt ) >BODY CELL+ @ ;
: TT>QUOTER    ( tt -- xt ) >BODY 3 CELLS + @ ;

\ Or using 'rectype' based naming from Recognizer RFD v4
: RECTYPE>EXECUTER  ( tt -- xt ) >BODY @ ;
: RECTYPE>COMPILER  ( tt -- xt ) >BODY CELL+ @ ;
: RECTYPE>QUOTER    ( tt -- xt ) >BODY 3 CELLS + @ ;


\ Example of defining literal token types
' LIT,   CREATE-TT-LITERAL TT-LIT
' 2LIT,  CREATE-TT-LITERAL TT-2LIT


\ === Nota bene ===

\ In this implementation:
\ - a token type created via CREATE-TT may not be changed via IS
\ - a token type created via BUILD-TT may not be used as argument for getters

\ And any token whether created via BUILD-TT or via CREATE-TT
\ may be used by the Forth system as result of resolving.
