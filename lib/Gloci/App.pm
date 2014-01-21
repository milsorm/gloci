{
package Gloci::App 0.01;

use 5.12.0;
use namespace::sweep;

use Moose;
use Smart::Args;
use Getopt::Long;
use Pod::Usage;
use Carp;
use IO::File;
use IO::Handle;
use File::Spec;

use Gloci::Loci::FromFile;

has debug => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
);

has check => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
);

has verbose => (
    is      => 'rw',
    isa     => 'Int',
    default => 0,
);

has file => (
    is      => 'rw',
    isa     => 'IO::Handle',
);

has main_name => (
    is          => 'rw',
    isa         => 'Str',
    init_arg    => undef,
    default     => 'stdio',
);

has circuits => (
    is          => 'rw',
    isa         => 'HashRef',
    init_arg    => undef,
    default     => sub { {} },
);

sub run {
    args my $self;

    $self->_parse_arguments;
    
    $self->_process_file( input => $self->{file}, sysid => $self->{main_name} );
}

sub _parse_arguments {
    args my $self;
    
    my $help = 0;
    my $debug = 0;
    my $check = 0;
    my $verbose = 0;
    my $force_verbose = 0;
    my $use_stdio = 0;
    
    my $getopt = new Getopt::Long::Parser;
    
    $getopt->getoptions(
        'help|h|?'      => \$help,
        'debug|d!'      => \$debug,
        'check|c'       => \$check,
        'verbose|v+'    => \$verbose,
        'vv'            => \$force_verbose,
        ''              => \$use_stdio,
        ) or pod2usage( -verbose => 0, -exitval => 2, -output => \*STDERR, -message => "Incorrect arguments.\n" );

    ++ $use_stdio unless $use_stdio || @ARGV;
    
    pod2usage( -verbose => 0, -exitval => 2, -output => \*STDERR, -message => "Incorrect arguments.\n" ) if ( $use_stdio && @ARGV ) || ( ! $use_stdio && @ARGV > 1 );
    pod2usage( -verbose => 1 ) if $help;
    
    $verbose += 2 if $force_verbose;
    
    $self->verbose( $verbose );
    
    $debug = 1 if $verbose >= 2;
    
    $self->debug( $debug );
    $self->check( $check );
    
    if ( $use_stdio ) {
        my $io = new IO::Handle;
        $io->fdopen( fileno( STDIN ), 'r' );
        
        croak( "Cannot read from standard input." ) unless defined $io;
        
        $self->_verbose( message => "GLOCI: Processing standard input.", level => 1 );
        $self->file( $io );
    } else {
        my $file = shift @ARGV;
        
        ( -e $file && -f $file ) or croak( "File $file cannot be open and read." );
        
        my $fh = new IO::File $file, 'r';
        croak( "File $file cannot be open and read." ) unless defined $fh;
        
        ( undef, undef, my $fname ) = File::Spec->splitpath( $file );
        $fname =~ s/\.l$//;
        $fname =~ s/\W//;
        $self->main_name( lc $fname );
        
        $self->_verbose( message => "GLOCI: Processing file $file.", level => 1 );
        $self->file( $fh );
    }
}

sub _find_file {
    args
        my $self,
        my $file => 'Str';
    
    # find $file in current directory, in directory where original circuit was found and in GLOCI_LIB
    ...;
    
    return '';  # not found
}

sub _process_file {
    args
        my $self,
        my $input => 'IO::Handle',
        my $sysid => 'Str';

    my $loci = new Gloci::Loci::FromFile handle => $input, verbose => $self->verbose, debug => $self->debug, sysid => $sysid;

    croak( "Logical circuit $sysid cannot be loaded." ) unless defined $loci && $loci->ok;
    
    if ( exists $self->circuits->{ $sysid } ) {
        croak( "Logical circuit $sysid already exists." );
    } else {
        $self->circuits->{ $sysid } = $loci;
        $self->_verbose( message => "GLOCI: Logical circuit $sysid added to repository.", level => 1 );
    }
    
    for my $circuit ( $loci->required_circuits ) {
        next if $circuit eq '--';                       # just plain wires
        
        if ( $circuit =~ /^\[(?<name>\w+)\]$/ ) {
            $circuit = $+{name};
            next if $circuit =~ /^(not|and|or|osc|zero|port)$/;       # internal circuits, zero level, oscilator and external port connection
            
            my $file = $self->_find_file( file => $circuit . '.l' );
            
            if ( $file ) {
                say "I need load $file.";
                
                # - load external recursively
                ...;
            } else {
                croak( "Definition for circuit [$circuit] cannot be found." );
            }
        } else {
            croak( "Unknown logical circuit $circuit used in $sysid." );
        }
    }
    
    # TODO:
    # - start process the whole circuit
    
    ...;
    
    undef $input;
}

sub _verbose {
    args
        my $self,
        my $message => 'Str',
        my $level => { isa => 'Int', optional => 1, default => 1 };
        
    print STDERR $message . "\n" if $self->verbose >= $level;
}

no Moose;
__PACKAGE__->meta->make_immutable;
}
