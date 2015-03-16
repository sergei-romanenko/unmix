# How to run Unmix? #

This version of Unmix can be run under [Guile](http://www.gnu.org/software/guile/guile.html) Scheme implementation.

The directory containing programs to be specialized must also contain
the file `unmix.scm` having the following contents:
```
(define **unmix-path** SSSS)
(load (string-append **unmix-path** "xunmix.scm"))
```
where `SSSS` is the path to the directory containing Unmix.

For example, if Unmix resides in the directory `~/unmix/`, the file
`unmix.scm` must contain the following lines:
```
(define **unmix-path** "~/unmix/")
(load (string-append **unmix-path** "xunmix.scm"))
```
To call Unmix, make sure that the directory containing programs to be
specialized is the current one. Then start the Scheme system and load
the file `unmix.scm`.

When the Scheme prompt appears, enter
```
(UNMIX)
```
As a result, Unmix starts and displays a menu on the screen, which
provides further information.