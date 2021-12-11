package ShortmeURL;

use strict;
use warnings;
use MIME::Base64;
#use Exporter;

#our @ISA = qw(Exporter);
#our @EXPORT = qw(get_encode_url, get_decode_url);
#my $LEVEL = 1;
my $baseUrl = "www.ShortMe.com";		#my website name

# get_encode_url (),
# fetch the user's url, create a unique key and new short url,
# map it with user's original url and store it
# for test purpose, storing it in a text file (it can be replaced with database, json, etc)
# return it

sub get_encode_url {
	
	my $newUrl = shift;
	my $encoded_newUrl = encode_base64($newUrl);
	chomp $encoded_newUrl;
	
	#check for existing URL
	my ($shortUrl_exists, $rUrl_exists) = check_exists ($encoded_newUrl);
	
	if ($shortUrl_exists){
		print "Requested URL already exists - $shortUrl_exists\n";
		return $shortUrl_exists;
	}else{ #create new
		my $keyString = get_keystring ();
		print "$keyString\n";
		my $shortUrl = $baseUrl."/?sKey=".$keyString;
		
		#add to file
		open(FH2,">>shortURLs.txt") || die "Couldn't open file, $!";
		print FH2 "$keyString,$encoded_newUrl,$shortUrl,$newUrl\n";
		close FH2;
		print "shortUrl = $shortUrl\n"
		
		return $shortUrl;
	}
}
sub get_keystring{
	
	my @element=('a'..'z','A'..'Z','0'..'9');
	
	#my $d = $elements[rand(scalar @elements)];
	
	#just creating a random chars key
	
	my $keyS = join "", map {$elements[rand(scalar @elements)]} 1..8;
	
	print "New key = $keyS\n";
	
	return $keyS;
	
}

sub check_exists {
	
	my $rData = shift;
	print "rData in check_exists = $rData\n";
	
	my($key_exists,$rUrl_exists,$sUrl_exists);
	
	open(FH1,"shortURLs.txt") || die "Couldn't open file, $!";
	my @file_url = <FH1>;
	close FH1;
	
	foreach my $line (@file_url){
		print "** $line\n";
		my ($skey,$rurl,$surl) = split (/,/,$line);
		print "$skey,$rurl,$surl \n";
		
		if ($rData eq $rurl) { #when request for new short url
			print "rData eq rurl\n";
			$sUrl_exists = $surl;
			$rUrl_exists = $rurl;
			last;
			
		}elsif ($rData eq $skey) {# when request with short url 
			print "rData eq skey\n";
			$sUrl_exists = $surl;
			$rUrl_exists = $rurl;
			last;
			
		}else{ next;	}
	}
	return ($sUrl_exists,$rUrl_exists);
}

sub get_decode_url {
	
	my $sUrlKey = shift;
	
	my ($sUrlLink,$rUrlLink) = check_exists ($sUrlKey);
	
	my $decoded_sUrlLink = decode_base64($rUrlLink);
	print "decoded_sUrlLink = $decoded_sUrlLink\n";
	
	return $decoded_sUrlLink;
}

#next to be worked are below --

	#use a database table or use hash for checking existing key/url
	#use more hard logic for encoding url and generating key
	#use Pertl CPAN library module for shortening URL
	#URL validation
	
1;s	