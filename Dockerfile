FROM ubuntu:18.04

# Environment
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${ANDROID_HOME}/emulator:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools/bin:/opt/tools:${PATH}
ENV DEBIAN_FRONTEND noninteractive

# Update apt-get
RUN dpkg --add-architecture i386
RUN apt-get update -yqq

# Intall tools
RUN apt-get install -y \
    curl \
    expect \
    git \
    htop \
    libc6:i386 \
    libgcc1:i386 \
    libncurses5:i386 \
    libstdc++6:i386 \
    locales \
    make \
    openjdk-8-jdk \
    openssh-client \
    unzip \
    vim \
    wget \
    zlib1g:i386

#Clean up
RUN apt-get clean

# Download Android SDK
RUN cd /opt \
    && wget -q https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -O android-sdk-tools.zip \
    && unzip -q android-sdk-tools.zip -d ${ANDROID_HOME} \
    && rm android-sdk-tools.zip

# Update sdk manager and accept licenses
RUN yes | sdkmanager --update
RUN yes | sdkmanager --licenses

# Platform tools
RUN sdkmanager "emulator" "tools" "platform-tools"

# Create an emulator
RUN yes | sdkmanager --install "system-images;android-19;default;armeabi-v7a"
RUN avdmanager create avd -f -d "2.7in QVGA" -n test -k "system-images;android-19;default;armeabi-v7a"

COPY android-wait-for-emulator.sh opt/tools/android-wait-for-emulator.sh

CMD ["bash"]