.name
    LED diode
    
.desc
    Switch on/off LED diode through port
    
.input
    light       We want to LED switch on/off according to this wire
    
.debug
    zero        Signal 0
    carrier     Signal 1

.process
    [zero]  zero = @zero
    [not]   @in = zero, @out = carrier
    [port]  @addr0 = zero, @addr1 = carrier, @addr2 = zero, @addr3 = zero, @arg00 = light, @arg01 = zero, @arg02 = zero, @arg03 = zero

# [port] can receive 4-byte arg0
