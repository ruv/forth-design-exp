\ rvm 2018-08-09

\ Methods to manage the resolvers

\ Just one of the possible variant.

: ENQUEUE-RESOLVER ( xt -- )
  RESOLVER 0= IF SET-RESOLVER EXIT THEN
  RESOLVER SWAP     ['] COMBINE-EITHER PARTIAL2   SET-RESOLVER
;
: PREEMPT-RESOLVER ( xt -- )
  RESOLVER 0= IF SET-RESOLVER EXIT THEN
  RESOLVER          ['] COMBINE-EITHER PARTIAL2   SET-RESOLVER
;


\ #todo other methods
