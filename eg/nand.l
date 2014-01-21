.name
    Negated AND (NAND)
    
.desc
    Implements negated AND (NAND) logic as out = ! ( a & b )
    
.input
    a           Signal A
    b           Signal B

.output
    out         A nand B
    
.temp
    temp        Temporary register
    
.process
    [and]       @a = a, @b = b, @out = temp
    [not]       @in = temp, @out = out
