;;; 1.19
; We can characterize fib-iter by the two state variables a and b and the transformation
; T => a <- a + b and b <- a, after applying this transformation n times starting
; with 1 and 0 we get the pair Fib(n+1) and Fib(n).
; Consider that the above transformation T is a special case of Tpq which transforms
; a <- bq + aq + ap and b <- bp + aq.

; Show that if we apply such a transformation Tpq twice, the effect is the same as using
; a single transformation Tp'q' of the same form, and compute p' and q' in terms
; of p and q. This gives us an explicit way of squaring this transformation and thus
; we can compute T^n using succesive squaring.


