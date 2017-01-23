# Chapter 4 - Metalinguistic Abstraction

- Establishing new languages is a powerful strategy for controlling
complexity in engineering design.
- Programming is endowed with a multitude of languages. There are
physical languages, such as the machine languages for particular
computers. These languages are concerned with the representation of data
and control in terms of individual bits of storage and primitive machine
instructions.
- Machine-language programmers are concerned with using the given
hardware to erect systems and utilities for the efficient implementation
of resource-limited computations. 
- High-level languages, erected on a machine-language substrate, hide
concerns about the representation of data as collections of bits and the
representation of programs as sequences of primitive instructions.
- _Metalinguistic abstraction_ -- establishing new languages -- plays an
important role n all branches of engineering design. 
- We can not only formulate new languages but we can also implement
these languages by constructing evaluators. 
- It is no exaggeration to regard this as the most fundamental idea in
programming:
  - The evaluator, which determines the meaning of expressions in
  a programming language, is just another program.
- To appreciate this point is to change our images of ourselves as
programmers. We come to see ourselves as designers of languages, rather
than only users of languages designed by others.
- In fact, we can regard almost any program as the evaluator for some
language

## 4.1 The Metacircular Evaluator
- An evaluator that is written in the same language that it evaluates is
said to be _metacircular_

### 4.1.1 The Core of the Evaluator
- The evaluation process can be described as the interplay between two
procedures: `eval` and `apply`

#### Eval
- `eval` takes as arguments an expression and an environment.
- It classifies the expression and directs its evaluation.
- `eval` is structred as a case analysis of the syntactic type of the
expression to be evaluated.

##### Primitive Expressions
- For self-evaluating expressions, such as numbers, `eval` returns the
expression itself.
- `eval` must look up variables in the environment to find their values.

##### Special Forms
- For quotes exps, `eval` returns the expression that was quoted.
- An assignment to (of a definition of) a variable must recursively vall
`eval` to compute the new value to be associated with the variable. The
environment must be modified to change (or create) the binding of the
variable.
- An `if` expression requires special processing of its parts, so as to
evaluate the consequent if the predicate is true, and otherwise to
evaluate the alternative.
- a `lambda` expression must be transformed into an applicable procedure
by packaging together the parameters and body specified by the `lambda`
expression with the environment of the evaluation.
- A `begin` expression requries evaluating its sequence of expresions in
the order in which they appear
- A case analysis (`cond`) is transformed into a nest of `if`
expressions and then evaluated.

##### Combinations
- For a procedure application, `eval` must recursively evaluate the
operator part and the operands of the combination. The resulting
procedure and arguments are passed to `apply`, which handles the actual
procedure application.

Here is the definition of `eval`:

```scm
(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((assignment? exp) (eval-assignment exp env))
        ((definition? exp) (eval-definition exp env))
        ((if? exp) (eval-if exp env))
        ((lambda? exp)
         (make-procedure (lambda-parameters exp)
                         (lambda-body exp)
                         env))
        ((begin? exp)
         (eval-sequence (begin-actions exp) env))
        ((cond? exp) (eval (cond->if exp) env))
        ((application? exp)
         (apply (eval (operator exp) env)
                (list-of-values (operands exp) env)))
        (else
         (error "Unknown expression type -- EVAL" exp))))
```

- For clarity, `eval` has been implemented as a case analysis using
`cond`. The disadvantage of this is that our procedure handles only
a few distinguishable types of expressions, and no new ones can be
defined without editing the definition of `eval`

#### Apply
- `apply` takes two arguments, a procedure and a list of arguments to
which the procedure should be applied.
- `apply` classifies procedures into two kinds: It calls
`apply-primitive-procedure` to apply primitives; it applies compound
procedures by sequentially evaluating the expressions that make up the
body of the procedure.

```scm
(define (apply procedure arguments)
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure procedure arguments))
        ((compound-procedure? procedure)
         (eval-sequence
           (procedure-body procedure)
           (extend-environment
             (procedure-parameters procedure)
             arguments
        (else(procedure-environment procedure))))
         (error
          "Unknown procedure type -- APPLY" procedure))))
```

#### Procedure Arguments
- When `eval` processes a procedure application, it uses `list-of-values`
to produce the list of arguments to which the procedure is to be
applied.

```scm
(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (cons (eval (first-operand exps) env)
            (list-of-values (rest-operands exps) env))))
```

#### Conditionals
- `eval-if` evaluates the predicate part of an `if` expression in the
given environment and does the appropriate thing

```scm
(define (eval-if exp env)
  (if (true? (eval (if-predicate exp) env))
      (eval (if-consequent exp) env)
      (eval (if-alternative exp) env)))
```

#### Sequences
- `eval-sequence` is used by `apply` to evaluate the sequence of
expressions in a procedure body and by `eval` to evaluate the sequence
of expressions in a `begin` expression.

```scm
(define (eval-sequence exps env)
  (cond ((last-exp? exps) (eval (first-exp exps) env))
        (else (eval (first-exp exps) env)
              (eval-sequence (rest-exps exps) env))))
```

#### Assignments and definitions
- The following procedure handles assignments to variables. It calls
`eval` to find the value to be assigned and transmits the variable and
the resulting value to `set-variable-value!` to be installed in the
designated environment

```scm
(define (eval-assignment exp env)
  (set-variable-value! (assignment-variable exp)
                       (eval (assignment-value exp) env)
                       env)
  'ok)
```

- Definitions of variables are handled in a similar manner

### 4.1.2 Representing Expressions

