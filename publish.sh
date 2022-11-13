#!/bin/bash

# flutter build web --release
# flutter build web
# flutter build web --web-renderer html

HOST='app.grandmaster.club'
USERNAME='root'
PASSWORD='aboba12345'
OUTPUT='/home/dev/web'
cd /Users/deargo/Projects/grandmaster
flutter build web --release --web-renderer canvaskit

echo
echo "Clearing grandmaster on server ..."
# sftp $USERNAME@$HOST
sshpass -p $PASSWORD ssh $USERNAME@$HOST -o StrictHostKeyChecking=no  "rm -rf $OUTPUT/*"
echo "Copying grandmaster on server ..."
sshpass -p $PASSWORD scp -r ./build/web/* $USERNAME@$HOST:$OUTPUT
echo
echo "Ready 👍"
