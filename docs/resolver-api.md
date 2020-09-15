
# Lexeme resolver mechanism

## Terms and notations

**perceptor**: a resolver that is currently used by the system to resolve lexems.

## API Level 1 (minimal)

`SET-PERCEPTOR      ( xt -- )` <br/>
Set the perceptor to perform only the resolver identified by `xt`.
__SET-PERCEPTOR__ word may allot data space.


`PERCEPTOR          ( -- xt )` <br/>
Return the perceptor.
__PERCEPTOR__ word may allot data space.



### Changes in the text interpreter

A Forth system shall perform the following semantics
in place of (b) and (c) items of The Forth text interpreter algorithm
(per [section 3.4](http://www.forth200x.org/documents/html/usage.html#section.3.4)
of the Forth 2012 Standard):
`PERCEPTOR EXECUTE DUP IF EXECUTE TRUE THEN ( flag )`<br/>
This `flag` is the flag of successful for item (d).

For that the system shall also represent its original (b) and (c) parts
of the text interpreter as a separate definition (__t__) with the stack effect
`( c-addr u -- k*x xt-tt | addr u 0 ) ( F: -- m*r )`,
where `xt-tt` has the stack effect `( i*x k*x -- j*x ) ( F: l*r m*r -- n*r )`.<br/>
In the case of _k+m_ is 0, `xt-tt` may be equal to the xt of `TT-NOOP` word.
Otherwise `xt-tt` should represent the semantics of (b.1-2) or (c.1-2) items
of the text interpreter in accordance with the returned values.

Performing of this definition should not have a detectable side effect
beyond the specified stack effect.

The xt of this definition (__t__)
is the system's default lexeme resolver (default perceptor)
and it
shall be return by `PERCEPTOR` word
before the first call of `SET-PERCEPTOR` word.



## API Level 2 (managing the system resolver)

For the generality, further _resolver_ term means _lexeme resolver_
if other is not stated.

This API is a subject for elaborating.

`SET-PERCEPTOR-AFTER ( xt -- )` <br/>
Set the perceptor to be the combination of the perceptor before that and the resolver xt.
After that the subsequent call of __PERCEPTOR__ word may return the different value.
__SET-PERCEPTOR-AFTER__ word may allot data space.

`SET-PERCEPTOR-BEFORE ( xt -- )` <br/>
Set the perceptor to be the combination of the resolver xt and the perceptor before that.
After that the subsequent call of __PERCEPTOR__ word may return the different value.
__SET-PERCEPTOR-BEFORE__ word may allot data space.

`REVERT-PERCEPTOR ( -- )` <br/>
Undo the most recent setting of the perceptor that was not yet undone.
After that the subsequent call of __PERCEPTOR__ word may return the different value.
An ambiguous condition exists if there is no such setting.
__REVERT-PERCEPTOR__ word may allot data space.



## API Level 3 (standard library)


### Lexeme translator

`PERCEIVE-LEXEME ( c-addr u -- k*x xt-tt | c-addr u 0 ) ( F: -- m*r ) ` <br/>
Try to resolve a lexeme (c-addr u) using the perceptor.
On success return the token `(k*x) (F: m*r)` and the token translator `xt-tt`,
on fail return `(c-addr u)` and `0`.

`TRANSLATE-LEXEME ( i*x c-addr u -- j*x true | c-addr u 0 ) ( F: l*r -- n*r )` <br/>
The execution semantics of this word is `RESOLVE-LEXEME DUP IF EXECUTE TRUE THEN`


### Token translators (optional)

`TT-XT ( i*x xt -- j*x | i*x )` <br/>
Translate "execution token" xt according to the current state.

`TT-LIT    ( x     -- x      | )` <br/>
Translate a number according to the current state.

`TT-2LIT   ( x x   -- x x    | )` <br/>
Translate a two-cells number according to the current state.

`TT-SLIT   ( c-addr u -- c-addr u | )` <br/>
Translate a string according to the current state.

`TT-FLIT   ( F: r -- r       | )` <br/>
Translate a float number according to the current state.

`TT-NT ( i*x nt -- j*x )` <br/>
Translate a "name token" according to the current state.

`TT-WORD ( i*x xt imm-flag -- j*x )` <br/>
Translate a "word token" `(xt -1|0)` according to the current state.

`TT-LITERAL-WITH ( k*x xt -- k*x | ) ( F: m*r -- m*r | ) \ xt ( k*x --  F: m*r -- ) ` <br/>
Translate a numeric literal token `(k*x) (F: m*r)` according to the current state
using the compilation word represented by `xt`.


### Lexeme resolvers (optional)

NB: the naming convention for these words should be refined.

`RESOLVE-DUN ( c-addr u -- d tt-2lit | c-addr u 0 )` <br/>
Resolver for a double-cell number, unsigned, plain

`RESOLVE-DN ( c-addr u -- d tt-2lit | c-addr u 0 )` <br/>
Resolver for a double-cell number, plain, with optional sign

`RESOLVE-DN-DOT ( c-addr u -- d tt-2lit | c-addr u 0 )` <br/>
Resolver for a double-cell number with trailing dot and optional sign

`RESOLVE-UN ( c-addr u -- u tt-lit | c-addr u 0 )` <br/>
Resolver for a single-cell number, unsigned, plain

`RESOLVE-N ( c-addr u -- n tt-lit | c-addr u 0 )` <br/>
Resolver for a single-cell number with optional sign

`RESOLVE-FN-E ( c-addr u -- tt-flit | c-addr u 0 ) ( F: -- r | )` <br/>
Resolver for a float number in standard 'E' format

`RESOLVE-NATIVE ( c-addr u -- xt tt-xt | c-addr u 0 )` <br/>
Resolver for a Forth word into "execution token"

`RESOLVE-NT ( c-addr u -- nt tt-nt | c-addr u 0 )` <br/>
Resolver for a Forth word into "name token"

`RESOLVE-WORD ( c-addr u -- xt imm-flag tt-word | c-addr u 0 )` <br/>
Resolver for a Forth word into "word token" `(xt -1|0)`
that is a pair of "execution token" and immediacy flag.


## References

Proof of concept implementation is available
at [GitHub](https://github.com/ruv/forth-design-exp/tree/master/lexeme-translator)

[Comparison](https://ruv.github.io/forth-design-exp/resolver-vs-recognizer.xml) with Recognizer RFD v4.
