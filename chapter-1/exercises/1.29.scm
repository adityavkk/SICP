; 1.29
(define (cube x)
  (* x x x))

(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))

(define (inc x)
  (+ x 1))

(define (simpson-pow a)
  (cond ((= a 0) 1)
        ((even? a) 2)
        (else 4)))

(define (simpson f a b n)
  (define h
    (/ (- b a) n))
  (define (y k)
    (f (+ a (* h k))))
  (define (term k)
    (* (simpson-pow k) (y k)))
  (* (/ h 3)
     (sum term 0 inc n)))

(simpson cube 0 1 100) ; <- 19/75
(simpson cube 0 1 1000) ; <- 751/3000
