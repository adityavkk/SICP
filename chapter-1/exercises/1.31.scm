; 1.31
; Linear Recursive
(define (product term a next b)
  (if (> a b)
      1
      (* (term a)
         (product term
                  (next a)
                  next
                  b))))

(define (factorial n)
  (if (= n 0)
      1
      (product (lambda (i) i)
           1
           (lambda (i) (+ 1 i))
           n)))

; Iterative
(define (product1 term a next b)
  (define (prod-iter a result)
    (if (> a b)
        result
        (prod-iter (next a)
                   (* result (term a)))))
  (prod-iter a 1))

(define factorial1
  (lambda (n)
    (product1 (lambda (i) i)
              1
              (lambda (i) (+ 1 i))
              n)))
