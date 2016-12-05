;;; 2.28 fringe
(define xs (list (list 1 2) (list 3 4)))

(define (not-pair? x)
  (and (not (pair? x))
       (not-null? x)))

(define (not-null? x)
  (not (null? x)))

(define (fringe xs)
  (cond ((null? xs) xs)
        ((not-pair? xs) (list xs))
        ((not-null? xs) (append (fringe (car xs))
                                (fringe (cdr xs))))))

(newline)
(display (fringe xs))
(newline)
