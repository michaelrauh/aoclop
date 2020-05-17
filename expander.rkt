#lang br/quicklang

(define-macro (aoclop-module-begin (aoclop-program BODY))
  #'(#%module-begin
     'BODY))
(provide (rename-out [aoclop-module-begin #%module-begin]))