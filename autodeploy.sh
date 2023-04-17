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
    COMMIT=$(curl https://api.github.com/repos/zglinus-for-nix/nixos-config/commits | jq -r ".[0].sha")
    echo $COMMIT > donotpush/rev
    COMMITFILE=$(cat donotpush/rev)
    if [ $COMMIT != $COMMITFILE ]
    then
        git pull origin
        echo "level auto" > /proc/acpi/ibm/fan
        script
        nix run github:serokell/deploy-rs -- -s .
        exit
        sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2}(;[0-9]{1,2})?)?)?[m|K]//g" typescript | tee ./donotpush/logfile
        RESULT=$(cat ./donotpush/logfile | grep "flake")
        echo $RESULT > ./donotpush/resultfile
        RESULTFILE=$(sed -r "s/\x1B\[\?2004l//g"  donotpush/resultfile)
        echo $RESULTFILE > ./donotpush/resultfile
        OUTPUT=$(tr -cd "[:print:]\n" < ./donotpush/resultfile|base64)
        python dingdingbot.py 1 2 $OUTPUT
        echo "level 4" > /proc/acpi/ibm/fan
    else
        echo "Nothing changes!"
    fi
    sleep 10s
done