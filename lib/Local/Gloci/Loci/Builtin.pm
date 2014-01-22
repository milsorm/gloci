{
package Local::Gloci::Loci::Builtin 0.01;

use 5.12.0;
use namespace::sweep;
use Mouse::Role;
use Smart::Args;

with 'Local::Gloci::Loci';

sub execute {
    args
        my $self,
        my $inputs = 'HashRef';
    
    # abstract    
    ...;
    
    return {};
}

no Mouse;
}

1;
