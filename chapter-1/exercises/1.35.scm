;;; 1.35
; Show that the golden ration is a fixed point of the transformation x -> 1 + 1/x
; and use this fact to compute the golden ratio of the fixed-point procedure

(define (fixed-point f first-guess)
  (define (try guess)
    (let((next (f guess)))
      (if (close-enough? next guess)
          next
          (try next))))
  (try first-guess))


(define (close-enough? x y)
  (< (abs (- x y)) 0.001))

(define phi (fixed-point (lambda (x) (+ 1 (/ 1 x)))
                         1.0))
