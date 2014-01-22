{
package Local::Gloci::Loci::Builtin::and 0.01;

use 5.12.0;
use namespace::sweep;
use Mouse;

extends 'Local::Gloci::Base';

with 'Local::Gloci::Loci::Builtin';

has '+name' => (
    default     => 'Logical conjunction (AND)',
);

has '+description' => (
    default     => 'out = a & b',
);

has '+input_wires' => (
    default     => sub { { a => 'Input signal A', b => 'Input signal B' } },
);

has '+output_wires' => (
    default     => sub { { out => 'Conjucted signal A & B' } },
);

no Mouse;
__PACKAGE__->meta->make_immutable;
}

1;
