(define (make-monitored f)
  (let ((count 0))
    (define (mf x)
      (cond ((eq? x 'how-many-calls?) count)
            (else (begin (set! count (+ count 1))
                         (f x)))))
    mf))

