#! /usr/bin/perl

print "Replace C++ comments with clean C comments: //text  =>  /* text */\n";
print "Written by Stas Degteff 2:5080/102\n\n";
if( $#ARGV<0 ){
print <<USAGE;
  Usage:

     $0 *.c *.h
USAGE
}

for( $i=0; $i<=$#ARGV; $i++ ){
  if ( ! open FF, "$ARGV[$i]") { print "Can't open $ARGV[$i]!\n"; next; }
  open OO, ">cpp2c.tmp" || die "Can't create/open cpp2c.tmp! Abort.\n";
  print "Process $ARGV[$i]\n";
  $commented=0;
  while( <FF> ){
    $commented=1 if( /\/\*/ );  # C comment start line
    $commented=0 if( /\*\// );  # C comment end line

    # replace // with /* */
    s%//([^\015\012]*)%/* $1 */% if( !$commented );

    # remove duplicated "*/"
    while( m%\*/.*\*/% ){
      s%\*/(.*)\*/% $1*/%;
    }

    print OO "$_";
  }
  close FF;
  close OO;
  rename $ARGV[$i], "$ARGV[$i].bak";
  rename "cpp2c.tmp", $ARGV[$i];
}