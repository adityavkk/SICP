;;; 2.33
; Fill in the missing expressions to complete the following definitions of some basic listmanipulation
; operations as accumulations:

(define (map-prime p sequence)
  (accumulate
    (lambda (x y)
      (cons (p y) x))
    nil
    sequence)
