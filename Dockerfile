FROM debian:stretch-slim

ENV ANDROID_HOME /opt/android-sdk-linux
ENV SDK_TOOLS_VERSION 25.2.5
ENV API_LEVELS android-25
ENV BUILD_TOOLS_VERSIONS build-tools-25.0.2
ENV ANDROID_EXTRAS extra-android-m2repository,extra-google-google_play_services,extra-google-m2repository
ENV ANDROID_IMAGES sys-img-x86-google_apis-25
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools
ENV DEBIAN_FRONTEND noninteractive
ENV DISPLAY=:0

RUN echo "root:qwerty" | /usr/sbin/chpasswd

RUN mkdir -p /usr/share/man/man1 && apt-get -y update && apt-get -y --no-install-recommends install net-tools socat \
    openjdk-8-jdk sudo supervisor openbox menu x11vnc qemu-kvm bridge-utils xvfb wget unzip python-xdg libqt5widgets5 \
    lxterminal obconf python-numpy procps \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/android-sdk-linux && cd /opt \
    && wget http://dl.google.com/android/repository/tools_r${SDK_TOOLS_VERSION}-linux.zip -O android-sdk-tools.zip \
    && unzip -q android-sdk-tools.zip -d ${ANDROID_HOME} \
    && rm -f android-sdk-tools.zip \
    && echo y | android update sdk --no-ui -a --filter \
       tools,platform-tools,${ANDROID_EXTRAS},${API_LEVELS},${BUILD_TOOLS_VERSIONS},${ANDROID_IMAGES} --no-https

RUN wget -nv -O noVNC.zip "https://github.com/novnc/noVNC/archive/master.zip" \
 && unzip -x noVNC.zip \
 && mv noVNC-master noVNC \
 && wget -nv -O websockify.zip "https://github.com/novnc/websockify/archive/master.zip" \
 && unzip -x websockify.zip \
 && mv websockify-master ./noVNC/utils/websockify \
 && rm websockify.zip \
 && ln noVNC/vnc.html noVNC/index.html

RUN mkdir /opt/android-sdk-linux/tools/keymaps && \
    touch /opt/android-sdk-linux/tools/keymaps/en-us

ADD etc /etc
ADD entrypoint.sh /entrypoint.sh

RUN /opt/android-sdk-linux/platform-tools/adb start-server

EXPOSE 5037 5554 5555 6080

CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
