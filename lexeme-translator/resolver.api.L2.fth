\ rvm 2018-08-09

\ Methods to manage the system resolvers

\ Just one of the possible variant.


VARIABLE (PERCEPTOR-LIST)

: ENLIST-PERCEPTOR ( -- )
  HERE (PERCEPTOR-LIST) @ , PERCEPTOR , (PERCEPTOR-LIST) !
;
: REVERT-PERCEPTOR ( -- ) \ delist and restore
  (PERCEPTOR-LIST) @ DUP 0= IF ABORT THEN
  2@ (PERCEPTOR-LIST) ! SET-PERCEPTOR
;

: SET-PERCEPTOR-AFTER ( xt -- )
  ENLIST-PERCEPTOR
  PERCEPTOR 0= IF SET-PERCEPTOR EXIT THEN
  PERCEPTOR SWAP    ['] COMBINE-EITHER PARTIAL2   SET-PERCEPTOR
;
: SET-PERCEPTOR-BEFORE ( xt -- )
  ENLIST-PERCEPTOR
  PERCEPTOR 0= IF SET-PERCEPTOR EXIT THEN
  PERCEPTOR         ['] COMBINE-EITHER PARTIAL2   SET-PERCEPTOR
;


\ #todo other methods
(
  Perhaps it will be useful to have several chains of the system resolvers:
    - names in various forms, words and words quotations
    - standard literals
    - other literals
    - markup
)
