This is a project to attempt to make a language that is well-suited to solving advent of code problems. Below, for reference, is a brief, slightly incorrect overview of programming language features that are being kept in mind for the project.


## History of language features
1. Assembler languages as a human readable machine code(1947)
1. Assemblers as a form of untyped programming
1. Using words for programming with flow-matic (1955-1959)
1. Early high level languages and the concept of a subroutine (Cobol (1959) and fortran (1957))
1. Early functional programming, macros, and homoiconicity with LISP(1958)
1. Code blocks and ad-hoc polymorphism (overloading) with ALGOL58 (1958)
1. Static, strong typing with ALGOL58(1958)
1. Static variables in ALGOL60 (1960) (own variables)
1. Tacit programming as a paradigm with APL(1962) and J(1990) (and Forth(1970) and Haskell(1990))
1. subtype polymorphism and modern OOP with Simula (1962)
1. Pattern matching in SNOBOL(1962)
1. continuations as a mathematical discovery that were already possible in Algol60  (Adriaan van Wijngaarden 1964)
1. Garbage collection in BASIC (1964)
1. structured Programming in Algol68(1968) and C (1972)
1. Little languages with Unix (1969)
1. Stack based programming with Forth (1970) (with a foray into concatenative programming)
1. static, weak, nominal, manifest typing and pointer arithmetic with C(1972)
1. Dynamic scope with C (1972) macros
1. parallelism in C (1972) with semaphores, processes, threads and pipes
1. Logic programming with Prolog (1972)
1. parametric polymorphism with standard ML(1973) (with sum and product types)
1. Dynamic, latent typing with Scheme(1975)
1. hygienic macros with Scheme(1975)
1. Tail call optimization in Scheme(1975)
1. Closures as lexically scoped first class functions in Scheme (1975)
1. Object oriented programming and encapsulation as message passing with Smalltalk (1975)
1. Literate programming with iPython(2001) and Tex(1978)
1. pure virtual functions with C++(1980) (abstract classes in Java(1995))
1. Reference passing as an abstraction on pointers with C++(1980)
1. templates with C++(1980)
1. Mixins in Common Lisp(1984)
1. parallelism via vectorization in MATLAB(1984)
1. Advanced inheritance, design by contract, and command query separation with Eiffel(1985)
1. Purely functional lazy programming with Miranda(1985)
1. Actor based programming with Erlang(1986) and Elixir(2011) (actors as an approach to Parallelism)
1. dependent types with Coq(1989) and Agda(2007)
1. inferred, Duck typing in Python(1991)
1. Scientific computing using high level scripting languages with C backends with Python(1991) (vectorization as an approach to Parallelism)
1. Bounded parametric polymorphism and ad-hoc functional polymorphism with Type classes in Haskell(1990)
1. Laziness with Haskell(1990) - working around the lack of expressiveness of lazy systems with currying, purity and monads
1. Declarative programming with Haskell(1990) - enabled by memoization as a result of referential transparency
1. The most successful general purpose statistics DSL with R(1993)
1. Virtualization, references, and memory safety with Java(1995) (The JVM as a language platform)
1. Generics with Java(1995)
1. Interfaces with Java (1995)
1. Prototype based programming with Javascript (1995)
1. The high level OOP scripting language movement with Ruby (1995) (Smalltalk lives on, with functional and meta features)
1. Language oriented programming with Racket(1995) and MPS(2009)
1. Aspect oriented programming with AspectJ(2001) in Java(1995)
1. Structural typing in OCaml(1996) and Go(2009)
1. Traits in Groovy(2003)
1. case classes as hindley-milner types in an OOP system with Scala(2003)
1. Object-functional as a paradigm with Scala(2003), with Swift(2014) and Kotlin(2011) following
1. Implicit parameters in Scala(2003) and Idris (with implicit quantification in Haskell(1990) too!)
1. Intentional programming(2003) as a dead idea (killed by Microsoft to make way for C#)
1. statelessness (agents) as an approach to Parallelism with Clojure(2007)
1. Typed holes with Agda
1. Probabilistic programming with Church(2008) and pyro(2016)
1. Hacking languages with Arc(2008)
1. Channels as Parallelism with Go(2009)
1. flow sensitive typing with Kotlin(2011)
1. Smart pointers with Rust(2010) and C++11(2011)
1. substructural types in Rust(2010)
1. Isolates for parallelism in Dart(2011)
1. statelessness and laziness as an approach to Parallelism with Spark(2012)
1. gradual and intersection typing with typescript (2012)
1. gradual typing as linters in mypy and sorbet
1. distributed programming at the language level with Julia(2012)
1. Constraint programming with Rosette(2013)
1. Reactive programming with React(2013) and Redux(2015)
1. Protocols and protocol extensions with Swift(2014)
1. optionals as a language feature with Swift(2014), stolen from Haskell
1. Refinement types in Liquid Haskell(2014)


## The future of language features
1. concurrent ownership for parallelism with Verona
1. Affine types and the promise of no garbage collection as a result in Formality
1. Abstract GPU programming with Futhark
1. Type driven development and dependent types with Idris (essentially a general purpose theorem prover)
1. totality with Idris
1. Limiting cognitive load and Manool
1. killing S-expressions with Honu and Rhombus
1. Row polymorphism in apparently nothing (like for real, even the papers on this don't name a language)
1. Quantum programming with quipper
1. Homotopy types with Arend
1. State as everything with Obsidian
1. Typed macros with MacroML and Unseemly
1. Effects as types with Koka - the next, way more powerful Swift
1. Callable closures with Inko
1. implicit union types and method definition stacks in Crystal
1. Everything in the world with typed, lazy, actor based, dependent Racket and racket written languages, like arc and brag
1. traceable haskell with duet
1. Rail based programming in Dark
1. Rank N types, arrows, lenses, GADTs in Haskell
1. Advanced effect systems like polysemy in Haskell
1. complete consistency in design with klisp


## problems of programming
1. How do we build systems that we can add to later?
1. How do we build systems that are clear to experts or end users?
1. How do we build systems that do what we want them to do every time?
1. How do we make systems fast?
1. How do we quickly create systems to get fast answers?
1. How do we quickly build systems to compete with entrenched businesses?

## mistakes in design
1. design flaws in Futhark
1. design flaws in Flix
1. design flaws in C

## performance concerns
1. beating C performance in Inko
1. winter is coming even more quickly (a discussion of optimizing Haskell from 44 min to 4 second runtime - a clear sign that abstraction is broken)

## other weird concepts
1. fibrations
1. strong fp
1. fold as a complete model of computation
1. The spineless tagless G machine

## new ideas in implementation
1. nanopass compilers
1. verified language semantics with Racket
