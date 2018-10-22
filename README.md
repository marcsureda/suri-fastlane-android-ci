Welcome to Fastlane for Android CI!
=============================

This is a docker image used to create the Continuous Integration Pipeline for Android.
It is using the fastlane tool.
It include:

 - Fastlane 2.107.0
 - Git
 - SonarQube 3.2.0.1227

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