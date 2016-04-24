# Baihan Lin, BGI, 2013

#!/usr/bin/perl -w

use strict;

print "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@";

my $file="ucsc.hg19.fa";

my $length=0;
my $NoNlength=0;
my $GC=0;

my $cycle=0;

my $string="K";

my $NStart=1;
my $NEnd=1;
#my $i=1;

my @index=();


open(FH,$file)or die $!;
while (<FH>){
    chomp;
    if (/>/){
        &initialization;
        &title;
    }
    &statistics;
}

close FH;

sub initialization{
    $cycle++;
    print "\n*******************************\n";
    print "This is Cycle $cycle.\n"; 
    print "Yeah! The initialization works well.\n";
    $length=0;
    $NoNlength=0;
    $NStart=1;
    $NEnd=1;
    $GC=0;
    $string="K";
    @index=();
}

sub title{
#    open(OUTFILE,">>fa.stat");
    print "Yeah! The title print in the statistics seems right.\n";
#        print OUTFILE ($_);
        print "---->",$_," \n";
    next;
}

sub statistics{
    print "Yeah! The normal calculation in the statistics can be open.\n";
        $GC=($_=~tr/[GgCc]//);
        $length+=length($_);
        $NoNlength+=($_=~tr/[GgCcAaTt]//);
        $string.=$_;
#        print "$string\n";
        &NLocation;
#        open(OUTFILE,">fa.stat");
#        print OUTFILE (" ",$length," ",$NoNlength," ",$GC/$NoNlength,"%\n");
    print "cycle",$cycle;
    print " ",$length," ",$NoNlength," ",100*$GC/$NoNlength,"%\n";
    $string.="K";
    my @index=split("",$string);
}

sub NLocation{
    print "Yeah! The NLocation can be open.\n";
#    print $index[3];
#    for($i=1;$i<=$length;$i++){
#    my $hash{$i}=$_;
#       if($index[1]=~/[Nn]/){
#          print "1_Start ";
#          $start=$i;
#       }else{
    &isThereStart;
}

sub isThereStart{
    if($NEnd+2<$length){
        if($NEnd>$NStart){
            $NStart=$NEnd+2;
        }
        if(($index[$NStart-1]!~/[Nn]/)&&($index[$NStart]!~/[Nn]/)){
            &isThereEnd;
        }else{
            $NStart++;
            &isThereStart;
        }
    }
#           print $i,"_Start ";
#           $start=$i;
#       }
#       }
#       if($index[$i]=~/[Nn]$/){
#           print $i,"_End ";
#           $end=$i;
#       }else{
#    }
}


sub isThereEnd{
    if($NEnd<$length+1){
           if ($NEnd<$NStart){
               $NEnd=$NStart;
           }
           if(($index[$NEnd]=~/[Nn]/)&&($index[$NEnd+1]!~/[Nn]/)){
               print $NStart,"_Start ",$NEnd,"_End ",$NEnd-$NStart+1,"_length\n";
               &isThereStart;
           }else{
               $NEnd++;
               &isThereEnd;
           }
}
#       print "Yeah! the for loop in NLocation works!";
#    }
#}



