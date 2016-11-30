;;; 1.36
(define (close-enough? x y)
  (< (abs (- x y)) 0.001))

(define (print-and-return to-print to-return)
  (display to-print)
  (newline)
  to-return)

(define (fixed-point f first-guess)
  (define (try guess iters)
    (let((next (f guess)))
      (display next)
      (newline)
      (if (close-enough? next guess)
          (print-and-return iters next)
          (try next (+ 1 iters)))))
  (try first-guess 0))

(define (average x y) (/ (+ x y) 2))

(define average-damped-sol (fixed-point (lambda (x) (average x
                                                (/ (log 1000) (log x))))
                                        2.0))

(newline)
(display "not average damped")
(newline)

(define sol (fixed-point (lambda (x) (/ (log 1000) (log x)))
                         2.0))

; 22 Iterations without avg dampening and 6 with average damping
