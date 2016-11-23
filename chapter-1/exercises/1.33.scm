; 1.33
(define (filtered-accumulate filter-fn comb null-val term a next b)
  (if (> a b)
      null-val
      (if (filter-fn a)
          (comb (term a)
                (filtered-accumulate filter-fn comb null-val term (next a) next b))
          (filtered-accumulate filter-fn comb null-val term (next a) next b))))

(define (sum-of-prime-squares a b)
  (filtered-accumulate prime? + 0 square a inc b)) ; <- (sum-of-prime-squares 2 5) = 38

(define (prod-of-rel-prime n)
  (define (rel-prime? i)
    (if (= (gcd i n) 1)
        #t
        #f))
  (filtered-accumulate rel-prime? * 1 ident 2 inc (- n 1)))

(define (inc x) (+ 1 x))
(define (ident x) x)

(define (prime? n)
  (fermat-test n 100))

(define (fermat-test n times)
  (cond ((= times 0) #t)
        ((fermat n) (fermat-test n (- times 1)))
        (else #f)))

(define (fermat n)
  (define (try a)
    (= (expmod a n n) a))
  (try (+ 1 (random (- n 1)))))

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
          (remainder (square (expmod base (/ exp 2) m)) m))
        (else
          (remainder (* base (expmod base (- exp 1) m)) m))))

(define (square n)
  (* n n))
