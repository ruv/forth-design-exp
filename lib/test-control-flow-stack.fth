\ rvm 2018-08-16

\ This snippet does ABORT if the host Forth system does not have the separate control flow stack.

[DEFINED] >CS [IF]  DEPTH :NONAME IF [ DEPTH  PAD ! ] THEN ; DROP PAD @ = [ELSE] FALSE [THEN] 0= [IF]
  \ The is no separate control flow stack
  .( Sorry, the separate control flow stack is absent in the host Forth system. Abort. ) CR
  ABORT
[THEN]
