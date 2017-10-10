#!/bin/sh

IP=$(ifconfig  | grep 'inet ' | grep -v '127.0.0.1' | sed -r 's/\s+/ /' | cut -d' ' -f3)

socat tcp-listen:5037,bind=$IP,fork tcp:127.0.0.1:5037 &
socat tcp-listen:5554,bind=$IP,fork tcp:127.0.0.1:5554 &
socat tcp-listen:5555,bind=$IP,fork tcp:127.0.0.1:5555 &

echo "no" | /opt/android-sdk-linux/tools/android create avd -f -n test -t android-25 --abi 'google_apis/x86'
echo "no" | /opt/android-sdk-linux/tools/emulator64-x86 -avd test -noaudio -gpu off -verbose

