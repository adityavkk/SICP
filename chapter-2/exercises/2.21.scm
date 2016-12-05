;;; 2.21
(define (square x)
  (* x x))

(define nil (list))

(define (square-list items)
  (if (null? items)
      nil
      (cons (square (car items))
            (square-list (cdr items)))))

(define (square-list-prime items)
  (map square items))

(define xs (list 1 2 3 4))
(newline)
(display (square-list xs))
(newline)
(display (square-list-prime xs))
