(define (square n)
  (* n n))

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
          (define next-expmod
            (expmod base (/ exp 2) m))
          (define next-expmod-square
            (square next-expmod))
          (define mod-m
            (remainder next-expmod-square m))
          (if (and
               (and (> next-expmod 1) (< next-expmod (- m 1))
                    (= mod-m 1)))
            0
            mod-m))
        (else
          (remainder (* base (expmod base (- exp 1) m))
                     m))))

(define (miller-rabin n)
  (define (try a)
    (define expmod-res
      (expmod a n n))
    (if (= expmod-res 0)
        #f
        (= expmod-res a)))
  (try (+ 1 (random (- n 1)))))

(define (miller-rabin-test n times)
  (cond ((= times 0) #t)
        ((miller-rabin n) (miller-rabin-test n (- times 1)))
        (else #f)))

(define (run-miller-rabin n)
  (miller-rabin-test n 100))

