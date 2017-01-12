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

#### 3.1.2 The Benefits of Introducing Assignment 

- The power of introducing assignment can be seen by the design of
a procedure `rand` that, whenever it is called, returns an integer
chosen at random.

- Let's assume that we have a procedure `rand-update` that has the
property that if we start with a given number `x1` and form

```scm
(rand-update (rand-update x1))
```

then the sequences `x1, x2, x3...` will have the desired statistical
properties of uniformity.

- We can then implement `rand` as a procedure with a local state
variable x that is initialized to some fixed value `random-init`. Each
call to `rand` computes `rand-update` of the current value of `x`,
returns this as the random number, and also stores this as the new value
of `x`

```scm
(define rand
  (let ((x random-init))
    (lambda ()
      (set! x (rand-update x))
      x)))
```

#### Sameness and change

- The issue surfacing here is more profound than the mere breakdown of
a particular model of computation. As soon as we introduce change into
our computational models, many notions that were previously
straightforward become problematical.
- Consider the concept of two things being __"the same"__, it becomes
much more difficult to make the claim that two things are __"the same"__
- A language that supports the concept that "equals can be substituted
for equals" in an expression without changing the value of the
expression is said to be __referentially transparent__. 
- "Once we forgo referential transparency, the notion of what it means for computational objects to be "the same'' becomes difficult to capture in a formal way. Indeed, the meaning of "same'' in the real world that our programs model is hardly clear in itself. In general, we can determine that two apparently identical objects are indeed "the same one'' only by modifying one object and then observing whether the other object has changed in the same way. But how can we tell if an object has "changed" other than by observing the "same' object twice and seeing whether some property of the object differs from one observation to the next? Thus, we cannot determine "change" without some a priori notion of "sameness, and we cannot determine sameness without observing the effects of change."

```scm
(define peter-acc (make-account 100))
(define paul-acc (make-account 100))
;vs
(define peter-acc (make-account 100))
(define paul-acc peter-acc)
```

### 3.2 The Environment Model of Evaluation

- Because we've destroyed the sustitution model,
- We now have to have a model which referes to a place, this is the
environment model
```scm
; y is not bound or is free in this expression
(lambda (x) (* x y))
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

## 3.3 Modeling with Mutable Data 

TODO

## 3.4 Concurrency: Time Is of the Essence

- The central issue lurking beneath the complexity of state, sameness,
and change is that by introducing assignment we are forced to admit time
into our computational models. 
- By admitting time, the result of evaluating an expression depends not
only on the expression itself, but also on whether the evaluation occurs
before or after events.
- We can go further in structuring computational models to match our
perception of the physical world.
  - Objects in the world do not change one at a time in sequence.
  Rather we perceive them as acting concurrently -- all at once.
  - It is often, therefore, natural to model systems as collections of
  computational processes that execute concurrently.
  - Just as we can make our programs modular by organizing models in
  terms of objects with seperate local state, is is often appropriate to
  divide computational models into parts that evolve separately and
  concurrently.
  - __Even if the programs are to be executed on a sequential computer,
  the practice of writing programs as if they were to be executed
  concurrently forces the programmer to avoid inessential timing
  constraints and thus makes programs more modular.__
- Concurrent computation can provide a speed advantage over sequential
computation.
  - Sequential computers execute only one operation at a time, so the
  amount of time it takes to perform a task is proportional to the total
  number of operations performed
  - However, if it is possible to decompose a problem into pieces that
  are relatively independent and need to communicate only rarely, it may
  be possible to allocate pieces to seperate computing processors,
  producing a speed advantage proportional to the number of processors
  available.
  - The complexities introduced by assignment become even more
  problematic in the presence of concurrency.

### 3.4.1 The Nature of Time in Concurrent Systems

- The indeterminacy in the ordre of events can pose serious problems in
the design of concurrent systems.

- For instance, let's look at the following procedure that lets us
withdraw from a bank account. 

```scm
(define (withdraw amount)
  (if (>= balance amount)
      (begin (set! balance (- balance amount))
             balance)
      "Insufficient funds"))
; First, we check the balance, the, we compute the new balance and
; finally set the balance to the new balance
```

- If 2 people use the same bank account and two withdraw processes
operate independently, then Peter might test the balance and attempt to
withdraw a legitimate amount. However, Paul might withdraw some funds in
between the time that Peter checks the balance and the time Peter
completes the withdrawal, thus invalidating Peter's test
- It can be even worse: Initial Balance $100 
  - Peter withdraws $10 and at the same time Paul withdraws $25, the 
  bank account ends up at $75

#### Correct behavior of concurrent programs
- To make concurrent programs behave correctly, we may have to place
some restrictions on concurrent execution.
- One possible restriction on concurrency would stipulate that no two
operations that change any shared state variables can occur at the same
time. However, this is an extremely stringent requirement that would be
both inefficient and overly conservative.
- A less stringent restriction on concurrency would ensure that
a concurrent system produces the same result as if the processes had run
sequentially in some order.

### 3.4.2 Mechanisms for Controlling Concurrency
- Suppose we have two processes, one with three ordered events (a, b, c)
and one with three ordered events (x, y, z). If they run concurrently,
with no constraints on how their execution is interleaved, then there
are 20 different possible orderings for the events that are consistent
with the individual orderings for the two processes
  - (a, b, c, x, y, z), (a, x, y, b, z, c) etc.

- We would have to consider the effects of each of these 20 orderings
and check that each behavior is acceptable. Such an approach rapidly
becomes unwieldly as the numbers of processes and events increase.

#### Serializing access to shared state
- Serialization is one mechanism that does this. Processes will execute
concurrentlly, but there will be certain collections of procedures that
cannot be executed concurrently.
  - More precisely, serialization creates distinguished sets of
  procedures such that only one execution of a procedure in each
  serialized set is permitted to happen at a time.
  - If some procedure in the set is being executed, then a process that
  attempts to execute any procedure in the set will be forced to wai
  tuntil the first execution has finished. 

- We can use serialization to controll access to shared variables. For
instance, if we want to update a shared variable based on the previous
value of that variable, we put the access to the previous value of the
variable and the assignment of the new value to the variable in the same
procedure. We then ensure that no other procedure that assigns to the
variable can run concurrently with this procedure by serializing all of
these pprocedures with the same serializer.

- This guarantees tha tthe value of the variable cannot be cahnged
between an access and the corresponding assignment.
