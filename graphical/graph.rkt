#lang racket

(struct point (x y) #:transparent)
(provide graph%)

(define (find-y-path p y)
  (define start-y (point-y p))
  (define fill-x (point-x p))
  (define sign (if (positive? y) 1 -1))
  (define ys (range (+ sign start-y) (+ start-y y sign) sign))
  (map (λ (y-pos) (point fill-x y-pos)) ys))

(define (find-x-path p x)
  (define start-x (point-x p))
  (define fill-y (point-y p))
  (define sign (if (positive? x) 1 -1))
  (define xs (range (+ sign start-x) (+ start-x x sign) sign))
  (map (λ (x-pos) (point x-pos fill-y)) xs))

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
      (define current-color-positions (hash-ref positions current-color))
      
      (define old-position (car current-color-positions))
      (define path (if (not (zero? x)) (find-x-path old-position x) (find-y-path old-position y))) ; note: this assumes movement across one axis at a time, which is guaranteed by the question for now
      (define result-path (append (reverse path) current-color-positions))
      (hash-set! positions current-color result-path))

    (define/public (intersects)
      (define (filter-list-origin l)
        (filter (λ (x) (not (equal? x origin))) l))

      (define nonempty-possibles (filter (λ (l) (not (null? l)))
                                         (map filter-list-origin
                                              (map (λ (x) (hash-ref positions x))
                                                   (range (+ 1 current-color))))))
      (define intersections (set->list (apply set-intersect (map list->set nonempty-possibles)))) ; note: this optimization is only possible because order does not matter, which is guaranteed by the question for now
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

