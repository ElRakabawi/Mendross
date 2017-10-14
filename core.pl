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
    print color("RED"), "Genes number must be between 1 and 3\n", color("RESET");
  }
  print "Enter number of genes:";
   $genes = <STDIN>;
   chomp $genes;
}

my $alleles = $genes*2; #Number of alleles

#Parent one genotype input and verification
while($len_one != $alleles){
  if($len_one != $alleles){
    print color("RED"), "Genotype must contain $alleles alleles\n", color("RESET");
  }
  print "Enter parent(1) genotype:\n";
  $p_one = <STDIN>;
  chomp $p_one;

  $len_one = length($p_one);
}

#Parent two genotype input and verification
while($len_two != $alleles){
  if($len_two != $alleles){
    print color("RED"), "Genotype must contain $alleles alleles\n", color("RESET");
  }
  print "Enter parent(2) genotype:\n";
  $p_two = <STDIN>;
  chomp $p_two;

  $len_two = length($p_two);
}

my @POG = (); #Parent One Gametes
my @PTG = (); #Parent Two Gametes
my @POS = (); #Parent one step
my @PTS = (); #Parent two step


#Computation of monohybrid crossing
if($genes == 1){
  for(my $i=0; $i<$alleles; $i++){
    $POG[$i] = substr($p_one,$i,1);
    $PTG[$i] = substr($p_two,$i,1);
  }


  my $rows = [
      #header rows
      ["  ","$POG[0]", "$POG[1]",],
      #rows
      [ "$PTG[0]", $PTG[0].$POG[0], $PTG[0].$POG[1] ],
      [ "$PTG[1]", $PTG[1].$POG[0], $PTG[1].$POG[1] ],

    ];

    print color("GREEN");
    print "The punett square for this monohybrid cross: \n";
    print generate_table(rows => $rows, header_row => 1, separate_rows => 1);
    print "\n";
    print color("RESET");

}

#Computation of dihybrid crossing
elsif($genes == 2) {
  for(my $i=0; $i<$alleles; $i++){
    $POS[$i] = substr($p_one,$i,1);
    $PTS[$i] = substr($p_two,$i,1);
  }

  my $m = 0;
  for(my $i=0; $i<$alleles; $i+=2){

    $POG[$i][0] = $POS[$m];
    $POG[$i][1] = $POS[2];
    $POG[$i+1][0] = $POS[$m];
    $POG[$i+1][1] = $POS[3];
    $m++;
  }

  my $n = 0;
  for(my $i=0; $i<$alleles; $i+=2){

    $PTG[$i][0] = $PTS[$n];
    $PTG[$i][1] = $PTS[2];
    $PTG[$i+1][0] = $PTS[$n];
    $PTG[$i+1][1] = $PTS[3];
    $n++;
  }


  my $rows = [
      #header rows
            ["  ",("$POG[0][0]"."$POG[0][1]"), ("$POG[1][0]"."$POG[1][1]"),("$POG[2][0]"."$POG[2][1]"), ("$POG[3][0]"."$POG[3][1]"),],
      #rows
      [ "$PTG[0][0]"."$PTG[0][1]", $PTG[0][0].$POG[0][0].$PTG[0][1].$POG[0][1], $PTG[0][0].$POG[1][0].$PTG[0][1].$POG[1][1],
      $PTG[0][0].$POG[2][0].$PTG[0][1].$POG[2][1], $PTG[0][0].$POG[3][0].$PTG[0][1].$POG[3][1] ], #row 1
      [ "$PTG[1][0]"."$PTG[1][1]", $PTG[1][0].$POG[0][0].$PTG[1][1].$POG[0][1], $PTG[1][0].$POG[1][0].$PTG[1][1].$POG[1][1],
      $PTG[1][0].$POG[2][0].$PTG[1][1].$POG[2][1], $PTG[1][0].$POG[3][0].$PTG[1][1].$POG[3][1] ], #row 2
      [ "$PTG[2][0]"."$PTG[2][1]", $PTG[2][0].$POG[0][0].$PTG[2][1].$POG[0][1], $PTG[2][0].$POG[1][0].$PTG[2][1].$POG[1][1],
      $PTG[2][0].$POG[2][0].$PTG[2][1].$POG[2][1], $PTG[2][0].$POG[3][0].$PTG[2][1].$POG[3][1] ], #row 3
      [ "$PTG[3][0]"."$PTG[3][1]", $PTG[3][0].$POG[0][0].$PTG[3][1].$POG[0][1], $PTG[3][0].$POG[1][0].$PTG[3][1].$POG[1][1],
      $PTG[3][0].$POG[2][0].$PTG[3][1].$POG[2][1], $PTG[3][0].$POG[3][0].$PTG[3][1].$POG[3][1] ], #row 4

    ];

    print color("GREEN");
    print "The punett square for this dihybrid cross: \n";
    print generate_table(rows => $rows, header_row => 1, separate_rows => 1);
    print "\n";
    print color("RESET");
}

