#!/usr/bin/perl
use strict;
use warnings;
use Term::ANSIColor;
use Text::Table::Tiny 0.04 qw/ generate_table /;


my $genes = 4; #Number of genes (Set to (4) to start the loop)
my $p_one = ""; #Parent one genotype
my $len_one = length($p_one); #length of Parent one genotype
my $p_two = "";
my $len_two = length($p_two); #length of Parent two genotype


#Number of genes input and verification
while($genes > 3){
  if($genes > 3){
    print "Genes number must be between 1 and 3\n";
  }
  print "Enter number of genes:";
   $genes = <STDIN>;
   chomp $genes;
}

my $alleles = $genes*2; #Number of alleles

#Parent one genotype input and verification
while($len_one != $alleles){
  if($len_one != $alleles){
    print "Genotype must contain $alleles alleles\n";
  }
  print "Enter parent(1) genotype:";
  $p_one = <STDIN>;
  chomp $p_one;

  $len_one = length($p_one);
}

#Parent two genotype input and verification
while($len_two != $alleles){
  if($len_two != $alleles){
    print "Genotype must contain $alleles alleles\n";
  }
  print "Enter parent(2) genotype:";
  $p_two = <STDIN>;
  chomp $p_two;

  $len_two = length($p_two);
}

my @POG = ();
my @PTG = ();

if($genes == 1){
  for(my $i=0; $i<$alleles; $i++){
    $POG[$i] = substr($p_one,$i,1);
    $PTG[$i] = substr($p_two,$i,1);
  }


  my $rows = [
      #header rows
      ["GA","$POG[0]", "$POG[1]",],
      #rows
      [ "$PTG[0]", $PTG[0].$POG[0], $PTG[0].$POG[1] ],
      [ "$PTG[1]", $PTG[1].$POG[0], $PTG[1].$POG[1] ],

    ];

    print generate_table(rows => $rows, header_row => 1, separate_rows => 1);
    print "\n";

}
