#!/usr/bin/perl -w

use strict;

my $file=shift;

my $length=-100;
my $NoNlength=0;
my $GC=0;
my $string="K";
my @index=();

open(FH,$file)or die $!;
while (<FH>){
    chomp;
    if (/>/){
        &statistics;
        &NLocation;
        &initialization;
        &title;
        next;
    }
    &processing;
}
&statistics;
&NLocation;
close FH;
close OUTFILE1;
close OUTFILE2;

sub initialization{
    $length=0;
    $NoNlength=0;
    $GC=0;
    $string="K";
    @index=();
}

sub title{
    open(OUTFILE1,">>fa.stat");
    open(OUTFILE2,">>N_region.txt");
    print OUTFILE1 "\n$_";
    print OUTFILE2 "\n$_\n";
}

sub processing{
        $string.=$_;
        @index=split("",$string);
        $length=length($string)-1;
}

sub statistics{  
    if($length>-1){
        foreach my $a(@index){
            $GC+=($a=~tr/[GgCc]//);
            $NoNlength+=($a=~tr/[GgCcAaTt]//);
        }
        print OUTFILE1  " ",$length," ",$NoNlength," ",100*$GC/$NoNlength,"%\n";
    }
}

sub NLocation{
    if($length>-1){
        $index[$length+1]="O";
        my @start;
        my @end;
        my $j=0;
        my $k=0;
        for(my $i=1;$i<$length+1;$i++){
            if($index[$i]=~/[Nn]/){
                if($index[$i-1]!~/[Nn]/){
                    $j++;
                    $start[$j]=$i;
                }
                if($index[$i+1]!~/[Nn]/){
                    $k++;
                    $end[$k]=$i;
                }
            }
        }
        for(my $l=1;$l<($j+$k-($j+$k)%2)/2+1;$l++){
            print OUTFILE2 $start[$l],"_start ",$end[$l],"_end ",$end[$l]-$start[$l]+1,"_length\n";
        }
    }
}