#! /bin/bash
TEMP=$(echo $(ps -ef | grep -v grep | grep maly_skrypt_1.sh | awk '{print $2}') | cut -c1-5) && NAZWA=`mktemp --suffix=$TEMP /tmp/fileXXXXX` && grep "OK DOWNLOAD" cdlinux.ftp.log | cut -d '"' -f 2,4 | sort | uniq | sed "s#.*/##" | grep \.iso$ > $NAZWA
cut -d " " -f 1,7,9 cdlinux.www.log | grep '200$' | sort | uniq | cut -d " " -f 2 | grep "\.iso" |grep -o "cdlinux-.*" | sed "s/?.*//" >> $NAZWA
cat < $NAZWA | sort | uniq -c | sort -r ; rm $NAZWA
