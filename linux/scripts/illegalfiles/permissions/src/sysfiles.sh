#/bin/bash

FILE="/etc/shadow"
PERMISSIONS="-rw-r-----"
if [[ $(stat -c "%A" "$FILE") != "$PERMISSIONS" ]]; then
	echo "BAD FILE PERMISSIONS ON $FILE" 
#	stat "$FILE"
        echo "WANTED $PERMISSIONS SAW $(stat -c "%A" "$FILE")"
	exit 1
else
       echo "GOOD PERMISSIONS on $FILE"
       echo "WANTED $PERMISSIONS SAW $(stat -c "%A" "$FILE")"
fi

