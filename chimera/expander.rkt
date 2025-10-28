#lang br/quicklang

(provide #%module-begin
         chimera-program
         mappetizer-block
         scope-block
         converge-block
         all-ops
         op
         collect
         read
         delimiter
         tape-program
         input
         statement-sequence
         pointer-assignment
         assignment
         tape-read
         termination-clause
         loop
         case-select
         hashmap
         operator
         evaluation
         search-program
         find-block
         search-assignment-sequence
         search-assignment
         range-expr
         satisfying-block
         function-call
         return-block
         expression
         identifier-sequence
         process-read
         statement
         graphical-program
         graphical-statement-sequence
         graphical-statement
         graphical-loop
         graphical-binding-set
         graphical-expression
         graphical-split
         graphical-read
         graphical-assignment
         graphical-case-select
         graphical-identifier-sequence
         graphical-calculation
         graph-call
         graphical-function-call
         graphical-number
         hash-entry
         hash-value
         default-clause
         countguesser-program
         read-block
         range-read
         assume-block
         bool-exp
         loop-expr
         arith-expr
         binding
         comp)

(require threading
         "util.rkt"
         "graph.rkt"
         lens
         syntax/parse
         racket/string
         (for-syntax racket/list syntax/parse racket/string))

(define current-graph (make-parameter #f))

(begin-for-syntax
  (require syntax/parse)
  (define-syntax-class id-seq
    #:description "a sequence of identifiers"
    (pattern (identifier-sequence id ...))))

(define-for-syntax (compute-step ids-stx env-stx)
  (datum->syntax env-stx (length (syntax->datum ids-stx))))

(define-for-syntax (build-id-vals ids-stx env-stx)
  (let* ([n (length (syntax->datum ids-stx))]
         [offs (map (λ (i) (datum->syntax env-stx i)) (range n))]
         [parts (map (λ (off)
                       #`(list-ref l (+ index #,off)))
                     offs)])
    #`(values #,@parts)))

(define-for-syntax (build-tape-fold-body substmts-stx env-stx)
  #`(transform l))

(define (converge proc x)
  (let loop ([step (proc x)] [sum 0])
    (if (<= step 0)
        sum
        (loop (proc step) (+ sum step)))))

(define-syntax-rule (input arg ...) (list 'arg ...))
(define-syntax-rule (statement-sequence stmt ...) (list stmt ...))
(define-syntax-rule (statement s) s)
(define-syntax-rule (mappetizer-block id read scope-block collect) 
  (list 'mappetizer-block 'id read scope-block collect))
(define-syntax-rule (scope-block content)
  content)
(define-syntax-rule (converge-block content)
  content)

(define-syntax (chimera-program stx)
  (syntax-parse stx
    [(_ (mappetizer-block id:id read:expr scope-block:expr collect:expr) entry:id)
     #'(begin
         (define id (λ () (apply collect (read-scope scope-block read))))
         (display (entry))
         (newline))]
    
    [(_ block:expr ... entry:id)
     #'(begin
         (define-block block) ...
         (display (entry))
         (newline))]))

(define-syntax (define-block stx)
  (syntax-parse stx
    #:datum-literals (find-block satisfying-block return-block)
    
    [(_ (tape-program id rest:expr ...))
     #'(tape-program id rest ...)]
    
    [(_ (mappetizer-block id:id read:expr scope-block:expr collect:expr))
     #'(define id (λ () (apply collect (read-scope scope-block read))))]
    
    [(_ (graphical-program id:id graphical-statement-sequence:expr))
     #'(graphical-program id graphical-statement-sequence)]
    
    [(_ (countguesser-program id:id rest:expr ...))
     #'(countguesser-program id rest ...)]
    
    [(_ (search-program id:id find-block satisfying-block return-block))
     #'(search-program id find-block satisfying-block return-block)]))

(define-syntax (read-scope stx)
  (syntax-parse stx
    #:datum-literals (read-scope scope-block converge-block)
    [(read-scope (scope-block (converge-block all-ops:expr)) read:expr)
     #'(map ((curry converge) all-ops) read)]
    [(read-scope (scope-block all-ops:expr) read:expr)
     #'(map all-ops read)]))

(define-syntax-rule (all-ops op ...)
  (λ~> op ...))

(define-syntax (op stx)
  (syntax-parse stx
    #:datum-literals (op)
    [(op x "identity") #'(identity x)]
    [(op x "floor") #'(floor x)]
    [(op x "/" divisor:number) #'(/ x divisor)]
    [(op x "-" difference:number) #'(- x difference)]))

(define-syntax-rule (collect "sum") +)

(define (pointer-assignment target-pos new-val)
  (λ (l) (lens-set (list-ref-lens target-pos) l new-val)))

(define-syntax-rule (process-read l (delegate first second))
  (delegate l first second))

(define-syntax-rule (assignment l target value)
  (define target value))

(define-syntax-rule (tape-read l index target)
  (define target (list-ref l index)))

(define-syntax (termination-clause stx)
  (syntax-case stx ()
    [(_ comp1 "=" comp2)
     #'(= comp1 comp2)]))

(define-syntax (loop stx)
  (syntax-parse stx
    #:datum-literals (read-sequence)
    [(_ identifier-sequence:id-seq termination-clause:expr (read-sequence read-clause:expr ...) substatement:expr)
     #:with step (compute-step #'(identifier-sequence.id ...) stx)
     #:with id-vals (build-id-vals #'(identifier-sequence.id ...) stx)
     #'(λ (input-list)
         (for/fold ([l input-list])
                   ([index (range 0 (- (length input-list) step) step)])
           #:break (let-values ([(identifier-sequence.id ...) id-vals]) termination-clause)
           (let-values ([(identifier-sequence.id ...) id-vals])
             (begin (process-read l read-clause) ... (substatement l)))))]))

(define-syntax (case-select stx)
  (syntax-parse stx
    #:datum-literals (hashmap default-clause hash-entry hash-value operator)
  
    [(_ to-find (hashmap (hash-entry key:expr val-wrapped:expr) ...) (default-clause default-wrapped))
     (define (unwrap-val v)
       (syntax-parse v
         #:datum-literals (hash-value operator)
         [(hash-value (operator "+")) #'+]
         [(hash-value (operator "*")) #'*]
         [(hash-value (operator "-")) #'-]
         [(hash-value (operator op)) #'op]
         [(hash-value op-str:string val:number)
          #:when (equal? (syntax->datum #'op-str) "-")
          #'(- val)]
         [(hash-value val:number) #'val]))
     (define vals (map unwrap-val (syntax->list #'(val-wrapped ...))))
     (define default-val (unwrap-val #'default-wrapped))
     (define flat-pairs (apply append (map list (syntax->list #'(key ...)) vals)))
     #`(hash-ref (hash #,@flat-pairs) to-find #,default-val)]
  
    [(_ to-find (hashmap (hash-entry key:expr val-wrapped:expr) ...))
     (define (unwrap-val v)
       (syntax-parse v
         #:datum-literals (hash-value operator)
         [(hash-value (operator "+")) #'+]
         [(hash-value (operator "*")) #'*]
         [(hash-value (operator "-")) #'-]
         [(hash-value (operator op)) #'op]
         [(hash-value op-str:string val:number)
          #:when (equal? (syntax->datum #'op-str) "-")
          #'(- val)]
         [(hash-value val:number) #'val]))
     (define vals (map unwrap-val (syntax->list #'(val-wrapped ...))))
     (define flat-pairs (apply append (map list (syntax->list #'(key ...)) vals)))
     #`(hash-ref (hash #,@flat-pairs) to-find)]))

(define-syntax (hashmap stx)
  (raise-syntax-error 'hashmap "should only appear in case-select context" stx))

; These are used as datum-literals in syntax-parse, they don't actually expand
(define-syntax (hash-entry stx)
  (raise-syntax-error 'hash-entry "should only appear in hashmap context" stx))

(define-syntax (default-clause stx)
  (raise-syntax-error 'default-clause "should only appear in case-select context" stx))

(define-syntax (hash-value stx)
  (syntax-parse stx
    #:datum-literals (operator)
    [(_ (operator op))
     #'op]
    [(_ op:string val:number)
     #:when (equal? (syntax->datum #'op) "-")
     #'(- val)]
    [(_ val:number)
     #'val]))

(define-syntax (operator stx)
  (syntax-case stx ()
    [(_ "+") #'+]
    [(_ "*") #'*]
    [(_ "-") #'-]))

(define-syntax-rule (evaluation x op y)
  (op x y))

(define-syntax-rule (identifier-sequence id ...)
  (identifier-sequence id ...))

(define-syntax (tape-program stx)
  (syntax-parse stx
    #:datum-literals (input statement-sequence statement)

    [(tape-program id:id (input arg ...) read:expr (statement-sequence (statement substatement:expr) ...))
     #:with body (build-tape-fold-body #'(substatement ...) stx)
     #'(define id (λ (arg ...)
                   (list-ref
                     (for/fold ([l read])
                               ([transform (list substatement ...)])
                       body)
                     0)))]

    [(tape-program id:id read:expr (statement-sequence (statement substatement:expr) ...))
     #:with body (build-tape-fold-body #'(substatement ...) stx)
     #'(define id (λ ()
         (list-ref
           (for/fold ([l read])
                     ([transform (list substatement ...)])
             body)
           0)))]))

(define-syntax (search-program stx)
  (define-syntax-class find-statement
    #:description "a find block"
    #:datum-literals (find-block search-assignment-sequence search-assignment)
    (pattern (find-block (search-assignment-sequence (search-assignment ident:id space:expr) ...))))

  (define-syntax-class satisfying-routine
    #:description "a satisfying block"
    #:datum-literals (satisfying-block function-call)
    (pattern (satisfying-block call:expr target:number)))
  
  (syntax-parse stx
    [(search-program id:id assignment:find-statement routine:satisfying-routine return-block:expr)
     #'(define id
         (λ ()
           (for*/first ([assignment.ident assignment.space] ...
              #:when (eq? routine.call routine.target))
             return-block)))]))

(define-syntax-rule (range-expr start end)
  (in-range start end))

(define-syntax-rule (return-block expression)
  expression)

(define-syntax expression
  (syntax-rules ()
    [(expression lhs operation rhs)
     (operation lhs rhs)]))

(define-syntax-rule (find-block search-assignment-sequence)
  (find-block search-assignment-sequence))

(define-syntax-rule (search-assignment-sequence search-assignment ...)
  (search-assignment-sequence search-assignment ...))

(define-syntax-rule (search-assignment id range)
  (search-assignment id range))

(define-syntax-rule (satisfying-block function-call value)
  (satisfying-block function-call value))

(define-syntax-rule (function-call func arg1 arg2)
  (func arg1 arg2))

(define (int->list n) 
  (if (zero? n) 
      null
      (append (int->list (quotient n 10)) (list (remainder n 10)))))

(define (pad l)
  (flatten (append (list -1) l (list -1))))

(define != (compose1 not =))

(define-syntax (countguesser-program stx)
  (syntax-parse stx
    #:datum-literals (read-block range-read assume-block)
    [(_ id:id (read-block (range-read number:number delim:string)) (assume-block bool-exp:expr ...))
     #:with expanded-delim (datum->syntax stx 
                             (cond
                               [(equal? (syntax->datum #'delim) "dash") "-"]
                               [(equal? (syntax->datum #'delim) "nl") "\n"]
                               [(equal? (syntax->datum #'delim) "newline") "\n"]
                               [(equal? (syntax->datum #'delim) "comma") ","]
                               [else (syntax->datum #'delim)]))
     #' (define id (λ ()
          (let ([data (read number expanded-delim)])
            (for/sum ([x (in-range (car data) (cadr data))]
                      #:when (and (handle-assumption bool-exp x) ...))
              1))))]))

(define-syntax (handle-assumption stx)
  (define-syntax-class binding-class
    #:datum-literals (binding)
    (pattern (binding id:id ...)
             #:with (offset ...) (datum->syntax stx (range (length (syntax->datum #'(id ...)))))))  
  (syntax-parse stx
    #:datum-literals (bool-exp loop-expr)
    ([_ (bool-exp (loop-expr "and" bind:binding-class inner-bool:expr)) x]
     #'(for/and ([bind.id (drop (int->list x) bind.offset)] ...)
         inner-bool))
    ([_ (bool-exp (loop-expr "or" bind:binding-class inner-bool:expr)) x]
     #'(for/or ([bind.id (drop (int->list x) bind.offset)] ...)
         inner-bool))
    ([_ (bool-exp (loop-expr "pador" bind:binding-class inner-bool:expr)) x]
     #'(for/or ([bind.id (drop (pad (int->list x)) bind.offset)] ...)
         inner-bool))
    ([_ bool:expr x]
     #'bool)))

(define-syntax-rule (read-block range-read)
  (read-block range-read))

(define-syntax-rule (range-read read-expr)
  (range-read read-expr))

(define-syntax-rule (assume-block bool-exp ...)
  (assume-block bool-exp ...))

(define-syntax (bool-exp stx)
  (syntax-case stx ()
    [(_ bool "and" bool2) #'(and bool bool2)]
    [(_ arith comp-op arith2) #'(comp-op arith arith2)]))

(define-syntax (loop-expr stx)
  (syntax-case stx ()
    [(_ kind binding bool-exp) #'(loop-expr kind binding bool-exp)]))

(define-syntax (arith-expr stx)
  (syntax-case stx ()
    [(_ id-or-number) #'id-or-number]
    [(_ first "-" second) #'(- first second)]
    [(_ first "+" second) #'(+ first second)]
    [(_ first "*" second) #'(* first second)]))

(define-syntax-rule (binding id ...)
  (binding id ...))

(define-syntax (comp stx)
  (syntax-case stx ()
    [(_ ">=") #'>=]
    [(_ "<=") #'<=]
    [(_ "=") #'=]
    [(_ "!=") #'!=]))

(define-syntax-rule (graphical-statement-sequence stmt ...)
  (begin stmt ...))

(define-syntax (graphical-statement stx)
  (syntax-parse stx
    [(_ s) #'s]))

(define-syntax (graphical-loop stx)
  (syntax-parse stx
    #:datum-literals (graphical-binding-set graphical-identifier-sequence graphical-statement-sequence)
    [(_ (graphical-binding-set (graphical-identifier-sequence id ... id-last) gen-expr) (graphical-statement-sequence substmt ...))
     #:with step (datum->syntax stx (length (syntax->list #'(id ...))))
     #:with (offset ...) (datum->syntax stx (range (syntax->datum #'step)))
     #'(for ([iter gen-expr])
         (let ([id (substring iter offset (+ 1 offset))] ... [id-last (substring iter step)])
           substmt ...))]))

(define-syntax-rule (graphical-binding-set id-seq expr)
  (graphical-binding-set id-seq expr))

(define-syntax-rule (graphical-expression e)
  e)

(define-syntax (graphical-split stx)
  (syntax-parse stx
    [(_ contents delim)
     #'(string-split contents delim)]))

(define-syntax-rule (graphical-read file-num delim)
  (read-string file-num delim))

(define-syntax-rule (graphical-assignment from to)
  (define from to))

(define-syntax-rule (graphical-case-select to-find hashmap default-clause)
  (case-select to-find hashmap default-clause))

(define-syntax-rule (graphical-identifier-sequence id ...)
  (graphical-identifier-sequence id ...))

(define-syntax (graphical-calculation stx)
  (syntax-parse stx
    [(_ expr1 op expr2)
     #'(op (if (string? expr1) (string->number expr1) expr1) 
           (if (string? expr2) (string->number expr2) expr2))]))

(define-syntax (graph-call stx)
  (syntax-parse stx
    #:datum-literals (graphical-function-call)
    [(_ (graphical-function-call subcall arg ...))
     #'(send (current-graph) subcall arg ...)]
    [(_ (graphical-function-call subcall arg ...) func-call ...)
     #'(graphical-helper-func (send (current-graph) subcall arg ...) func-call ...)]))

(define-syntax (graphical-helper-func stx)
  (syntax-parse stx
    #:datum-literals (graphical-function-call)
    [(_ graph-obj (graphical-function-call final-subcall arg-final ...))
     #'(send graph-obj final-subcall arg-final ...)]
    [(_ graph-obj (graphical-function-call first-subcall arg-first ...) remaining-call ...)
     #'(graphical-helper-func (send graph-obj first-subcall arg-first ...) remaining-call ...)]))

(define-syntax-rule (graphical-function-call name arg ...)
  (graphical-function-call name arg ...))

(define-syntax (graphical-number stx)
  (syntax-parse stx
    [(_ op:string val:number)
     #:when (equal? (syntax->datum #'op) "-")
     #'(- val)]
    [(_ val:number)
     #'val]))

(define-syntax (graphical-program stx)
  (syntax-parse stx
    #:datum-literals (graphical-statement-sequence)
    [(_ id:id (graphical-statement-sequence substmt ...))
     #'(define id (λ ()
                    (parameterize ([current-graph (new graph%)])
                      substmt ...)))]))
