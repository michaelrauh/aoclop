#lang info
(define collection 'use-pkg-name)
(define deps '("beautiful-racket-lib"
               "brag-lib"
               "htdp-lib"
               "rackunit-lib"
               "threading-lib"
               "base"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/mappetizer.scrbl" ())))
(define pkg-desc "Description Here")
(define version "0.0")
(define pkg-authors '(michaelrauh))
