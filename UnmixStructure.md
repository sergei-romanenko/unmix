# The structure of Unmix #

## Two phases of the specialization process ##

Unmix is a system that specializes programs written in a subset
of Scheme, and consists of two phases: "preprocessor" and "generator of
residual programs". The specialization is done in two steps.

At the first step, preprocessor takes a Scheme program and a descriptor
of the program's input parameters. The program is a non-empty sequence
of function definitions. The first function definition in the program is
assumed to be the "main" function of the program. The descriptor is a
string of letters "s" and "d", the length of the descriptor being equal
to the number of the main function's parameters.

The descriptor of the program's parameters classifies each parameter of
the main function as either static or dynamic. If a parameter is static,
the corresponding letter in the descriptor is "s", otherwise the letter
is "d".

Preprocessor takes as input a program and a descriptor and produces an
"annotated" version of the original program, which contains some
directions for the generator of residual programs.

At the second step, the generator of residual programs takes as input
an annotated program and a sequence of file names (separated by one or
more spaces). The number of file names must be equal to the number of
the program's static input parameters. Each of the files must contain
zero, one, or more Scheme S-expressions to be used as values of the
corresponding static parameters.

## Preprocessor ##

The preprocessing consists of several stages.

First, the original program is "desugared", i.e. compiled from Scheme to
Mixwell, which is the internal language of the specializer.

Second, all variables and operations in the program are classified as
either static or dynamic and this information is inserted into the
program. The result is an annotated version of the original program.
Annotated Mixwell programs will be regarded as programs written in
Mixwell-Ann, a version of Mixwell supplemented with additional
constructs to express annotations.

Third, some of the defined function calls in the annotated program are
annotated as "residual" in order to avoid infinite unfolding of function
calls and duplication of function calls that may result from some calls
being unfolded.



## Residual program generator ##

The generator consists of "partial evaluator", which generates residual
program by symbolically evaluating Mixwell expressions, and
"postprocessor", which performs some additional transformations of the
residual program and then translates the residual Mixwell program to
Scheme.

## The structure of the postprocessor ##

The postprocessing comprises the following stages.

  1. The first Call Graph Reduction.
  1. Arity Raising.
  1. The second Call Graph Reduction,
  1. Compilation from Mixwell into Scheme.

More information may be found in the source programs of Unmix.