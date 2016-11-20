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

(define fib
  (lambda (n)
    (cond ((= n 0) 0)
          ((= n 1) 1)
          (else (+ (fib (- n 1))
                   (fib (- n 2)))))))

(define (fib1 n)
  (define (fib-iter tar last second)
    (if (= tar 0)
        last
        (fib-iter (- tar 1)
                  (+ last second)
                  last)))
  (fib-iter n 0 1))

; Coin Change
(define (change a n)
  (define (first n)
    (cond ((= n 1) 1)
          ((= n 2) 5)
          ((= n 3) 10)
          ((= n 4) 25)
          ((= n 5) 50)))
  (cond ((= a 0) 1)
        ((or (< a 0) (= n 0)) 0)
        (else (+ (change a (- n 1))
                 (change
                   (- a (first n))
                   n)))))

; Basic Exp recursive
(define (expt a n)
  (if (= n 0)
      a
      (* a (expt (- n 1)))))

; Basic Exp Iterative
(define (expt-iter a n prod)
  (cond ((= n 0) 1)
        ((= n 1) prod)
        (else (expt-iter a (- n 1) (* a prod)))))

(define (expt1 a n)
  (expt-iter a n a))

; Successive Squaring
(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((even? n) (square (fast-expt b (/ n 2))))
        (else (* b (fast-expt b (- n 1))))))

(define (even? n)
  (= (remainder n 2) 0))
