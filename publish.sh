#!/bin/bash

# flutter build web --release
# flutter build web
# flutter build web --web-renderer html

HOST='79.133.181.103'
USERNAME='dev'
PASSWORD='0412'
OUTPUT='/home/dev/web'

flutter build web --release

echo
echo "Clearing cash_bot_client on server ..."
sshpass -p $PASSWORD ssh $USERNAME@$HOST "rm -rf $OUTPUT/*"
echo "Copying cash_bot_client on server ..."
sshpass -p $PASSWORD scp -r ./build/web/* $USERNAME@$HOST:$OUTPUT
echo
echo "Ready 👍"
