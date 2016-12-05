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

## 2.2 Hierarchical Data and the Closure Property

- As we have seen, `cons` can be used to combine not only numbers but
pairs as well. As a consequence of this, pairs provide a universal
building block from which we can construct all sorts of data structures.

```scm
; Two ways of combining 1, 2, 3, and 4
(cons
  (cons 1 2)
  (cons 3 4))

(cons
  (cons 1
    (cons 2 3))
  4)
```

- The ability to create pairs whose elements are pairs is the essence of
list structure's importance as a representation tool. This is the
_closure property_ of `cons`
- Closure comes from abstract algebra and refers to the property of sets
whose elements can be combined using an operator to create other
elements of the same set. 
- The Lisp community uses the term _closure_ to refer to something
totally different, but in this book we will use it to on reference the
mathematical concept.

### 2.2.1 Representing Sequences
- A canonical way of using pairs to represent a sequence of values is
the _list_ 

```scm
(cons 1
  (cons 2
    (cons 3
      (cons 4 nil))))

; Can be abbreviated as
(list 1 2 3 4)
```

- We can think of `car` as selecting the first item in the list, and of
`cdr` as selecting the sublist consisting of all but the first item.

#### List Operations
- `list-ref` takes as arguments a list and a number _n_ and returns the
_n_ th element of the list.
  - For _n = 0_, `list-ref` returns the car of the list
  - Otherwise, `list-ref` returns the _(n - 1)_ st element of the `cdr`

```scm
(define (list-ref items n)
  (if (= n 0)
      (car items)
      (list-ref (cdr items)
                (- n 1))))
```

- `null?` tests wether its argument is the empty list
- `length` procedure calculates the length of a given list

```scm
(define (length items)
  (if (null? items)
      0
      (+ 1 (length (cdr items)))))

; Iterative implementation
(define (length items)
  (define (length-iter a count)
    (if (null? a)
        count
        (length-iter (cdr a) (+ 1 count))))
  (length-iter items 0))
```

- `append` takes two lists as arguments and combines their elements to
make a new list:

```scm
(define (append list1 list2)
  (if (null? list1)
      list2
      (cons (car list1) (append (cdr list1) list2))))
```

#### Mapping over lists
- `map` takes as arguments a procedure of oneargument and a list, and
returns a list of the results produced by applying the procedure of each
element in thelist

```scm
(define (map proc xs)
  (if (null? xs)
      xs
      (cons (proc (car xs))
            (map proc (cdr xs)))))

(map abs (list -5.0 -6.0 1.2 17)) ; <- (5.0 6.0 1.2 17)
(map (lambda (x) (* x x))
     (list 1 2 3 4)) ; <- (1 4 9 16)
```

### 2.2.2 Hierarchical Structures
- Sequences whose elements are sequences can be thought of as trees
- Recursion is a natural tools for dealing with trees. Since each branch
of a tree can be thought of as another tree.

```scm
(define (count-leaves x)
  (cond ((null? x) 0)
        ((not (pair? x)) 1)
        (else (+ (count-leaves (car x))
                 (count-leaves (cdr x))))))
```

