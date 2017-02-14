# docker build -t dbpedia-cs-extractor https://github.com/KIZI/extraction-framework.git#:docker
# docker run -d --name dbpedia-cs-extractor dbpedia-cs-extractor -l=cs
FROM debian:jessie

MAINTAINER kizi "prozeman@gmail.com"

WORKDIR /root

RUN apt-get update && \
    apt-get install -y openjdk-7-jdk git maven && \
    /bin/bash -c "debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'" && \
    /bin/bash -c "debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'" && \
    apt-get -y install mysql-server && \
    apt-get -y install apache2 wget php5 libapache2-mod-php5 php5-apcu php5-mysql php5-dev liblua5.1-dev
    
ADD my.cnf /etc/mysql/my.cnf
ADD start.sh /root

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
    cp luasandbox.ini /etc/php5/cli/conf.d && \
    echo 'apc.enabled=1' >> /etc/php5/mods-available/apcu.ini && \
    echo 'apc.enable_cli=1' >> /etc/php5/mods-available/apcu.ini && \
    chown -R root:www-data /var/www/html/mediawiki && \
    chmod -R 775 /var/www/html/mediawiki    

ENV JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8"

RUN git clone https://github.com/KIZI/extraction-framework.git && \
    mkdir datasets && \
    cd extraction-framework && \
    mvn clean install && \
    chmod 775 /root/start.sh
    
ADD LocalSettings.php /var/www/html/mediawiki
ADD *doc.properties extraction-framework/dump/
    
WORKDIR /root/extraction-framework

ENTRYPOINT ["/root/start.sh"]