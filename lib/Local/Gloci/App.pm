{
package Local::Gloci::App 0.01;
# ABSTRACT: Main application code for gloci (Genius Logical Circuits)

use 5.12.0;
use namespace::sweep;

use Mouse;
use Smart::Args;
use Getopt::Long;
use Pod::Usage;
use Carp;
use IO::File;
use IO::Handle;
use File::Spec;
use File::Find::Rule;

use Local::Gloci::Sugar;

extends 'Local::Gloci::Base';

has check => (
    is          => 'rw',
    isa         => 'Bool',
    default     => 0,
);

has file => (
    is          => 'rw',
    isa         => 'IO::Handle',
);

has main_name => (
    is          => 'rw',
    isa         => 'Str',
    init_arg    => undef,
    default     => 'stdio',
);

has circuits => (
    is          => 'rw',
    isa         => 'Local::Gloci::Circuits',
    init_arg    => undef,
);

has origpath => (
    is          => 'rw',
    isa         => 'Str',
    default     => '',
);

has input_wires => (
    is          => 'rw',
    isa         => 'HashRef',
    default     => sub { { } },
);

sub run {
    args my $self;

    $self->_parse_arguments;
    
    $self->circuits( instanceof 'Local::Gloci::Circuits' );

    $self->_build_builtins();    
    
    $self->_process_file( input => $self->file, sysid => $self->main_name );

    $self->_execute();
}

sub _execute () {
    args my $self;
    
    my $primary_circuit = $self->circuits->get( sysid => $self->main_name );

    my %input_wires = ();    
    for ( $primary_circuit->required_input_wires ) {
        # if not set, than zero !!! LATER: permute
        $input_wires{ $_ } = exists $self->input_wires->{ $_ } ? $self->input_wires->{ $_ } : 0;
    }

    my %output_wires = $primary_circuit->execute( inputs => \%input_wires );
    
    say "Result:";
    say sprintf "%-20s : %s", $_, $output_wires{ $_ } for sort keys %output_wires;
}

sub _build_builtins {
    args my $self;
    
    my %builtins = ( instanceof 'Local::Gloci::BuiltinFactory' )->createBuiltins;
    for ( keys %builtins ) {
        $self->circuits->add( sysid => $_, circuit => $builtins{ $_ } );
        $self->_verbose( message => "GLOCI: Logical builtin circuit [$_] added to repository.", level => 1 );
    }
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
    
    pod2usage( -verbose => 0, -exitval => 2, -output => \*STDERR, -message => "Incorrect arguments.\n" ) if ( $use_stdio && @ARGV );
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
        
        my ( $volume, $path, $fname ) = File::Spec->splitpath( $file );
        $fname =~ s/\.l$//;
        $fname =~ s/\W//;
        $self->main_name( lc $fname );
        
        $self->_verbose( message => "GLOCI: Processing file $file.", level => 1 );
        $self->file( $fh );
        
        $self->origpath( File::Spec->catpath( $volume, $path ) );
        
        for ( @ARGV ) {
            pod2usage( -verbose => 0, -exitval => 3, -output => \*STDERR, -message => "Invalid format of input wires.\n" ) if !/=[01]$/;
            
            my ( $wire, $value ) = split /=/;
            pod2usage( -verbose => 0, -exitval => 4, -output => \*STDERR, -message => "Duplicate input wire $wire.\n" ) if exists $self->input_wires->{$wire};

            $self->input_wires->{$wire} = $value;
            $self->_verbose( message => "GLOCI: Input wire $wire set to $value.", level => 1 );
        }
    }
}

sub _find_file {
    args
        my $self,
        my $file => 'Str';
    
    # find $file in current directory
    -e $file && -f $file && return $file;

    # in directory where original circuit was found
    if ( $self->origpath ) {
        my $fname = File::Spec->catfile( $self->origpath, $file );
        -e $fname && -f $fname && return $fname;
    }
    
    # in GLOCI_LIB (semicolon separated list)
    if ( exists $ENV{GLOCI_LIB} && $ENV{GLOCI_LIB} ) {
        my @inc = split /;/, $ENV{GLOCI_LIB};
        for ( File::Find::Rule->file()->name( $file )->maxdepth( 1 )->in( @inc ) ) {
            -e $_ && -f $_ && return $_;
        }
    }
    
    # not found
    return '';
}

sub _process_file {
    args
        my $self,
        my $input => 'IO::Handle',
        my $sysid => 'Str';

    my $loci = instanceof 'Local::Gloci::Loci::FromFile' => ( handle => $input, sysid => $sysid );   

    croak( "Logical circuit $sysid cannot be loaded." ) unless defined $loci && $loci->ok;
    
    if ( $self->circuits->exist( sysid => $sysid ) ) {
        croak( "Logical circuit $sysid already exists." );
    } else {
        $self->circuits->add( sysid => $sysid, circuit => $loci );
        $self->_verbose( message => "GLOCI: Logical circuit [$sysid] added to repository.", level => 1 );
    }
    
    for my $circuit ( $loci->required_circuits ) {
        next if $circuit eq '--';
        
        if ( $circuit =~ /^\[(?<name>\w+)\]$/ ) {
            $circuit = $+{name};
            next if $self->circuits->exist( sysid => $circuit );
            
            $self->_verbose( message => "GLOCI: I am searching for $circuit.l.", level => 1 );
            my $file = $self->_find_file( file => $circuit . '.l' );
            
            if ( $file ) {
                my $fh = new IO::File $file, 'r';
                croak( "File $file cannot be open and read." ) unless defined $fh;
                
                $self->_verbose( message => "GLOCI: Processing file $file.", level => 1 );                
                $self->_process_file( input => $fh, sysid => lc $circuit );
            } else {
                croak( "Definition for circuit [$circuit] cannot be found." );
            }
        } else {
            croak( "Unknown logical circuit [$circuit] used in $sysid." );
        }
    }
    
    undef $input;
}

no Mouse;
__PACKAGE__->meta->make_immutable;
}
