cat $2 | awk -F '\t' '{print $2}' > $2.tmp
sed 's/\-/ /g' $2.tmp > $2.tmp2
wer $1 $2.tmp2
