import regex as re
import argparse
import zhon.hanzi
from tsm.sentence import Sentence
from functools import partial

parser = argparse.ArgumentParser()
parser.add_argument('src_path')
parser.add_argument('dest_path')
parser.add_argument('--remove-punct', action='store_true')
args = parser.parse_args()

with open(args.src_path) as fp:
    src_sents = fp.read().splitlines()

dest_sents = list(map(partial(Sentence.parse_mixed_text, remove_punct=args.remove_punct), src_sents))
with open(args.dest_path, 'w') as fp:
    for dest_sent in dest_sents:
        fp.write(" ".join(dest_sent) + '\n')
