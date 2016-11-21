;;; 1.46
(define (iterative-improve good? improve)
  (define (iterate guess)
    (if (good? guess)
        guess
        (iterate (improve guess))))
  iterate)

(define (average x y)
  (/ (+ x y) 2))

(define (square n)
  (* n n))

(define (sqrt x)
  ((iterative-improve
    (lambda (guess) (< (abs (- (square guess) x)) 0.001))
    (lambda (guess) (average guess (/ x guess))))
   1.0))

(define (fixed-point f first-guess)
  ((iterative-improve
     (lambda (guess) (< (abs (- (f guess) guess)) 0.00001))
     (lambda (guess) (f guess)))
   first-guess))
