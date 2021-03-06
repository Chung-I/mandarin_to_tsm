order=3
#for text in $1;
#do
#  lmplz -o $order --intermediate $text.intermediate <$text
#done
intermediates=""
weights=""
num_files="$(echo $1 | wc -w)"
weight=$(python3 -c "print(1.0/$num_files)")
echo $weight
for text in $1;
do
  intermediates="$intermediates $text.intermediate"
  weights="$weights $weight"
done
interpolate -m $intermediates -w $weights > $2
