#lang info
(define collection "tape")
(define deps '("brag-lib"
               "htdp-lib"
               "rackunit-lib"
               "threading-lib"
               "base" "lens-lib" "beautiful-racket"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/tape.scrbl" ())))
(define pkg-desc "Description Here")
(define version "0.0")
(define pkg-authors '(michaelrauh))
