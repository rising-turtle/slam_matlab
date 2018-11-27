import sys
import os

inFile = sys.argv[1]


with open(inFile, "rb") as f:
    first = f.readline()
    f.seek(-2, os.SEEK_END)
    while f.read(1) != b"\n":
        f.seek(-2, os.SEEK_CUR)
    last = f.readline()


tokens = first.split(' ')
sot = float(tokens[0])
tokens = last.split(' ')
eot = float(tokens[0])

sec = int(eot-sot)

min = int(sec/60)

sec = sec -60*min

print min,":",sec