package Google::Translate;

use 5.006;
use strict;
use warnings;

use Moo;
 
use HTTP::Tiny;
use JSON;
use Data::Dumper;
use Carp;

around BUILDARGS => sub {
    my ($orig, $class, $args) = @_;

    my $build = ( );

    my $template_base_args = { 
        format => "text",    
    };

    for(qw/q source target format/){
        if (defined $args->{$_}){
            $template_base_args->{$_} = $args->{$_}; 
        }
    }

    $build->{translate_base_args} = $template_base_args;

    for (qw/api_key base_url tiny/) {
        if (defined $args->{$_}) {
            $build->{$_} = $args->{$_};
        }
    }

    return $class->$orig( $build );
};

has [qw/api_key translate_base_args/] => (
    is => 'rw',
);

has [qw/base_url tiny/] => (
    is => 'rw',
    lazy => 1,
    builder => 1,
);

sub _build_base_url {
    return 'https://translation.googleapis.com/language/translate/v2'
}

sub _build_tiny {
    # ssl_opts stops fb crying
    my $tiny = HTTP::Tiny->new(ssl_opts =>  1);
    return $tiny;
}

sub translate {
    my ($self, $args) = @_;

    my $base_args = $self->translate_base_args;
    my $content = $self->_join_args($base_args, $args);
    my $url = sprintf '%s?key=%s', $self->base_url, $self->api_key;

    return $self->tiny_post($url, $content);
}

sub detect {
    my ($self, $args) = @_;

    my $url = sprintf "%s/detect?key=%s", $self->base_url, $self->api_key;
    return $self->tiny_post($url, $args);
}

sub _join_args {
    my ($self, $base_args, $args) = @_;

    for ( keys %{ $args } ) {
        $base_args->{$_} = $args->{$_};
    }
    return $base_args;
}

sub tiny_post {
    my ($self, $url, $content) = @_;
    
    my $response = $self->tiny->post($url => {
        content => to_json($content),
        headers => {
            'Content-Type' => "application/json",
        },
    });

    if ($response->{success}) {
        my $success = $response->{content};
        return $success;
    } else {
        croak "something went wrong" . $response;
    } 
}

1;

__END__

=head1 NAME

Google::Translate 

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

    use Google::Translate;

    my $foo = Google::Translate->new({
        api_key => '2343534334',
        source => 'en',
        target => 'nl'
    });

    my $translation = $foo->translate({ q => 'some text' });
    ...

    my $detect = $foo->detect({ q => "any language" });

