;;; 1.21
; Use the smallest-divisor procedure to find the smallest divisor of each of
; the following: 199, 1999, 19999

(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test)
  (cond ((> (* test test) n) n)
        ((= (remainder n test) 0) test)
        (else (find-divisor n (+ test 1)))))

(define (print-answer)
  (display (smallest-divisor 199))
  (newline)
  (display (smallest-divisor 1999))
  (newline)
  (display (smallest-divisor 19999)))
