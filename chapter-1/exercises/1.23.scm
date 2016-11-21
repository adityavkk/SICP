(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (next test-divisor)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))

(define (next input)
  (if (= input 2)
      3
      (+ input 2)))

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


(search-for-primes 1e9 1e10) ; <- 3e-2, 3.9e-2, 4e-2
(newline)
(search-for-primes 1e10 1e11) ; <- 0.109, 0.109, -.109
(newline)
(search-for-primes 1e11 1e12) ; <- 0.35, 0.35, 0.35

; The times are roughly 1.65 x faster than when we check everything
; Though we expect it to be 2 x as fast because the input size has now been halved
; it is slower than expected, maybe because of the fact that we're doing a bit more
; work per input than we were before i.e. the operations inside the next procedure
