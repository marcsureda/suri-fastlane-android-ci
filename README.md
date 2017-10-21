Welcome to Fastlane for Android CI!
=============================

This is a docker image used to create the Continuous Integration Pipeline for Android.
It is using the fastlane tool.
It include:

 - Fastlane 2.62.0
 - Git
 - SonarQube 3.0.3.778
 - Android SDK 26.0.2
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