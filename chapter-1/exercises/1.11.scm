;;; 1.11
(define (f n)
  (cond ((< n 3) n)
        (else
              (+
                (f (- n 1))
                (* 2 (f (- n 2)))
                (* 3 (f (- n 3)))))))

(define (f-iter n a b c)
  (cond ((= n 2) a)
        ((= n 1) b)
        ((= n 0) c)
        (else
          (f-iter
            (- n 1)
            (+
              a
              (* 2 b)
              (* 3 c))
            a
            b))))


