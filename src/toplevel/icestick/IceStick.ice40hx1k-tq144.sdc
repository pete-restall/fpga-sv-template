# 12MHz clock (83.333...ns period) with an overly generous >400ppm (83.33ns period) in
# order to cover crystal tolerances and encourage worst-case timing analysis
create_clock -name ICE_CLK -period 83.33
