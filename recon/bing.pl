#!/usr/bin/env perl

# Use: $ perl bing.pl https://target.com

use 5.018;
use strict;
use warnings;
use WWW::Mechanize;

sub main {
    my $domain = $ARGV[0];

    if ($domain) {
        my $mech = WWW::Mechanize -> new();
        my %seen = ();
        my @urls = ();

        my @dorks = (
            "site:$domain intitle:index.of",
            "site:$domain intext:(password | passcode | senha | login | username | userid | user)",
            "site:$domain intext:(restrito | confidencial | interno | private | restricted | internal) filetype:(pdf | txt | docx | sql | csv | xlsx)",
            # "site:pastebin.com intext:$domain",
            # "site:trello.com intext:$domain"
        );

        foreach my $dork (@dorks) {
            print "[!] - $dork\n";

            for (my $page = 0; $page <= 10; $page++) {
                my $url = "http://www.bing.com/search?q=" . $dork . "&first=" . $page . "0";
                        
                $mech -> get($url);
                my @links = $mech -> links();
                        
                foreach my $link (@links) {
                    $url = $link -> url();
                    next if $seen{$url}++;

                    if ($url =~ m/^https?/ && $url !~ m/bing|live|microsoft|msn/) {
                        print "[+] - $url\n";
                    }
                }
            }

            print "\n";
        }
    }
}

main();
exit;