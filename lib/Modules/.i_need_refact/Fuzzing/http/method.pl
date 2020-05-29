#!/usr/bin/env perl
# Usage: $ perl method.pl https://target.com /wordlists/http/api_paths.txt

use 5.018;
use strict;
use warnings;
use HTTP::Request;
use LWP::UserAgent;

sub main {
    my $target   = $ARGV[0];
    my $wordlist = $ARGV[1];
    
    if ($target && $wordlist) {
        my $userAgent = LWP::UserAgent -> new();

        my $header = [
            "Accept" => "*/*",
            "Content-Type" => "*/*"
        ];

        my @verbs = (
            "GET", "POST", "PUT", "DELETE", "HEAD", "OPTIONS", "CONNECT", "TRACE", "PATCH", "SUBSCRIBE", "MOVE", "REPORT",
            "UNLOCK", "%s%s%s%s", "PURGE", "POLL", "OPTIONS", "NOTIFY", "SEARCH", "1337", "JEFF", "CATS", "*",
            "DATA", "HEADERS", "PRIORITY", "RST_STREAM", "SETTINGS", "PUSH_PROMISE", "PING",  "GOAWAY", "WINDOW_UPDATE", 
            "CONTINUATION"
        );
        
        open (my $routes, "<", $wordlist);

        while (<$routes>) {
            chomp ($_);
            
            my $endpoint = $target . $_;

            foreach my $verb (@verbs) {
                my $request     = new HTTP::Request($verb, $endpoint, $header);
                my $response    = $userAgent -> request($request);
                my $httpCode    = $response -> code();
                my $httpMessage = $response -> message();

                print "[!] -> [$httpCode] | $endpoint \t [$verb] - $httpMessage\n";
            }
        }

        close ($routes);
    }
}

main();
exit;