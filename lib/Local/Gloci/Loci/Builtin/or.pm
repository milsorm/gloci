{
package Local::Gloci::Loci::Builtin::or 0.01;
# ABSTRACT: Builtin logical disjunction (OR)

use 5.12.0;
use namespace::sweep;
use Mouse;

with 'Local::Gloci::Loci::Builtin';

extends 'Local::Gloci::Base';

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
