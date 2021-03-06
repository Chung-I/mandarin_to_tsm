ftv_dir=/home/nlpmaster/ssd-1t/corpus/ftv/$4.segment
tmp_dir=$1
out_dir=$2
name=$3
mkdir -p $tmp_dir
mkdir -p $out_dir
utt2txt_file="$tmp_dir/$name"
txt_file="$tmp_dir/$name.txt"
utt_file="$tmp_dir/$name.utt"
out_file="$out_dir/$name"
cat $ftv_dir/*/text* > $utt2txt_file
#cat $utt2txt_file | awk '{print $3}' > $txt_file
python3 get_after_n.py $utt2txt_file $txt_file --way after --index 2
python3 get_after_n.py $utt2txt_file $utt_file --way before --index 2
#cat $utt2txt_file | awk '$3=""; {print $0}' > $utt_file
#allennlp predict ckpts/bopomofo-transformer-declayer8 $txt_file --output-file $out_file --batch-size 32 --silent --cuda-device 0 || exit 1;
#mv $out_file $out_file.tmp
#paste -d " " $utt_file $out_file.tmp > $out_file
#rm -r $tmp_dir
#for txtfile in $ftv_dir/*/text*;
#do
#  tmp_file="$tmp_dir/$(basename $txtfile)"
#  out_file="$out_dir/$(basename $txtfile)"
#  cat $txtfile | awk '{print $3}' > $tmp_file
#  allennlp predict ckpts/bopomofo-transformer-declayer8 $tmp_file --output-file $out_file --batch-size 32 --silent --cuda-device 0 || exit 1;
#  cat $txtfile | awk '$3=""; {print $0}' > $tmp_file
#  mv $out_file $out_file.tmp
#  paste -d " " $tmp_file $out_file.tmp > $out_file
#done
