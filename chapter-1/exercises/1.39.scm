;;; 1.39

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

(define (tan-cf x k)
  (cont-frac (lambda (i)
               (cond ((= i 1) x)
                     (else (* -1 (* x x)))))
             (lambda (i) (- (* 2 i) 1))
              k))

(display (tan-cf (* 2 pi) 10.0))

