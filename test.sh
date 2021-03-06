moses_dir=/home/nlpmaster/Works/mosesdecoder
$moses_dir/bin/moses -f $1/model/moses.ini < $2 > $4 2> $5
$moses_dir/scripts/generic/multi-bleu.perl -lc $3 < $4
