import argparse

parser = argparse.ArgumentParser()
parser.add_argument('src_path')
parser.add_argument('dest_path')
parser.add_argument('--way', choices=['before', 'after'])
parser.add_argument('--index', type=int)
args = parser.parse_args()

with open(args.src_path) as fp:
    lines = fp.read().splitlines()
with open(args.dest_path, 'w') as fp:
    for line in lines:
        fields = line.split()
        if args.way == "before":
            fp.write(" ".join(fields[:args.index]) + '\n')
        elif args.way == "after":
            fp.write(" ".join(fields[args.index:]) + '\n')
        else:
            raise NotImplementedError
