PreTeX
====

A LaTeX Beamer template for presentations in English and German. 

Setup
-----

Edit the <code>\newcommand{\lang}{ngerman}</code> command to setup the language You write your submission in. Possible options are 
* <code>ngerman</code> and
* <code>english</code>.

Furthermore, edit the <code>config/metainfo.tex</code> file to include
* your name,
* the title and subtitle and 
* the submission date
of Your presentation.

Compiling the Source Code
-------------------------

Use `pdflatex` and `bibtex` to generate a presentation.
If You use texmaker, you can include the following command to automatically compile the sources: 
<code>pdflatex -synctex=1 -interaction=nonstopmode %.tex | bibtex % | pdflatex -synctex=1 -interaction=nonstopmode %.tex 
| pdflatex -synctex=1 -interaction=nonstopmode %.tex</code>

