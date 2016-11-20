(define (pascal i j)
  (if (or (= i 0) (= j 0) (= j i))
      1
      (+
        (pascal (- i 1) j)
        (pascal (- i 1) (- j 1)))))

