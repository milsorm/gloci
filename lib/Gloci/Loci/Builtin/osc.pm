{
package Gloci::Loci::Builtin::osc 0.01;

use 5.12.0;
use namespace::sweep;
use Moose;

with 'Gloci::Loci::Builtin';

has '+name' => (
    default     => 'Oscilator',
);

has description => (
    default     => 'Change output signal according to time',
);

has output_wires => (
    default     => sub { { tick => 'Changed 1 and 0 depending on time' } },
);

no Moose;
__PACKAGE__->meta->make_immutable;
}
