\ rvm 2018-08-09

\ The words that create new definitions
\ should not be executed in compile mode.
\ Check STATE and throw exeption if it not zero.
: ?STATE0 ( -- )
  STATE @ IF -29 THROW THEN \ "compiler nesting"
;


\ Combinators

\ Partial function application for one argument
\ Combinator that creates the new definition fixing one top argument
: PARTIAL1 ( x1  xt -- xt2 )
  ?STATE0
   >R >R :NONAME R> LIT, R> COMPILE, POSTPONE ;
;

\ Partial function application for two arguments
\ Combinator that creates the new definition fixing two top arguments
: PARTIAL2 ( x1 x2  xt -- xt2 )
  ?STATE0
  >R 2>R :NONAME R> R> LIT, LIT, R> COMPILE, POSTPONE ;
;

\ Combinator that executes xt if it is not null; otherwise returns null
: EXECUTE-MAYBE ( k*x xt -- j*x | k*x 0 -- k*x 0 )
  DUP IF EXECUTE THEN
;

\ Combinator that executes the given two definitions one by one
\ left to right (i.e. the top one at the end) and stops on the first success.
\ xt ( i*x -- j*x flag )
: COMBINE-EITHER ( i*x xt1 xt2 -- j*x flag )
  >R EXECUTE DUP IF RDROP EXIT THEN DROP R> EXECUTE
;
: COMBINE-EITHER-MAYBE ( i*x xt1|0 xt2|0 -- j*x flag )
  >R EXECUTE-MAYBE DUP IF RDROP EXIT THEN DROP R> EXECUTE-MAYBE
;
