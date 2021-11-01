#lang info
(define collection "search")
(define deps '("beautiful-racket-lib"
               "brag-lib"
               "htdp-lib"
               "rackunit-lib"
               "tape"
               "base"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/tape.scrbl" ())))
(define pkg-desc "Description Here")
(define version "0.0")
(define pkg-authors '(michaelrauh))
