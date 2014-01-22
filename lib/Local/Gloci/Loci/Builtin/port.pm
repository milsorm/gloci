{
package Local::Gloci::Loci::Builtin::port 0.01;
# ABSTRACT: Builtin input/output devices interface through ports

use 5.12.0;
use namespace::sweep;
use Mouse;

extends 'Local::Gloci::Base';

with 'Local::Gloci::Loci::Builtin';

has '+name' => (
    default     => 'Input/output devices interface',
);

has '+description' => (
    default     => 'Allow interaction with other devices and external equipment',
);

has '+input_wires' => (
    default     => sub { {
                    addr0 => 'Bit 0 of device address',
                    addr1 => 'Bit 1 of device address',
                    addr2 => 'Bit 2 of device address',
                    addr3 => 'Bit 3 of device address',
                    arg00 => 'Bit 0 of 1st argument',
                    arg01 => 'Bit 1 of 1st argument',
                    arg02 => 'Bit 2 of 1st argument',
                    arg03 => 'Bit 3 of 1st argument',
                    arg04 => 'Bit 4 of 1st argument',
                    arg05 => 'Bit 5 of 1st argument',
                    arg06 => 'Bit 6 of 1st argument',
                    arg07 => 'Bit 7 of 1st argument',
                    arg10 => 'Bit 0 of 2nd argument',
                    arg11 => 'Bit 1 of 2nd argument',
                    arg12 => 'Bit 2 of 2nd argument',
                    arg13 => 'Bit 3 of 2nd argument',
                    arg14 => 'Bit 4 of 2nd argument',
                    arg15 => 'Bit 5 of 2nd argument',
                    arg16 => 'Bit 6 of 2nd argument',
                    arg17 => 'Bit 7 of 2nd argument',
                    arg20 => 'Bit 0 of 3rd argument',
                    arg21 => 'Bit 1 of 3rd argument',
                    arg22 => 'Bit 2 of 3rd argument',
                    arg23 => 'Bit 3 of 3rd argument',
                    arg24 => 'Bit 4 of 3rd argument',
                    arg25 => 'Bit 5 of 3rd argument',
                    arg26 => 'Bit 6 of 3rd argument',
                    arg27 => 'Bit 7 of 3rd argument',
                    arg30 => 'Bit 0 of 4th argument',
                    arg31 => 'Bit 1 of 4th argument',
                    arg32 => 'Bit 2 of 4th argument',
                    arg33 => 'Bit 3 of 4th argument',
                    arg34 => 'Bit 4 of 4th argument',
                    arg35 => 'Bit 5 of 4th argument',
                    arg36 => 'Bit 6 of 4th argument',
                    arg37 => 'Bit 7 of 4th argument',
                    } },
);

has '+output_wires' => (
    default     => sub { {
                    status => 'Status flag',
                    data00 => 'Bit 0 of 1st data byte',
                    data01 => 'Bit 1 of 1st data byte',
                    data02 => 'Bit 2 of 1st data byte',
                    data03 => 'Bit 3 of 1st data byte',
                    data04 => 'Bit 4 of 1st data byte',
                    data05 => 'Bit 5 of 1st data byte',
                    data06 => 'Bit 6 of 1st data byte',
                    data07 => 'Bit 7 of 1st data byte',
                    data10 => 'Bit 0 of 2nd data byte',
                    data11 => 'Bit 1 of 2nd data byte',
                    data12 => 'Bit 2 of 2nd data byte',
                    data13 => 'Bit 3 of 2nd data byte',
                    data14 => 'Bit 4 of 2nd data byte',
                    data15 => 'Bit 5 of 2nd data byte',
                    data16 => 'Bit 6 of 2nd data byte',
                    data17 => 'Bit 7 of 2nd data byte',
                    data20 => 'Bit 0 of 3rd data byte',
                    data21 => 'Bit 1 of 3rd data byte',
                    data22 => 'Bit 2 of 3rd data byte',
                    data23 => 'Bit 3 of 3rd data byte',
                    data24 => 'Bit 4 of 3rd data byte',
                    data25 => 'Bit 5 of 3rd data byte',
                    data26 => 'Bit 6 of 3rd data byte',
                    data27 => 'Bit 7 of 3rd data byte',
                    data30 => 'Bit 0 of 4th data byte',
                    data31 => 'Bit 1 of 4th data byte',
                    data32 => 'Bit 2 of 4th data byte',
                    data33 => 'Bit 3 of 4th data byte',
                    data34 => 'Bit 4 of 4th data byte',
                    data35 => 'Bit 5 of 4th data byte',
                    data36 => 'Bit 6 of 4th data byte',
                    data37 => 'Bit 7 of 4th data byte',
                    } },
);

no Mouse;
__PACKAGE__->meta->make_immutable;
}

1;
