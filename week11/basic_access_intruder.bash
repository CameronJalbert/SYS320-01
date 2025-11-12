#!/bin/bash
# basic_access_intruder.bash
# This script accesses the webpage 20 times in a row

for i in {1..20}
do
    echo "Access #$i"
    curl http://10.0.17.20/page2.html
    echo "------------------------------------"
done
