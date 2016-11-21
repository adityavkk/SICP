;;; 1.19
; We can characterize fib-iter by the two state variables a and b and the transformation
; T => a <- a + b and b <- a, after applying this transformation n times starting
; with 1 and 0 we get the pair Fib(n+1) and Fib(n).
; Consider that the above transformation T is a special case of Tpq which transforms
; a <- bq + aq + ap and b <- bp + aq.

; Show that if we apply such a transformation Tpq twice, the effect is the same as using
; a single transformation Tp'q' of the same form, and compute p' and q' in terms
; of p and q. This gives us an explicit way of squaring this transformation and thus
; we can compute T^n using succesive squaring.

;;;;;;;;;; Solution ;;;;;;;;;;
; We know that Tp'q' is of the same form as Tpq:

; ∴ Tp'q' =>
;            a <- bq' + aq' + ap'
;            b <- bp' + aq'

; We also know that Tp'q' is T^2
; ∴ Tp'q' =>
;            a <- (bp + aq) q + (bq + aq + ap) q + (bq + aq + ap) p
;                 = b (q^2 + 2pq) + a (p^2 + q^2) + a (q^2 + 2pq)
;            b <- (bp + aq) p + (bq + aq + ap) q
;                 = b (p^2 + q^2) + a (2pq + q^2)

; ∴  p' = (p^2 + q^2)
;    q' = (2pq + q^2)

(define (fib n)
  (fib-iter 1 0 0 1 n))

(define (square n)
  (* n n))

(define (fib-iter a b p q count)
  (define (p-prime p q)
    (+ (square p) (square q)))
  (define (q-prime p q)
    (+ (* 2 p q) (square q)))
  (cond ((= count 0) b)
        ((even? count)
          (fib-iter a
                    b
                    (p-prime p q)
                    (q-prime p q)
                    (/ count 2)))
        (else (fib-iter (+ (* b q) (* a q) (* a p))
                        (+ (* b p) (* a q))
                        p
                        q
                        (- count 1)))))


