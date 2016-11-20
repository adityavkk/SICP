;;; 1.15

(define (small-enough? x)
  (< x 0.1))

(define (cube x)
  (* x x x))

(define (p x i)
  (-
    (* 3 x)
    (* 4 (cube x))))

(define (sine theta)
  (if (small-enough? theta)
      theta
      (p (sine (/ theta 3.0)))))

; How many times is the procedure p applied when (sine 12.15) is evaluated?
; p is applied log3 12.15 times

; Order of growth
; The algorithm can be characterized by the following reccurance T(n) = T(n / 3)
