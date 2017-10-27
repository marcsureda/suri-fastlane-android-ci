Welcome to Fastlane for Android CI!
=============================

This is a docker image used to create the Continuous Integration Pipeline for Android.
It is using the fastlane tool.
It include:

 - Fastlane 2.62.0
 - Git
 - SonarQube 3.0.3.778
 - Android SDK 27.0.0
 - Kotlin 1.1.50
 - Android AVD preconfigured with ARM SDK 23. To run it is needed: *emulator64-arm @test -no-window -no-audio -gpu off &*

----------


How to run the image
------------------------------

    docker run -v {host}:{container} -it --rm msuri/suri-fastlane-android-ci bash


Options to build manually the image
----------------------------------------------------

    docker build -t msuri/suri-fastlane-android-ci .

or you can use the docker-compose

    docker-compose build
    docker-compose down --rmi all  (to remove all created)

To take into account (Virtual device)
----------------------------------------------------
To generate the virtual device is needed to execute:

    emulator64-arm @test -no-window -no-audio -gpu off &

Take into account that you can use this virtual device to execute UI tests and also get screenshots, but the screenshots retrieved will be a black square png.
We are executing it as -no-window it means that there is no screen to capture.
In case you want to do some snapshots is needed to connect another external devices with the command:
	
	adb connect {ip}:{port}