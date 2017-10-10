#!/bin/sh

if [ "x$IMAGE" = "x" ]; then
    IMAGE="android-25"
fi
echo "Using image: $IMAGE"

if [ "x$ARCH" = "x" ]; then
	ARCH="arm"
fi
echo "Using arch: $ARCH"

if [ "$ARCH" = "arm" ]; then
	ABI="google_apis/armeabi-v7a"
else
	ABI="google_apis/x86"
fi
echo "Using ABI: $ABI"

IP=$(ifconfig  | grep 'inet ' | grep -v '127.0.0.1' | sed -r 's/\s+/ /' | cut -d' ' -f3)

socat tcp-listen:5037,bind=$IP,fork tcp:127.0.0.1:5037 &
socat tcp-listen:5554,bind=$IP,fork tcp:127.0.0.1:5554 &
socat tcp-listen:5555,bind=$IP,fork tcp:127.0.0.1:5555 &

echo "no" | /opt/android-sdk-linux/tools/android create avd -f -n test -t $IMAGE --abi $ABI
echo "no" | /opt/android-sdk-linux/tools/emulator64-${ARCH} -avd test -noaudio -gpu off -verbose

