{
package Gloci::Loci 0.01;

use 5.12.0;
use namespace::sweep;
use Moose;
use Smart::Args;
use IO::Handle;
use Carp;

has sysid => (
    is          => 'rw',
    isa         => 'Str',
    required    => 1,
);

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

has handle => (
    is          => 'rw',
    isa         => 'IO::Handle',
    required    => 1,
);

has ok => (
    is          => 'rw',
    isa         => 'Bool',
    init_arg    => undef,
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

sub BUILD {
    args_pos
        my $self,
        my $args => 'HashRef';
    
    $self->load_circuit();
}

sub load_circuit {
    args my $self;

    my $io = $self->handle;
    my $group = '';
    
    my $name = '';
    my $desc = '';
    my %wires = ( input => {}, output => {}, debug => {} );
    my @process = ();
    
    while ( <$io> ) {
        s/[\r\n]+$//;
        s/\s*#.*$//;
        s/^\s+//;
        s/\s+$//;
        
        next unless $_;

        if ( /^\.(?<group>\w+)$/ ) {
            $group = $+{group};
            $self->_verbose( message => "Start reading group $group.", level => 2 );
            next;
        }
        
        unless ( $group ) {
            $self->verbose( message => "Instruction outside group: $_", level => 1 );
            next;            
        }
        
        my $line = $_;
        given ( $group ) {
            when ( /^name$/ ) {
                $name .= ' ' if $name;
                $name .= $line;
            }
            
            when ( /^desc$/ ) {
                $desc .= ' ' if $desc;
                $desc .= $line;
            }
            
            when ( /^(?:input|output|debug)$/ ) {
                if ( $line =~ /^(?<wire>\w+)\s+(?<desc>.*)$/ ) {
                    if ( exists $wires{ $group }->{ $+{wire} } ) {
                        croak( "Duplicate wire definition for $+{wire}." );
                    } else {
                        $wires{ $group }->{ $+{wire} } = $+{desc};
                    }
                } else {
                    croak( "Unknown $group wire definition $line." );
                }
            }
            
            when ( /^process$/ ) {
                if ( $line =~ /^(?<circuit>\[\w+\]|--)(?:\s+(?<def>.*))?$/ ) {
                    my $circuit = $+{circuit};
                    my @connections = ();
                    for ( split /,\s*/, $+{def} ) {
                        if ( /^(?<to>\@?\w+)\s*=\s*(?<from>\@?\w+)$/ ) {
                            push @connections, { from => $+{from}, to => $+{to} };    
                        } else {
                            croak( "Unknown connection definition $_ for $circuit." );
                        }
                    }
                    
                    push @process, { circuit => $circuit, connections => \@connections };
                } else {
                    croak( "Unknown internal connection definition $line." );
                }
            }
            
            default {
                croak( "Unknown instruction $_ in group $group." );
            }
        }
    }

    unless ( $name ) {
        croak( message => "Name of circuit is required." );
        return;
    }
    
    $self->name( $name );
    $self->description( $desc );
    $self->input_wires( $wires{ input } );
    $self->output_wires( $wires{ output } );
    $self->debug_wires( $wires{ debug } );
    $self->processing( \@process );
    
    $self->ok( 1 );
    
    $self->print_circuit if $self->verbose;
}

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
    $self->_print_wires( type => 'Debug', wires => $self->debug_wires );
    say "-" x 60;

    for ( @{ $self->processing } ) {
        my @conn = @{ $_->{connections} };
        my $first = scalar @conn ? ( $conn[0]->{from} . ' --> ' . $conn[0]->{to} ) : 'none';
        say sprintf "   %-12s %s", $_->{circuit}, $first;
        shift @conn if @conn;
        say sprintf "%15s %s", ' ', $_->{from} . ' --> '. $_->{to} for @conn;    
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

no Moose;
__PACKAGE__->meta->make_immutable;
}
