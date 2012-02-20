#!/usr/bin/perl -w
use strict;

print "\n** XENFO -- XEN Mem info **\n\n";

my $total_memory = `xm info|grep total_memory |cut -f2 -d':'`;
chomp $total_memory;
$total_memory =~ s/\s//g;
print "TOTAL_MEMORY=$total_memory MB\n";

my $free_memory = `xm info|grep free_memory |cut -f2 -d':'`;
chomp $free_memory;
$free_memory =~ s/\s//g;
print "FREE_MEMORY=$free_memory MB\n\n";

my $vmmem = `xm list |grep -v Name |awk '{print \$1,\$3}' |sort -k2 -rn`;

my @hostmems = split(/\n/,$vmmem);
my $numofvms = @hostmems;
my $dom0mem;
my $guest_doms_total_mem = 0;

for( my $i=0 ; $i < $numofvms; $i++){
    my $h = $hostmems[$i];
    chomp $h;
    my @currenthost = split(/\s/,$h);
    if ($currenthost[0] eq "Domain-0") {
        $dom0mem = $currenthost[1];
    } else {
        $guest_doms_total_mem += $currenthost[1];
    }
    print "HOST: $h MB\n";
}

print "\nDOM0 MEM = $dom0mem MB\nGUEST MEM TOTAL: $guest_doms_total_mem MB\n";
my $totalmem_usage  = $dom0mem + $guest_doms_total_mem + $free_memory;
print "TOTAL: $totalmem_usage MB\n";
