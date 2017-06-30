#!/usr/bin/env bash
#created by JACOBMENKE at Mon Jun 12 17:33:50 EDT 2017

fileName="$1"

firstString=$(cat<<EOM
#!/usr/bin/env bash
#{{{                    MARK:Header
#**************************************************************
#####   Author: JACOBMENKE
#####   Date: `date`
#####   Purpose: 
#####   Notes: 
#}}}***********************************************************

EOM
)

echo "$firstString" > "$fileName"
