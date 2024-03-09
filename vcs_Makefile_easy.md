# Compilation commands

# For compiling a single Verilog file
vcs top.v

# For multiple Verilog files, use a file list
# file.list containing file1.v, file2.v, etc.
vcs -f file.list

# For SystemVerilog files, add the -sverilog flag
vcs -sverilog top.sv

# For class-based SystemVerilog files, include all .sv files in a package file (pkg.sv)
# Example pkg.sv content:
# package pkg;
#  `include "file1.sv"
#  `include "file2.sv"
# endpackage
vcs -sverilog +incdir+filespath pkg.sv

# Extra attributes in compile command

# To generate a compile log file
vcs -sverilog -l compile.log top.sv

# To override all timescales in your files
vcs -sverilog -timescale_override=1ns/1ps -l compile.log top.sv

# To change or set a local parameter
vcs -sverilog +define+LENGTH=10 -timescale_override=1ns/1ps -l compile.log top.sv

# For UVM users (specify UVM version with -ntb_opts)
vcs -sverilog -ntb_opts uvm-1.2 +define+LENGTH=10 -timescale_override=1ns/1ps -l compile.log top.sv

# For enabling debugging
vcs -sverilog -ntb_opts uvm-1.2 -debug_all +define+LENGTH=10 -timescale_override=1ns/1ps -l compile.log top.sv

# For enabling code coverage
vcs -sverilog -ntb_opts uvm-1.2 -debug_all +define+LENGTH=10 -timescale_override=1ns/1ps -lca -cm line+cond+fsm+tgl+assert -cm_tgl mda -l compile.log top.sv

# Simulation commands

# Simple file simulation
./simv

# Simulation with log file
simv -l sim.log

# Simulation using GUI & (waveforms)
simv -gui &

# Extra attributes in simulation command

# For UVM, specify the test name
simv +UVM_TESTNAME=testname

# For code coverage enablement in simulation
simv +UVM_TESTNAME=testname -cm line+cond+fsm+tgl+assert -cm_tgl mda

# Coverage commands

# Generate the default coverage report with urg
urg -dir simv.vdb

# Generate a custom coverage report with urg
urg -report user_report -dir simv.vdb

# Viewing the coverage report with Firefox
firefox urgReport/grp0.html &
