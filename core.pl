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

    #Applying format_swap function to the array elements
    for(my $y=1; $y<3; $y++){
      for(my $z=1; $z<3; $z++){
        $rows->[$y][$z] = format_swap($rows->[$y][$z]);
      }
    }

    #Derefrencing the multidimensional array into a one-dimensional array
    my @arr = ();
    for my $val (@$rows) {
      for ( 1 .. $#$val ) {
        push @arr, $val->[$_];
      }
    }

    my $arr_len = scalar(@arr);
    my $dom_holder;
    my $het_holder;
    my $rec_holder;

    for(my $i=0; $i<$arr_len; $i++){
      if($arr[$i] =~ m/([A-Z])([A-Z])/){
        $dom_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([A-Z])([a-z])/){
        $het_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([a-z])([a-z])/){
        $rec_holder = $arr[$i];
      }
    }

    #Regular expressions to count genotypic ratios
    my $dom = grep(/([A-Z])([A-Z])/, @arr); #i.e: AA
    my $het = grep(/([A-Z])([a-z])/, @arr); #i.e: Aa
    my $rec = grep(/([a-z])([a-z])/, @arr); #i.e: aa

    #Percentages of genotypes
    my $per_dom = ($dom/4)*100;
    my $per_het = ($het/4)*100;
    my $per_rec = ($rec/4)*100;

    #Regular expressions to count phenotypic ratios
    my $trait_one = grep(/([A-Z])([A-Z])|([A-Z])([a-z])/, @arr); #i.e: AA or Aa
    my $per_trait_one = ($trait_one/4)*100;                             #to get the percentage
    my $trait_two = grep(/([a-z])([a-z])/, @arr);                #i.e: aa
    my $per_trait_two = ($trait_two/4)*100;


      print color("GREEN");
      print "The punett square for this monohybrid cross: \n";
      print generate_table(rows => $rows, header_row => 1, separate_rows => 1);
      print "\n";
      print color("RESET");
      print "\n";
      print"Genotype: \n";
      print color("GREEN");
      print "$dom_holder: $dom($per_dom)%\n$het_holder: $het($per_het)%\n$rec_holder: $rec($per_rec)%\n";
      print color("RESET");
      print"Phenotype: \n";
      print color("GREEN");
      print "Dominant trait: $trait_one($per_trait_one)%\nRecessive trait: $trait_two($per_trait_two)%\n";
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

    #Derefrencing the multidimensional array into a one-dimensional array
    my @arr = ();
    for my $val (@$rows) {
      for ( 1 .. $#$val ) {
        push @arr, $val->[$_];
      }
    }

    my $arr_len = scalar(@arr);
    my $one_holder;
    my $two_holder;
    my $thr_holder;
    my $fou_holder;
    my $fiv_holder;
    my $six_holder;
    my $sev_holder;
    my $eig_holder;
    my $nin_holder;


    for(my $i=0; $i<$arr_len; $i++){
      if($arr[$i] =~ m/([A-Z])([A-Z])([A-Z])([A-Z])/){  #XXXX
        $one_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([A-Z])([a-z])([A-Z])([a-z])/){  #XxXx
        $two_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([A-Z])([A-Z])([A-Z])([a-z])/){  #XXXx
        $thr_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([A-Z])([a-z])([A-Z])([A-Z])/){  #XxXX
        $fou_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([A-Z])([A-Z])([a-z])([a-z])/){  #XXxx
        $fiv_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([A-Z])([a-z])([a-z])([a-z])/){  #Xxxx
        $six_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([a-z])([a-z])([A-Z])([a-z])/){  #xxXx
        $sev_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([a-z])([a-z])([A-Z])([A-Z])/){  #xxXX
        $eig_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([a-z])([a-z])([a-z])([a-z])/){ #xxxx
        $nin_holder = $arr[$i];
      }
    }

    #Regular expressions to count genotypic ratios
    #Dom-Dom
    my $gone = grep(/([A-Z])([A-Z])([A-Z])([A-Z])/, @arr); #i.e: XXXX
    my $gtwo = grep(/([A-Z])([a-z])([A-Z])([a-z])/, @arr); #i.e: XxXx
    my $gthr = grep(/([A-Z])([A-Z])([A-Z])([a-z])/, @arr); #i.e: XXXx
    my $gfou = grep(/([A-Z])([a-z])([A-Z])([A-Z])/, @arr); #i.e: XxXX
    #Dom-Rec
    my $gfiv = grep(/([A-Z])([A-Z])([a-z])([a-z])/, @arr); #i.e: XXxx
    my $gsix = grep(/([A-Z])([a-z])([a-z])([a-z])/, @arr); #i.e: Xxxx
    #Rec-Dom
    my $gsev = grep(/([a-z])([a-z])([A-Z])([a-z])/, @arr); #i.e: xxXx
    my $gnin = grep(/([a-z])([a-z])([A-Z])([A-Z])/, @arr); #i.e: xxXX
    #Rec-Rec
    my $geig = grep(/([a-z])([a-z])([a-z])([a-z])/, @arr); #i.e: xxxx

    #Percentages of genotypes
    my $per_gone = ($gone/16)*100;
    my $per_gtwo = ($gtwo/16)*100;
    my $per_gthr = ($gthr/16)*100;
    my $per_gfou = ($gfou/16)*100;
    my $per_gfiv = ($gfiv/16)*100;
    my $per_gsix = ($gsix/16)*100;
    my $per_gsev = ($gsev/16)*100;
    my $per_geig = ($geig/16)*100;
    my $per_gnin = ($gnin/16)*100;

    #Regular expressions to count phenotypic ratios
    my $dom_dom = grep(/([A-Z])([A-Z])([A-Z])([A-Z])|([A-Z])([a-z])([A-Z])([a-z])|([A-Z])([A-Z])([A-Z])([a-z])|([A-Z])([a-z])([A-Z])([A-Z])/, @arr); #i.e: XXXX or XxXx or XXXx or XxXX
    my $per_one = ($dom_dom/16)*100;                             #to get the percentage

    my $dom_rec = grep(/([A-Z])([A-Z])([a-z])([a-z])|([A-Z])([a-z])([a-z])([a-z])/, @arr);                #i.e: XXxx or Xxxx
    my $per_two = ($dom_rec/16)*100;

    my $rec_dom = grep(/([a-z])([a-z])([A-Z])([a-z])|([a-z])([a-z])([A-Z])([A-Z])/, @arr);                #i.e: xxXx or xxXX
    my $per_three = ($rec_dom/16)*100;

    my $rec_rec = grep(/([a-z])([a-z])([a-z])([a-z])/, @arr);                #i.e: xxxx
    my $per_four = ($rec_rec/16)*100;


    print color("GREEN");
    print "The punett square for this monohybrid cross: \n";
    print generate_table(rows => $rows, header_row => 1, separate_rows => 1);
    print "\n";
    print color("RESET");
    print "\n";
    print "Genotype: \n";
    print color("GREEN"), "$one_holder: $gone($per_gone)%
$two_holder: $gtwo($per_gtwo)%
$thr_holder: $gthr($per_gthr)%
$fou_holder: $gfou($per_gfou)%
$fiv_holder: $gfiv($per_gfiv)%
$six_holder: $gsix($per_gsix)%
$sev_holder: $gsev($per_gsev)%
$eig_holder: $geig($per_geig)%
$nin_holder: $geig($per_gnin)%\n";
    print color("RESET");
    print"Phenotype:\n";
    print color("GREEN");
    print "dom-dom: $dom_dom($per_one%)\ndom-rec: $dom_rec($per_two%)\nrec-dom: $rec_dom($per_three%)\nrec_rec: $rec_rec($per_four%)\n";
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
