; Write a procedure to generate the Ranmanujan numbers
; Numbers that can be expressed as the sum of two cubes in more than one way
; called Ranmanujan numbers

(define (print-stream s n)
  (if (= n 0)
    (print "end")
    ((display (stream-first s))
     (display ",")
     (print-stream (stream-rest s) (- n 1)))))

(define (merge-weighted s1 s2 w)
  (cond ((stream-empty? s1) s2)
        ((stream-empty? s2) s1)
        (else
          (let ((s1car (stream-first s1))
                (s2car (stream-first s2)))
                  (cond ((< (w s1car) (w s2car))
                          (stream-cons s1car (merge-weighted (stream-rest s1) s2 w)))
                        ((> (w s1car) (w s2car))
                          (stream-cons s2car (merge-weighted s1 (stream-rest s2) w)))
                        (else
                          (stream-cons s1car
                                      (stream-cons s2car
                                        (merge-weighted (stream-rest s1)
                                                        (stream-rest s2)
                                                        w)))))))))

(define (pairs s t w)
  (stream-cons
    (list (stream-first s)
          (stream-first t)
          (ranmanujan-weight (list (stream-first s) (stream-first t))))
    (merge-weighted
      (stream-map (lambda (x) (list (stream-first s)
                                    x
                                    (ranmanujan-weight (list (stream-first s) x))))
                  (stream-rest t))
      (pairs (stream-rest s) (stream-rest t) w)
      w)))

(define pos-integers
  (stream-cons
    0
    (stream-map (lambda (x) (+ x 1)) pos-integers)))

(define (cube x)
  (* x x x))

(define (ranmanujan-weight pair)
  (let ((i (car pair))
        (j (cadr pair)))
    (+ (cube i) (cube j))))

(define all-pairs (pairs pos-integers pos-integers ranmanujan-weight))

(define (double-filter-stream f s)
  (let ((h (stream-first s))
        (t (stream-first (stream-rest s)))
        (rest (stream-rest (stream-rest s))))
    (if (f h t)
        (stream-cons t
                     (double-filter-stream f rest))
        (double-filter-stream f (stream-rest s)))))

(define (ramanujan? p1 p2)
  (= (caddr p1) (caddr p2)))

(define ramanujan-stream
  (stream-map caddr (double-filter-stream ramanujan? all-pairs)))

(print-stream ramanujan-stream 5)

