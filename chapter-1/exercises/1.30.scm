; 1.30
(define (sum term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a)
              (+ (term a)
                 result))))
  (iter a 0))

(define (cube x)
  (* x x x))

(define (sum-of-cubes a b)
  (sum cube
       a
       (lambda (x) (+ x 1))
       b))

(sum-of-cubes 0 2) ; <- 9
