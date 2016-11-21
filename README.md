# NAME

Google::Translate 

# VERSION

Version 0.01

# SYNOPSIS

    use Google::Translate;

    my $foo = Google::Translate->new({
        api_key => '2343534334',
        source => 'en',
        target => 'nl'
    });

    my $translation = $foo->translate({ q => 'some text' });
    ...

    my $detect = $foo->detect({ q => "any language" });
