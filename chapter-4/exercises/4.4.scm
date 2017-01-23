; and: The expressions are evaluated from left to right. If any expression evaluates 
; to false, false is returned; any remaining expressions are not evaluated. If 
; all the expressions evaluate to true values, the value of the last expression 
; is returned. If there are no expressions then true is returned.

; or: The expressions are evaluated from left to right. If any expression 
; evaluates to a true value, that value is returned; any remaining expressions 
; are not evaluated. If all expressions evaluate to false, or if there are no 
; expressions, then false is returned.

; Install and and or as new special forms for the evaluator by defining appropriate
; syntax procedures and evaluation procedures eval-and and eval-or

(define (eval exp env)
  (cond ((and? exp) (eval-and exp env))
        ((or? exp) (eval-or exp env))))

(define (eval-and exps env)
  (cond ((last-exp? exps) (eval (first-exp exps) env))
        ((null? exps) 'true)
        ((false? (eval (first-exp exps) env)) 'false)
        (else (eval-and (rest-exp exps) env))))

(define (and? expr)
  (tagged-list? expr 'and))

(define (or? expr)
  (tagged-list? expr 'or))

(define (first-exp exp)
  (cadr exp))

(define (rest-exp exp)
  (cddr exp))

(define (eval-or exps env)
  (cond ((last-exp? exps) (eval (first-exp exps) env))
        ((true? (eval (first-exp exps) env)) 'true)
        ((null? exps) 'false)
        (else (eval-or (rest-exp exps) env))))

; as derived expressions
(define (eval exp env)
  (cond ((and? exp) (eval (and->if exp) env))
        ((or? exp) (eval (or->if exp) env))))

(define (and->if exp)
  (expand-and-clauses (and-clauses exp)))

(define (expand-and-clauses clauses)
  (if (null? clauses)
      'true
      (let ((first (car clauses))
            (rest (cdr clauses)))
        (make-if first (expand-and-clauses rest) 'false))))

(define (or->if exp)
  (expand-or-clauses (or-clauses exp)))

(define (expand-or-clauses clauses)
  (if (null? clauses)
      'false
      (let ((first (car clauses))
            (rest (cdr clauses)))
        (make-if first 'true (expand-or-clauses rest)))))
