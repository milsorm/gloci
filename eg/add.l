# comment
.name
    AND circuit

.desc
    This allows blah blah blah

.input
    my_a	first wire
    my_b	second wire

.output
    my_c	result

.process
    [and] @a = my_a, @b = my_b, res = @c
    [beep]
    [led] @light = my_a
    -- my_c = c

.debug
    my_c	internal and result

# -- means plain wire without any circuit
# [name] means use some circuit, his wires are identified via @syntax
# = assign wire to wire
# circuit can be [not], [and], [or], [osc] (oscilator)
# or universal [port] which can emulate:
#   [led] (LED diode), [beep] (beeper, sound) and [key] (input state)
#   all of these will be special circuit based on port with pre-defined address and input/output signals
# or external found in name.l file (base directories: current, where file is located, GLOCI_LIB)
