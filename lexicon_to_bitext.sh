cat $1 | awk '{print $1}' > $2/$3
gzip $2/$3

cat $1 | awk '{$1=""; print substr($0, 2)}' > $2/$4
gzip $2/$4
