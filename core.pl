#!/usr/bin/perl
use strict;
use warnings;
use Term::ANSIColor;
use Text::Table::Tiny 0.04 qw/ generate_table /;


#Formatting function for displaying offspring genotype properly
sub format_swap {
my ($geno) = @_;
my $new_geno;

my $len = length($geno);

for(my $i=0; $i<$len; $i+=2){
  my $chunk = substr($geno, $i, 2);
  my $first = substr($chunk, 0, 1);
  my $second = substr($chunk, 1, 1);

  if($second lt $first){
    my $temp = $second;
    $second = $first;
    $first = $temp;
    $chunk = $first.$second;
  }

   $new_geno .= $chunk;
}

return $new_geno;
}


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
  print "Enter number of genes: ";
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

    for(my $y=1; $y<3; $y++){
      for(my $z=1; $z<3; $z++){
        $rows->[$y][$z] = format_swap($rows->[$y][$z]);
      }
    }

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

    for(my $y=1; $y<5; $y++){
      for(my $z=1; $z<5; $z++){
        $rows->[$y][$z] = format_swap($rows->[$y][$z]);
      }
    }

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
            ("$POG[0][0]"."$POG[0][1]"."$POS[4]"), #col 1
            ("$POG[0][0]"."$POG[0][1]"."$POS[5]"), #col 2
            ("$POG[1][0]"."$POG[1][1]"."$POS[4]"), #col 3
            ("$POG[1][0]"."$POG[1][1]"."$POS[5]"), #col 4
            ("$POG[2][0]"."$POG[2][1]"."$POS[4]"), #col 5
            ("$POG[2][0]"."$POG[2][1]"."$POS[5]"), #col 6
            ("$POG[3][0]"."$POG[3][1]"."$POS[4]"), #col 7
            ("$POG[3][0]"."$POG[3][1]"."$POS[5]"), #col 8
            ],
      #rows
      [
      "$PTG[0][0]"."$PTG[0][1]"."$PTS[4]", #row 1
      $PTG[0][0].$POG[0][0].$PTG[0][1].$POG[0][1].$PTS[4].$POS[4], #r1-c1
      $PTG[0][0].$POG[0][0].$PTG[0][1].$POG[0][1].$PTS[4].$POS[5], #r1-c2
      $PTG[0][0].$POG[1][0].$PTG[0][1].$POG[1][1].$PTS[4].$POS[4], #r1-c3
      $PTG[0][0].$POG[1][0].$PTG[0][1].$POG[1][1].$PTS[4].$POS[5], #r1-c4
      $PTG[0][0].$POG[2][0].$PTG[0][1].$POG[2][1].$PTS[4].$POS[4], #r1-c5
      $PTG[0][0].$POG[2][0].$PTG[0][1].$POG[2][1].$PTS[4].$POS[5], #r1-c6
      $PTG[0][0].$POG[3][0].$PTG[0][1].$POG[3][1].$PTS[4].$POS[4], #r1-c7
      $PTG[0][0].$POG[3][0].$PTG[0][1].$POG[3][1].$PTS[4].$POS[5]  #r1-c8
      ],
      [
      "$PTG[0][0]"."$PTG[0][1]"."$PTS[5]", #row 2
      $PTG[0][0].$POG[0][0].$PTG[0][1].$POG[0][1].$PTS[5].$POS[4], #r2-c1
      $PTG[0][0].$POG[0][0].$PTG[0][1].$POG[0][1].$PTS[5].$POS[5], #r2-c2
      $PTG[0][0].$POG[1][0].$PTG[0][1].$POG[1][1].$PTS[5].$POS[4], #r2-c3
      $PTG[0][0].$POG[1][0].$PTG[0][1].$POG[1][1].$PTS[5].$POS[5], #r2-c4
      $PTG[0][0].$POG[2][0].$PTG[0][1].$POG[2][1].$PTS[5].$POS[4], #r2-c5
      $PTG[0][0].$POG[2][0].$PTG[0][1].$POG[2][1].$PTS[5].$POS[5], #r2-c6
      $PTG[0][0].$POG[3][0].$PTG[0][1].$POG[3][1].$PTS[5].$POS[4], #r2-c7
      $PTG[0][0].$POG[3][0].$PTG[0][1].$POG[3][1].$PTS[5].$POS[5]  #r2-c8
      ],
      [
      "$PTG[1][0]"."$PTG[1][1]"."$PTS[4]", #row 3
      $PTG[1][0].$POG[0][0].$PTG[1][1].$POG[0][1].$PTS[4].$POS[4], #r3-c1
      $PTG[1][0].$POG[0][0].$PTG[1][1].$POG[0][1].$PTS[4].$POS[5], #r3-c2
      $PTG[1][0].$POG[1][0].$PTG[1][1].$POG[1][1].$PTS[4].$POS[4], #r3-c3
      $PTG[1][0].$POG[1][0].$PTG[1][1].$POG[1][1].$PTS[4].$POS[5], #r3-c4
      $PTG[1][0].$POG[2][0].$PTG[1][1].$POG[2][1].$PTS[4].$POS[4], #r3-c5
      $PTG[1][0].$POG[2][0].$PTG[1][1].$POG[2][1].$PTS[4].$POS[5], #r3-c6
      $PTG[1][0].$POG[3][0].$PTG[1][1].$POG[3][1].$PTS[4].$POS[4], #r3-c7
      $PTG[1][0].$POG[3][0].$PTG[1][1].$POG[3][1].$PTS[4].$POS[5]  #r3-c8
      ],
      [
      "$PTG[1][0]"."$PTG[1][1]"."$PTS[5]", #row 4
      $PTG[1][0].$POG[0][0].$PTG[1][1].$POG[0][1].$PTS[5].$POS[4], #r4-c1
      $PTG[1][0].$POG[0][0].$PTG[1][1].$POG[0][1].$PTS[5].$POS[5], #r4-c2
      $PTG[1][0].$POG[1][0].$PTG[1][1].$POG[1][1].$PTS[5].$POS[4], #r4-c3
      $PTG[1][0].$POG[1][0].$PTG[1][1].$POG[1][1].$PTS[5].$POS[5], #r4-c4
      $PTG[1][0].$POG[2][0].$PTG[1][1].$POG[2][1].$PTS[5].$POS[4], #r4-c5
      $PTG[1][0].$POG[2][0].$PTG[1][1].$POG[2][1].$PTS[5].$POS[5], #r4-c6
      $PTG[1][0].$POG[3][0].$PTG[1][1].$POG[3][1].$PTS[5].$POS[4], #r4-c7
      $PTG[1][0].$POG[3][0].$PTG[1][1].$POG[3][1].$PTS[5].$POS[5]  #r4-c8
      ],
      [
      "$PTG[2][0]"."$PTG[2][1]"."$PTS[4]", #row 5
      $PTG[2][0].$POG[0][0].$PTG[2][1].$POG[0][1].$PTS[4].$POS[4], #r5-c1
      $PTG[2][0].$POG[0][0].$PTG[2][1].$POG[0][1].$PTS[4].$POS[5], #r5-c2
      $PTG[2][0].$POG[1][0].$PTG[2][1].$POG[1][1].$PTS[4].$POS[4], #r5-c3
      $PTG[2][0].$POG[1][0].$PTG[2][1].$POG[1][1].$PTS[4].$POS[5], #r5-c4
      $PTG[2][0].$POG[2][0].$PTG[2][1].$POG[2][1].$PTS[4].$POS[4], #r5-c5
      $PTG[2][0].$POG[2][0].$PTG[2][1].$POG[2][1].$PTS[4].$POS[5], #r5-c6
      $PTG[2][0].$POG[3][0].$PTG[2][1].$POG[3][1].$PTS[4].$POS[4], #r5-c7
      $PTG[2][0].$POG[3][0].$PTG[2][1].$POG[3][1].$PTS[4].$POS[5]  #r5-c8
      ],
      [
      "$PTG[2][0]"."$PTG[2][1]"."$PTS[5]", #row 6
      $PTG[2][0].$POG[0][0].$PTG[2][1].$POG[0][1].$PTS[5].$POS[4], #r6-c1
      $PTG[2][0].$POG[0][0].$PTG[2][1].$POG[0][1].$PTS[5].$POS[5], #r6-c2
      $PTG[2][0].$POG[1][0].$PTG[2][1].$POG[1][1].$PTS[5].$POS[4], #r6-c3
      $PTG[2][0].$POG[1][0].$PTG[2][1].$POG[1][1].$PTS[5].$POS[5], #r6-c4
      $PTG[2][0].$POG[2][0].$PTG[2][1].$POG[2][1].$PTS[5].$POS[4], #r6-c5
      $PTG[2][0].$POG[2][0].$PTG[2][1].$POG[2][1].$PTS[5].$POS[5], #r6-c6
      $PTG[2][0].$POG[3][0].$PTG[2][1].$POG[3][1].$PTS[5].$POS[4], #r6-c7
      $PTG[2][0].$POG[3][0].$PTG[2][1].$POG[3][1].$PTS[5].$POS[5], #r6-c8
      ],
      [
      "$PTG[3][0]"."$PTG[3][1]"."$PTS[4]", #row 7
      $PTG[3][0].$POG[0][0].$PTG[3][1].$POG[0][1].$PTS[4].$POS[4], #r7-c1
      $PTG[3][0].$POG[0][0].$PTG[3][1].$POG[0][1].$PTS[4].$POS[5], #r7-c2
      $PTG[3][0].$POG[1][0].$PTG[3][1].$POG[1][1].$PTS[4].$POS[4], #r7-c3
      $PTG[3][0].$POG[1][0].$PTG[3][1].$POG[1][1].$PTS[4].$POS[5], #r7-c4
      $PTG[3][0].$POG[2][0].$PTG[3][1].$POG[2][1].$PTS[4].$POS[4], #r7-c5
      $PTG[3][0].$POG[2][0].$PTG[3][1].$POG[2][1].$PTS[4].$POS[5], #r7-c6
      $PTG[3][0].$POG[3][0].$PTG[3][1].$POG[3][1].$PTS[4].$POS[4], #r7-c7
      $PTG[3][0].$POG[3][0].$PTG[3][1].$POG[3][1].$PTS[4].$POS[5]  #r7-c8
      ],
      [
      "$PTG[3][0]"."$PTG[3][1]"."$PTS[5]", #row 8
      $PTG[3][0].$POG[0][0].$PTG[3][1].$POG[0][1].$PTS[5].$POS[4], #r8-c1
      $PTG[3][0].$POG[0][0].$PTG[3][1].$POG[0][1].$PTS[5].$POS[5], #r8-c2
      $PTG[3][0].$POG[1][0].$PTG[3][1].$POG[1][1].$PTS[5].$POS[4], #r8-c3
      $PTG[3][0].$POG[1][0].$PTG[3][1].$POG[1][1].$PTS[5].$POS[5], #r8-c4
      $PTG[3][0].$POG[2][0].$PTG[3][1].$POG[2][1].$PTS[5].$POS[4], #r8-c5
      $PTG[3][0].$POG[2][0].$PTG[3][1].$POG[2][1].$PTS[5].$POS[5], #r8-c6
      $PTG[3][0].$POG[3][0].$PTG[3][1].$POG[3][1].$PTS[5].$POS[4], #r8-c7
      $PTG[3][0].$POG[3][0].$PTG[3][1].$POG[3][1].$PTS[5].$POS[5]  #r8-c8
      ],

    ];

    for(my $y=1; $y<9; $y++){
      for(my $z=1; $z<9; $z++){
        $rows->[$y][$z] = format_swap($rows->[$y][$z]);
      }
    }

    print color("GREEN");
    print "The punett square for this trihybrid cross: \n";
    print generate_table(rows => $rows, header_row => 1, separate_rows => 1);
    print "\n";
    print color("RESET");
}
