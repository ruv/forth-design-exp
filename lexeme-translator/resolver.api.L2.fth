\ rvm 2018-08-09

\ Methods to manage the system resolvers

\ Just one of the possible variant.


VARIABLE (RESOLVER-LIST)

: ENLIST-CURRENT-RESOLVER ( -- )
  HERE (RESOLVER-LIST) @ , RESOLVER , (RESOLVER-LIST) !
;
: UNDO-RESOLVER ( -- ) \ delist and restore
  (RESOLVER-LIST) @ DUP 0= IF ABORT THEN
  2@ (RESOLVER-LIST) ! SET-RESOLVER
;

: ENQUEUE-RESOLVER ( xt -- )
  ENLIST-CURRENT-RESOLVER
  RESOLVER 0= IF SET-RESOLVER EXIT THEN
  RESOLVER SWAP     ['] COMBINE-EITHER PARTIAL2   SET-RESOLVER
;
: PREEMPT-RESOLVER ( xt -- )
  ENLIST-CURRENT-RESOLVER
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
