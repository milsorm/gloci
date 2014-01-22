{
package Local::Gloci::Sugar 0.01;

use 5.12.0;
use namespace::sweep;
use Moose ();
use Mouse::Exporter;
    
Mouse::Exporter->setup_import_methods (
    as_is   => [ qw/instanceof/ ],
    also    => 'Mouse',
);

# class => [ args ]
# class => ( args )
# class
sub instanceof {
    my $newClass = shift;
    my @args = ( scalar @_ == 1 && ref $_[0] eq 'ARRAY' ) ? @{ $_[0] } : @_;
    
    # I need to find $self of my mother class
    # I assume it is Moose/Mouse class so there is no user code in new(), everything is in BUILD() or methods
    # In that situation I am able to look to my caller to first argument - $self in non-static method (not in constructor)
    {
        # call of caller in DB package sets @DB::args
        # it is necessary to call it in list context
        package DB;
        () = CORE::caller(1);
    }

    my $self = shift @DB::args;
    $self->createInstance( class => $newClass, args => \@args )
}

no Moose;
}

1;
