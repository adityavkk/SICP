# Computing With Register Machines

- In order to provide a more complete description of the control
structure of the Lisp evaluator, we must work at a more primitive level
than Lisp itself.
- A traditional computer, or _register machine_, sequentially executes
_instructions_ that manipulate the contents of a fixed set of storage
elements called _registers_ 
- A typical register-machine instruction applies a primitive operation
to the contents of some registers and assigns the result to another
register.
- We will approach our task from the prespective of a hardware architect
rather that that of a machine-language computer programmer.

## 5.1 Designing Register Machines
- To design a register machine, we must design its _data paths_ (registers 
and operations) and the _controller_ that sequences these operations.

```scm
(define (gcd a b)
  (if (= b 0)
    a
    (gcd b (remainder a b))))
```

- A machine to carry out this algorithm must keep track of two numbers,
_a_ and _b_, so let us assume that these numbers are stored in two
registers with those names.
- On each cycle of the GCD algorithm, the contents of register `a` must
be replaced by the contents of register `b`, and the contents of `b`
must be replaced by the remainder of the old contents of `a` divided by
the old contents of `b`.
- To accomplish this swap, our machine will use a third "temporary"
register, which we call `t`.
- In order for the data paths to actually compute GCDs, the buttons must
be pushed in the correct sequence. We will describe this sequence in
terms of a controller diagram.
- The elements of a controller diagram identify data-path buttons to be
pushed, and the arrows describe the sequencing from one step to the
next. The diamond in the diagram represents a decision.
- Think of the diagram as a maze in which a marble is rolling. When
a marble rolls into a box, it pushes the data-path button that is named
by the box. When the marble rolls into a decision node, it leaves the
node on the path determined by the result of the indicated test. 
- Taken together, the data paths and the controller completely describe
a machine for computing GCDs.

### 5.1.1 A Language for Describing Register Machines
- Data-pth and controller diagrams are adequate for representing simple
machines such as GCD, but they are unwieldy for describing large
machines such as a Lisp interpreter. To make it possible to deal with
complex machines, we will create a language that presents, in textual
form, all the information given by the data-path and controller
diagrams. We will start with a notation that directly mirrors the
diagrams.

- We define the data paths of a mchine by describing the registers and
the operations. To describe a register, we give it a name and specify
the buttons that control assignment to it. We give each of these buttons
a name and specify the source of the data that enters the register under
the button's control

- We define the controller of a machine as a sequence of _instructions_
together with _labels_ that identify _entry points_ in the sequence. An
instruction is one of the following: 
  - The name of a data-path button to push to assign a value to
  a register (This corresponds to a box in the controller diagram).
  - A `test` instruction, that performs a specified test.
  - A conditional branch (`branch` instruction) to a location indicated
  by a s controller label, based on the result of the previous test.
  - An unconditional branch (`goto` instruction) naming a controller
  label at which to continue execution.

- The machine starts at the beginning of the controller instruction
sequence and stops when the execution reaches the end of the sequence.
  - Except when a branch changes the flow of control, instructions are
  executed in the order in which they are listed

```scm
(data-paths
 (registers
  ((name a)
   (buttons ((name a<-b) (source (register b)))))
  ((name b)
   (buttons ((name b<-t) (source (register t)))))
  ((name t)
   (buttons ((name t<-r) (source (operation rem))))))
 (operations
  ((name rem)
   (inputs (register a) (register b)))
  ((name =)
   (inputs (register b) (constant 0)))))

(controller
 test-b ; label
   (test =) ; test
   (branch (label gcd-done)) ; conditional branch
   (t<-r) ; button push
   (a<-b) ; button push
   (b<-t) ; button push
   (goto (label test-b)) ; unconditional branch
  gcd-done) ; label
```

- Unfortunately, it is difficult to read such a description. In order to
understand the controller instructions we must constantly refer back to
the definitions of the button names and the operation names, and to
understand what the buttons do we may have to refer to the definitions
of the operation names. We will thus transform our notation to combine
the information from the data-pah and the controller descriptions so
that we see it all togther.

- To obtain this form of description, we will replace the arbitrary
button and operation names by the definitions of their behavior. 
- Instead of saying (in the controller) "Push button `t<-r`"  and
seperately saying (in the data-paths) "Button `t<-r` assigns the value
of the `rem` operation to register `t`" and "The `rem` operation's
inputs are the contents of registers `a` and `b`, we will say (in the
controller) "Push the button that assigns to the register `t` the value
of the `rem` operation on the contents of registers `a` and `b`"

```scm
(controller
  test-b
    (test (op =) (reg b) (const 0))
    (branch (label gcd-done))
    (assign t (op rem) (reg a) (reg b))
    (assign a (reg b))
    (assign b (reg t))
    (goto (label test-b))
  gcd-done)
```

### 5.1.4 Using a Stack to Implement Recursion
