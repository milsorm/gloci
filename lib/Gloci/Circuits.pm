{
package Gloci::Circuits 0.01;

use 5.12.0;
use namespace::sweep;
use Mouse;
use Mouse::Util::TypeConstraints;
use Smart::Args;
use Carp;

extends 'Gloci::Base';

role_type 'Gloci::Loci';

has circuits => (
    is          => 'rw',
    isa         => 'HashRef',
    init_arg    => undef,
    default     => sub { {} },
);

sub add {
    args
        my $self,
        my $sysid => 'Str',
        my $circuit => 'Gloci::Loci';
        
    if ( $self->exist( sysid => $sysid ) ) {
        croak( "Cannot add second definition for [$sysid] circuit." );
    }
    
    $self->circuits->{ $sysid } = $circuit;
}

sub exist {
    args
        my $self,
        my $sysid => 'Str';
        
    return exists $self->circuits->{ $sysid };
}

no Mouse;
no Mouse::Util::TypeConstraints;
__PACKAGE__->meta->make_immutable;
}

1;
