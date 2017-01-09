(define x (list 'a 'b 'c))

(define x1 (list (list 'george)))
(define x3 (cdr '((x1 x2) (y1 y2))))
(define x4 (cadr '((x1 x2) (y1 y2))))
(define x5 (pair? (car '(a short list))))
(define x6 (memq 'red '((red shoes) (blue socks))))
(define x7 (memq 'red '(red shoes blue socks)))
