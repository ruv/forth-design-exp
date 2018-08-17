\ rvm 2007, 2018-08-16

\ There is a general principle that Forth words usually consume their arguments.
\ Although in the cases of chaining it is highly likely that the same arguments will be used again.
\ In such case it is more convenient to return such arguments depending on conditions.

\ Etymology for peculiar 'SFIND-WORDLIST' word:
\ 1. 'SFIND' is similar to 'FIND' but uses (c-addr u) string
\ in place of counted string.
\ 2. 'FIND-WORDLIST' is similar to 'SEARCH-WORDLIST' but returns
\ incoming string unchanged on fail (like 'FIND' does).
\ 3. Hence 'SFIND-WORDLIST' is similar to 'SEARCH-WORDLIST'
\ but works with (c-addr u) string and return it unchanged on fail.
: SFIND-WORDLIST ( c-addr u wid -- xt true | c-addr u false )
  >R 2DUP R> SEARCH-WORDLIST DUP 0= ?E 2NIP
;

\ Try to resolve name in wordlist wid; on sucess execute xt and return true,
\ on fail return name unchanged and false.
: OBEY ( i*x c-addr u wid -- j*x true | i*x c-addr u false )
  SFIND-WORDLIST ?E0 EXECUTE TRUE
;




\ Some tools to manage context. It is better to have a standard library for that.

: PUSH-CURRENT ( wid -- ) ( C: -- wid-prev )
  GET-CURRENT SWAP SET-CURRENT
;
: DROP-CURRENT ( -- ) ( C: wid-prev -- )
  SET-CURRENT
;
: PUSH-DEVELOP ( wid -- ) ( C: -- wid-prev )
  DUP >R PUSH-CURRENT
  GET-ORDER R> SWAP 1+ SET-ORDER
;
: DROP-DEVELOP ( -- ) ( C: wid-prev -- )
  GET-ORDER NIP 1- SET-ORDER
  DROP-CURRENT
;
