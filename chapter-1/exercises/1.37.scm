;;; 1.37
(define actual 0.618033988749)

(define (cont-frac n d k)
  (cont-frac-rec n d k 1))

(define (cont-frac-rec n d k i)
  (let ((ni (n i))
        (di (d i)))
    (if (= k i)
        (/ ni di)
        (/ ni (+ di (cont-frac-rec n
                                   d
                                   k
                                   (+ i 1)))))))

(define (calc-phi k)
  (cont-frac (lambda (i) 1.0)
             (lambda (i) 1.0)
             k))

(define (close-enough? guess val)
  (< (abs (- guess val)) 0.0001))

(define (inverse-phi-steps i)
  (define val (calc-phi i))
  (if (close-enough? val actual)
      i
      (inverse-phi-steps (+ i 1))))

(display (inverse-phi-steps 1.0))
(newline)
