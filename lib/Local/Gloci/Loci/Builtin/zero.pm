{
package Local::Gloci::Loci::Builtin::zero 0.01;

use 5.12.0;
use namespace::sweep;
use Mouse;

extends 'Local::Gloci::Base';

with 'Local::Gloci::Loci::Builtin';

has '+name' => (
    default     => 'Universal ground (zero signal)',
);

has '+description' => (
    default     => 'zero = 0',
);

has '+output_wires' => (
    default     => sub { { zero => 'Always signal 0' } },
);

no Mouse;
__PACKAGE__->meta->make_immutable;
}

1;
