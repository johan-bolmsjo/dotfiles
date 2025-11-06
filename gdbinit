# ~/.gdbinit

# C++ display option
set print static-members off

# Print fancy structs
set print pretty on

# Dont ask for key press when printing things
set pagination off

# Display this many lines at a time
set listsize 20

set logging file ~/.cache/gdb/output.txt
set logging enabled

set history filename ~/.cache/gdb/history.txt
set history save on
set history size 500

handle SIGPIPE nostop noprint pass

define hexdump
  dump binary memory ~/.cache/gdb/dump.bin $arg0 ((const char*)($arg0))+($arg1)
  shell od --endian=big -A x -t x4z -v ~/.cache/gdb/dump.bin
end
