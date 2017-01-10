FROM debian:jessie

MAINTAINER kizi "prozeman@gmail.com"

WORKDIR /root

RUN "apt-get update" && \
    apt-get install -y openjdk-7-jdk git maven && \
    /bin/bash -c "debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'" && \
    /bin/bash -c "debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'" && \
    apt-get -y install mysql-server && \
    apt-get -y install apache2 wget php5 libapache2-mod-php5 php5-apcu php5-mysql php5-dev liblua5.1-dev
    
ADD my.cnf /etc/mysql/my.cnf

RUN wget https://releases.wikimedia.org/mediawiki/1.28/mediawiki-1.28.0.tar.gz && \
    tar -zxvf mediawiki-1.28.0.tar.gz && \
    rm mediawiki-1.28.0.tar.gz     && \
    mv /root/mediawiki-1.28.0 /var/www/html/mediawiki && \
    cd /var/www/html/mediawiki/extensions && \
    git clone -b REL1_28 https://gerrit.wikimedia.org/r/p/mediawiki/extensions/timeline.git && \
    git clone -b REL1_28 https://gerrit.wikimedia.org/r/p/mediawiki/extensions/CharInsert.git && \
    git clone -b REL1_28 https://gerrit.wikimedia.org/r/p/mediawiki/extensions/MobileFrontend.git && \
    git clone -b REL1_28 https://gerrit.wikimedia.org/r/p/mediawiki/extensions/CategoryTree.git && \
    git clone https://gerrit.wikimedia.org/r/p/mediawiki/php/luasandbox.git && \
    git clone -b REL1_28 https://gerrit.wikimedia.org/r/p/mediawiki/extensions/GeoData.git && \
    git clone -b REL1_26 https://gerrit.wikimedia.org/r/p/mediawiki/extensions/ExpandTemplates.git && \
    git clone -b REL1_28 https://gerrit.wikimedia.org/r/p/mediawiki/extensions/Babel.git && \
    git clone -b REL1_28 https://gerrit.wikimedia.org/r/p/mediawiki/extensions/Scribunto.git && \
    git clone -b REL1_28 https://gerrit.wikimedia.org/r/p/mediawiki/extensions/TextExtracts.git && \
    git clone -b REL1_28 https://gerrit.wikimedia.org/r/p/mediawiki/extensions/Math.git && \
    git clone -b REL1_28 https://gerrit.wikimedia.org/r/p/mediawiki/extensions/wikihiero.git && \
    git clone -b REL1_28 https://gerrit.wikimedia.org/r/p/mediawiki/extensions/Mantle.git && \
    cd luasandbox && \
    phpize && ./configure && make && make install && \
    cp luasandbox.ini /etc/php5/apache2/conf.d && \
    chown -R root:www-data /var/www/html/mediawiki && \
    chmod -R 775 /var/www/html/mediawiki    

ENV JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8"

RUN git clone -b cs-docker-v1 https://github.com/KIZI/extraction-framework.git && \
    mkdir datasets && \
    cd extraction-framework && \
    cp dump/src/main/mediawiki/LocalSettings.php /var/www/html/mediawiki && \
    mvn clean install
    
WORKDIR /root/extraction-framework

CMD cd core && \
    ../run download-ontology && \
    ../run download-mappings && \
    ../run generate-settings && \
    cd .. && \
    mvn install && \
    cd dump && \
    ../run download config=download.cs.properties && \
    service mysql start && \
    ../run import && \
    service apache2 start && \
    ../run extraction extraction.abstracts.cs.properties && \
    service apache2 stop && \
    service mysql stop && \
    ../run extraction extraction.cs.properties