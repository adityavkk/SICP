; 1.16
; Design a procedure that evolves an iterative exponentiation process that uses
; successive squaring and uses a logarithmic number of steps, as does fast-expt.

(define (fast-expt b n)
  (fast-expt-iter b n 1))

(define (fast-expt-iter b n a)
  (cond ((= n 1) a)
        ((= n 0) 1)
        ((odd? n)
          (fast-expt-iter b (- n 1) (* b a)))
        (else (fast-expt-iter
                b
                (/ n 2)
                (* a (square b))))))

(define (odd? n)
  (= (remainder n 2) 1))

(define (square x)
  (* x x))
