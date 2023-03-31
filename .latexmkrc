$pdf_mode = 1;
$pdflatex = 'pdflatex --shell-escape -interaction=nonstopmode %O %S -file-line-error -synctex=1';

# Custom dependency and function for glossaries package
add_cus_dep('glo', 'gls', 0, 'makeglo2gls');
add_cus_dep('acn', 'acr', 0, 'makeglo2gls');
sub makeglo2gls {
        system("makeglossaries $_[0]");
}

# Custom dependency and function for nomencl package
add_cus_dep( 'nlo', 'nls', 0, 'makenlo2nls' );
sub makenlo2nls {
 system( "makeindex -s nomencl.ist -o \"$_[0].nls\" \"$_[0].nlo\"" );
}
