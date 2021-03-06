prefix=$1
python3 simple_tokenize_mixed.py raw_data/$prefix.mandarin raw_data/$prefix.mandarin.tok.txt --remove-punct
python3 simple_tokenize_mixed.py raw_data/$prefix.taibun raw_data/$prefix.taibun.tok.txt --remove-punct
gzip raw_data/$prefix.mandarin.tok.txt
gzip raw_data/$prefix.taibun.tok.txt
