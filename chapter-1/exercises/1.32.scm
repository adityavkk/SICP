; 1.32
; Linear Recursive
(define (rec-accumulate combiner null-val term a next b)
  (define (special-case term a next b)
    (if (> a b)
        null-val
        (combiner (term a)
                  (special-case term
                                (next a)
                                next
                                b))))
  (special-case term a next b))

(define (product term a next b)
  (rec-accumulate * 1 term a next b))

(define (factorial n)
  (if (= n 0)
      1
      (product (lambda (i) i)
              1
              (lambda (i) (+ 1 i))
              n)))

; Iterative
(define (iter-accumulate combiner null-val term a next b)
  (define (accum-iterator current result)
    (if (> current b)
        result
        (accum-iterator (next current)
                        (combiner result
                                  (term current)))))
  (accum-iterator a null-val))

(define (sum term a next b)
  (iter-accumulate + 0 term a next b))

(define (square n)
  (* n n))

(define (inc n)
  (+ 1 n))

(define (sum-of-squares a b)
  (sum square a inc b))
