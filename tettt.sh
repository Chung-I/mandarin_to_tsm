a="123 1234"
num_files="$(echo $a | wc -w)"
w=$(python3 -c "print(1.0/$num_files)")
echo $w
