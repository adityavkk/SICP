; Enumerate, in ascending order with no repetitions, all positive integers with
; no prime factors other than 2, 3 or 5.

(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream))

(define (merge s1 s2)
  (cond ((stream-empty? s1) s2)
        ((stream-empty? s2) s1)
        (else
          (let ((s1car (stream-first s1))
                (s2car (stream-first s2)))
                  (cond ((< s1car s2car)
                          (stream-cons s1car (merge (stream-rest s1) s2)))
                        ((> s1car s2car)
                          (stream-cons s2car (merge s1 (stream-rest s2))))
                        (else
                          (stream-cons s1car
                                      (merge (stream-rest s1)
                                              (stream-rest s2)))))))))
(define ones (stream-cons 1 ones))
(define doubles (stream-cons 1 (scale-stream doubles 2)))
(define triples (stream-cons 1 (scale-stream triples 3)))
(define quintuples (stream-cons 1 (scale-stream quintuples 5)))

(define S (stream-cons 1
                       (merge doubles
                              (merge triples quintuples))))
