.name
    LED diode
    
.desc
    Switch on/off specified LED diode through port
    
.input
    led<0:3>    4-byte address of LED diode on panel
    light       We want to LED switch on/off according to this wire
    
.temp
    zero        Signal 0
    carrier     Signal 1
    ignore      Ignore wire

.process
    [zero]  @zero = zero                                              # [zero] is generator of 0 signal
    [not]   @in = zero, @out = carrier                                # inverter creates 1 from 0
    [port]  @addr0 = zero, @addr1 = carrier, @addr<2:3> = zero, _     # 0010 means LED panel
            @arg0<0:3> = led<0:3>, @arg0<4:7> = zero, _
            @arg1<0:7> = zero, @arg2<0:7> = zero, @arg3<0:7> = zero, _
            @signal = ignore, _
            @data0<0:7> = ignore, @data1<0:7> = ignore, @data2<0:7> = ignore, @data3<0:7> = ignore
