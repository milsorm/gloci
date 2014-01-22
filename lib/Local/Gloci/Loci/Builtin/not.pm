{
package Local::Gloci::Loci::Builtin::not 0.01;
# ABSTRACT: Builtin logical inverter (NOT)

use 5.12.0;
use namespace::sweep;
use Mouse;

extends 'Local::Gloci::Base';

with 'Local::Gloci::Loci::Builtin';

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
