import argparse
import re
import gzip
from pathlib import Path
from collections import Counter
from functools import partial

arabic_chinese_mapping = {
    0: "零",
    1: "一",
    2: "二",
    3: "三",
    4: "四",
    5: "五",
    6: "六",
    7: "七",
    8: "八",
    9: "九",
}

def strip_puncts(a):
    a=a.replace('-',' ')
    a=a.replace("，"," ")
    a=a.replace(","," ")
    a=a.replace(".", " ")
    a=a.replace("?", " ")
    a=a.replace("﹖", " ")
    a=a.replace("!", " ")
    a=a.replace(":", " ")
    a=a.replace("”", " ")
    a=a.replace('“', ' ')
    a=a.replace(";", " ")
    a=a.replace("/", " ")
    a=a.replace("…", " ")
    a=a.replace("(", " ")
    a=a.replace(")", " ")
    a=a.replace("‘", " ")
    a=a.replace("’", " ")
    a=a.replace("／", " ")
    a=a.replace("⋯", " ")
    a=a.replace("~", " ")
    a=a.replace("（", " ")
    a=a.replace("）", " ")
    a=a.replace("「", " ")
    a=a.replace("」", " ")
    a=a.replace("％", " ")
    a=a.replace("｣", " ")
    a=a.replace("%", " ")
    a=a.replace("、", " ")
    a=a.replace("｢", " ")
    a=a.replace("--", " ")
    a=a.replace("！", " ")
    a=a.replace("：", " ")
    a=a.replace("。", " ")
    a=a.replace("—", " ")
    a=a.replace("？", " ")
    a=a.replace("；", " ")
    a=a.replace("──", " ")
    a=a.replace("\"", " ")
    a=a.replace("\'", " ")
    a=a.replace("^", " ")
    a=a.replace("  ", " ")
    a=a.strip()
    return a

def flatten(l):
    return [item for sublist in l for item in sublist]

def convert_arabic_number_to_chinese(sent):
    sent = "".join([arabic_chinese_mapping[int(char)] if re.match("\d", char) else char for char in sent])
    return sent

def read_gzip_file(gzip_file):
    with gzip.open(gzip_file, 'rb') as fp:
        raw_text = fp.read().decode('utf-8')
    return raw_text

def parse_src_sent(sent, merge=True):
    #sent = strip_puncts(sent).lower()
    sent = sent.lower()
    if merge:
        sent = re.sub("[^\u4e00-\u9fa5A-Za-z0-9]", "", sent) 
    else:
        words = sent.split()
        words = [re.sub("[^\u4e00-\u9fa5A-Za-z0-9]", "", word) for word in words]
        sent = " ".join(words)
    return sent

def parse_tgt_word(word, split=False):
    if not split:
        return [word]
    syls = word.split("-")
    def parse_tgt_syl(syl):
        if re.match("^\d+$", syl):
            return " ".join(syl)
        else:
            syl = re.sub("[^\u4e00-\u9fa5A-Za-z0-9]", "", syl)
            try:
                return re.match("\d?(\w+\d)", syl).group(1)
            except AttributeError:
                return ""
    return map(parse_tgt_syl, syls)

def parse_tgt_sent(sent, row=1, split=True):
    sent = sent.lower()
    words = flatten([parse_tgt_word(word.split("｜")[row], split=split) for word in re.split("\s+", sent)])
    words = filter(lambda word: word, words)
    sent = " ".join(words)
    return sent

def write_lines_to_file(lines, text_file):
    with open(text_file, 'w') as fp:
        for line in lines:
            fp.write(line + '\n')

def get_all_datas(input_dir, src_prefixes, tgt_prefixes):
    src_sents = []
    tgt_sents = []
    for src_prefix, tgt_prefix in zip(src_prefixes, tgt_prefixes):
        src_text = read_gzip_file(Path(input_dir).joinpath(f"{src_prefix}.txt.gz"))
        tgt_text = read_gzip_file(Path(input_dir).joinpath(f"{tgt_prefix}.txt.gz"))
        src_sents += list(filter(lambda line: line, src_text.splitlines()))
        tgt_sents += list(filter(lambda line: line, tgt_text.splitlines()))
    assert len(src_sents) == len(tgt_sents)
    return src_sents, tgt_sents

def main(args):
    src_sents, tgt_sents = get_all_datas(args.input_dir, args.src_prefixes, args.tgt_prefixes)
    src_sents = list(map(partial(parse_src_sent, merge=not args.dont_merge), src_sents))
    tgt_sents = list(map(partial(parse_tgt_sent, split=not args.dont_split), tgt_sents))
    if args.vocab_path is not None:
        counter = Counter(flatten(map(lambda sent: sent.split(), src_sents)))
        write_lines_to_file([word for word, count in counter.most_common()], args.vocab_path)
    write_lines_to_file(list(map(lambda x: f"{x[0]}|{x[1]}", zip(src_sents, tgt_sents))),
                        f"{args.output_dir}/all.txt")

parser = argparse.ArgumentParser()
parser.add_argument('input_dir')
parser.add_argument('output_dir')
parser.add_argument('--src-prefixes', nargs='+')
parser.add_argument('--tgt-prefixes', nargs='+')
parser.add_argument('--vocab-path', type=str)
parser.add_argument('--dont-merge', action='store_true')
parser.add_argument('--dont-split', action='store_true')
args = parser.parse_args()
main(args)
