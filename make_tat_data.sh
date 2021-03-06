python3 extract_parallel_sents.py 中文 漢羅台文 TAT-Vol1-train-lavalier/json raw_data/tat.mandarin raw_data/tat.taibun
python3 simple_tokenize_mixed.py raw_data/tat.mandarin raw_data/tat.tok.mandarin
python3 simple_tokenize_mixed.py raw_data/tat.taibun raw_data/tat.tok.taibun
gzip raw_data/tat.tok.mandarin
gzip raw_data/tat.tok.taibun
