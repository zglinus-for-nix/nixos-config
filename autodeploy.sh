# #!/bin/bash

# sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2}(;[0-9]{1,2})?)?)?[m|K]//g" ~/typescript | tee ./donotpush/logfile
# export RESULT=$(cat ./donotpush/logfile | grep "flake")
# echo $RESULT > ./donotpush/resultfile
# export RESULTFILE=$(sed -r "s/\x1B\[\?2004l//g"  donotpush/resultfile)
# echo $RESULTFILE > ./donotpush/resultfile
# export OUTPUT=$(tr -cd "[:print:]\n" < ./donotpush/resultfile|base64)
# python dingdingbot.py 1 2 $OUTPUT

while [ 1 ]
do
    COMMIT=$(curl -s -u $OAUTH https://api.github.com/repos/zglinus-for-nix/nixos-config/commits | jq -r ".[0].sha")
    COMMITFILE=$(cat donotpush/rev)
    if [ $COMMIT != $COMMITFILE ]
    #if [ 1 ]
    then
        MESSAGE=$(curl -s https://api.github.com/repos/zglinus-for-nix/nixos-config/commits | jq -r ".[0].commit.message"|base64)
        git pull origin
        echo "level auto" > /proc/acpi/ibm/fan
        start=$(date +%s)
        #sleep 10s;
        nix run github:serokell/deploy-rs -- -s . -- --print-build-logs > ./donotpush/logfile 2>&1
        end=$(date +%s)
        sed -i -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2}(;[0-9]{1,2})?)?)?[m|K]//g" ./donotpush/logfile
        linenum=`cat ./donotpush/logfile | wc -l`
        linenum_l3=`expr $linenum - 2`
        linenum_l2=`expr $linenum - 1`
        SPEND=`expr $end - $start`
        OUTPUT1=$(sed -n ''"$linenum_l3"'p' ./donotpush/logfile|base64 -w 0)
        OUTPUT2=$(sed -n ''"$linenum_l2"'p' ./donotpush/logfile|base64 -w 0)
        OUTPUT3=$(sed -n ''"$linenum"'p' ./donotpush/logfile|base64 -w 0)
        #echo $SPEND
        python dingdingbot.py $COMMIT $MESSAGE $OUTPUT1 $OUTPUT2 $OUTPUT3 $SPEND
        echo "level 4" > /proc/acpi/ibm/fan
        echo $COMMIT > donotpush/rev
        #exit
    else
        echo "Nothing changes!"
    fi
    sleep 10s
done
