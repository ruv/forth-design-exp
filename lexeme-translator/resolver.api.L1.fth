\ rvm 2018-08-09, 2018-09-03

\ Lexeme resolvers management mechanism

\ A lexeme resolver has the stack signature ( c-addr u -- k*x xt-token-translator | addr u 0 )
\ A token translator has the stack signature ( i*x k*x -- j*x )
\ A lexeme translator has the stack signature ( i*x c-addr u -- j*x true | i*x addr u 0 )

\ Prefix 'TT-' stands for "translate-token" (and for "token-type" in the same time)
\ see also ./ttoken.stdlib.fth


\ Useful factor
\ take the flag; throw 'notfound' exception if the flag is false
: ?NF ( i*x c-addr u 0 -- j*x -13 | k*x true -- k*x )
  0= IF -13 THROW THEN \ "undefined word" error
  \ the string ( c-addr u ) can be saved for further error message
;


\ Private words

VARIABLE _PERCEPTOR \ a lexeme resolver that is currently used by the system



\ Public API lexicon

\ Get and set the system default lexeme resolver.
\ The names choice is aligned with naming convention of PRECISION and SET-PRECISION words.
: SET-PERCEPTOR      ( xt -- ) _PERCEPTOR ! ;
: PERCEPTOR          ( -- xt ) _PERCEPTOR @ ;
\ Possible alias for the latter one is GET-PERCEPTOR
\ - to be aligned with naming convention of GET-CURRENT and SET-CURRENT words.


\ A resolver has technical ability to do full translation of a lexeme by itself.
\ In such case this designated "noop token" translator shall be returned.
\ Actually it's not safe and discouraged now: a resolver should not have side effects.
: TT-NOOP ( -- ) ; \ it does nothing


\ Top-level lexeme resolver.
\ Resolve lexeme and return token ( k*x ) and xt of corresponding token translator,
\ or unchanged lexeme and false.
\ This word should not be chained with any other resolvers
\ to avoid unnecessary indirect recursion
: PERCEIVE-LEXEME ( c-addr u -- k*x xt-tt | c-addr u 0 )
  PERCEPTOR EXECUTE
;

\ Top-level lexeme translator.
\ It return an effect of translating (if any) and true or unchanged lexeme and false
: TRANSLATE-LEXEME ( i*x c-addr u -- j*x true | c-addr u 0 )
  PERCEIVE-LEXEME DUP IF EXECUTE TRUE THEN
;
\ NB: TRANSLATE-TOKEN is just EXECUTE



\ Translate the text from SOURCE parse area
\ Throw error if some lexeme can not be translated
: TRANSLATE-SOURCE-SURELY ( i*x -- j*x )
  BEGIN PARSE-NAME DUP WHILE TRANSLATE-LEXEME ?NF ?STACK REPEAT 2DROP
;

\ Classic non-standard INTERPRET word is this TRANSLATE-SOURCE-SURELY
\ : INTERPRET TRANSLATE-SOURCE-SURELY ;
