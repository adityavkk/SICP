(define (reverse xs)
  (define (reverse-iter xs rxs)
    (if (null? xs)
        rxs
        (reverse-iter (cdr xs)
                      (cons (car xs) rxs))))
  (reverse-iter xs (list)))

(define (reverse-prime xs)
  (if (null? (cdr xs))
      xs
      (append (reverse (cdr xs))
              (cons (car xs) (list)))))

(define xs (list 1 2 3 4))
(newline)
(display (reverse-prime xs))
(newline)
(display (reverse xs))
