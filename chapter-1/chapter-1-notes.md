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

### 1.2.2 Tree Recursion
- Consider the evolved process of the fibonacci algorithm defined by the
following code

```scm
(define fib
  (lambda (n)
    (cond ((= n 0) 0)
          ((= n 1) 1)
          (else (+ (fib (- n 1))
                   (fib (- n 2)))))))
```

To compute `(fib 5)`, we need to compute `(fib 4)` and `(fib 3)`, and
for (fib 4) we need `(fib 3)` `(fib 2)` this forms a tree structure. 
- It is important to note that there is a lot of duplicated work in the
recursion tree i.e. `(fib 5)` needs `(fib 3)` but `(fib 4)` does also
and the calculation of `(fib 3)` happens twice. 
- The value of Fib(n) grows exponentially with n and the number of calls
to Fib(1) and Fib(0) is Fib(n + 1), therefore the time complexity of
this implementation is O(Fib(n)) or O(ø^n)
- The space required for this implementation grows only linearly with
the input `n`. 
  - In general, the number of steps required by a tree-recursive process
  will be proportional to the number of nodes in the tree, and the space
  required will be proportional to the maximum depth of the tree.

#### An iterative process to calculate fib 
- The idea is to use a pair of numbers `last` (F(n - 1)) and `second`
(F(n - 2)) to remember the state of the previous calculations and
constently update `last <- last + second`, `second <- last` and `target
<- target - 1` and return the last value when the target you're looking for
reaches `0`

```scm
(define (fib1 n) 
  (define (fib-iter tar last second) 
    (if (= tar 0) 
        last
        (fib-iter (- tar 1) (+ last second) last))) 
  (fib-iter n 0 1)) 
```

- It's fairly straight forward to see that this process requires
a linear number of steps to complete i.e. n steps.

#### Example: Counting Change

- It is not a big leap to come up with an iterative Fibonacci algorithm.
However, a problem like coin change has a simple solution as a recursive
procedure, but isn't straightforwardly translated into an iterative
process.
- The problem goes as follows: Can we write a procedure to compute the
number of ways to change any given amount of money?
  - For instance, how many ways can we make change of $1.00 given
  half-dollars, quarters, nickels and pennies? 

##### A Recursive Solution
- We can think of the ways to change an amount ___a___ using ___n___
coin types as:
  - The number of ways to change ___a___ using all but the first coin
  plus
  - The number of ways to change ___a___ using at least one of the first
  coin i.e. the number of ways to make change of amount ___a - d___
  using the same set of coin denominations.
- Thus, we can recursively reduce the problem of changing a given amount
to the problem of changing smaller amounts using fewer kinds of coins.
- Base Cases: 
  - If `(= a 0)`, this counts as exactly 1 way of making change
  - If `(< a 0)`, this counts as 0 ways of making change
  - If there are no more coins, i.e. `(= n 0)`, this also counts as 0 ways

```scm
; Coin Change
(define (change a n)
  (define (first n)
    (cond ((= n 1) 1)
          ((= n 2) 5)
          ((= n 3) 10)
          ((= n 4) 25)
          ((= n 5) 50)))
  (cond ((= a 0) 1)
        ((or (< a 0) (= n 0)) 0)
        (else (+ (change a (- n 1))
                 (change
                   (- a (first n))
                   n)))))

(change 100 5) ; -> 292 ways to make one dollar
```

- `(change a n)` generates a tree recursive process with duplicated
calls similar to those in our first implimentation of `fib`
- It is not obvious how to design a better algorithm for computing the
result.

### 1.2.4 Exponentiation
- The following algorithm describes a basic exponentiation algorithm in
a linear recursive process 

```scm
; Basic Exp recursive
(define (expt a n)
  (if (= n 0)
      a
      (* a (expt (- n 1)))))

```

- This process requires θ(n) steps and θ(n) space, where n is the
exponent
- It isn't too difficult to come up with a linear iterative process for
exponentiation

```scm
; Basic Exp Iterative
(define (expt-iter a n prod)
  (cond ((= n 0) 1)
        ((= n 1) prod)
        (else (expt-iter a (- n 1) (* a prod)))))

(define (expt1 a n)
  (expt-iter a n a))
```

- This process requires θ(n) steps and θ(1) space.
- However, we can compute exponentials in fewer than linear steps by
___successive squaring___ 

```
b^8 = b * b * b * b * b * b * b * b
b^2 = b * b
b^4 = b^2 * b^2
b^8 = b^4 * b^4
```

- This method works for even exponents _n_ but with a slight
modification we can also account for odd exponents.
  - note that if n is odd (n - 1) is even

```
b^n = (b^(n/2))^2 if n is even
b^n = b * b^(n - 1) if n is odd
```

- We can express this method as the following procedure:

```scm
; Successive Squaring
(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((even? n) (square (fast-expt b (/ n 2))))
        (else (* b (fast-expt b (- n 1))))))

(define (even? n)
  (= (remainder n 2) 0))
```

- This `fast-expt` process grows θ(log(n))
  - To see this, observe that computing `b^2n` only requires one
  additional multiplication than computing `b^n`
