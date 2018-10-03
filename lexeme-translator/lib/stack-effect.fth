\ 2007-2008

\ Take xt, execute it and push the stask depth difference
: EXECUTE-BALANCE ( i*x xt -- j*x n )
  DEPTH 1- >R EXECUTE DEPTH R> -
;

\ Take n and xt, execute xt, throw exception
\ if the stack depth difference is not equal to n
: EXECUTE-BALANCED ( i*x xt n -- j*x ) \ j = i + n
  >R EXECUTE-BALANCE R> = ?E -11 THROW \ result out of range
;

\ Take xt and execute it, throw exception
\ if the stack depth difference is not equal to +1
: EXECUTE-BALANCED(+1) ( i*x xt -- i*x x )
  1 EXECUTE-BALANCED
;

\ See also: "execute-effect" word in Factor
\ https://docs.factorcode.org/content/word-execute-effect,combinators.html
