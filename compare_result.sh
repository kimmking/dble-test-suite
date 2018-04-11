#!/bin/bash
generate_simple_cmp_file () {
	files=$(ls $1| egrep -v "*_pass.log|balance")

    cmp_dir=$2

    for s in $files; do
#        echo "file: $s"
        if [ -d "$1/$s" ]; then
            mkdir "$cmp_dir/$s"
            subfiles=$(ls "$1/$s"| grep -E -v *_pass.log)
            for ss in $subfiles; do
#                echo "$1/$s/$ss"
#                echo "$cmp_dir/$s/$ss"
                grep '===file:' "$1/$s/$ss" > "$cmp_dir/$s/$ss"
                grep '===id:' "$1/$s/$ss" > "$cmp_dir/$s/$ss"
            done
		else
#		    echo "$1/$s/$ss"
#            echo "$cmp_dir/$s/$ss"
            grep '===file:' "$1/$s" > "$cmp_dir/$s"
            grep '===id:' "$1/$s" > "$cmp_dir/$s"
        fi
    done
}

rm -rf cmp_result && mkdir cmp_result
rm -rf cmp_std_result && mkdir cmp_std_result
generate_simple_cmp_file std_result cmp_std_result
generate_simple_cmp_file logs/result cmp_result

res=`diff -qr cmp_std_result cmp_result`
if [ ${#res} -gt 0 ]; then
    echo "Oop! result is different with the standard one"
    echo 'try "diff -qr cmp_std_result cmp_result" to see the differences'
    exit 1
else
    echo "pass"
    exit 0
fi