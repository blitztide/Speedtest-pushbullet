#########################################################################################################################
#					Speedtest-pushbullet.sh								#
#					Author: David Elliott								#
#					Date: 2018-03-30								#
#					Version: 0.1									#
#########################################################################################################################
#!/usr/local/bin/bash

#Get current System Date
date=`date "+%Y_%m_%d %H:%M:%S"`

#Run the speedtest and output to a temporary file

/usr/local/bin/speedtest-cli --csv > temp.file


#Extract all variables from the speedtest

server=`cut -d"," -f3 ./temp.file`
ping=`cut -d"," -f6 ./temp.file | bc`
download=`cut -d"," -f7 ./temp.file`
upload=`cut -d"," -f8 ./temp.file`
uploadmb=`echo "scale=2;${upload}/1048576" | bc -l`
downloadmb=`echo "scale=2;${download}/1048576" | bc -l`

#Prepare Pushbullet API message
access_token=`cat api.key`
message=`echo "PING: ${ping}ms\\nDOWN: ${downloadmb}MBs\\nUP: ${uploadmb}MBs"`
title=`echo "${date} Speedtest Results, server: ${server}"`


#Push the results to the pushbullet API
/usr/local/bin/curl -s -u ${access_token}: -X POST https://api.pushbullet.com/v2/pushes --header 'Content-Type: application/json' --data-binary '{"type": "note", "title": "'"${title}"'", "body": "'"${message}"'"}' >/dev/null

