{
package Local::Gloci::Circuits 0.01;
# ABSTRACT: Collection of known logical circuits

use 5.12.0;
use namespace::sweep;
use Mouse;
use Mouse::Util::TypeConstraints;
use Smart::Args;
use Carp;

extends 'Local::Gloci::Base';

role_type 'Local::Gloci::Loci';

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
        my $circuit => 'Local::Gloci::Loci';
        
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
