.name
    Logical equality (EQ)
    
.desc
    Implements logical equality (EQ) logic as out = a xnor b
    
.input
    a           Signal A
    b           Signal B

.output
    out         A eq B
    
.process
    [xnor]      @a = a, @b = b, @out = out
