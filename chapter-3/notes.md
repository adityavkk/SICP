# Chapter 3 

## Modularity, Objects, and State

- So far we've written __functional programs__ that encode mathematical
truths 
```scm
(define (fact n)
  (cond ((= n 1) 1)
        (else (* n (fact (- n 1))))))
```

- Whenever we have true statements of that sort, those processes can be
evolved by substitution, i.e. a sequence of equalities, always
preserving truth
- A powerful design strategy, which is particularly appropriate to the
construction of programs for modeling physical systems, is to base the
structure of our programs on the structure of the systems being modeled.
- For each object in the system, we construct a corresponding
computational object. For each system action, we define a symbolic
operation in our computational model.
- We hope that extending the model to accommodate new objects or new
actions will require no strategic changes to the program, only the
addition of the new symbolic analogs of those objects or actions.
- We will look at two different 'world views' of the structure of
systems.
- Viewing a large system as a collection of distinct objects whose
behaviors may change over time.
- View a system as streams of information that flows in the system, like
an electrical engineer views a signal-processing system.

- With objects, we must be concerned with how a computational object can
change and yet maintain its identity.
- This will force us to abandon our old substitution model of
computation in favor of a more mechanistic but less theoretically
tractable _environment model_
- __The difficulties of dealing with objects, change and identity are
a fundamental consequence of the need to grapple with time in our
computational models. These difficulties become even greater when we
allow the possibility of concurrent execution of programs.__
- __The stream approach can be most fully exploited when we decouple
simulated time in our model from the order of the events that take place
in the computer during evaluation. This will be accomplished by using
a technique known as delayed evaluation__

### 3.1 Assignment and Local State

- Assignments are special, they produce a moment in time. There is
a before and after assignment.
- The procedures we've written up to now, are independant of time. The
- substitution model describes static phenemon 

- The very fact that we're introducing assignment means that we need
a new model of computation

```scm
(define balance 100) 
(define (withdraw amount)
  (if (>= balance amount)
      (begin (set! balance (- balance amount))
             balance)
      "Insufficient funds"))
; Decremenmting balance is accomplished by the expression
(set! balance (- balance amount))

; Begin is a special form that causes more than one expression to be
; evaluated.

; We can accomplish a similar thing using a let expression to set the
; local state of balance on withdraw
(define new-withdraw
  (let ((balance 100))
    (lambda (amount)
      (if (>= balance amount)
          (begin (set! balance (- balance amount))
                 balance)
          "Insufficient funds"))))

; A functional factorial with no concept of time that can be modeled
; with substitution
(define (fact n)
  (define (iter m i)
    (cond ((> i n) m)
          (else (iter (* i m) (+ i 1)))))
  (iter 1 1))

; An imperative factorial
(define (fact n)
  (let ((i 1) (m 1))
    (define (loop)
      (cond ((> i n) m)
            (else
              (set! m (* i m))
              (set! i (+ i 1))
              (loop))))
    (loop)))
```

- `define` will always have the same value, you create something once
and it never changes

#### Making a bank account

```scm
(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch m)
    (cond ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          (else (error "Unknown request -- MAKE-ACCOUNT"
                        m))))
dispatch)
```

- Each call to `make-account` sets up an environemnt with a local state
variable `balance`. 

- Within this environment, `make-account` defines procedures `deposit`
and `withdraw` that access `balance` and an additional procedure
`dispatch` that takes a 'message' as input and returns one of the two
local procedures.

### 3.2 The Environment Model of Evaluation

- Because we've destroyed the sustitution model,
- We now have to have a model which referes to a place, this is the
environment model
```scm
; y is not bound or is free in this expression
(labmda (x) (* x y))
; * is a free variable
(lambda (y) ((lambda (x) (* x y)) 3))
```

- A procedure is made out of two parts, sort of like cons. 

- The first part refers to some code/instructions and the second refers to an
environment.

- Rule 1: A procedure object is applied to a set of arguments by
constructing a frame, binding the formal parameters of the procedure to
the actual arguments of the call, and then evaluating the body of the
procedure in the context of the new environment constructed. The new
frame has as its enclosing environment the environment part of the
procedure object being applied ![](https://i.imgur.com/SPi4Vnb.png)
- Rule 2: A lambda-expression is evaluated relative to a given
environment as follows: A new procedure object is formed, combining the
text (code) of the lambda-expr with a pointer to the environment of
evaluation
