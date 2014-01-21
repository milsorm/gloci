.name
    Simple beeper
    
.desc
    Make a short sound (just like "\a")
    
.temp
    zero        Signal 0
    carrier     Signal 1
    ignore      Ignore wire

.process
    [zero]  @zero = zero                                                # [zero] is generator of 0 signal
    [not]   @in = zero, @out = carrier                                  # inverter creates 1 from 0
    [port]  @addr0 = carrier, @addr<1:3> = zero, _                      # 0001 means beeper
            @arg0<0:7> = zero, @arg1<0:7> = zero, @arg2<0:7> = zero, @arg3<0:7> = zero, _
            @signal = ignore, _
            @data0<0:7> = ignore, @data1<0:7> = ignore, @data2<0:7> = ignore, @data3<0:7> = ignore
