#!/usr/bin/env bash
#created by JACOBMENKE at Mon Jun 12 17:33:50 EDT 2017

fileName="$1"
echo '#!/usr/bin/env bash' > "$fileName"
printf '#created by JACOBMENKE at ' >> "$fileName"
printf "%s" "$(date)" >> "$fileName"
printf " with %s\n" "$SHELL" >> "$fileName"
echo  >> "$fileName"
