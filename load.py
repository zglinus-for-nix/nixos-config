import sys

load1 = float(sys.argv[1])
load2 = float(sys.argv[2])
time = int(sys.argv[3])

if time <= 900:
    load = (load2*900 - load1*(900-time))/time
else:
    load = load2

print(load)