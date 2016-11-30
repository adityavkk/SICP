;;; 1.38
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

(define (calc-e-2 k)
  (cont-frac (lambda (i) 1.0)
             (lambda (i)
               (cond ((= (remainder i 3) 2) (* 2 ( + 1 (/ (- i 2) 3))))
                     (else 1)))
             k))

; d(i) is given by
;   | 3i + 2 = 2 * (i + 1) or for i mod 3 = 2
;   | otherwise 1
