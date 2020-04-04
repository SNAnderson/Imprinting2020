#combine_count_tables_input_command_line.pl by sna
use strict; use warnings;

die "usage: perl /home/springer/sna/scripts/combine_count_tables_input_command_line.pl <any number of files > 1> \n" unless @ARGV > 1;

my $colnum = scalar @ARGV;

#instead of manual hash generation, create list of files from samples.txt files
open (my $samples, $ARGV[0]) or die $!;

my @line2;
my $feature;
my $count;
my %element_hash;

for (my $j = 0; $j < $colnum; $j++){
  open (my $file_n,"<",$ARGV[$j]) or die "Can't open $ARGV[$j]: $!\n";
  while (my $line = <$file_n>) {
    chomp $line;
    @line2 = split/\t/, $line;
    $feature = $line2[0];
    $count = $line2[1];
    $element_hash{$feature}{$j} = $count;
  }
  close $file_n; 
}

my ($u_file) = ("combined_counts.txt");
my ($uout);

open($uout,">",$u_file) or die "Couldn't open $u_file: $!";

foreach my $ele (sort keys %element_hash){
  print $uout "$ele\t";

  #for all but last column
  for (my $i = 0; $i < $colnum -1; $i++){
    if (exists $element_hash{$ele}{$i}){
      print $uout "$element_hash{$ele}{$i}\t";
    }
    else {
      print $uout "0\t";
    }
  }

  #last column needs new line character
  if (exists $element_hash{$ele}{$colnum -1}){
    print $uout "$element_hash{$ele}{$colnum -1}\n";
  }
  else {
    print $uout "0\n";
  }
}
