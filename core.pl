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
      if($dom != 0){
        print "$dom_holder: $dom($per_dom)%\n";
      }
      if($het != 0){
        print "$het_holder: $het($per_het)%\n";
      }
      if($rec != 0){
        print "$rec_holder: $rec($per_rec)%\n";
      }
      print color("RESET");
      print"Phenotype: \n";
      print color("GREEN");
      print "Dominant trait: $trait_one($per_trait_one)%\nRecessive trait: $trait_two($per_trait_two)%\n";
      print color("RESET");


      #Chi-square analysis
      print "Enter dominant trait observed number:";
      my $obs_one = <STDIN>; #Observed number of dominant trait
      chomp $obs_one;

      print "Enter dominant trait observed number:";
      my $obs_two = <STDIN>; #Observed number of recessive trait
      chomp $obs_two;

      my $total = $obs_one + $obs_two;

      my $exp_one = ($trait_one/4) * $total; #Expected number of dominant trait
      my $exp_two = ($trait_two/4) * $total; #Expected number of recessive trait

      my $DOF = 1; #Degree of freedom = (n-1) = (2-1) = 1

      my $chi_value = ((($obs_one - $exp_one)**2) / $exp_one)+((($obs_two - $exp_two)**2) / $exp_two);
      my $critical_value = 3.841; # 1 --> (0.05)

      print "\nChi-square value: $chi_value\n";

      if($chi_value < $critical_value){
        print color("GREEN");
        print "ACCEPTED\n";
        print color("RESET");
      }
      else {
        print color("RED");
        print "NOT ACCEPTED\n";
        print color("RESET");
      }
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
    my $geig = grep(/([a-z])([a-z])([A-Z])([A-Z])/, @arr); #i.e: xxXX
    #Rec-Rec
    my $gnin = grep(/([a-z])([a-z])([a-z])([a-z])/, @arr); #i.e: xxxx

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
    print "The punett square for this dihybrid cross: \n";
    print generate_table(rows => $rows, header_row => 1, separate_rows => 1);
    print "\n";
    print color("RESET");
    print "\n";
    print "Genotype: \n";
    print color("GREEN");
    if($gone != 0){
      print "$one_holder: $gone($per_gone)%\n";
    }
    if($gtwo != 0){
      print "$two_holder: $gtwo($per_gtwo)%\n";
    }
    if($gthr != 0){
      print "$thr_holder: $gthr($per_gthr)%\n";
    }
    if($gfou != 0){
      print "$fou_holder: $gfou($per_gfou)%\n";
    }
    if($gfiv != 0){
      print "$fiv_holder: $gfiv($per_gfiv)%\n";
    }
    if($gsix != 0){
      print "$six_holder: $gsix($per_gsix)%\n";
    }
    if($gsev != 0){
      print "$sev_holder: $gsev($per_gsev)%\n";
    }
    if($geig != 0){
      print "$eig_holder: $geig($per_geig)%\n";
    }
    if($gnin != 0){
      print "$nin_holder: $gnin($per_gnin)%\n";
    }
    print color("RESET");
    print"Phenotype:\n";
    print color("GREEN");
    print "dom-dom: $dom_dom($per_one%)\ndom-rec: $dom_rec($per_two%)\nrec-dom: $rec_dom($per_three%)\nrec_rec: $rec_rec($per_four%)\n";
    print color("RESET");

    #Chi-square analysis
    print "Enter dom-dom trait observed number: ";
    my $obs_one = <STDIN>; #Observed number of dominant trait
    chomp $obs_one;

    print "Enter dom-rec trait observed number: ";
    my $obs_two = <STDIN>; #Observed number of recessive trait
    chomp $obs_two;

    print "Enter rec-dom trait observed number: ";
    my $obs_three = <STDIN>; #Observed number of dominant trait
    chomp $obs_three;


    print "Enter rec-rec trait observed number: ";
    my $obs_four = <STDIN>; #Observed number of dominant trait
    chomp $obs_four;


    my $total = $obs_one + $obs_two + $obs_three + $obs_four;

    my $exp_one = ($dom_dom/16) * $total; #Expected number of dom-dom trait
    my $exp_two = ($dom_rec/16) * $total; #Expected number of dom-rec trait
    my $exp_three = ($rec_dom/16) * $total; #Expected number of rec-dom trait
    my $exp_four = ($rec_rec/16) * $total; #Expected number of rec-rec trait

    my $DOF = 3; #Degree of freedom = (n-1) = (4-1) = 3

    my $chi_value = ((($obs_one - $exp_one)**2) / $exp_one) + ((($obs_two - $exp_two)**2) / $exp_two) + ((($obs_three - $exp_three)**2) / $exp_three) + ((($obs_four - $exp_four)**2) / $exp_four);
    my $critical_value = 7.815; # 3 --> (0.05)

    print "\nChi-square value: $chi_value\n";

    if($chi_value < $critical_value){
      print color("GREEN");
      print "ACCEPTED\n";
      print color("RESET");
    }
    else {
      print color("RED");
      print "NOT ACCEPTED\n";
      print color("RESET");
    }
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

    #Derefrencing the multidimensional array into a one-dimensional array
    my @arr = ();
    for my $val (@$rows) {
      for ( 1 .. $#$val ) {
        push @arr, $val->[$_];
      }
    }

    my $arr_len = scalar(@arr);
    my $one_holder; #1 RRYYCC
    my $two_holder; #2 RRYYCc
    my $thr_holder; #3 RRYYcc
    my $fou_holder; #4 RRYyCC
    my $fiv_holder; #5 RRYyCc
    my $six_holder; #6 RRYycc
    my $sev_holder; #7 RRyyCC
    my $eig_holder; #8 RRyyCc
    my $nin_holder; #9 RRyycc
    my $ten_holder; #10 RrYYCC
    my $ele_holder; #11 RrYYCc
    my $twe_holder; #12 RrYYcc
    my $tht_holder; #13 RrYyCC
    my $fot_holder; #14 RrYyCc
    my $fit_holder; #15 RrYycc
    my $sit_holder; #16 RryyCC
    my $set_holder; #17 RryyCc
    my $eit_holder; #18 Rryycc
    my $nit_holder; #19 rrYYCC
    my $twt_holder; #20 rrYYCc
    my $twtone_holder; #21 rrYYcc
    my $twttwo_holder; #22 rrYyCC
    my $twtthr_holder; #23 rrYyCc
    my $twtfou_holder; #24 rrYycc
    my $twtfiv_holder; #25 rryyCC
    my $twtsix_holder; #26 rryyCc
    my $twtsev_holder; #27 rryycc


    for(my $i=0; $i<$arr_len; $i++){
      if($arr[$i] =~ m/([A-Z])([A-Z])([A-Z])([A-Z])([A-Z])([A-Z])/){  #1 RRYYCC  dom-dom-dom
        $one_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([A-Z])([A-Z])([A-Z])([A-Z])([A-Z])([a-z])/){  #2 RRYYCc  dom-dom-dom
        $two_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([A-Z])([A-Z])([A-Z])([A-Z])([a-z])([a-z])/){  #3 RRYYcc  dom-dom-rec
        $thr_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([A-Z])([A-Z])([A-Z])([a-z])([A-Z])([A-Z])/){  #4 RRYyCC  dom-dom-dom
        $fou_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([A-Z])([A-Z])([A-Z])([a-z])([A-Z])([a-z])/){  #5 RRYyCc  dom-dom-dom
        $fiv_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([A-Z])([A-Z])([A-Z])([a-z])([a-z])([a-z])/){  #6 RRYycc  dom-dom-rec
        $six_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([A-Z])([A-Z])([a-z])([a-z])([A-Z])([A-Z])/){  #7 RRyyCC  dom-rec-dom
        $sev_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([A-Z])([A-Z])([a-z])([a-z])([A-Z])([a-z])/){  #8 RRyyCc  dom-rec-dom
        $eig_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([A-Z])([A-Z])([a-z])([a-z])([a-z])([a-z])/){ #9 RRyycc   dom-rec-rec
        $nin_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([A-Z])([a-z])([A-Z])([A-Z])([A-Z])([A-Z])/){ #10 RrYYCC  dom-dom-dom
        $ten_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([A-Z])([a-z])([A-Z])([A-Z])([A-Z])([a-z])/){ #11 RrYYCc  dom-dom-dom
        $ele_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([A-Z])([a-z])([A-Z])([A-Z])([a-z])([a-z])/){ #12 RrYYcc  dom-dom-rec
        $twe_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([A-Z])([a-z])([A-Z])([a-z])([A-Z])([A-Z])/){ #13 RrYyCC  dom-dom-dom
        $tht_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([A-Z])([a-z])([A-Z])([a-z])([A-Z])([a-z])/){ #14 RrYyCc  dom-dom-dom
        $fot_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([A-Z])([a-z])([A-Z])([a-z])([a-z])([a-z])/){ #15 RrYycc  dom-dom-rec
        $fit_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([A-Z])([a-z])([a-z])([a-z])([A-Z])([A-Z])/){ #16 RryyCC  dom-rec-dom
        $sit_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([A-Z])([a-z])([a-z])([a-z])([A-Z])([a-z])/){ #17 RryyCc  dom-rec-dom
        $set_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([A-Z])([a-z])([a-z])([a-z])([a-z])([a-z])/){ #18 Rryycc  dom-rec-rec
        $eit_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([a-z])([a-z])([A-Z])([A-Z])([A-Z])([A-Z])/){ #19 rrYYCC  rec-dom-dom
        $nit_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([a-z])([a-z])([A-Z])([A-Z])([A-Z])([a-z])/){ #20 rrYYCc  rec-dom-dom
        $twt_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([a-z])([a-z])([A-Z])([A-Z])([a-z])([a-z])/){ #21 rrYYcc  rec-dom-rec
        $twtone_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([a-z])([a-z])([A-Z])([a-z])([A-Z])([A-Z])/){ #22 rrYyCC  rec-dom-dom
        $twttwo_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([a-z])([a-z])([A-Z])([a-z])([A-Z])([a-z])/){ #23 rrYyCc  rec-dom-dom
        $twtthr_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([a-z])([a-z])([A-Z])([a-z])([a-z])([a-z])/){ #24 rrYycc  rec-dom-rec
        $twtfou_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([a-z])([a-z])([a-z])([a-z])([A-Z])([A-Z])/){ #25 rryyCC  rec-rec-dom
        $twtfiv_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([a-z])([a-z])([a-z])([a-z])([A-Z])([a-z])/){ #26 rryyCc  rec-rec-dom
        $twtsix_holder = $arr[$i];
      }
      if($arr[$i] =~ m/([a-z])([a-z])([a-z])([a-z])([a-z])([a-z])/){ #27 rryycc  rec-rec-dom
        $twtsev_holder = $arr[$i];
      }
    }

    #Regular expressions to count phenotypic ratios
    my $dom_dom_dom = grep(/([A-Z])([A-Z])([A-Z])([A-Z])([A-Z])([A-Z])|([A-Z])([A-Z])([A-Z])([A-Z])([A-Z])([a-z])|([A-Z])([A-Z])([A-Z])([a-z])([A-Z])([A-Z])|([A-Z])([A-Z])([A-Z])([a-z])([A-Z])([a-z])|([A-Z])([a-z])([A-Z])([A-Z])([A-Z])([A-Z])|([A-Z])([a-z])([A-Z])([A-Z])([A-Z])([a-z])|([A-Z])([a-z])([A-Z])([a-z])([A-Z])([A-Z])|([A-Z])([a-z])([A-Z])([a-z])([A-Z])([a-z])/, @arr); #i.e: 1 or 2 or 4 or 5 or 10 or 11 or 13 or 14
    my $per_one = ($dom_dom_dom/64)*100;  #to get the percentage

    my $dom_dom_rec = grep(/([A-Z])([A-Z])([A-Z])([A-Z])([a-z])([a-z])|([A-Z])([A-Z])([A-Z])([a-z])([a-z])([a-z])|([A-Z])([a-z])([A-Z])([A-Z])([a-z])([a-z])|([A-Z])([a-z])([A-Z])([a-z])([a-z])([a-z])/, @arr); #i.e: 3 or 6 or 12 or 15
    my $per_two = ($dom_dom_rec/64)*100;

    my $dom_rec_dom = grep(/([A-Z])([A-Z])([a-z])([a-z])([A-Z])([A-Z])|([A-Z])([A-Z])([a-z])([a-z])([A-Z])([a-z])|([A-Z])([a-z])([a-z])([a-z])([A-Z])([A-Z])|([A-Z])([a-z])([a-z])([a-z])([A-Z])([a-z])/, @arr); #i.e: 7 or 8 or 16 or 17
    my $per_three = ($dom_rec_dom/64)*100;

    my $dom_rec_rec = grep(/([A-Z])([A-Z])([a-z])([a-z])([a-z])([a-z])|([A-Z])([a-z])([a-z])([a-z])([a-z])([a-z])/, @arr); #i.e: 9 or 18
    my $per_four = ($dom_rec_rec/64)*100;

    my $rec_dom_dom = grep(/([a-z])([a-z])([A-Z])([A-Z])([A-Z])([A-Z])|([a-z])([a-z])([A-Z])([A-Z])([A-Z])([a-z])|([a-z])([a-z])([A-Z])([a-z])([A-Z])([A-Z])|([a-z])([a-z])([A-Z])([a-z])([A-Z])([a-z])/, @arr); #i.e: 19 or 20 or 22 or 23
    my $per_five = ($rec_dom_dom/64)*100;

    my $rec_dom_rec = grep(/([a-z])([a-z])([A-Z])([A-Z])([a-z])([a-z])|([a-z])([a-z])([A-Z])([a-z])([a-z])([a-z])/, @arr); #i.e: 21 or 24
    my $per_six = ($rec_dom_rec/64)*100;

    my $rec_rec_dom = grep(/([a-z])([a-z])([a-z])([a-z])([A-Z])([A-Z])|([a-z])([a-z])([a-z])([a-z])([A-Z])([a-z])/, @arr); #i.e: 25 or 26
    my $per_seven = ($rec_rec_dom/64)*100;

    my $rec_rec_rec = grep(/([a-z])([a-z])([a-z])([a-z])([a-z])([a-z])/, @arr); #i.e: 27
    my $per_eight = ($rec_rec_rec/64)*100;


    print color("GREEN");
    print "The punett square for this trihybrid cross: \n";
    print generate_table(rows => $rows, header_row => 1, separate_rows => 1);
    print "\n";
    print color("RESET");
    print color("RESET");
    print"Phenotype:\n";
    print color("GREEN");
    print "dom-dom-dom: $dom_dom_dom($per_one%)
    dom-dom-rec: $dom_dom_rec($per_two%)
    dom-rec-dom: $dom_rec_dom($per_three%)
    dom-rec-rec: $dom_rec_rec($per_four%)
    rec-dom-dom: $rec_dom_dom($per_five%)
    rec-dom-rec: $rec_dom_rec($per_six%)
    rec-rec-dom: $rec_rec_dom($per_seven%)
    rec-rec-rec: $rec_rec_rec($per_eight%)\n";
    print color("RESET");

    #Chi-square analysis
    print "Enter dom-dom trait observed number: ";
    my $obs_one = <STDIN>; #Observed number of dominant trait
    chomp $obs_one;

    print "Enter dom-rec trait observed number: ";
    my $obs_two = <STDIN>; #Observed number of recessive trait
    chomp $obs_two;

    print "Enter rec-dom trait observed number: ";
    my $obs_three = <STDIN>; #Observed number of dominant trait
    chomp $obs_three;


    print "Enter rec-rec trait observed number: ";
    my $obs_four = <STDIN>; #Observed number of dominant trait
    chomp $obs_four;

    print "Enter dom-dom trait observed number: ";
    my $obs_five = <STDIN>; #Observed number of dominant trait
    chomp $obs_five;

    print "Enter dom-rec trait observed number: ";
    my $obs_six = <STDIN>; #Observed number of recessive trait
    chomp $obs_six;

    print "Enter rec-dom trait observed number: ";
    my $obs_seven = <STDIN>; #Observed number of dominant trait
    chomp $obs_seven;


    print "Enter rec-rec trait observed number: ";
    my $obs_eight = <STDIN>; #Observed number of dominant trait
    chomp $obs_eight;


    my $total = $obs_one + $obs_two + $obs_three + $obs_four + $obs_five + $obs_six + $obs_seven + $obs_eight;

    my $exp_one = ($dom_dom_dom/16) * $total; #Expected number of dom-dom-doc trait
    my $exp_two = ($dom_dom_rec/16) * $total; #Expected number of dom-dom-rec trait
    my $exp_three = ($dom_rec_dom/16) * $total; #Expected number of dom-rec-dom trait
    my $exp_four = ($dom_rec_rec/16) * $total; #Expected number of dom-rec-rec trait
    my $exp_five = ($rec_dom_dom/16) * $total; #Expected number of rec-dom-dom trait
    my $exp_six = ($rec_dom_rec/16) * $total; #Expected number of rec-dom-rec trait
    my $exp_seven = ($rec_rec_dom/16) * $total; #Expected number of rec-rec-dom trait
    my $exp_eight = ($rec_rec_rec/16) * $total; #Expected number of rec-rec-rec trait

    my $DOF = 7; #Degree of freedom = (n-1) = (8-1) = 7

    my $chi_value = ((($obs_one - $exp_one)**2) / $exp_one) + ((($obs_two - $exp_two)**2) / $exp_two) + ((($obs_three - $exp_three)**2) / $exp_three) + ((($obs_four - $exp_four)**2) / $exp_four) + ((($obs_five - $exp_five)**2) / $exp_five) + ((($obs_six - $exp_six)**2) / $exp_six) + ((($obs_seven - $exp_seven)**2) / $exp_seven) + ((($obs_eight - $exp_eight)**2) / $exp_eight);
    my $critical_value = 14.067; # 7 --> (0.05)

    print "\nChi-square value: $chi_value\n";

    if($chi_value < $critical_value){
      print color("GREEN");
      print "ACCEPTED\n";
      print color("RESET");
    }
    else {
      print color("RED");
      print "NOT ACCEPTED\n";
      print color("RESET");
    }


}
