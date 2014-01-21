.name
    Binary half adder (a + b) without input carry

.desc
    Base circuit for constructing adder on binary level

.input
    a           Data wire 1
    b           Data wire 2

.output
    out         Data wire
    carry       Output carry

.process
    [xor]   @a = a, @b = b, @out = out
    [and]   @a = a, @b = b, @out = carry
    