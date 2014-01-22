{
package Local::Gloci::BuiltinFactory 0.01;
# ABSTRACT: Factory class for constructing all builtin circuits

use 5.12.0;
use namespace::sweep;
use Mouse;
use Smart::Args;
use Module::Util qw/find_in_namespace/;

use Local::Gloci::Sugar;

extends 'Local::Gloci::Base';

sub createBuiltins {
    args my $self;
    
    my %circuits = ();
    
    $self->_verbose( message => "GLOCI: Trying to find all builtins through factory.", level => 1 );
    
    for my $module ( find_in_namespace( 'Local::Gloci::Loci::Builtin' ) ) {
        my $circuit_name = $module;
        $circuit_name =~ s/^.*:://;
        $circuit_name = '--' if $circuit_name eq 'wire';

        $self->_verbose( message => "GLOCI: Find [$circuit_name] in $module.", level => 1 );
        
        my $loci = instanceof $module => ( sysid => $circuit_name );
        $circuits{ $circuit_name } = $loci;
    }
    
    return %circuits;
}

no Mouse;
__PACKAGE__->meta->make_immutable;
}

1;
