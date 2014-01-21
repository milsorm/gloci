{
package Gloci::Loci 0.01;

use 5.12.0;
use namespace::sweep;
use Mouse::Role;
use Smart::Args;
use Carp;

has sysid => (
    is          => 'rw',
    isa         => 'Str',
    required    => 1,
);

has debug => (
    is          => 'ro',
    isa         => 'Bool',
    default     => 0,
);

has verbose => (
    is          => 'ro',
    isa         => 'Int',
    default     => 0,
);

has name => (
    is          => 'rw',
    isa         => 'Str',
    init_arg    => undef,
    default     => '',
);

has description => (
    is          => 'rw',
    isa         => 'Str',
    init_arg    => undef,
    default     => '',
);

has input_wires => (
    is          => 'rw',
    isa         => 'HashRef',
    init_arg    => undef,
    default     => sub { {} },
);

has output_wires => (
    is          => 'rw',
    isa         => 'HashRef',
    init_arg    => undef,
    default     => sub { {} },
);

has temp_wires => (
    is          => 'rw',
    isa         => 'HashRef',
    init_arg    => undef,
    default     => sub { {} },
);

has debug_wires => (
    is          => 'rw',
    isa         => 'HashRef',
    init_arg    => undef,
    default     => sub { {} },
);

has processing => (
    is          => 'rw',
    isa         => 'ArrayRef',
    init_arg    => undef,
    default     => sub { [] },
);

sub _print_wires {
    args
        my $self,
        my $type => 'Str',
        my $wires => 'HashRef';
        
    say "$type wires:";
    for ( sort keys %$wires ) {
        say sprintf "   %-20s: %s", $_, $wires->{$_};
    }
    
    say "   none" unless keys %$wires;    
}

sub print_circuit {
    args my $self;

    say "[" . $self->sysid . "] " . $self->name;
    say $self->description if $self->description;
    say "-" x 60;
    $self->_print_wires( type => 'Input', wires => $self->input_wires );
    $self->_print_wires( type => 'Output', wires => $self->output_wires );
    $self->_print_wires( type => 'Debug', wires => $self->debug_wires ) if $self->debug;
    $self->_print_wires( type => 'Temp', wires => $self->debug_wires ) if $self->verbose >= 2;
    say "-" x 60;

    for ( @{ $self->processing } ) {
        my @conn = @{ $_->{connections} };
        my $first = scalar @conn ? ( $conn[0]->{from} . ' -- ' . $conn[0]->{to} ) : 'none';
        say sprintf "   %-12s %s", $_->{circuit}, $first;
        shift @conn if @conn;
        say sprintf "%15s %s", ' ', $_->{from} . ' -- '. $_->{to} for @conn;    
    }
}

sub _verbose {
    args
        my $self,
        my $message => 'Str',
        my $level => { isa => 'Int', optional => 1, default => 1 };
        
    print STDERR $message . "\n" if $self->verbose >= $level;
}

sub required_circuits {
    args my $self;
    
    return map { $_->{circuit} } @{ $self->processing };
}

no Mouse;
}

1;
