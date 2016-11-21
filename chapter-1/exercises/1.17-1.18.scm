;;; 1.17
; Design a multiplication procedure analogous to fast-expt that uses a 
; logarithmic number of steps.

(define (even? n)
  (= (remainder n 2) 0))

(define (double n)
  (+ n n))

(define (halve n)
  (define (halve-iter n div)
    (if (= (double div) n)
        div
        (halve-iter n (+ div 1))))
  (halve-iter n 0))

(define (fast-mult a b)
  (if (= b 1)
      a
      (if (even? b)
        (fast-mult (double a) (halve b))
        (+ a (fast-mult a (- b 1))))))

;;; 1.18
; Devise a procedure that generates an iterative process for multiplying two
; integers in terms of adding, doubling, and halving and uses a log number of steps
(define (fast-mult-iter a b)
  (fast-mult-iterator a b 0))

(define (fast-mult-iterator a b accum)
  (cond ((= b 1) (+ accum a))
        ((= b 0) 0)
        ((even? b)
          (fast-mult-iterator (double a)
                              (halve b)
                              accum))
        (else
          (fast-mult-iterator a (- b 1) (+ accum a)))))
