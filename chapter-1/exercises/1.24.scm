;;; 1.24
(define (square n)
  (* n n))

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
          (remainder (square (expmod base (/ exp 2) m))
                     m))
        (else
          (remainder (* base (expmod base (- exp 1) m))
                     m))))

(define (fermat-test n)
  (define (try a)
    (= (expmod a n n) a))
  (try (+ 1 (random (- n 1)))))

(define (fast-prime n times)
  (cond ((= times 0) true)
        ((fermat-test n) (fast-prime n (- times 1)))
        (else false)))

(define (timed-prime-test n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (fast-prime n 10000)
  (report-prime n (- (runtime) start-time))))

(define (report-prime n elapsed-time)
  (newline)
  (display n)
  (display " *** ")
  (display elapsed-time))

(define (divides? a b)
  (= (remainder b a) 0))

(define (search-for-primes start search-size)
  (cond ((divides? 2 start) (search-for-primes (+ start 1) search-size))
        ((= search-size 0) #t)
        ((fast-prime start 5)
          (timed-prime-test start)
          (search-for-primes (+ start 2) (- search-size 1)))
        (else
          (search-for-primes (+ start 2) (- search-size 1)))))

(search-for-primes 1000000000000000 100) ; <- 1000000007 *** 0.0499, 1000000009 *** 0.06, 1000000021 *** 0.06
