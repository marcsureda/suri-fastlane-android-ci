FROM ubuntu:17.04
MAINTAINER Marc Sureda <marc.sureda@gmail.com>

#DECLARE ENVIRONMENT VARIABLES
ENV VERSION_SDK_TOOLS "3859397"
ENV VERSION_BUILD_TOOLS "26.0.2"
ENV VERSION_TARGET_SDK "26"
ENV VERSION_ARM_EMULATOR "25"
ENV FASTLANE_VERSION "2.62.0"
ENV SONARQUBE_VERSION "3.0.3.778"
ENV ANDROID_HOME "/sdk"
ENV PATH "$PATH:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/emulator:${ANDROID_HOME}/platform-tools"
ENV DEBIAN_FRONTEND noninteractive

ENV HOME "/root"

#INSTALL NECESSARY LIBRARIES AND TOOLS
RUN apt-get -qq update && \
    apt-get install -qqy --no-install-recommends \
      curl \
      html2text \
      openjdk-8-jdk \
#      openjdk-8-jre-headless \
      libc6-i386 \
      lib32stdc++6 \
      lib32gcc1 \
      lib32ncurses5 \
      lib32z1 \
      unzip \
      zip \
      git \
      ruby \
      ruby-dev \
      build-essential \
      file \
      ssh \
      libqt5widgets5 \
      libqt5svg5 \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#INSTALL KOTLIN
#RUN curl -s https://get.sdkman.io | bash
#RUN source "/root/.sdkman/bin/sdkman-init.sh"
#RUN sdk install kotlin

#GIT CONFIGURATION
RUN git config --global http.sslverify false

#INSTALL SONARQUBE
RUN mkdir /opt/sonar-scanner-cli
ADD https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONARQUBE_VERSION}-linux.zip /sonar-scanner-linux.zip
RUN unzip /sonar-scanner-linux.zip -d /opt/sonar-scanner-cli && rm -v /sonar-scanner-linux.zip
ENV PATH "$PATH:/opt/sonar-scanner-cli/sonar-scanner-${SONARQUBE_VERSION}-linux/bin"

#CERTIFICATES
RUN rm -f /etc/ssl/certs/java/cacerts; \
    /var/lib/dpkg/info/ca-certificates-java.postinst configure

#INSTALL/CONFIGURE ANDROID TOOLS
ADD https://dl.google.com/android/repository/sdk-tools-linux-${VERSION_SDK_TOOLS}.zip /tools.zip
RUN unzip /tools.zip -d /sdk && \
    rm -v /tools.zip

RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager --licenses

RUN mkdir -p $HOME/.android && touch $HOME/.android/repositories.cfg
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "tools" "platforms;android-${VERSION_TARGET_SDK}" "build-tools;${VERSION_BUILD_TOOLS}"
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "extras;android;m2repository" "extras;google;google_play_services" "extras;google;m2repository"
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "emulator" "system-images;android-${VERSION_ARM_EMULATOR};google_apis;armeabi-v7a"
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "cmake;3.6.4111459"

#CREATE NEW EMULATOR DEVICE
RUN echo no | ${ANDROID_HOME}/tools/bin/avdmanager create avd -f --name test --abi google_apis/armeabi-v7a --package "system-images;android-${VERSION_ARM_EMULATOR};google_apis;armeabi-v7a"

##INSTALL FASTLANE
RUN gem install fastlane -v ${FASTLANE_VERSION}

#CONFIGURE CERTIFICATES
ADD id_rsa $HOME/.ssh/id_rsa
ADD id_rsa.pub $HOME/.ssh/id_rsa.pub
ADD adbkey $HOME/.android/adbkey
ADD adbkey.pub $HOME/.android/adbkey.pub
