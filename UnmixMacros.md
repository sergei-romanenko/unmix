# Appendix. Some macros used in Unmix #

Unmix, as well as the example programs, has been written in Scheme
extended with the following macros.

## Generalized CASE-expression ##
```
        (MATCH  (arg ...)
                (pat ...  & guard => exp ...) ...)
```
The expressions `arg ...` are evaluated to produce S-expressions `S-exp ...`.
`S-exp ...` are then matched against the corresponding patterns
`pat ...`. If the matching succeeds for some clause
```
         (pat ... & guard => exp ...)
```
the variables in `pat ...` get bound to the corresponding
subexpressions in `S-exp ...`, and then the expression "guard" is
evaluated in the extended environment. If the result of "guard" is not
`#f`, the expressions `exp ...` are evaluated in the extended
environment, otherwise the next clause is tried.  If the guard is `#t`,
"& guard" may be omitted.

The patterns have the following syntax:
```
   <pat> ::= '<S-exp>             matches <S-exp>.
           | <literal>            matches <literal>.
           | <var>                matches anything, <var> is bound.
           | _                    matches anything.
           | (<var> as <pat>)     matches <pat>, <var> is bound.
           | (<pat> . <pat>)      matches a pair with <pat>'s as elements.

   <var> ::= <symbol>
   <literal> ::=
           | ()
           | <boolean>
           | <number>
           | <character>
           | <string>
           | <vector>
```

## Generalized LET-expression ##
```
        (WITH  ((pat arg) ...) exp ...)
```
The expressions `arg ...` are evaluated to produce S-expressions `S-exp ...`.
`S-exp ...` are supposed to match the patterns `pat ...`, in which
case the variables in `pat ...` get bound to the corresponding
subexpressions in `S-exp ...`, and then the expressions `exp ...` are
evaluated in the extended environment.  If some of `S-exp ...` do not
match against patterns `pat ...`, the result of the form `WITH` is
unspecified, because there is no actual analysis of the structure of
`S-exp ...`.  The syntax of patterns is exactly the same as in the case
of the form `MATCH`.

The form
```
        (WITH* ((pat1 arg1) . (pat arg) ...) exp ...)
```
is equivalent to
```
        (WITH ((pat1 arg1)) (WITH* ((pat arg) ...) exp ...)
```

## Restricted generalized CASE-expression ##
```
        (SELECT (arg ...)
                (rpat ...  & guard => exp ...) ...)
```
The expressions `arg ...` are evaluated to produce S-expressions `S-exp ...`.
`S-exp ...` are then matched against the corresponding restricted
patterns `rpat ...`. If the matching succeeds for some clause
```
        (rpat ... & guard => exp ...)
```
the variables in `pat ...` get bound to the corresponding
subexpressions in `S-exp ...`, and then the expression "guard" is
evaluated in the extended environment. If the result of "guard" is not
`#f`, the expressions `exp ...` are evaluated in the extended
environment, otherwise the next clause is tried. If the guard is `#t`, "&
guard" may be omitted.

The syntax of restricted patterns coincides with that of the ordinary
patterns appearing in the construct `MATCH` described above, but their
meaning is slightly different.

If a restricted pattern `<pat>` doesn't have the form `(<pat'> . <pat''>)`,
it has the same meaning as the ordinary pattern `<pat>`.

If an S-expression `<S-exp>` is not a pair, the result of matching
`<S-exp>` against a pattern `(<pat'> . <pat''>)` is unspecified (i.e.
matching `<S-exp>` against such a pattern may produce either an error or
unpredictable results).

If an S-expression `<S-exp>` is a pair `(<S-exp'> . <S-exp''>)`, and a
pattern `<pat>` has the form `(<pat'> . ())`, then `<S-exp>` matches `<pat>`,
iff `<S-exp'>` matches `<pat'>`. In other words, a restricted pattern of
the form `(<pat'> . ())` is completely equivalent to the restricted
pattern `(<pat'> . _)`.

If an S-expression `<S-exp>` is a pair `(<S-exp'> . <S-exp''>)`, and a
pattern has the form `(<pat'> . <pat''>)`, where `<pat''>` is not `()`, then
`<S-exp>` matches `<pat>`, iff `<S-exp'>` matches `<pat'>` and `<S-exp''>`
matches `<pat''>`.

The fact that restricted patterns are less careful at examining
S-expressions than the ordinary patterns are, enables them to be
compiled into efficient code.

## RCALL ##
```
        (RCALL (fname arg ...))
```
This construct is used for telling the specializer that the function
call `(fname arg ...)` is a residual one. In all other respects this
construct is equivalent to `(fname arg ...)`.


## GENERALIZE ##
```
        (GENERALIZE exp)
```
This construct is used for telling the specializer that the result of
specializing `(GENERALIZE exp)` must be dynamic even if `exp` is static. In
all other respects this construct is equivalent to `exp`.