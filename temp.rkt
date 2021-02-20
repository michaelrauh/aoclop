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

      (define (f l)
        (not (equal? l (list origin))))

      (define poses (map help (range current-color)))
      (define possibles (filter f poses))
      (define intersections (apply set-intersect possibles))
      (define ans (new intersects% [intersections intersections]))  
      ans)

    (define/public (get-positions)
      positions)))

(define intersects%
  (class object%
    (init intersections)
    (define ints intersections)
    (super-new)
    (define (magnitude p)
      (+ (abs (point-x p)) (abs (point-y p))))
    
    (define/public (magnitudes)
      (map magnitude ints))))
  
(define current-graph (new graph%))
(send current-graph changecolor)
(send current-graph add 1 2)
(send current-graph add 1 2)
(send current-graph add 1 2)
(send current-graph changecolor)
(send current-graph add 1 2)
(send current-graph add 1 2)
(define intersects (send current-graph intersects))
(send intersects magnitudes)
; graph.add(1, 2)
; graph.changecolor()
; graph.intersects().magnitudes().minimum()


