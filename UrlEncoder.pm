package Tie::UrlEncoder;

use 5.006;
use strict;
use warnings;

our $VERSION = '0.01';

# sub PACK(){0};
sub KEY(){1};
# sub VALUE(){2};
my $b;
sub TIEHASH{bless \$b}
sub FETCH{
	my $result = $_[KEY];
	$result =~ s{([^ 0-9a-zA-Z\$\-_\.\!\*\(\)\,])}
		    {sprintf("%%%02X",ord($1))}ge;
	$result =~ tr/ /+/;
	$result
}

sub import{ no strict;
	tie %{caller().'::urlencode'}, __PACKAGE__
}


1;
__END__

=head1 NAME

Tie::UrlEncoder - interpolatably URL-encode strings

Syntactic sugar for URL-Encoding strings. Tie::UrlEncoder imports
a tied hash C<%urlencode> into your package, which delivers a RFC 1738
URL Encoded string of whatever is given to it, for easy embedding
of URL-Encoded strings into doublequoted templates.



=head1 SYNOPSOZAMPLE

  our %urlencode;	# make use strict happy
  use Tie::UrlEncoder 0.01; # import ties %urlencode
  ...
  print "To add $id to your list, click here:\n";
  print "http://listmonger.example.com/listadd?id=$urlencode{$id}\n";
  

=head1 DESCRIPTION

No longer must you clutter up your CGI program with endless repetitions
of line noise code that performs this tricky function.  Simply use
Tie::UrlEncoder and you instantly get a magic C<%urlencode> hash that
gives you an Url Encoded version of the key:
C<$urlencode{$WhatYouWantToEncode}> is ready to interpolate in double-quoted
literals without messy intermediate variables.


=head1 EXPORT

you get C<our %urlencode> imported into your package by default.

Defeat this wanton pollution (perhaps if you already have something
called C<%urlencode>)
by invoking C<use> with an empty list and tieing a different hash.

  use Tie::UrlEncoder 0.01 ();
  tie my %MagicUrlEncodingHash, 'Tie::UrlEncoder';
  ...
  qq( <a href="add_data.pl?data=$MagicUrlEncodingHash{$SpecialData}">
      Click here to add your special data <em>$SpecialData</em></a> );


=head1 HISTORY


=head2 0.01

I was setting this up for a project I am working on and
thought, it's useful in general so why not publish it.


=head1 FUTURE

A hash-tieing interface for HTML escapes would be a good
companion to this module

Localization is not addressed.

=head1 AUTHOR

Copyright (C) 2004 david nicol davidnico@cpan.org
released under your choice of the GNU Public or Artistic licenses

=head1 SEE ALSO

Google for "URL Encoding"

RFC 1738

L<URI::Escape>

L<HTML::Mason::Escapes>

=cut
