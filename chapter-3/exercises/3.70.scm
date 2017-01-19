; Write merge-weighted that is like merge, except that merge-weighted takes
; an additional argument weight, which computes the weight of a pair.
; Use this to generalize pairs to a procedure weighted-pairs.

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
                                      (merge-weighted (stream-rest s1)
                                                      (stream-rest s2)
                                                      w))))))))

(define (pairs s t w)
  (stream-cons
    (list (stream-first s) (stream-first t))
    (merge-weighted
      (stream-map (lambda (x) (list (stream-first s) x)) (stream-rest t))
      (pairs (stream-rest s) (stream-rest t) w)
      w)))

; The stream of all pairs of positive integers (i, j) with i <= j ordered
; according to i + j

(define (sum-weight pair)
  (+ (car pair) (cadr pair)))

(define pos-integers
  (stream-cons
    0
    (stream-map (lambda (x) (+ x 1)) pos-integers)))

(define sum-pairs (pairs pos-integers pos-integers sum-weight))

; The stream of all pairs of positive integers (i, j) where neither i nor j
; is divisible by 2, 3, or 5 and the pairs are ordered according to the sum
; 2i + 3j + 5ij

(define (div? a b)
  (= (remainder a b) 0))

(define (div-by-2-3-5? x)
  (or (div? x 3) (div? x 2) (div? x 5)))

(define (weight1 pair)
  (let ((i (car pair))
        (j (cadr pair)))
   (+ (* 2 i) (* 3 j) (* 5 i j))))

(define not-2-3-5 (stream-filter (lambda (x) (not (div-by-2-3-5? x))) pos-integers))

(define pairs1 (pairs not-2-3-5 not-2-3-5 weight1))
