# 200MHz LVDS clock (5ns period) with an overly generous ~400ppm (4.998ns period) in
# order to cover crystal tolerances and encourage worst-case timing analysis
create_clock -name CLK_200M -period 4.998 [get_ports CLK_P_200M]
