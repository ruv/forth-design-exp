\ rvm 2018-08-09

\ Methods to manage the system resolvers

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
(
  Perhaps it will be useful to have several chains of the system resolvers:
    - names in various forms, words and words quotations
    - standard literals
    - other literals
    - markup
)
