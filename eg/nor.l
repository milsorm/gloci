.name
    Negated OR (NOR)
    
.desc
    Implements negated OR (NOR) logic as out = ! ( a | b )
    
.input
    a           Signal A
    b           Signal B

.output
    out         A nor B
    
.temp
    temp        Temporary register
    
.process
    [or]        @a = a, @b = b, @out = temp
    [not]       @in = temp, @out = out
