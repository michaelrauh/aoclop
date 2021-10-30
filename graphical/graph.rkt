#lang racket

(struct point (x y))
(struct traversal (point step))
(provide graph%)

(define (find-y-path p y)
  (define start-y (point-y (traversal-point p)))
  (define fill-x (point-x (traversal-point p)))
  (define start-step (traversal-step p))
  (define sign (if (positive? y) 1 -1))
  (define ys (range (+ sign start-y) (+ start-y y sign) sign))
  (define steps (range start-step (+ start-step (length ys))))
  (map (λ (y-pos step) (traversal (point fill-x y-pos) step)) ys steps))

(define (find-x-path p x)
  (define start-x (point-x (traversal-point p)))
  (define start-step (traversal-step p))
  (define fill-y (point-y (traversal-point p)))
  (define sign (if (positive? x) 1 -1))
  (define xs (range (+ sign start-x) (+ start-x x sign) sign))
  (define steps (range start-step (+ start-step (length xs)))) ; steps may be off by one
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

    (define (find-intersections l) ; prefer intersections with lower step
      (define against (car l))
      (define others (cdr l))
      (for/list ([x against]
             #:when (in-all x others))
    x))

    (define (in-all x yss)
      (for/and ([ys yss])
        (member-of-list x ys)))

    (define (member-of-list x ys)
      (member x ys pointmember))

    (define (pointmember x y)
      (and (= (point-x (traversal-point x)) (point-x (traversal-point y))) (= (point-y (traversal-point x)) (point-y (traversal-point y)))))

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
                                        ints)]))))

(define delays%
  (class object%
    (init delays)
    (super-new)
    (define dels delays)))

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
  (send graph add 5 0)
  (send graph add 0 5)
  (send graph add -6 0)
  (send graph changecolor)
  (send graph add 0 7)
  (define res (send (send (send graph intersects) magnitudes) minimum))
  (check-equal? res 5))

