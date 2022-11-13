#!/bin/bash

PORT=4000

function initialize() {
  echo "-----------------------------------------------------"
  echo -n "[INFO] Start at: "
  date "+%Y/%m/%d-%H:%M:%S"
  echo "-----------------------------------------------------"
  figlet "simple-web-server"
  echo "-----------------------------------------------------"
  echo "The Server is running at http://127.0.0.1:${PORT}"
  echo "-----------------------------------------------------"
  echo "Access Web Page is http://127.0.0.1:${PORT}/index.html"
  echo "-----------------------------------------------------"
}

# main process
initialize

# log
OUT="out.log"
ERROR="error.log"

exec 1> >(tee -a $OUT)
exec 2> >(tee -a $ERROR)

# prepare
if [ -e "./stream" ]; then
  rm stream
fi

trap exit INT
mkfifo stream
while true; do
  nc -l "$PORT" -w 1 < stream | awk '/HTTP/ {system("./content.sh " $2)}' > stream
done
