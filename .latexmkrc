$pdf_mode = 1;
$pdflatex = 'pdflatex --shell-escape -interaction=nonstopmode %O %S -file-line-error -synctex=1';
# Custom dependency and function for nomencl package
add_cus_dep( 'nlo', 'nls', 0, 'makenlo2nls' );
sub makenlo2nls {
 system( "makeindex -s nomencl.ist -o \"$_[0].nls\" \"$_[0].nlo\"" );
}
