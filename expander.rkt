#lang br/quicklang

(define-macro (aoclop-module-begin (aoclop-program READ (scope-block OP)))
  #'(#%module-begin
     '(scope-block OP READ)))
(provide (rename-out [aoclop-module-begin #%module-begin]))