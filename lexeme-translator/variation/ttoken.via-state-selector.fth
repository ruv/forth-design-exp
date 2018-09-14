\ rvm 2018-09-14

\ Resolvers mechanism impementation variant

\ Use XSTATE as a selector in a table of methods.
\ XSTATE coding is following:
\   0 - execute
\   1 - compile
\   2 - postpone


[UNDEFINED] NOOP [IF] : NOOP ; [THEN]

[UNDEFINED] XSTATE [IF] \ define a variant for testing
\ NB: This variant is synced with STATE-LEVEL
VARIABLE (XSTATE)
: XSTATE ( -- addr )
  STATE-LEVEL  DUP 2 > -29 AND THROW  (XSTATE) TUCK !
  \ use -29 "compiler nesting"
;
\ Since "x XSTATE !" will not work (due to auto-synchronizing), define a setter
: SET-XSTATE ( state -- ) \ it is a lazy recurisive implementation
  DUP STATE-LEVEL > IF INC-STATE RECURSE EXIT THEN
  DUP STATE-LEVEL < IF DEC-STATE RECURSE EXIT THEN
  (XSTATE) !
;
[THEN]



\ Translate a complex token ( k*x vmt ),
\ where vmt is Virtual Methods Table to handle the token ( k*x ),
\ according to the current XSTATE value, that is an indirect selector for vmt.
: TT-VMT ( i*x vmt -- j*x )
  XSTATE @ CELLS + @ EXECUTE
;

\ Create a 'postponer' method as an anonymous definition
\ that is based on the given 'compiler' and 'quoter' methods
: BUILD-POSTPONER ( xt-compiler xt-quoter -- xt-postponer )
  2>R :NONAME 2R>  COMPILE,  LIT,  ['] COMPILE, COMPILE,  POSTPONE ;
;

\ Create a token type (as anonymous definition for a token translation)
\ that is based on the given three methods
: BUILD-TT ( xt-executer xt-compiler xt-quoter -- xt-tt )
  2DUP BUILD-POSTPONER SWAP
  HERE >R ( S: xt-executer xt-compiler xt-postponer xt-quoter R: vmt )
    2>R SWAP , , R> R> , ,
  :NONAME R> LIT, ['] TT-VMT COMPILE, POSTPONE ;
;

\ helper for literals
: BUILD-TT-LITERAL ( xt-compiler -- xt-tt )
  ['] NOOP SWAP DUP BUILD-TT
;

\ helpers for "name token" nt
: EXECUTE-NT  ( nt -- ) NAME>INTERPRET  EXECUTE ;
: COMPILE-NT, ( nt -- ) NAME>COMPILE    EXECUTE ;


\ "execution token" type
' EXECUTE     ' COMPILE,    ' LIT,  BUILD-TT    DEFER TT-XT   IS TT-XT

\ "name token" type
' EXECUTE-NT  ' COMPILE-NT, ' LIT,  BUILD-TT    DEFER TT-NT   IS TT-NT

\ some literal token types
' LIT,      BUILD-TT-LITERAL    DEFER TT-LIT    IS TT-LIT   \ a single-cell number
' 2LIT,     BUILD-TT-LITERAL    DEFER TT-2LIT   IS TT-2LIT  \ a double-cell number
' SLIT,     BUILD-TT-LITERAL    DEFER TT-SLIT   IS TT-SLIT  \ a string as a pair of address and length

\ NB: a token type is an xt
\ And the corresponding TT-* words shall execute this xt (not return xt)
\ For that reason DEFER is used. If you want to use VALUE it will look like:
\ ' LIT, BUILD-TT-LITERAL  VALUE XT-TT-LIT  : TT-LIT XT-TT-LIT EXECUTE ;




\ Example resolver: support for hex numbers in form 0xNNN
: RESOLVE-N-0x ( c-addr u -- x tt-lit | c-addr u 0 )
  2DUP 2>R S" 0x" MATCH-HEAD IF
    BASE @ >R  HEX  RESOLVE-N  R> BASE !
    IF RDROP RDROP ['] TT-LIT EXIT THEN
    \ NB: use token type that is defined above
    \ in place of the one that is returned by RESOLVE-N
  THEN 2DROP 2R> 0
;

\ add new resolver into the system resolver chain
' RESOLVE-N-0x ENQUEUE-RESOLVER
