; (let ((var1 exp1) ... (varn expn))
;    body)
; is equivalent to
; ((lambda (var1 ... varn) body) exp1 ... expn)

; Implement a syntactic transformation let->combination that reduces evaluating
; let expressions to evaluating combinations of the type shown above, and add the
; appropriate clause to eval to handle let expressions

(define (eval exp env)
  (cond ((let? exp) (eval (let->combination exp) env))))

(define (let->combination exp)
  (cons (make-lambda (vars exp) (body exp)) (let-expressions exp))

(define (vars exp)
  (map car (cadr exp)))

(define (body exp)
  (cddr exp))

(define (let-expressions exp)
  (map cadr (cadr exp)))
