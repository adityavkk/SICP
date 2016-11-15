; 1.1
; Prefix notation
(+ (* 3 5) (- 10 6)) ; 19

(+ (* 3
      (+ (* 2 4)
        (+ 3 5)))
  (+ (- 10 7)
      6)) ;57

;1.1.4
(define (square x) (* x x))

(define (sum-of-squares x y)
 (+ (square x) (square y)))

(define (f a)
 (sum-of-squares (+ a 1) (* a 2)))
; f (a) = (a + 1)^2 + (2*a)^2

;1.1.6
(define (abs x)
 (cond ((> x 0) x)
       ((= x 0) 0)
       ((< x 0) (- x))))

(define (abs1 x)
 (cond ((< x 0) (- x))
       (else x)))

(define (abs2 x)
(if (< x 0)
  (- x)
  (x)))

(define (greater-than-both x y z)
  (and (x > y)
       (x > z)))

(define (equal-to-either x y z)
  (or (= x y)
      (= x z)))

(define (is-not-equal x y)
  (not (= x y)))

;;; 1.1.7

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x) 
       x)))

(define (improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (good-enough? guess x)
  (<
    (abs (- (square guess) x))
    0.001))

(define (square x)
  (* x x))

(define (sqrt x)
  (sqrt-iter 1.0 x))

(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))

