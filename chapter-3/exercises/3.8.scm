(define c 0)
(define (f x)
  (cond ((= x c) (begin (set! c 2) -1))
        (else (begin (set! c 2) x))))
