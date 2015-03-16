## What is Unmix? ##

Unmix is a simple _program specializer_ (based on _partial evaluation_)
for a subset of Scheme. It includes a _binding time analyzer_, a
_residual program generator_ and an _arity raiser_.

Despite its simplicity, Unmix is able to do some interesting things.
Perhaps this is due to a good balance between its complexity and its
capabilities. Thus Unmix has gain some popularity as a "guinea-
pig" (i.e. an "experimental animal"), whose properties and
capabilities have been studied in some papers. For example:

> Gade, J., Glück, R.: On Jones-optimal specializers: a case study using Unmix. In: Kobayashi, N. (ed.) Programming Languages and Systems. Proceedings. LNCS, vol. 4279, pp. 406-422. Springer, Berlin (2006). [doi](http://dx.doi.org/10.1007/s10990-008-9033-5)

A distributive of Unmix has also been used as a supplement (a didactic
stuff) to the classic book

> Jones, N. D., Gomard, C. K., and Sestoft, P. 1993 Partial Evaluation and Automatic Program Generation. Prentice-Hall, Inc. (see http://www.dina.kvl.dk/~sestoft/pebook/)

## What is the purpose of this project? ##

However, that distributive was made in 1993 and was meant for TI
Scheme (a Scheme implementation for MS DOS). It can't be readily used
with a modern Scheme implementation.

This is really a shame! Since Unmix is still "conceptually
alive" (albeit as  an "experimental animal"), it should be accessible
for "common people" via Internet! (And, as you can guess, my main
concern in my life is just the Good and Prosperity of common
people... :-) )

That's why I've brought the old distributive to the day light and,
with some insignificant modifications, made it accessible via Google
Code.

Certainly, at the moment the project is not good-looking, but the
information about Unmix can be found in the sources:

  1. In the file [unmix.txt](http://code.google.com/p/unmix/source/browse/unmix.txt).
  1. In the [sources](http://code.google.com/p/unmix/source/browse/) that contain a lot of comments.

## What Scheme implementation can be used for running Unmix? ##

The version exposed in the Google Code project can be readily run by
means of [Guile](http://www.gnu.org/software/guile/guile.html).

The main problem with running Unmix is related to the behavior of the
functions `char-ready?` and `get-char`, which are used in Unmix at the top
level only, for implementing its pseudo-graphic menus. In 1993 Unmix
was the first and only menu-driven specializer in the world! :-)

For some mysterious reasons the behavior of `char-ready?` and `get-char`
in Guile is the same as in the old good TI Scheme. (By the way, in
1993 I succeeded in self-applying Unmix with a 640K... And now my desk-
top has 4 Gb. :-) )

## What else is good in Guile? ##

Guile is a Scheme version that is used inside some well-known pieces of free software (like [GIMP](http://www.gimp.org/)) for the purposes of scripting and writing add-ons/plug-ins.

A good feature of Guile is that it's possible to write applications
with graphic interface by means of [Guile-Gtk](http://www.gnu.org/software/guile-gtk/).

Thus, potentially, a good-looking graphic interface can be added to
Unmix. Although, a web-interface, like that of [SPSC](http://code.google.com/p/spsc/) and [HOSC](http://code.google.com/p/hosc/) might be of more use.