;;; 2.6
; The higher-order-function that represents the natural number n is a function
; that maps any given function f to it's n-fold composition.
; All Church numerals are functions that take two parameters

; For instance, the number 3 can be represented by the action of applying any
; given function three times to a given value.

; In Haskell
; church :: Int -> Church Int
; church 0 = \f -> \x -> x
; church n = \f -> \x -> f (church (n - 1) f x)

; unchurch :: Church Int -> Int
; unchurch churchNum = churchNum (+ 1) 0

(define (add-cn a b)
  (lambda (f)
    (lambda (x)
      ((b f) ((a f) x)))))

(define (inc x)
  (+ x 1))

(define (unchurch cn)
  ((cn inc) 0))

(define zero
  (lambda (f)
    (lambda (x)
      x)))

(define (add-1 n)
  (lambda (f)
   (lambda (x)
     (f ((n f) x)))))

