#lang info
(define collection 'use-pkg-name)
(define deps '("base"
               "brag-lib"
               "htdp-lib"
               "rackunit-lib"
               "racket" "beautiful-racket" "threading-lib"))
(define build-deps '("mappetizer"
                     "scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/mappetizer.scrbl" ())))
(define pkg-desc "Description Here")
(define version "0.0")
(define pkg-authors '(michaelrauh))
