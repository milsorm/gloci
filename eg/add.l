.name
    Binary adder (a + b)

.desc
    Base circuit for adding on binary level
    out     = a [halfadd] b [halfadd] c_in
    c_out   = (a & b) | ( c_in & (a [halfadd] b) )

.input
    a           Data wire 1
    b           Data wire 2
    c_in        Input carry

.output
    out         Data wire
    c_out       Output carry

.temp
    temp_out    Adding without input carry
    temp1       Temporary register 1
    temp2       Temporary register 2
    
.process
    [halfadd]   @a = a, @b = b, @out = temp_out
    [halfadd]   @a = temp_out, @b = c_in, @out = out
    
    [and]       @a = a, @b = b, @out = temp1
    [or]        @a = c_in, @b = temp_out, @out = temp2
    [or]        @a = temp1, @b = temp2, @out = c_out

# For creating add2, add4, add8 will be better to use carry-lookahead adders, lookahead carry unit or carry-save adders
