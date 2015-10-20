# Step 1:  Read in the source file
analyze -format sverilog -lib WORK { decode.sv}
elaborate decode -lib WORK
uniquify
# Step 2: Set design constraints
# Uncomment below to set timing, area, power, etc. constraints
# set_max_delay <delay> -from "<input>" -to "<output>"
# set_max_area <area>
# set_max_total_power <power> mW


# Step 3: Compile the design
compile -map_effort medium

# Step 4: Output reports
report_timing -path full -delay max -max_paths 1 -nworst 1 > reports/decode.rep
report_area >> reports/decode.rep
report_power -hier >> reports/decode.rep

# Step 5: Output final VHDL and Verilog files
write_file -format verilog -hierarchy -output "mapped/decode.v"
echo "\nScript Done\n"
echo "\nChecking Design\n"
check_design
quit
