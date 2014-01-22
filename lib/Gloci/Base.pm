{
package Gloci::Base 0.01;

use 5.12.0;
use namespace::sweep;

use Mouse;
use Smart::Args;
use Module::Load;

has debug => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
);

has verbose => (
    is      => 'rw',
    isa     => 'Int',
    default => 0,
);

sub createInstance {
    args
        my $self,
        my $class => 'Str',
        my $args => { isa => 'ArrayRef', optional => 1 };
        
    load $class;
    $args = [] unless defined $args and $args;
    my $instance = $class->new( debug => $self->debug, verbose => $self->verbose, @$args );
    
    return $instance;
}

sub _verbose {
    args
        my $self,
        my $message => 'Str',
        my $level => { isa => 'Int', optional => 1, default => 1 };
        
    print STDERR $message . "\n" if $self->verbose >= $level;
}

no Mouse;
__PACKAGE__->meta->make_immutable;
}

1;
