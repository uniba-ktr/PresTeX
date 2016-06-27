PresTeX
=======

A LaTeX Beamer template for presentations in English and German.

Setup
-----

Edit the <code>\newcommand{\lang}{ngerman}</code> command to setup the language You write your submission in. Possible options are
* <code>ngerman</code> and
* <code>english</code>.

Furthermore, edit the <code>config/metainfo.tex</code> file to include
* your name,
* the title and subtitle of Your presentation and
* the presentation date.

Compiling the Source Code
-------------------------

Use `latexmk` to generate a readable document, or use `make all` of the `Makefile`.
If you use texmaker, setup `latexmk` as your default build command
