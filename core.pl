#!/usr/bin/perl
use strict;
use warnings;
use Term::ANSIColor;


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





print "parent one $p_one\n";
print "parent two $p_two\n";
