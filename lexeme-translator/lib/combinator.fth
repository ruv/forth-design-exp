\ rvm 2018-08-09

\ Combinators

\ Partial function application for one argument.
\ Create the new definition fixing one top argument for given xt.
: PARTIAL1 ( x1  xt -- xt2 )
  ?STATE0
  >R >R :NONAME R> LIT, R> COMPILE, POSTPONE ;
;

\ Partial function application for two arguments.
\ Create the new definition fixing two top arguments for given xt.
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


\ Combinator.
\ Take xt; save copy of the two top values; execute xt; if it retuns zero
\ then put the saved values into the place of the two undertop values and exit;
\ otherwise discard the saved values.
: ?KEEP2 ( i*x 2*x xt -- j*x 2*x 0 | j*x true ) \ xt ( i*x 2*x -- j*x 2*y 0 | j*x true )
  2 PICK 2 PICK 2>R EXECUTE DUP IF RDROP RDROP EXIT THEN DROP 2DROP 2R> 0
;
