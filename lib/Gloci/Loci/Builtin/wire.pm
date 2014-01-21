{
package Gloci::Loci::Builtin::wire 0.01;

use 5.12.0;
use namespace::sweep;
use Mouse;

with 'Gloci::Loci::Builtin';

has '+sysid' => (
    default     => '--',
);

has '+name' => (
    default     => 'Pure wire',
);

has '+description' => (
    default     => 'Just connect other wires',
);

no Mouse;
__PACKAGE__->meta->make_immutable;
}

1;
