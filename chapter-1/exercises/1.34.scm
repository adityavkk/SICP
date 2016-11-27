;;; 1.34
(define (f g)
  (g 2))

; If we evaluate (f f), we are essentially asking the interpreter to evaluate
; (f 2) and that throws an error because (2 2) doesn't make sense because 2 is
; not a procedure
