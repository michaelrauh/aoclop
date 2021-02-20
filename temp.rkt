#lang racket

(struct point (x y) #:transparent)

(define graph%
  (class object%
    (define origin (point 0 0))
    (define current-color 0)
    (define positions (make-hash (list (cons current-color (list origin)))))
    (super-new)

    (define/public (changecolor)
      (set! current-color (+ 1 current-color))
      (hash-set! positions current-color (list origin)))

    (define/public (add x y)
      (define old-position (car (hash-ref positions current-color)))
      (define current-position (point (+ x (point-x old-position)) (+ y (point-y old-position))))
      (hash-set! positions current-color (cons current-position (hash-ref positions current-color))))

    (define/public (intersects)
      
      (define (help pos)
        (hash-ref positions pos))

      (define (not-origin? p)
    (not (equal? p (point 0 0))))

      (define (filter-list-origin l)
    (filter not-origin? l))

      (define poses (map help (range (+ 1 current-color))))
      (define possibles (map filter-list-origin poses))
      (define nonempty-possibles (filter (λ (l) (not (null? l))) possibles))
      (define intersections (apply set-intersect nonempty-possibles))
      (define ans (new intersects% [intersections intersections]))
      ans)))

(define intersects%
  (class object%
    (init intersections)
    (define ints intersections)
    (super-new)
    (define (magnitude p)
      (+ (abs (point-x p)) (abs (point-y p))))
    
    (define/public (magnitudes)
      (define ans (map magnitude ints))
      (new magnitudes% [magnitudes ans]))))

(define magnitudes%
  (class object%
    (init magnitudes)
    (super-new)
    (define mags magnitudes)

    (define (min-2 x y)
      (if (< x y) x y))

    (define (minimum-of-list l)
      (foldl min-2 (car l) (cdr l)))
    
    (define/public (minimum)
      (minimum-of-list mags))))
  
(define current-graph (new graph%))
(send current-graph changecolor)
(send current-graph add 1 2)
(send current-graph add 1 2)
(send current-graph add 1 2)
(send current-graph changecolor)
(send current-graph add 1 2)
(send current-graph add 1 2)
(define intersects (send current-graph intersects))
(define mags (send intersects magnitudes))
(send mags minimum)


