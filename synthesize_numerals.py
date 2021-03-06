from itertools import product, chain
import cn2an
import argparse
import random
from operator import itemgetter
from tsm.util import write_lines_to_file

flatten = lambda l: [item for sublist in l for item in sublist]
def generate_year_bitext(start=1, end=2500):
    def year_ordinal_bitext(i):
        mandarin = cn2an.an2cn(i, "direct")
        mandarin = mandarin.replace("万", "萬")
        taibun = mandarin.replace("零", "空")
        o_mandarin = mandarin.replace("零", "○")
        return list(product([f"{mandarin}年", f"{i}年", f"{o_mandarin}年"], [f"{taibun}年"]))

    def year_cardinal_bitext(i):
        mandarin = cn2an.an2cn(i, "low")
        mandarin = mandarin.replace("万", "萬")
        for numeral in ["百", "千", "萬", "億", "兆"]:
            mandarin = mandarin.replace(f"二{numeral}", f"兩{numeral}")
        taibun = mandarin
        return chain(product([f"{mandarin}年", f"{i}年"], [f"{taibun}年", f"{taibun}冬"]))

    years_ordinals = flatten([year_ordinal_bitext(i) for i in range(start, end)])
    years_cardinals = flatten([year_cardinal_bitext(i) for i in range(start, end)])
    return list(chain(years_ordinals, years_cardinals))


parser = argparse.ArgumentParser()
parser.add_argument("--prefix")
parser.add_argument("--samples", type=int, default=0)
parser.add_argument("--start", type=int, default=1)
parser.add_argument("--end", type=int, default=25000)
args = parser.parse_args()
bitexts = generate_year_bitext(args.start, args.end)
if args.samples and len(bitexts) > args.samples:
    bitexts = random.sample(bitexts, args.samples)

mandarins = list(map(itemgetter(0), bitexts))
taibuns = list(map(lambda taibun: " ".join(taibun), map(itemgetter(1), bitexts)))
write_lines_to_file(f"{args.prefix}.mandarin.txt", mandarins)
write_lines_to_file(f"{args.prefix}.taibun.txt", taibuns)
