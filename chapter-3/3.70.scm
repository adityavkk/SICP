; Write merge-weighted that is like merge, except that merge-weighted takes
; an additional argument weight, which computes the weight of a pair.
; Use this to generalize pairs to a procedure weighted-pairs.

(define (merge-weighted s1 s2 w)
  (cond ((stream-empty? s1) s2)
        ((stream-empty? s2) s1)
        (else
          (let ((s1car (stream-first s1))
                (s2car (stream-first s2))
                (ws1car (w s1car))
                (ws2car (w s2car)))
                  (cond ((< ws1car ws2car)
                          (stream-cons s1car (merge (stream-rest s1) s2)))
                        ((> ws1car ws2car)
                          (stream-cons s2car (merge s1 (stream-rest s2))))
                        (else
                          (stream-cons s1car
                                      (merge (stream-rest s1)
                                              (stream-rest s2)))))))))

(define (pairs ))
