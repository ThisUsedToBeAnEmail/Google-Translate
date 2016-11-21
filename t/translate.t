use strict;
use warnings;

use Data::Dumper;
use Google::Translate;

my $foo = Google::Translate->new({
    api_key => 'add a key',
    source => 'en',
    target => 'nl'
});

my $translation = $foo->translate({ q => 'some text' });
                                                
my $detect = $foo->detect({ q => "Good Morning" });

warn Dumper $detect;
warn Dumper $translation;
