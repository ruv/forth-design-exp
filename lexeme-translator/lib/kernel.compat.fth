
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
