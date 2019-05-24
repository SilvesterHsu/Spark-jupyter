#!/bin/bash

curl http://185.186.146.243/s/i3nRLRQzZJ2Ln5a/download --output jdk-8u211-linux-x64.tar.gz
mkdir /opt/jdk
tar -zxf jdk-8* -C /opt/jdk
update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_211/bin/java 100
update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_211/bin/javac 100
update-alternatives --display java
update-alternatives --display javac
rm jdk-8u211-linux-x64.tar.gz
