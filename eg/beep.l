.name
    Simple beeper
    
.desc
    Make a short sound (just like "\a")
    
.debug
    zero        Signal 0
    carrier     Signal 1

.process
    [zero]  zero = @zero
    [not]   @in = zero, @out = carrier
    [port]  @addr0 = carrier, @addr1 = zero, @addr2 = zero, @addr3 = zero, @arg00 = zero, @arg01 = zero, @arg02 = zero, @arg03 = zero

# [zero] is generator of 0 signal
# negotiator creates 1 from 0

# [port] receive 4-bit @addr and 4-bit @arg0
# 0001 ... beeper
# 0010 ... led diode
# 0011 ... input key
