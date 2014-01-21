{
package Gloci::Loci::Builtin::or 0.01;

use 5.12.0;
use namespace::sweep;
use Mouse;

with 'Gloci::Loci::Builtin';

has '+name' => (
    default     => 'Logical disjunction (OR)',
);

has '+description' => (
    default     => 'out = a | b',
);

has '+input_wires' => (
    default     => sub { { a => 'Input signal A', b => 'Input signal B' } },
);

has '+output_wires' => (
    default     => sub { { out => 'Disjucted signal A | B' } },
);

no Mouse;
__PACKAGE__->meta->make_immutable;
}

1;
