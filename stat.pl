# Baihan Lin, BGI, Aug 2013

#!/usr/bin/perl -w

use strict;

print "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@";

my $file=shift;

my $length=-100;
my $NoNlength=0;
my $GC=0;

my $cycle=0;

my $string="K";

my $NStart=1;
my $NEnd=1;

my @index=();


open(FH,$file)or die $!;
while (<FH>){
    chomp;
    if (/>/){
        &statistics;
        &NLocationNew;
        &initialization;
        &title;
        next;
    }
    &processing;
}
&statistics;
&NLocationNew;

close FH;
close OUTFILE1;
close OUTFILE2;

sub initialization{
    $cycle++;
    print "\n*******************************\n";
#    print "This is Cycle $cycle.\n";
#    print "Yeah! The initialization works well.\n";
    $length=0;
    $NoNlength=0;
    $NStart=1;
    $NEnd=1;
    $GC=0;
    $string="K";
    @index=();
}

sub title{
    open(OUTFILE1,">>fa.stat");
    open(OUTFILE2,">>N_region.txt");
    #    print "Yeah! The title print in the statistics seems right.\n";
#        print OUTFILE ($_);
    print "---->",$_," \n";
    print OUTFILE1 "$_";
    print OUTFILE2 "$_\n";
#    next;
}

sub processing{
#    print "Yeah! The normal calculation in the statistics can be open.\n";
##        $GC=($_=~tr/[GgCc]//);
##        $length+=length($_);
##        $NoNlength+=($_=~tr/[GgCcAaTt]//);
#        $string.="K";
        $string.=$_;
        @index=split("",$string);
#        print "$string-------------------------------I am here once!\n";
        $length=length($string)-1;
##        &NLocation;
#        open(OUTFILE,">fa.stat");
#        print OUTFILE (" ",$length," ",$NoNlength," ",$GC/$NoNlength,"%\n");
##    print "cycle",$cycle;
##    print " ",$length," ",$NoNlength," ",100*$GC/$NoNlength,"%\n";
#    $string.="K";
#    @index=split("",$string);
}

sub statistics{  
    print $string,"\n";
    if($length>-1){
        foreach my $a(@index){
            $GC+=($a=~tr/[GgCc]//);
            $NoNlength+=($a=~tr/[GgCcAaTt]//);
###            if($a=~/[GgCc]/){
###               print $a;
###                $GC++;
###            }
        }
        print "cycle",$cycle;
        print " ",$length," ",$NoNlength," ",100*$GC/$NoNlength,"%\n";
        print OUTFILE1  " ",$length," ",$NoNlength," ",100*$GC/$NoNlength,"%\n";
    }
}

sub NLocationNew{
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
            print "\n",$start[$l],"_start ",$end[$l],"_end ",$end[$l]-$start[$l]+1,"_length";
            print OUTFILE2 $start[$l],"_start ",$end[$l],"_end ",$end[$l]-$start[$l]+1,"_length\n";
        }
    }
}

sub NLocation{
#    print "Yeah! The NLocation can be open.\n";
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
#    &Debugging;
    if(($NEnd+2<$length)&&($NStart<$length+1)){
#        &Debugging;
        if($NEnd>$NStart){
            $NStart=$NEnd+2;
        }
##        print "@index\n$NStart\n";
####    if(($index[$NStart-1]!~/[Nn]/)&&($index[$NStart]!~/[Nn]/)){
        if($index[$NStart]=~/[Nn]/){   #Only for fa test...
####            if($index[$NStart-1]!~/[Nn]/){ # it seems only this can work!
                &isThereEnd;
            }else{
            $NStart++;
            &isThereStart;
####            }
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

sub Debugging{
    print "$string\n";
    print "\n))))))))))))))length is $length.";
    print "\n))))))))))))))End is $NEnd. Start is $NStart.\n";
    print "\n))))))))))))))This is to test index[NStart+1]. $index[$NStart+1]\n";
    print ")))))))))))))))And How about index[1]: $index[1], index[NEnd}:$index[$NEnd],and index[0]:$index[0]\n";
}

sub isThereEnd{
#    &Debugging;
    if($NEnd<$NStart){
        $NEnd=$NStart;
#        print "Just to say i came here instead of skirt it."
    }
    &Debugging;
    if($NEnd=$length){
        if($index[-1]=~/[Nn]/){
            print $NStart,"_Start ",$NEnd,"_End ",$NEnd-$NStart+1,"_length\n";
        }
    }        
#    print "Only to test if > or < work. %%%%%%%%%%%%%%%%%%%" if(1<2);
    if($NEnd<$length){
##        print "at least i came to this step.";
        if(($index[$NEnd]=~/[Nn]/)&&($index[$NEnd+1]!~/[Nn]/)){
            print $NStart,"_Start ",$NEnd,"_End ",$NEnd-$NStart+1,"_length\n";
            &isThereStart;
        }else{
            $NEnd++;
            &isThereEnd;
        }
    }
}
#       print "Yeah! the for loop in NLocation works!";
#    }
#}
