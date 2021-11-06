# AOCLOP (Advent of code, with language oriented programming)

# Mission Statement

This is a project to attempt to make a language that is well-suited to solving Advent of Code problems. It is written in Racket.
Here is a blog post explaining the philosophy of the project: https://michaelrauh.github.io/jekyll/update/2020/12/06/thin-slicing-a-language.html

Advent of Code has very diverse problems that all fit into the category of non real-time data processing with small data. This is a project that is attempting to create a programming language that is good at these tasks.
A sign that this is a success will be that a user will be able to complete an Advent of Code challenge in this language more quickly than in Python.

# Roadmap
Right now there are a few answers in place. Each file is named for the day and subproblem it solves.
* 1.1.rkt: Written in `mappetizer`
* 1.2.rkt: Written in `mappetizer`. Same as 1.1 with a tiny change.
* 2.1.rkt: Written in `tape`
* 2.2_answer.rkt: Written in `search`. This program calls in to 2.2_tape.rkt which is written in `tape`. This necessesitated allowing `tape` programs to take in arguments. The tape program is otherwise the same as in 1.1
* 3.1.rkt: Written in `graphical`
* 3.2.rkt: Written in `graphical`
* 4.1.rkt: Written in `countguesser`
* 4.2.rkt: Written in `countguesser`

## Future work
1. Continue to solve days using existing or new DSLs
2. Standardize the syntax of the DSLs into one grammar
3. Create a chimera language that holds the semantics for all of these languages at once. Each language would exist in a labeled block and be able to pass data freely.

# Installing AOCLOP
Each language is in a folder by name. Install that folder to run each language. Each lanaguage uses the Beautiful Racket ecosystem. Install those tools first.

# Languages

## Mappetizer
A data pipeline language. Contains the concept of a scoping operator. Scoping down means that you are mapping over data. The last operation is an accumulator. Also contains the idea of a "convergence block" which runs code until it bottoms out at the identity of the operator.

## Tape
An array processing language (not like APL or J). Has a global tape object which it processes on each line. All statements write to the tape and the first item in the tape is the answer. This language can also accept input from external callers and in that case it will provide its answer in a lambda.

## Search
A language intended to connect to another language and give it inputs until a certain output is reached.

## Graphical
An object oriented language that does not provide the ability to create objects. There is a built in global graph that takes in data at runtime and can be queried for graph intersects across different colors.

## Countguesser
A language that is intended to search in a range of numbers and operate on the digits of the numbers. Outside of the read block, all statements are anded together boolean statements. And and or or together a sliding loop of bound variables within the context of one try. Pador pads the digits before oring over them.

