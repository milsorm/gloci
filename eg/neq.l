.name
    Logical nonequality (NEQ)
    
.desc
    Implements logical nonequality (NEQ) logic as out = a xor b
    
.input
    a           Signal A
    b           Signal B

.output
    out         A neq B
    
.process
    [xor]      @a = a, @b = b, @out = out
