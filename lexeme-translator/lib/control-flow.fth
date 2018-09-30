\ rvm 2012, 2018-08-16

\ The words that create new definitions
\ should not be executed in compile mode.
\ Check STATE and throw an exeption if it is not zero.
: ?STATE0 ( -- )
  STATE @ IF -29 THROW THEN \ "compiler nesting"
;


\ The useful factors

\ Drop the flag; return control to the calling definition if the flag is not zero.
: ?E ( flag -- ) \ Exit on true
  POSTPONE IF POSTPONE EXIT POSTPONE THEN
; IMMEDIATE

\ Return control to the calling definition if the top value is not zero.
: T?E ( x -- x )
  POSTPONE DUP POSTPONE ?E
; IMMEDIATE

\ Return control to the calling definition if the top value is zero.
: 0?E ( x -- x )
  POSTPONE DUP POSTPONE 0= POSTPONE ?E
; IMMEDIATE

\ Return control to the calling definition if the top value is not zero,
\ otherwise drop the top value (that is zero).
: ?ET ( 0 -- | x -- x ) \ Exit on True returning this true
  POSTPONE T?E POSTPONE DROP
; IMMEDIATE

\ Return control to the calling definition if the top value is zero,
\ otherwise drop the top value (that is not zero).
: ?E0 ( x -- | 0 -- 0 ) \ Exit on 0 returning this 0
  POSTPONE 0?E POSTPONE DROP
; IMMEDIATE


\ If x1 and x2 are equal then drop them both and push true,
\ otherwise drop the top one and push false.
: =? ( x1 x2 -- x1 false | true )
  OVER = DUP IF NIP THEN
;
