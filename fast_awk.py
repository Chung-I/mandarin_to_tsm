import sys

for line in sys.stdin.readlines():
    idx = 0
    while line[idx] != "\t":
        idx += 1
    sys.stdout.write(line[:idx] + '\n')
    
