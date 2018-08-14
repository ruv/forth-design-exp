\ rvm 2018-08-09

\ Lexeme interpreters management mechanism

\ A lexeme interpreter has the stack signature ( c-addr u -- k*x xt-token-translator | addr u 0 )
\ A token translator has the stack signature ( i*x k*x -- j*x )
\ A lexeme translator has the stack signature ( i*x c-addr u -- j*x true | i*x addr u 0 )

\ Prefix 'I-' stands for "interpret" verb (interpret a lexeme by default).
\ Prefix 'TT-' stands for "translate-token" (and for "token-type" in the same time)
\ Prefix 'T-' stands for "translate" verb (usually to translate a lexeme).


\ Useful factor
\ take the flag; throw 'notfound' exception if the flag is false
: ?NF ( c-addr u 0 -- | k*x true -- k*x )
  0= IF -13 THROW THEN \ "undefined word" error
  \ the string ( c-addr u ) can be saved for further error message
;


\ Private words

VARIABLE CURRENT-INTERPRETER \ current lexeme interpreter



\ Public API lexicon

\ Get and set the system default lexeme interpreter.
\ The names choice is aligned with naming convention of PRECISION and SET-PRECISION words.
: SET-INTERPRETER   ( xt -- ) CURRENT-INTERPRETER ! ;
: INTERPRETER       ( -- xt ) CURRENT-INTERPRETER @ ;
\ Possible alias for the last one is GET-INTERPRETER
\ - to be aligned with naming convention of GET-CURRENT and SET-CURRENT words.


\ Top-level lexeme interpreter.
\ Interpret lexeme and return token ( k*x ) and xt of corresponding token translator,
\ or unchanged lexeme and false.
\ This word should not be chained with any other interpreters
\ to avoid unnecessary indirect recursion
: I-LEXEME ( c-addr u -- k*x xt-tt | c-addr u 0 )
  INTERPRETER DUP IF EXECUTE THEN
;

\ Top-level lexeme translator.
\ It return an effect of translating (if any) and true or unchanged lexeme and false
: T-LEXEME ( i*x c-addr u -- j*x true | c-addr u 0 )
  I-LEXEME DUP IF EXECUTE TRUE THEN
;




\ Translate given lexeme,
\ throw error if the lexeme cannot be translated
: TRANSLATE-LEXEME ( i*x c-addr u -- j*x ) T-LEXEME ?NF ;

\ Translate the text from SOURCE parse area
: TRANSLATE-SOURCE ( i*x -- j*x )
  BEGIN PARSE-NAME DUP WHILE TRANSLATE-LEXEME ?STACK REPEAT 2DROP
;

\ Classic non-standard INTERPRET word is TRANSLATE-SOURCE
\ : INTERPRET TRANSLATE-SOURCE ;
