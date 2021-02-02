FROM openjdk:14-alpine
# WIKI https://docs.opendaylight.org/projects/netconf/en/latest/testtool.html

RUN apk add curl && \
    mkdir -p /opt/app/netconf-testtool && \
    curl https://nexus.opendaylight.org/content/repositories/public/org/opendaylight/netconf/netconf-testtool/1.8.0/netconf-testtool-1.8.0-executable.jar \
      -o /opt/app/netconf-testtool/netconf-testtool-1.8.0-executable.jar

EXPOSE 17830
ENTRYPOINT ["java", "-Xmx1G", "-XX:MaxPermSize=256M", "-jar", "/opt/app/netconf-testtool/netconf-testtool-1.8.0-executable.jar"]