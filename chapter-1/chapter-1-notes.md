#Building Abstractions with Proceduers
- A computational processes are abstract beings that inhabit computers.
- They manipulate other abstract things called data. 
- They are controlled by a pattern of rules called programs
- Why lisp?
  - lisps Descriptions of prcesses called procedures, can themselves be
  manipulated as lisp data
  - "The ability to represent procedures as data also makes lisp an
   excellent language to manipulate other programs as data, such as the
   interpreters and compilers that support computer languages"

## 1.1 The Elements of Programming
- A powerful programming language provides ways to combine simple
programs into complex ones. 
  - __Primitive expressions__, the simplest entities that language is
  concerned with
  - __means of combination__ - the ways in which complex elements are
  built from simple ones
  - __means of abstraction__ - how compound elements can be named and
  manipulated as units
- Two kinds of elements in programming: proceduers and data

#### 1.1.2 Naming and the Environment 

```scm
(define pi 3.1415)
(define radius 10)
(* pi (* radius radius)) ;314.159
(define circumference (* 2 pi radius)) ;62.8318
```
- The compiler must keep track of the name-object pairs that define
provides us
- This memory is called the environment

#### 1.1.4 Compound Procedures 

```scm 
(define (square x) (* x x))

(define (sum-of-squares x y)
 (+ (square x) (square y)))

(define (f a) (sum-of-squares (+ a 1) (* a 2))) 
; f (a) = (a + 1)^2 + (2*a)^2 
``` 

#### 1.1.6 Conditional Expressions and Predicates (1.1.6)
- __Case analysis__
```scm

(define (abs x)
 (cond ((> x 0) x)
       ((= x 0) 0)
       ((< x 0) (- x))))
```
   The general form of a conditional expression is
   ``` 
   (cond (<p1> <e1>) (<p2> <e2>))
   ```  

   Where the pairs p1, e1 are called clauses and consist of a predicate
   and an expression. If none of the predicates of a case statement
   return true, the value of the cond is undefined

  Another way to express the absolute value function is to use the else
  clause which acts as a catch all.
   
   ```scm
(define (abs1 x)
 (cond ((< x 0) (- x))
       (else x)))
   ```

  Yet another way to define the abs function is to use the special form
  'if' which can be used when there are exactly two cases in the case
  analysis

- Other logical composition operators
```scm
(define (greater-than-both x y z)
  (and (x > y)
       (x > z)))

(define (equal-to-either x y z)
  (or (= x y)
      (= x z)))

(define (is-not-equal x y)
  (not (= x y)))
```

#### 1.1.7 Example: Square Roots by Newton's Method
- Computational procedures are like mathematical functions but with an
important difference, procedures must be effective.
- For instance, take the mathematical definition of a square root:
  `sqrt(x) = all y s.t. y >= 0 and y^2 = x` We can use this to check if
  some y is the sqrt of x, but it doesn't describe a procedure.
- This distinction is sometimes referred to as the distinction between
declarative and imperative knowledge.
- A common algorithm to compute the sqrt of a number is using newtons
method

```scm
(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x) 
       x)))

(define (improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (good-enough? guess x) ; convention to name predicates with ?
  (<
    (abs (- (square guess) x))
    0.001))

(define (square x)
  (* x x))

(define (sqrt x)
  (sqrt-iter 1.0 x))
```

- The sqrt program illustrates that the simple procedural language we
have inroduced so far is sufficient for writing any purely numerical
program. 
- What is surprising about this is that we have not included any
iterative constructs. `sqrt-iter` demonstrates how one can accomplish
iteration using only the ability to call a procedure.

#### 1.1.8 Procedures as Black-Box Abstractions
- The importance of decomposing programs and procedures into smaller,
"black-boxes" isn't just in dividing it into smaller parts. Rather, it
is in abstracting away smaller, identifiable, more atomic processes 

```scm
; With respect to sqrt, for instance, it doesn't matter how square 
; is implimented. Square can be optimized for different machines, styles
; etc. 

(define (square x) (* x x))

(define (square x)
  (define (double x) (+ x x))
  (exp (double (log x))))
; You can imagine how if your machine had an expansive look-up table for
; logarithms and exp that the second definition of square might be better
```

- A procedure definition should be able to supress detail and a user of
a particular procedure should not need to know how the procedure is
implemented in order to use it.

##### Block Structure
- In our previous definition of sqrt, we had auxiliary procedures like
square, good-enough?, improve etc. The problem with this is that the
only procedure that is important to users of sqrt is sqrt. The other
procedures only add clutter. 
- We can solve this by localizing the subprocedures, hiding them inside
sqrt.
- In addition, since x is bound in the definition of sqrt, all the other
subprocedures are in the scope of x. So, we don't even need to pass
x explicitly to each of these procedures.
- Making x a free variable with respect to the internal definitions!
- This is called _lexical scoping_

```scm
(define (sqrt x)

  (define (good-enough? guess x)
    (< (abs (- (square guess) x)) 0.001))

  (define (improve guess)
    (average guess (/ x guess)))

  (define (sqrt-iter guess)
    (if (good-enough? guess)
        guess
        (sqrt-iter (improve guess))))

  (sqrt-iter 1.0))
```

## 1.2 Procedures and the Processes They Generate 

### 1.2.1 Linear Recursion and Iteration

```scm
(define (factorial n) 
  (if (= n 1) 
    1 
    (* n factorial(n - 1))))

(define (fact n)
  (define (iter prod counter)
    (if (= counter n)
        prod
        (iter (* prod counter)
              (+ counter 1))))
  (iter 1 1))
```

#### Distinction Between A Recursive Process And A Recursive Procedure
- From one point of view, both of these implementations are the same.
Both require a number of steps proportional to n to compute n!, both of
these processes even carry out the same series of multiplications
- In the first implementation of factorial, however, the process built
up a chain of _deferred operations_
  - This type of process, characterized by a chain of deferred
  operations, is called a _recursive process_
  - Carrying out this process requires that the interpreter keep track
  of the chain of deferred multiplications. 
  - Don't confuse the notion of a recursive _process_ with a recursive
  _procedure_. Recursive _procedures_ refer to the _procedure_ itself. 
  - When we describe a recursive _process_ we are refering to how the
  _process_ itself evolves not how the _procedure_ itself is defined.
  - This might be confusing because most implementations of common
  languages are designed in such a way that the interpretation of any
  recursive procedure consumes an amount of memory that grows with the
  number of procedure calls, even when the process described is, in
  principle, iterative. As a consequence, these languages tend to
  describe iterative processes only by resorting to special-purpose
  "looping constructs" like _do, for, while, etc._
  - Scheme doesn't share this defect. It executes iterative processes in
  constant space, even if the iterative process is described by
  a recursive procedure. An implementation with this property is said to
  be ___tail recursive___
  - With a tail recursive implementation, iteration can be expressed
  using the ordinary procedure call mechanism so that special iteration
  constructs are useful only as syntactic sugar.
