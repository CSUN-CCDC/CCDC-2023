#/bin/bash
find "/home/" -type f -exec bash -c '
	for file do
		if [[ $(stat -c "%A" "$file") =~ "x" ]]; then
		echo "File: $file"
			stat -c "%A" "$file"
			echo "$file has the executable bit set!"
			echo "$file" >> report
		fi
done
' bash {} + 
