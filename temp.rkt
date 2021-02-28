#lang racket

(struct point (x y) #:transparent)
(provide graph%)

(define graph%
  (class object%
    (super-new)
    (define origin (point 0 0))
    (define current-color 0)
    (define positions (make-hash (list (cons current-color (list origin)))))

    (define/public (changecolor)
      (set! current-color (+ 1 current-color))
      (hash-set! positions current-color (list origin)))

    (define/public (add x y)
      (define old-position (car (hash-ref positions current-color)))
      
      (define current-position (point (+ x (point-x old-position)) (+ y (point-y old-position))))
      (hash-set! positions current-color (cons current-position (hash-ref positions current-color))))

    (define/public (intersects)
      (define (filter-list-origin l)
        (filter (λ (x) (not (equal? x origin))) l))

      ;(display positions)

      (define nonempty-possibles (filter (λ (l) (not (null? l)))
                                         (map filter-list-origin
                                              (map (λ (x) (hash-ref positions x))
                                                   (range (+ 1 current-color))))))
      (define intersections (apply set-intersect nonempty-possibles))
      (new intersects% [intersections intersections]))))

(define intersects%
  (class object%
    (super-new)
    (init intersections)
    (define ints intersections)
    
    (define/public (magnitudes)
      (new magnitudes% [magnitudes (map (λ (p)
                                          (+ (abs (point-x p))
                                             (abs (point-y p))))
                                        ints)]))))

(define magnitudes%
  (class object%
    (init magnitudes)
    (super-new)
    (define mags magnitudes)
    (define/public (minimum)
      (define (min-2 x y)
        (if (< x y) x y))
      (foldl min-2 (car mags) (cdr mags)))))

(module+ test
  (require rackunit)
  (define graph (new graph%))
  (send graph changecolor)
  (send graph add 5 0)
  (send graph add 0 5)
  (send graph add -6 0)
  (send graph changecolor)
  (send graph add 0 7)
  (define res (send (send (send graph intersects) magnitudes) minimum))

  (check-equal? res 5))

