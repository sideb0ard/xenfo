#!/usr/bin/perl -w
use strict;

my $total_memory = `xm info|grep total_memory |cut -f2 -d':'`;
chomp $total_memory;
$total_memory =~ s/\s//g;
print "TOTAL_MEMORY=$total_memory\n";

my $free_memory = `xm info|grep free_memory |cut -f2 -d':'`;
chomp $free_memory;
$free_memory =~ s/\s//g;
print "FREE_MEMORY=$free_memory\n";

my $vmmem = `xm list |grep -v Name |awk '{print \$1,\$3}' |sort -k2 -rn`;

my @hostmems = split(/\n/,$vmmem);
my $dom0mem;
my $guest_doms_total_mem;
foreach my $h (@hostmems) {
    chomp $h;
    my @currenthost = split(/\s/,$h);
    if ($currenthost[0] eq "Domain-0") {
        $dom0mem = $currenthost[1];
    } else {
        $guest_doms_total_mem += $currenthost[1];
    }
    print "HOST: $h\n";
}

print "DOM0 MEM = $dom0mem\nGUEST MEM TOTAL: $guest_doms_total_mem\n";
my $totalmem_usage  = $dom0mem + $guest_doms_total_mem + $free_memory;
print "TOTAL: $totalmem_usage\n";
