data_dir=$1
mkdir -p $data_dir
#python3 preprocess.py raw_data $data_dir/all --src-prefixes 對齊外語語句 對齊外語字詞 dict_man \
#  --tgt-prefixes 對齊母語語句 對齊母語字詞 dict_tsm --dont-merge
python3 preprocess.py raw_data $data_dir/all --src-prefixes 對齊外語語句 對齊外語字詞 \
  --tgt-prefixes 對齊母語語句 對齊母語字詞 --dont-merge
#python3 subset_data.py $data_dir/all.txt $data_dir/dev.txt $data_dir/train.txt 1000
#python3 subset_data.py $data_dir/dev.txt $data_dir/test.txt $data_dir/dev-tmp.txt 500
#mv $data_dir/dev-tmp.txt $data_dir/dev.txt
#for split in train dev test;
for split in all;
do
  cat $data_dir/$split.txt | awk -F '|' '{print $1}' > $data_dir/$split.man
  cat $data_dir/$split.txt | awk -F '|' '{print $2}' > $data_dir/$split.tsm
done
