#!/usr/bin/perl
use strict;
use warnings;


my $fa_file=shift;
die "perl $0 fa_file\n" unless $fa_file;

open IN,$fa_file or die $!;
$/=">";$/=<IN>;$/="\n";
while (<IN>){
	chomp;
	(my $id=$_)=~s/\s+.*$//;
	
	$/=">";
	my $seq=<IN>;
	chomp $seq;
	$seq=~s/\s+//g;
	$/="\n";

	my $length = length($seq);
	my @a=split //,$seq;
	my $start=0;
	my $len=0;
	if($a[0] eq "N"){
        print "$id\t1\t";
        for my $i(0..@a-1){
            if($a[$i] ne "N"){
                print "$i\t$i\n";
                last;
            }
        }
    }
    foreach my $i(0..@a- 1)
	{
        if ($a[$i] eq "N")
		{	
			my $m=$i + 1;
			print "$start\t$len\n" if $m-$start>1 && $len>0;
			$len=0 if $m-$start>1 && $len>0;
			print "$id\t$m\t" if $m- $start>1;
			$start=$m;
			$len++;
		}
	
	}
	print "$start\t$len\n";
}
close IN;

