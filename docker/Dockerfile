FROM debian:jessie

MAINTAINER kizi "prozeman@gmail.com"

WORKDIR /root

RUN apt-get update && \
    apt-get install -y openjdk-7-jdk git maven && \
    
RUN git clone https://github.com/KIZI/extraction-framework.git && \
    mkdir datasets
    
ADD *.properties extraction-framework/dump

RUN cd extraction-framework && \
    mvn clean install && \
    cd core
    ../run download-ontology
    ../run generate-settings
    cd ../dump
    ../run download config=download.cs.properties
    ../run extraction extraction.cs.properties