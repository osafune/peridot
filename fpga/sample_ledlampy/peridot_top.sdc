# ------------------------------------------
# Create generated clocks based on PLLs
# ------------------------------------------

derive_pll_clocks



# ---------------------------------------------
# Original Clock
# ---------------------------------------------

create_clock -period "20.000 ns" -name {CLOCK_50} {CLOCK_50}
create_clock -period "83.333 ns" -name {SCI_SCLK} {SCI_SCLK}

set_clock_groups -asynchronous \
	-group {SCI_SCLK} \
	-group {CLOCK_50 *|altpll_component|auto_generated|*} \



# ---------------------------------------------
# Set SDRAM I/O requirements
# ---------------------------------------------




