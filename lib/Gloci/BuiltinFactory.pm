{
package Gloci::BuiltinFactory 0.01;

use 5.12.0;
use namespace::sweep;
use Mouse;
use Smart::Args;
use Module::Util qw/find_in_namespace/;
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

sub createBuiltins {
    args my $self;
    
    my %circuits = ();
    
    $self->_verbose( message => "GLOCI: Trying to find all builtins through factory.", level => 1 );
    
    for my $module ( find_in_namespace( 'Gloci::Loci::Builtin' ) ) {
        my $circuit_name = $module;
        $circuit_name =~ s/^.*:://;
        $circuit_name = '--' if $circuit_name eq 'wire';

        $self->_verbose( message => "GLOCI: Find [$circuit_name] in $module.", level => 1 );
        
        load $module;
        my $loci = $module->new( sysid => $circuit_name, verbose => $self->verbose, debug => $self->debug );
        $circuits{ $circuit_name } = $loci;
    }
    
    return %circuits;
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
