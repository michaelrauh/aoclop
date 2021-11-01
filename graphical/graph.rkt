#lang racket
(require racket/hash)

(struct point (x y) #:transparent)
(struct traversal (point step))
(provide graph%)

(define (find-y-path p y)
  (define start-y (point-y (traversal-point p)))
  (define fill-x (point-x (traversal-point p)))
  (define start-step (add1 (traversal-step p)))
  (define sign (if (positive? y) 1 -1))
  (define ys (range (+ sign start-y) (+ start-y y sign) sign))
  (define steps (range start-step (+ start-step (length ys))))
  (map (λ (y-pos step) (traversal (point fill-x y-pos) step)) ys steps))

(define (find-x-path p x)
  (define start-x (point-x (traversal-point p)))
  (define start-step (add1 (traversal-step p)))
  (define fill-y (point-y (traversal-point p)))
  (define sign (if (positive? x) 1 -1))
  (define xs (range (+ sign start-x) (+ start-x x sign) sign))
  (define steps (range start-step (+ start-step (length xs))))
  (map (λ (x-pos step) (traversal (point x-pos fill-y) step)) xs steps))

(define graph%
  (class object%
    (super-new)
    (define origin (traversal (point 0 0) 0))
    (define current-color 0)
    (define positions (make-hash (list (cons current-color (list origin)))))

    (define/public (changecolor)
      (set! current-color (add1 current-color))
      (hash-set! positions current-color (list origin)))

    (define/public (add x y)
      (define current-color-positions (hash-ref positions current-color))
      
      (define old-position (car current-color-positions))
      (define path (if (not (zero? x)) (find-x-path old-position x) (find-y-path old-position y)))
      (define result-path (append (reverse path) current-color-positions))
      (hash-set! positions current-color result-path))

    (define (find-intersections pss)
      (map (λ (kvp) (traversal (car kvp) (cdr kvp)))
           (hash->list
            (apply hash-intersect
                   (map (λ (ps)
                          (apply hash-union
                                 (map (λ (p)
                                        (hash (traversal-point p) (traversal-step p)))
                                      ps)
                                 #:combine min))
                        pss)
                   #:combine (λ (v1 v2) (flatten (append (list v1) (list v2))))))))

    (define/public (intersects)
      (define (filter-list-origin l)
        (filter (λ (x) (not (equal? x origin))) l))

      (define nonempty-possibles (filter (λ (l) (not (null? l)))
                                         (map filter-list-origin
                                              (map (λ (x) (hash-ref positions x))
                                                   (range (add1 current-color))))))
      (define intersections (find-intersections nonempty-possibles)) 
      (new intersects% [intersections intersections]))))

(define intersects%
  (class object%
    (super-new)
    (init intersections)
    (define ints intersections)
    
    (define/public (magnitudes)
      (new magnitudes% [magnitudes (map (λ (p)
                                          (+ (abs (point-x (traversal-point p)))
                                             (abs (point-y (traversal-point p)))))
                                        ints)]))

    (define/public (delays)
      (new delays% [delays (map (λ (p)
                                  (apply + (traversal-step p)))
                                ints)]))))

(define delays%
  (class object%
    (init delays)
    (super-new)
    (define dels delays)
    (define/public (minimum)
      (apply min dels))))

(define magnitudes%
  (class object%
    (init magnitudes)
    (super-new)
    (define mags magnitudes)
    (define/public (minimum)
      (apply min mags))))

(module+ test
  (require rackunit)
  (define graph (new graph%))
  (send graph changecolor)
  (send graph add 8 0)
  (send graph add 0 5)
  (send graph add -5 0)
  (send graph add 0 -3)
  (send graph changecolor)
  (send graph add 0 7)
  (send graph add 6 0)
  (send graph add 0 -4)
  (send graph add -4 0)
  (define res (send (send (send graph intersects) magnitudes) minimum))
  (check-equal? res 6))

(module+ test
  (require rackunit)
  (define graph2 (new graph%))
  (send graph2 changecolor)
  (send graph2 add 8 0)
  (send graph2 add 0 5)
  (send graph2 add -5 0)
  (send graph2 add 0 -3)
  (send graph2 changecolor)
  (send graph2 add 0 7)
  (send graph2 add 6 0)
  (send graph2 add 0 -4)
  (send graph2 add -4 0)
  (define res2 (send (send (send graph2 intersects) delays) minimum))
  (check-equal? res2 30))