elsif($genes == 3) {
  for(my $i=0; $i<$alleles; $i++){
    $POS[$i] = substr($p_one,$i,1);
    $PTS[$i] = substr($p_two,$i,1);
  }

  my $m = 0;
  for(my $i=0; $i<$alleles; $i+=2){

    $POG[$i][0] = $POS[$m];
    $POG[$i][1] = $POS[2];
    $POG[$i+1][0] = $POS[$m];
    $POG[$i+1][1] = $POS[3];
    $m++;
  }

  my $n = 0;
  for(my $i=0; $i<$alleles; $i+=2){

    $PTG[$i][0] = $PTS[$n];
    $PTG[$i][1] = $PTS[2];
    $PTG[$i+1][0] = $PTS[$n];
    $PTG[$i+1][1] = $PTS[3];
    $n++;
  }


  my $rows = [
      #header rows
            ["  ",
            ("$POG[0][0]"."$POG[0][1]"."$POS[4]"),
            ("$POG[0][0]"."$POG[0][1]"."$POS[5]"),
            ("$POG[1][0]"."$POG[1][1]"."$POS[4]"),
            ("$POG[1][0]"."$POG[1][1]"."$POS[5]"),
            ("$POG[2][0]"."$POG[2][1]"."$POS[4]"),
            ("$POG[2][0]"."$POG[2][1]"."$POS[5]"),
            ("$POG[3][0]"."$POG[3][1]"."$POS[4]"),
            ("$POG[3][0]"."$POG[3][1]"."$POS[5]"),],
      #rows
      [
      "$PTG[0][0]"."$PTG[0][1]"."$PTS[4]",
      $PTG[0][0].$POG[0][0].$PTG[0][1].$POG[0][1].$PTS[4].$POS[4],
      $PTG[0][0].$POG[1][0].$PTG[0][1].$POG[1][1],
      $PTG[0][0].$POG[2][0].$PTG[0][1].$POG[2][1],
      $PTG[0][0].$POG[3][0].$PTG[0][1].$POG[3][1] ],
      [
      "$PTG[1][0]"."$PTG[1][1]"."$PTS[5]",
      $PTG[1][0].$POG[0][0].$PTG[1][1].$POG[0][1].$PTS[5].$POS[4],
      $PTG[1][0].$POG[1][0].$PTG[1][1].$POG[1][1],
      $PTG[1][0].$POG[2][0].$PTG[1][1].$POG[2][1],
      $PTG[1][0].$POG[3][0].$PTG[1][1].$POG[3][1] ],
      [
      "$PTG[2][0]"."$PTG[2][1]"."$PTS[4]",
      $PTG[2][0].$POG[0][0].$PTG[2][1].$POG[0][1].$PTS[4].$POS[4],
      $PTG[2][0].$POG[1][0].$PTG[2][1].$POG[1][1],
      $PTG[2][0].$POG[2][0].$PTG[2][1].$POG[2][1],
      $PTG[2][0].$POG[3][0].$PTG[2][1].$POG[3][1] ],
      [
      "$PTG[3][0]"."$PTG[3][1]"."$PTS[5]",
      $PTG[3][0].$POG[0][0].$PTG[3][1].$POG[0][1].$PTS[5].$POS[4],
      $PTG[3][0].$POG[1][0].$PTG[3][1].$POG[1][1],
      $PTG[3][0].$POG[2][0].$PTG[3][1].$POG[2][1],
      $PTG[3][0].$POG[3][0].$PTG[3][1].$POG[3][1] ],
      [
      "$PTG[0][0]"."$PTG[0][1]"."$PTS[4]", $PTG[0][0].$POG[0][0].$PTG[0][1].$POG[0][1].$PTS[4].$POS[4], $PTG[0][0].$POG[1][0].$PTG[0][1].$POG[1][1], $PTG[0][0].$POG[2][0].$PTG[0][1].$POG[2][1], $PTG[0][0].$POG[3][0].$PTG[0][1].$POG[3][1] ],
      [
      "$PTG[1][0]"."$PTG[1][1]"."$PTS[5]", $PTG[1][0].$POG[0][0].$PTG[1][1].$POG[0][1].$PTS[5].$POS[4], $PTG[1][0].$POG[1][0].$PTG[1][1].$POG[1][1], $PTG[1][0].$POG[2][0].$PTG[1][1].$POG[2][1], $PTG[1][0].$POG[3][0].$PTG[1][1].$POG[3][1] ],
      [
      "$PTG[2][0]"."$PTG[2][1]"."$PTS[4]", $PTG[2][0].$POG[0][0].$PTG[2][1].$POG[0][1].$PTS[4].$POS[4], $PTG[2][0].$POG[1][0].$PTG[2][1].$POG[1][1], $PTG[2][0].$POG[2][0].$PTG[2][1].$POG[2][1], $PTG[2][0].$POG[3][0].$PTG[2][1].$POG[3][1] ],
      [ "$PTG[3][0]"."$PTG[3][1]"."$PTS[5]", $PTG[3][0].$POG[0][0].$PTG[3][1].$POG[0][1].$PTS[5].$POS[4], $PTG[3][0].$POG[1][0].$PTG[3][1].$POG[1][1], $PTG[3][0].$POG[2][0].$PTG[3][1].$POG[2][1], $PTG[3][0].$POG[3][0].$PTG[3][1].$POG[3][1] ],

    ];

    print color("GREEN");
    print "The punett square for this dihybrid cross: \n";
    print generate_table(rows => $rows, header_row => 1, separate_rows => 1);
    print "\n";
    print color("RESET");
}
