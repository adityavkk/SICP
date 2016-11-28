;;; 2.5
; Show that we can represent pairs of nonnegative integers using only numbers and arithmetic
; operations if we represent the pair a and b as the integer that is the product 2a 3b. Give the corresponding
; definitions of the procedures cons, car, and cdr. 
(define (square x)
  (* x x))

(define (pow b e)
  (cond ((= e 1) b)
        ((= e 0) 1)
        ((even? e) (square (pow b (/ e 2))))
        (else (* b (pow b (- e 1))))))

(define (cons-prime a b)
  (* (pow 2 a)
     (pow 3 b)))

(define (car-prime x)
  (car-prime-iter x 0))

(define (cdr-prime x)
  (cdr-prime-iter x 0))

(define (car-prime-iter x count)
  (cond ((or (odd? x) (= x 1)) count)
        (else (car-prime-iter (/ x 2) (+ count 1)))))

(define (cdr-prime-iter x count)
  (cond ((even? x) (cdr-prime (divide-by-car x)))
        ((= x 1) count)
        (else (cdr-prime-iter (/ x 3) (+ count 1)))))

(define (divide-by-car x)
  (/ x (pow 2 (car-prime x))))

