moses_dir=/home/nlpmaster/Works/mosesdecoder
model_dir=$1
gran=$2
data_path=$3
dev_path=$4
test_path=$5
src_code=$6
tgt_code=$7
hyp_path="$model_dir/$(basename $test_path).hyp.$tgt_code"
lm_path=lm/${gran}_all.arpa.$tgt_code
blm_path=lm/${gran}_all.blm.$tgt_code
order=$8
lm_data=$(dirname $data_path)/lm.$tgt_code
echo $lm_data
if [ ! -f $lm_data ]; then
  lm_data=$data_path.$tgt_code
fi
export PATH=$moses_dir/bin:$PATH
mkdir -p $model_dir
mkdir -p $(dirname $lm_path)
if [ ! -f $lm_path ];
then
  $moses_dir/bin/lmplz -o $order < $lm_data > $lm_path
fi
if [ ! -f $blm_path ];
then
  $moses_dir/bin/build_binary $lm_path $blm_path
fi

perl $moses_dir/scripts/training/train-model.perl -root-dir $model_dir --corpus $data_path --f $src_code --e $tgt_code -external-bin-dir $moses_dir/tools --lm 0:$order:$PWD/$blm_path  -reordering msd-bidirectional-fe -score-options "--GoodTuring"
#perl $moses_dir/scripts/training/mert-moses.pl $dev_path.$src_code $dev_path.$tgt_code $moses_dir/bin/moses $model_dir/model/moses.ini --working-dir `pwd`/$model_dir/mert-dir -mertargs="--sctype TER,BLEU --scconfig weights:0.6+0.4" --mertdir $moses_dir/bin --rootdir $moses_dir/scripts --return-best-dev
$moses_dir/bin/moses -f $model_dir/model/moses.ini < $test_path.$src_code > $hyp_path 2> $1/$(basename $test_path).decode.log
#$moses_dir/bin/moses -f $model_dir/mert-dir/moses.ini < $test_path.$src_code > $hyp_path.mert 2> $1/$(basename $test_path).mert.decode.log
$moses_dir/scripts/generic/multi-bleu.perl -lc $test_path.$tgt_code < $hyp_path > $1/score.txt
#$moses_dir/scripts/generic/multi-bleu.perl -lc $test_path.$tgt_code < $hyp_path.mert > $1/score-tuned.txt
