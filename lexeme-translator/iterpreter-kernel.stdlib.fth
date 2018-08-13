\ rvm 2018-08-09

\ Methods to manage the interpreters

\ Just one of the possible variant.

: ENQUEUE-INTERPRETER ( xt -- )
   INTERPRETER SWAP    ['] COMBINE-EITHER PARTIAL2   SET-INTERPRETER
;
: PREEMPT-INTERPRETER ( xt -- )
   INTERPRETER         ['] COMBINE-EITHER PARTIAL2   SET-INTERPRETER
;


\ #todo other methods
