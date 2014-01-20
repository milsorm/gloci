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
	-- my_c = c

.debug
	my_c	internal and result

# -- means plain wire without any circuit
# [name] means use some circuit, his wires are identified via @syntax
# = assign wire to wire
# circuit can be [not], [and], [or], [osc] (oscilator), [led] (LED diode) or external found in name.l file
# (base directories: current, where file is located, GLOCI_LIB)
