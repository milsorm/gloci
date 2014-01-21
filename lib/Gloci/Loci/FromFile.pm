{
package Gloci::Loci::FromFile 0.01;

use 5.12.0;
use namespace::sweep;
use Moose;
use Moose::Util::TypeConstraints;
use Smart::Args;
use IO::Handle;
use Carp;

with 'Gloci::Loci';

has handle => (
    is          => 'ro',
    isa         => 'IO::Handle',
    required    => 1,
);

has ok => (
    is          => 'rw',
    isa         => 'Bool',
    init_arg    => undef,
    default     => 0,
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
    my %wires = ( input => {}, output => {}, debug => {}, temp => {} );
    my @process = ();
    
    my $oldbuffer = '';
    
    while ( <$io> ) {
        s/[\r\n]+$//;
        s/\s*#.*$//;
        s/^\s+//;
        s/\s+$//;
        
        next unless $_;
        
        if ( s/_$// ) {
            s/\s+$//;
            $oldbuffer .= $_;
            next;
        }

        if ( $oldbuffer ) {        
            $_ = $oldbuffer . $_;
            $oldbuffer = '';
        }

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
                $desc .= "\n" if $desc;
                $desc .= $line;
            }
            
            when ( /^(?:input|output|debug|temp)$/ ) {
                if ( $line =~ /^(?<wire>\w+)(?:\<(?<rfrom>[0-9a-f]):(?<rto>[0-9a-f])\>)?\s+(?<desc>.*)$/ ) {
                    if ( defined $+{rfrom} && $+{rfrom} ne '' && defined $+{rto} && $+{rto} ne '' ) {
                        # create wires $+{wire} with suffixes from $+{rfrom} to $+{rto}
                        for my $wirename ( $self->range( name => $+{wire}, from => $+{rfrom}, to => $+{rto} ) ) {
                            if ( exists $wires{ $group }->{ $wirename } ) {
                                croak( "Duplicate wire definition for $wirename." );
                            } else {
                                $wires{ $group }->{ $wirename } = $+{desc};
                            }
                        }
                    } else {
                        if ( exists $wires{ $group }->{ $+{wire} } ) {
                            croak( "Duplicate wire definition for $+{wire}." );
                        } else {
                            $wires{ $group }->{ $+{wire} } = $+{desc};
                        }
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
                        if ( /^(?<from>\@?\w+)(?:\<(?<fromrfrom>[0-9a-f]):(?<fromrto>[0-9a-f])\>)?\s*=\s*(?<to>\@?\w+)(?:\<(?<torfrom>[0-9a-f]):(?<torto>[0-9a-f])\>)?$/ ) {
                            my @from = ();  my @to = ();
                            if ( defined $+{fromrfrom} && $+{fromrfrom} ne '' && defined $+{fromrto} && $+{fromrto} ne '' ) {
                                @from = $self->range( name => $+{from}, from => $+{fromrfrom}, to => $+{fromrto} );   
                            } else {
                                @from = ( $+{from} );
                            }
                            if ( defined $+{torfrom} && $+{torfrom} ne '' && defined $+{torto} && $+{torto} ne '' ) {
                                @to = $self->range( name => $+{from}, from => $+{torfrom}, to => $+{torto} );   
                            } else {
                                @to = ( $+{to} );
                            }
                            
                            if ( scalar @from == 0 || scalar @to == 0 ) {
                                croak( "Invalid assignment in [$circuit]." );
                            }
                            
                            if ( scalar @from < scalar @to ) {
                                my @from_orig = @from;
                                @from = ( @from, @from_orig ) while scalar @from < scalar @to;
                                pop @from while scalar @from > scalar @to;
                            } elsif ( scalar @from > scalar @to ) {
                                my @to_orig = @to;
                                @to = ( @to, @to_orig ) while scalar @from > scalar @to;
                                pop @to while scalar @from < scalar @to;
                            }

                            for my $from ( @from ) {
                                my $to = shift @to;
                                ( $from, $to ) = ( $to, $from ) if $from !~ /^\@/ && $to =~ /^\@/;
                                push @connections, { from => $from, to => $to };
                            }
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
    $self->temp_wires( $wires{ temp } );
    $self->processing( \@process );
    
    $self->ok( 1 );
    
    $self->print_circuit if $self->verbose;
}

sub range {
    args
        my $self,
        my $name => 'Str',
        my $from => 'Str',
        my $to => 'Str';
    
    my $indices = '0123456789abcdef';   
    $indices =~ s/^.*(?=$from)//;
    $indices =~ s/(?<=$to).*$//;
    
    return map { $name . $_ } split //, $indices;
}

no Moose;
__PACKAGE__->meta->make_immutable;
}

1;
