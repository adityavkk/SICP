;;; 2.27 Deep Reverse
(define xs (list (list 1 2) (list 3 4)))

(define (non-pair? x)
  (not (pair? x)))

(define (deep-reverse xs)
    (cond ((non-pair? xs) xs)
          (else (let ((reversed (reverse xs)))
                  (cons (deep-reverse (car reversed))
                        (deep-reverse (cdr reversed)))))))

(newline)
(display (reverse xs))
(newline)
(display (deep-reverse xs))
(newline)
