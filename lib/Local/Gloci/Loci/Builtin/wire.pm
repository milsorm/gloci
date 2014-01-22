{
package Local::Gloci::Loci::Builtin::wire 0.01;

use 5.12.0;
use namespace::sweep;
use Mouse;
use Smart::Args;

extends 'Local::Gloci::Base';

with 'Local::Gloci::Loci::Builtin';

has '+sysid' => (
    default     => '--',
);

has '+name' => (
    default     => 'Pure wire',
);

has '+description' => (
    default     => 'Just connect other wires',
);

# just wire
sub execute {
    args my $self;
    
    return 1;
}

no Mouse;
__PACKAGE__->meta->make_immutable;
}

1;
