# Constrain clock port clk24mhz

create_clock -period 41.6667 [get_ports clk24mhz]
create_clock -period 40.0000 [get_ports conn_tck_in]
