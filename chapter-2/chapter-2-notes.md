### 2.1.2 Abstraction Barriers
- _Abstraction Barriers_ isolate different 'levels' of the system.
- Procedures at each level are the interfaces that define the
abstraction barriers and connect the different levels.

### 2.1.3 What is Meant by Data?
- In general, we can think of data as defined by some collection of
selectors and constructors, together with specified conditions that
these procedures must fulfill in order to be a valid representation.
- We can use this point not only for 'high-level' data objects, such as
rational numbers, but also for lower-level objects.
- Consider the notion of a pair. The only thing we need to know about
them is that if we glue two objects together using `cons` we need to be
able to retrieve the objects using `car` and `cdr`
- This point is illustrated strikingly by the fact that we could
implement `cons, car` and `cdr` without using any data structures at all
but only using procedures.

```scm
(define (cons x y) 
  (lambda (pick)
    (cond ((= pick 1) x)
          ((= pick 2) y)
          (else (error "Argument not 0 or 1 -- CONS" m)))))

(define (car z) (z 0))
(define (cdr z) (z 1))
```

- The point of exhibiting this procedural representation of pairs is not
that our language works this way (Scheme, and Lisp systems in general,
implement pairs directly, for efficiency reasons) but that it could work
this way. 
- Although obscure, the procedural representation is a perfectly
adequate way to represent pairs, since it fulfills the only axion that
pairs need to fulfill.
- This style of programming is often called _message passing_
