# What is Unmix? #

If a program has several input parameters, it can be "specialized"
with respect to the values of some of the parameters, in which case
we get a "residual" program with less input parameters than the original
program.

The parameters whose values are known at the time the program is being
specialized are referred to as "static" parameters, all other parameters
are referred to as "dynamic" ones.

Unmix is a system that specializes programs written in a subset
of Scheme. Unmix is essentially a revised version of the specializer Mix developed at [DIKU](http://www.diku.dk/), the Department of Computer Science of the University of Copenhagen.