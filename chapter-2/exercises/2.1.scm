;;; 2.1
; Define a better version of make-rat that handles both positive and negative arguments.
; Make-rat should normalize the sign so that if the rational number is positive, both the numerator and
; denominator are positive, and if the rational number is negative, only the numerator is negative. 

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

(define numer car)
(define denom cdr)
(define (negate x)
  (* x -1))

(define (make-rat n d)
  (cond ((and (< n 0) (< d 0)) (make-rat (negate n) (negate d)))
        ((< d 0) (make-rat (negate n) (negate d)))
        (else (let ((g (gcd n d)))
                (cons (/ n g) (/ d g))))))

(define (print-rat x)
  (newline)
  (display (numer x))
  (display "/")
  (display (denom x)))
