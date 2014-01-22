{
package Gloci::Loci::Builtin::not 0.01;

use 5.12.0;
use namespace::sweep;
use Mouse;

extends 'Gloci::Base';

with 'Gloci::Loci::Builtin';

has '+name' => (
    default     => 'Logical inverter (NOT)',
);

has '+description' => (
    default     => 'out = ! in',
);

has '+input_wires' => (
    default     => sub { { in => 'Input signal' } },
);

has '+output_wires' => (
    default     => sub { { out => 'Inverted signal' } },
);

no Mouse;
__PACKAGE__->meta->make_immutable;
}

1;
