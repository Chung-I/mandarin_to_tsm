import re
import sys

for line in sys.stdin.readlines():
    words = []
    for word in re.finditer("[A-Za-z]+\d", line):
        words.append(word.group())
    sys.stdout.write(" ".join(words) + "\n")

