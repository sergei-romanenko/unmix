# The languages related to Unmix #

There are several languages Unmix is associated with:

  * The implementation language: Scheme + a few macros.
  * The input language: a subset of Scheme + a few macros.
  * The internal language Mixwell.
  * The internal language Mixwell-Ann.

## The implementation language ##

Unmix itself is written in "Scheme with EXtensions" (files with the
extention sex). Before being loaded and executed, the sex-files have to
be compiled to scm-files (with the extension scm), containing programs
in Scheme without extensions.

For bootstrapping reasons, several parts of Unmix have been written in
Scheme directly, so that they are contained in files with the extension
scm and needn't be compiled.

## The input language ##

Unmix accepts input programs written in a subset of Scheme extended with a few macros.

Here is the syntax of the input programs:
```
<Program> ::= <ProcDef> <ProcDef>* ;; Program

<ProcDef> ::=
    (define (<Pname> <Vname>*) <Exp>) ;; Procedure definition

<Exp> ::= <Vname>                   ;; Variable
      |   (quote <S-expression>)    ;; Constant
      |   <Literal>                 ;; Literal constant
      |   (if <Exp> <Exp> <Exp>)    ;; Conditional
      |   (let (<Binding>*) <Exp>)  ;; Let-expression
      |   (rcall (<Pname> <Exp>*))  ;; Residual call
      |   (generalize <Exp>)        ;; Generalizer
      |   (<Pname> <Exp>*)          ;; Procedure call
      |   (<Mname> <S-Expression>*) ;; Macro

<Binding> ::= (<Vname> <Exp>)       ;; Local binding

<Pname> ::= <Symbol>                ;; Procedure name
<Vname> ::= <Symbol>                ;; Variable name
<Mname> ::= <Symbol>                ;; Macro name


<Literal> ::= <boolean> | <number> | <character>
          |   <string> | <vector>
```

All procedures called in the program must be without side-effects. For
this reason, the terms "procedure" and "function" will be used in the
description of Unmix interchangeably.

Constructs `(generalize <Exp>)` and `(rcall (<Pname> <Exp>*))` are used to
insert into the program hand-made annotations, which permit the user to
control the specializer. They are useless for ordinary programming.

Construct `(generalize <Exp>)` tells the specializer that the result of
specializing `<Exp>` must be dynamic, even if `<Exp>` is static. When the
program is compiled in the usual way, this construct is equivalent to
`<Exp>`.

Construct `(rcall (<Pname> <Exp>*))` tells the specializer that the result
of specializing the procedure call `(<Pname> <Exp>*)` must be a residual
call. When the program is compiled in the usual way, this construct is
equivalent to `(<Pname> <Exp>*)`.

Some useful macro definitions may be found in the file `x-match.sex`.
File `x-synt.scm` contains a definition of `extend-syntax`, a powerful
tool for defining macro extensions.

## The internal language Mixwell ##

Mixwell is the internal language of the specializer Unmix. Here is its
syntax:
```
<Program> ::= <ProcDef> <ProcDef>*

<ProcDef> ::= (<Pname> (<Vname>*) = <Exp>)

<Exp> ::= <Vname>                ;; Variable
      |   (quote <S-expression>) ;; Constant
      |   (if <Exp> <Exp> <Exp>) ;; Conditional
      |   (call <Pname> <Exp>*)  ;; Defined function call
      |   (rcall <Pname> <Exp>*) ;; Defined function call
      |   (xcall <Pname> <Exp>*) ;; External function call
      |   (<Pname> <Exp>*)       ;; External function call

<Pname> ::= <Symbol>             ;; Procedure name
<Vname> ::= <Symbol>             ;; Variable name
```
The construct `(call <Pname> <Exp>*)` is a call on the procedure `<Pname>`
defined in the program, which will be unfolded during partial
evaluation.

The construct `(rcall <Pname> <Exp>*)` is a call on the procedure `<Pname>`
defined in the program, which will give rise to a residual call during
partial evaluation.

The construct `(xcall <Pname> <Exp>*)` is a call on the procedure `<Pname>`
defined somewhere outside the program. If `<Pname>` is different from the
symbols `STATIC`, `IFS`, `IFD`, `RCALL`, `CALL`, and `XCALL`, the keyword `XCALL` is
omitted and the construct takes the form `(<Pname> <Exp>*)`.

## The internal language Mixwell-Ann ##
```
<Ann-Program> ::=
    <RP-Names> <D-Program> <S-Program>      ;; Program
<RP-Names> ::= (<Pname>*)                   ;; Residual procedure names
<D-Program> ::=                             ;; Dynamic program
    (<A-ProcDef> <A-ProcDef>*)
<S-Program> ::= (<ProcDef>*)                ;; Static program
<A-ProcDef> ::=
    (<Pname> <ParList> <ParList> = <A-Exp>) ;; Annotated procedure
                                            ;; definition
<ParList> ::= (<Vname>*)                    ;; Parameter list

<A-Exp> ::=
    <Vname>                                 ;; Variable
  | (static <Exp>)                          ;; Static subexpression
  | (ifs <Exp> <A-Exp> <A-Exp>)             ;; Static conditional
  | (ifd <A-Exp> <A-Exp> <A-Exp>)           ;; Dynamic conditional
  | (call <Pname> (<Exp>*) (<A-Exp>*))      ;; Unfoldable defined
                                            ;; function call
  | (rcall <Pname> (<Exp>*) (<A-Exp>*))     ;; Residual defined
                                            ;; function call
  | (xcall <Pname> <A-Exp>*)                ;; External function call
  | (<Pname> <A-Exp>*)                      ;; External function call
```