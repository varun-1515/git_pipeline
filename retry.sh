#!/bin/bash
URL="https://www.google.com"
STATUS_CODE=$(curl -o /dev/null -s -w "%{http_code}" $URL)

if [ $STATUS_CODE -eq 200 ]; then
        echo "URL is reachable (HTTP 200 ok)"
else
        echo "URL is not reachable, status code is $STATUS_CODE"
fi
