import argparse
from pathlib import Path
from operator import itemgetter

from tsm.util import write_lines_to_file
from tsm.sentence import ParallelSentence

parser = argparse.ArgumentParser()
parser.add_argument('src_field')
parser.add_argument('tgt_field')
parser.add_argument('input_dir')
parser.add_argument('src_dest_path')
parser.add_argument('tgt_dest_path')

def get_jsonfiles(root_dir: Path):
    yield from root_dir.rglob("*.json")

def main(args):
    jsonfiles = get_jsonfiles(Path(args.input_dir))
    bitexts = []
    for jsonfile in jsonfiles:
        bitext = ParallelSentence.from_json_to_tuple(
            jsonfile, args.src_field, args.tgt_field,
        )
        bitexts.append(bitext)

    write_lines_to_file(args.src_dest_path, map(itemgetter(0), bitexts))
    write_lines_to_file(args.tgt_dest_path, map(itemgetter(1), bitexts))

args = parser.parse_args()
main(args)
