#!/bin/bash -x
export PATH=/c/Dev/SDKs/AndroidSDK/platform-tools:$PATH
adb start-server
phase=ya
port=3445
activity='com.yandex.browser/.YandexBrowserMainActivity'
socket_name=yandex_devtools_remote
adb shell am start -n ${activity}
adb forward --remove tcp:${port}
adb_port=$(adb forward tcp:${port} localabstract:${socket_name})
adb_err=$?
#3445
echo $port:$adb_port
if [[ "${port}" != "${adb_port}" ]] ; then
    echo "Can't forward port ${port} for socket ${socket_name}"
    echo "Error code: ${adb_err}"
else
wget http://localhost:${port}/json/list -O ${phase}.tabs.$(date +%s).json
adb forward --remove tcp:${port}
fi

phase=chrome
port=3446
activity='com.android.chrome/com.google.android.apps.chrome.Main'
socket_name=chrome_devtools_remote
adb shell am start -n ${activity}
adb forward --remove tcp:${port}
adb_port=$(adb forward tcp:${port} localabstract:${socket_name})
adb_err=$?
#3445
echo $port:$adb_port
if [[ "${port}" != "${adb_port}" ]] ; then
    echo "Can't forward port ${port} for socket ${socket_name}"
    echo "Error code: ${adb_err}"
else
    wget http://localhost:${port}/json/list -O ${phase}.tabs.$(date +%s).json
    adb forward --remove tcp:${port}
fi
