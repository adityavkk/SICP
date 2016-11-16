;;; 1.1
; 10
; 12
; 8
; 3
; 6
; a
; b
; 19
; #f
; 4
; 16
; 6
; 16

;;; 1.2
(define ans (/
  (+ 5 4 
    (- 2
      (- 3
        (+ 6 (/ 4 5)))))
  (* 3
    (- 6 2)
    (- 2 7))))

;;; 1.3
(define (square x)
  (* x x))

(define (sum-of-squares x y)
  (+ (square x) (square y)))

(define (min a b c)
  (cond ((and (<= a b) (<= a c)) a)
        ((and (<= c b) (<= c b)) c)
        ((and (<= b c) (<= b a)) b)))

(define (two-max x y)
  (if (<= x y) 
    y
    x))

(define (three-max x y z)
  (cond ((>= x (two-max y z)) x)
        ((>= y (two-max x z)) y)
        ((>= z (two-max x y)) z)))

(define (three-num-squares x y z)
  (cond ((= x (three-max x y z)) (sum-of-squares x (two-max y z)))
        ((= y (three-max x y z)) (sum-of-squares y (two-max x z)))
        ((= z (three-max x y z)) (sum-of-squares z (two-max x y)))))

(define (three-num-squares-1 x y z)
  (cond ((= x (min x y z)) (sum-of-squares y z))
        ((= y (min x y z)) (sum-of-squares x z))
        ((= z (min x y z)) (sum-of-squares x y))))

;;; 1.4
(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))
; -> If b is positive the procedure will (+ a b) otherwise (- a b)

;;; 1.5
;TODO

;;; 1.6
(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))
; If this new-if procedure is used in the sqrt function it will just simply
; return x instead of doing the procedure (sqrt-iter (improve guess x) x)
; since the sqrt function is defined wtih (if (good-enough? guess x)) and simply
; replacing if with new-if will just return guess or x depending on good-enough?

;;; 1.7
; Our square root method will fail for numbers smaller than the ε provided to
; good-enough?
; Old Sqrt Method
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

; New sqrt procedure with alternative good-enough? called close-enough?
(define (sqrt-iter-large guess x)
  (define new-guess (improve guess x))
  (if (close-enough? new-guess guess)
      guess
      (sqrt-iter-large new-guess x)))

(define (close-enough? new old)
  (<
    (abs (- new old))
    (* old 0.000000001)))

(define (sqrt-large x)
  (sqrt-iter-large 1.0 x))

;;; 1.8
(define (cube-root-iter guess x)
  (define new-guess (cube-improve guess x))
  (if (close-enough? new-guess guess)
      guess
      (cube-root-iter new-guess x)))

(define (cube-improve y x)
  (/
    (+ (/ x (square y)) (* 2 y))
     3))

(define (cube-root x)
  (cube-root-iter 1.0 x))

;;; 1.9
; The first implementation of adding is a recursive process because the
; interpreter has to remember the state of incrementing the results of the
; every individual recursive call to + i.e. deferred operations
; However, the second implementation has all of the relavent information 
; needed stored in each subsequent call to +

;;; 1.10
; The Ackermann!
(define (A x y)
  (cond ((= y 0) 0)
        ((= x 0) (* 2 y))
        ((= y 1) 2)
        (else (A (- x 1)
                 (A x (- y 1))))))
; (A 1 10)
; (A 0 (A 1 9))
; (* 2 (A 1 9))
; (* 2 (A 0 (A 1 8)))
; (* 2 (* 2 (A 1 8)))
; (* 2 (* 2 (A 0 (A 1 7))))
; (* 2 (* 2 (* 2 (A 1 7))))
; (* 2 (* 2 (* 2 (A 0 (A 1 6)))))
; (* 2 (* 2 (* 2 (* 2 (A 0 (A 1 5))))))
; (* 2 (* 2 (* 2 (* 2 (* 2 (A 1 5))))))
; (* 2 (* 2 (* 2 (* 2 (* 2 (A 0 (A 1 4)))))))
; (* 2 (* 2 (* 2 (* 2 (* 2 (* 2 (A 1 4)))))))
; (* 2 (* 2 (* 2 (* 2 (* 2 (* 2 (A 0 (A 1 3))))))))
; (* 2 (* 2 (* 2 (* 2 (* 2 (* 2 (* 2 (A 1 3))))))))
; (* 2 (* 2 (* 2 (* 2 (* 2 (* 2 (* 2 (A 0 (A 1 2)))))))))
; (* 2 (* 2 (* 2 (* 2 (* 2 (* 2 (* 2 (* 2 (A 1 2)))))))))
; (* 2 (* 2 (* 2 (* 2 (* 2 (* 2 (* 2 (* 2 (A 0 (A 1 1))))))))))
; (* 2 (* 2 (* 2 (* 2 (* 2 (* 2 (* 2 (* 2 (* 2 (2))))))))))
; 2^10 or 2^y
; 1024

; (A 2 4)
; (A 1 (A 2 3))
; (A 1 (A 1 (A 2 2)))
; (A 1 (A 1 (A 1 (A 2 1))))
; (A 1 (A 1 (A 1 (2))))
; (A 1 (A 1 (A 0 (A 1 1))))
; (A 1 (A 1 (A 0 (2))))
; (A 1 (A 1 (* 2 2)))
; (A 1 (A 1 (4)))
; (A 1 (A 0 (A 1 3)))
; (A 1 (A 0 (A 0 (A 1 2))))
; (A 1 (A 0 (A 0 (A 0 (A 1 1)))))
; (A 1 (A 0 (A 0 (A 0 (2)))))
; (A 1 (* 2 (* 2 (* 2 2))))
; (A 1 (16)) ; NOOOOOOO, make it stop!!
; 2^16 because (A 1 y) is 2^y = 65536

; (A 3 3)
; (A 2 (A 3 2))
; (A 2 (A 2 (A 3 1))
; (A 2 (A 2 (2)))
; (A 2 (A 1 (A 2 1))
; (A 2 (A 1 (2)))
; (A 2 (A 0 (A 1 1)))
; (A 2 (A 0 (2)))
; (A 2 (4))
; (A 1 (A 2 3))
; 2^(A 2 3) -> (A 2 y) = 2^(A 2 (y-1))
; 2^(2^(A 2 2))
; 2^(2^(2^(A 2 1)))
; 2^(2^(2^(2)))
; 2^16 = 6536

(define (f n) (A 0 n)) ; (A 0 n) -> (* 2 n)
(define (g n) (A 1 n)) ; (A 1 n) -> (pow 2 n)
(define (h n) (A 2 n)) ; (A 2 n) -> 2^2^2....^2 n times

