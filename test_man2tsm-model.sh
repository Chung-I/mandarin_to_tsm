moses_dir=/home/nlpmaster/Works/mosesdecoder
#$moses_dir/bin/moses -f $1/model/moses.ini < $2/dev.man > $1/dev.hyp.tsm 2> $1/dev.dec.log
python3 get_raw_tailo.py < $2/dev.tsm > $2/dev.pure.tsm
python3 get_raw_tailo.py < $1/dev.hyp.tsm > $1/dev.hyp.pure.tsm
$moses_dir/scripts/generic/multi-bleu.perl -lc $2/dev.pure.tsm < $1/dev.hyp.pure.tsm

