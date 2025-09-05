#!/bin/bash

#CF SETTING
CF_API=YOUR_API
CF_USERNAME=YOUR_USER_EMAIL
CF_PASSWORD=YOUR_PASSWORD
CF_APP=YOUR_APP_NAME
CF_ORG=YOUR_ORG
CF_SPACE=YOUR_SPACE #default to be dev

#TIMESETTING
TIMEZONE="Asia/Shanghai"

sapalive() {
echo === Login to Cloud Foundary ===
cf api ${CF_API} --skip-ssl-validation
cf auth ${CF_USERNAME} ${CF_PASSWORD}
cf target -o ${CF_ORG} -s ${CF_SPACE}

echo === try to restart app ===
cf restart ${CF_APP}
echo === Done ===
}

checktime() {
        local cur_hour=$(TZ="$TIMEZONE" date '+%H')
        local cur_mins=$(TZ="$TIMEZONE" date '+%M')

        echo UTC+8 TIME is ${cur_hour} ${cur_mins}
        if [ "$current_hour" = "08" ] && [ "$current_minute" = "05" ]; then
                sapalive()
        else
                echo "not the time to do sap-alive"
        fi
}
