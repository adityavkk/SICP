; 1.26
; By using an explicit multiplication instead of the square procedure in the expmod
; procedure, each call to expmod makes 2 calls to expmod, each with half the input
; (leading to the recurrance T(n) => 2T(n/2) which leads to a O(n log(n)) runtime)
; On the other hand, using the square procedure, each call to expmod calls expmod
; only once with the same input size of half the original input, n.
; (T(n) => T(n/2) which leads to a O(log(n)) runtime)
