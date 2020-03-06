FROM ubuntu:18.04

LABEL maintainer "marc.sureda@gmail.com"

# Environment variables for non interactive debconf frontend (anti-frontend). This means it never interacts with you at all, and makes the default answers be used for all questions
ENV DEBIAN_FRONTEND noninteractive
# Environment variables for versions
ENV SONARQUBE_VERSION "3.2.0.1227"
ENV ANDROID_SDK_TOOLS_VERSION "4333796"
ENV FASTLANE_VERSION "2.143.0"
ENV FASTLANE_FIREBASE_PLUGIN_VERSION "0.1.4"
ENV JSON_VERSION "2.3.0"
# Environment variables for paths
ENV HOME "/root"
ENV ANDROID_HOME "/sdk"
#ENV ANDROID_SDK_TOOLS_HOME "/sdk/tools"

# Update + install apt-utils to avoid multiple warnings of: "debconf: delaying package configuration, since apt-utils is not installed"
RUN apt-get update && apt-get install -qqy apt-utils
# Upgrade
RUN apt-get upgrade -qqy

# Set the en_US locale
RUN apt-get -qqy install locales
RUN locale-gen en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8 

# Install packages
RUN apt-get install -qqy --no-install-recommends \
      curl \
      html2text \
      openjdk-8-jdk \
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
      jq \
      sudo \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Git configuration
RUN git config --global http.sslverify false

# Certificates
RUN rm -f /etc/ssl/certs/java/cacerts; /var/lib/dpkg/info/ca-certificates-java.postinst configure

# Install Bundler
RUN gem install bundler

# Install Fastlane
RUN gem install fastlane -v ${FASTLANE_VERSION}

# Install Fastlane Firebase plugin
RUN gem install fastlane-plugin-firebase_app_distribution -v ${FASTLANE_FIREBASE_PLUGIN_VERSION}

# Install JSON gem
RUN gem install json -v ${JSON_VERSION}

# Install Firebase CLI 
RUN curl -sL https://firebase.tools | bash

# Install SonarQube
RUN mkdir /opt/sonar-scanner-cli
ADD https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONARQUBE_VERSION}-linux.zip /sonar-scanner-linux.zip
RUN unzip -qq /sonar-scanner-linux.zip -d /opt/sonar-scanner-cli && rm -v /sonar-scanner-linux.zip
ENV PATH "$PATH:/opt/sonar-scanner-cli/sonar-scanner-${SONARQUBE_VERSION}-linux/bin"

# Install Android SDK tools
ADD https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS_VERSION}.zip /tools.zip
RUN unzip -qq /tools.zip -d $ANDROID_HOME && rm -v /tools.zip
ENV PATH "$PATH:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/emulator"
# Configure Android SDK tools
RUN mkdir -p $HOME/.android && touch $HOME/.android/repositories.cfg
RUN yes | sdkmanager --licenses
RUN sdkmanager "tools" "platform-tools" "extras;android;m2repository" "extras;google;google_play_services" "extras;google;m2repository"
ENV PATH "$PATH:${ANDROID_HOME}/platform-tools"



