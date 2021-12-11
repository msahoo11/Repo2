#!/usr/bin/perl

use strict;
use warnings;

use CGI;
use ShortmeURL;

my $baseUrl = "www.ShortMe.com";

#my $req = CGI->new;
#print $req->header('text/html');

#my $r_input = $req->param();
my $r_input = "https://www.abcdefghijklmn.in/abcd/abcd"; #add any other url here to be encoded
#my $r_input = "www.ShortMe.com/?sKey=eOKOcchu";
#my $r_input = "www.ShortMe.com/?sKey=aJv2O6za"; # url to be decoded 

#check the URL if it is a new or need to be redirect
#key can be retrived from the url using CGI parameters/request format
#here just added a static check
if ($r_input =~ /ShortMe/) {
	print "It is a short URL, need to be decoded and redirected = $r_input\n";
	
	#get the key from the URL
	my @input_s = split('=',$r_input);
	my $rKey = $input_s[-1]; #key is after = sign
	
	print "rKey = $rKey\n";
	#get the decoded URL
	my $oUrl = ShortmeURL::get_decode_url($rKey);
	
	print " Original URL = $oUrl\n";
	
	#print $req->redirect($oUrl);
	
}else{
	
	print "Request for Short URL = $r_input\n";
	my $nUrl = ShortmeURL::get_encode_url($r_input);
	
	print "New Short Url = $nUrl\n";
	
	#From here need to send to HTML template to print on page for the user
	
}
