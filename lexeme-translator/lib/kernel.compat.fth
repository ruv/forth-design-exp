
\ Some well known words

[UNDEFINED] 0! [IF]
: 0! ( addr -- ) 0 SWAP ! ;
[THEN]

[UNDEFINED] 1+! [IF]
: 1+! ( addr -- ) DUP @ 1+ SWAP ! ;
[THEN]

[UNDEFINED] 1-! [IF]
: 1-! ( addr -- ) DUP @ 1- SWAP ! ;
[THEN]

[UNDEFINED] CHAR- [IF]
: CHAR- ( addr1 -- addr2 ) -1 CHARS + ;
[THEN]

[UNDEFINED] 2NIP [IF]
: 2NIP ( d2 d1 -- d1 ) 2SWAP 2DROP ;
[THEN]

[UNDEFINED] RDROP [IF]
: RDROP ( R: x -- ) POSTPONE R> POSTPONE DROP ; IMMEDIATE
[THEN]



[UNDEFINED] DEFER! [IF]
: DEFER! ( xt2 xt1 -- ) >BODY ! ;
[THEN]


[UNDEFINED] PARSE-NAME [IF]
[DEFINED] PARSE-WORD [IF]
: PARSE-NAME PARSE-WORD ;
[ELSE]
: PARSE-NAME ( -- addr u ) BL PARSE ;
[THEN]
[THEN]



[UNDEFINED] ?STACK [IF] \ unstandard word
: ?STACK ( -- ) DEPTH 0 < -4 AND THROW ; \ stack underflow
[THEN]
