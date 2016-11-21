;;; 1.22
(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test)
  (cond ((> (* test test) n) n)
        ((= (remainder n test) 0) test)
        (else (find-divisor n (+ test 1)))))

(define (prime? n)
  (= (smallest-divisor n) n))

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (prime? n)
  (report-prime (- (runtime) start-time))))

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

(define (search-for-primes start stop)
  (prime-search-iter start stop 0 3))

(define (prime-search-iter start stop count limit)
  (cond ((even? start)
          (prime-search-iter (+ start 1) stop count limit))
        ((or (= count limit) (> start stop)) #t)
        ((prime? start) (timed-prime-test start)
                        (prime-search-iter (+ start 2) stop (+ count 1) limit))
        (else (prime-search-iter (+ start 2) stop count limit))))


(search-for-primes 1e9 1e10) ; <- 1000000007 *** 0.0499, 1000000009 *** 0.06, 1000000021 *** 0.06
(newline)
(search-for-primes 1e10 1e11) ; <- 0.1799, 0.1799, 0.180
(newline)
(search-for-primes 1e11 1e12) ; <- 0.58, 0.58, 0.58

; each of the calculations takes about the sqrt(10) times the ones that are one
; power of 10 above i.e. 0.180 * sqrt(10) ~ 0.58. This fits our notion. 
