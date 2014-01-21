.name
    Exclusive OR (XOR)
    
.desc
    Implements exclusive OR (XOR) logic as out = ( a & ! b ) | ( ! a & b )
    
.input
    a           Signal A
    b           Signal B

.output
    out         A xor B
    
.temp
    not_a       Inverted signal A
    not_b       Inverted signal B
    temp1       Temporary register 1
    temp2       Temporary register 2
    
.process
    [not]       @in = a, @out = not_a
    [not]       @in = b, @out = not_b
    [and]       @a = a, @b = not_b, @out = temp1
    [and]       @a = not_a, @b = b, @out = temp2
    [or]        @a = temp1, @b = temp2, @out = out
