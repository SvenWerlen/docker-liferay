##
## Docker image: Liferay DXP -> Tomcat 
##
## Build: docker build -t liferay-dxp-tomcat .
## Run: docker run -it -p 8080:8080 liferay-dxp-tomcat 
## Run: docker run -it -p 8080:8080 --link liferay-mysql:liferay-mysql -e DBHOST=liferay-mysql -e DBNAME=lportal -e DBUSER=lportal -e DBPASS=lportal liferay-62-tomcat
##
FROM ubuntu 

# ENVIRONMENT
ENV LIFERAY_VERSION		"7.0.2 GA3"
ENV LIFERAY_VERSION_FULL	"7.0-ga3-20160804222206210"
ENV LIFERAY_SHA1		"4fab54cc019f97bdf450652f316622e430b156e6"

# PATHS
ENV DOWNLOAD		/tmp/download/
ENV APP_HOME		/opt/app/
ENV LIFERAY_HOME	/opt/app/liferay
ENV TOMCAT_HOME		/opt/app/liferay/tomcat

# Install CURL
USER root
RUN apt-get update \
    && apt-get install -y curl

# DOWNLOAD packages
RUN mkdir $DOWNLOAD \
    && cd $DOWNLOAD
RUN curl -L -O "http://downloads.sourceforge.net/project/lportal/Liferay Portal/$LIFERAY_VERSION/liferay-ce-portal-tomcat-$LIFERAY_VERSION_FULL.zip"
RUN mv *.* $DOWNLOAD

## INSTALLATION: Liferay + Tomcat 
RUN apt-get install -y unzip
RUN mkdir -p $APP_HOME \
    && cd $APP_HOME \
    && sha1sum $DOWNLOAD/liferay-ce-portal-tomcat-$LIFERAY_VERSION_FULL.zip | grep $LIFERAY_SHA1 \
    && unzip $DOWNLOAD/liferay-ce-portal-tomcat-$LIFERAY_VERSION_FULL.zip \
    && find -name "liferay-ce-portal-*" -type d -exec ln -s {} liferay \;  \
    && cd liferay \
    && find -name "tomcat-*" -type d -exec ln -s {} tomcat \;

## USER PERMISSIONS
RUN useradd -d $LIFERAY_HOME liferay
RUN chown -R liferay.users $LIFERAY_HOME

## INSTALLATION: Java
RUN apt-get install -y openjdk-8-jdk

## CONFIGURATIONS
COPY files /tmp/files
RUN cp /tmp/files/portal-mysql.properties $LIFERAY_HOME/ \
    && cp /tmp/files/update-config.sh $LIFERAY_HOME/ \
    && cp /tmp/files/portal-ext.properties $LIFERAY_HOME/ \
    && cp /tmp/files/system-ext.properties $TOMCAT_HOME/webapps/ROOT/WEB-INF/classes/ \
    && /bin/echo -e '\nCATALINA_OPTS="$CATALINA_OPTS -Dexternal-properties=portal-mysql.properties"' >> $TOMCAT_HOME/bin/setenv.sh

RUN cat $TOMCAT_HOME/bin/setenv.sh

## CLEANUP
RUN rm -rf $HOME/files \
    && rm -rf $DOWNLOAD

## EXPOSE ports
EXPOSE 8080

CMD $LIFERAY_HOME/update-config.sh && $TOMCAT_HOME/bin/catalina.sh  run 
