(define (make-accumulator c)
  (lambda (inc) (begin (set! c (+ c inc))
                 c)))
