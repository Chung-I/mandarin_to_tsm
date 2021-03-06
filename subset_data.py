import argparse
import numpy as np

def read_file_to_lines(txt_file):
    with open(txt_file) as fp:
        lines = fp.read().splitlines()
    return lines

def write_lines_to_file(lines, txt_file):
    with open(txt_file, 'w') as fp:
        for line in lines:
            fp.write(line + '\n')

def main(args):
    src_lines = read_file_to_lines(args.src_path)
    if args.random:
        dest_line_nums = np.random.choice(len(src_lines), args.num_samples, replace=False)
    else:
        dest_line_nums = list(range(len(src_lines) - (args.num_samples + 1), len(src_lines) - 1))
    write_lines_to_file([src_lines[n] for n in dest_line_nums], args.dest_path)
    rest_line_nums = set(range(len(src_lines))) - set(dest_line_nums)
    write_lines_to_file([src_lines[n] for n in rest_line_nums], args.rest_path)

parser = argparse.ArgumentParser()
parser.add_argument('src_path')
parser.add_argument('dest_path')
parser.add_argument('rest_path')
parser.add_argument('--random', action='store_true')
parser.add_argument('num_samples', type=int)
args = parser.parse_args()
main(args)
