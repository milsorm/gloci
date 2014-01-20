package Gloci::App 0.01;

use 5.12.0;
use Moose;
use Smart::Args;
use Getopt::Long;
use Pod::Usage;
use Carp;
use IO::File;
use IO::Handle;

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

sub run {
    args my $self;

    $self->_parse_arguments;
    
    $self->_process_file( input => $self->{file} );
}

sub _parse_arguments {
    args my $self;
    
    my $help = 0;
    my $debug = 0;
    my $check = 0;
    my $verbose = 0;
    my $use_stdio = 0;
    
    my $getopt = new Getopt::Long::Parser;
    
    $getopt->getoptions(
        'help|h|?'      => \$help,
        'debug|d!'      => \$debug,
        'check|c'       => \$check,
        'verbose|v+'    => \$verbose,
        ''              => \$use_stdio,
        ) or pod2usage( -verbose => 0, -exitval => 2, -output => \*STDERR, -message => "Incorrect arguments.\n" );

    ++ $use_stdio unless $use_stdio || @ARGV;
    
    pod2usage( -verbose => 0, -exitval => 2, -output => \*STDERR, -message => "Incorrect arguments.\n" ) if ( $use_stdio && @ARGV ) || ( ! $use_stdio && @ARGV > 1 );
    pod2usage( -verbose => 1 ) if $help;
    
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
        
        $self->_verbose( message => "GLOCI: Processing file $file.", level => 1 );
        $self->file( $fh );
    }
}

sub _process_file {
    args
        my $self,
        my $input => 'IO::Handle';
        
    print while <$input>;
        
    undef $input;
}

sub _verbose {
    args
        my $self,
        my $message => 'Str',
        my $level => { isa => 'Int', optional => 1, default => 1 };
        
    print STDERR $message . "\n" if $self->verbose >= $level;
}

1;
