A simple _program specializer_ (based on _partial evaluation_) for a subset of Scheme. It includes a _binding time analyzer_, a _residual program generator_ and an _arity raiser_.

At the moment, some information about Unmix can be found in ReadMe, [UnmixTOC](UnmixTOC.md),
[unmix.txt](http://code.google.com/p/unmix/source/browse/unmix.txt) and in UnmixRelatedPapers

In 1993 Unmix was developed under
[SCM](http://people.csail.mit.edu/jaffer/SCM).
Now the sources have been slightly modified, in order for Unmix to run under
[Guile](http://www.gnu.org/software/guile/guile.html).

There are some problems with SCM concerning the functions char-ready? and get-char, which disappear under Guile.