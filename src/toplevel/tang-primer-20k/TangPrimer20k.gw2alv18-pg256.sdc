# 27MHz clock (37.037...ns period) with an overly generous >400ppm (37.02ns period) in
# order to cover crystal tolerances and encourage worst-case timing analysis
create_clock -name H11_IOT27A_OSC_CK -period 37.02 [get_ports {H11_IOT27A_OSC_CK}]
