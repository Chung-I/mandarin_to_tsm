moses_dir=/home/nlpmaster/Works/mosesdecoder
model_dir=$1
data_path=$2
test_path=$3
src_code=$4
tgt_code=$5
lm_path=lm/char_train.arpa.$5
blm_path=lm/char_train.blm.$5
order=$6
mkdir -p $model_dir
mkdir -p $(dirname $lm_path)
export PATH=$moses_dir/bin:$PATH
$moses_dir/bin/lmplz -o $order < $data_dir.tsm > $lm_path
$moses_dir/bin/build_binary $lm_path $blm_path
perl $moses_dir/scripts/training/train-model.perl -root-dir $model_dir --corpus $data_dir --f man --e tsm -external-bin-dir $moses_dir/tools --lm 0:$order:$PWD/$blm_path
