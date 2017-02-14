#!/bin/bash

IS_TERMINATED=false

_term() {  
  IS_TERMINATED=true 
}

trap _term SIGTERM SIGINT

startedFile="/root/started"
if [[ -f "$startedFile" ]]; then
while ! $IS_TERMINATED; do sleep 5; done
else

touch $startedFile

DOWNLOAD_CONFIGS=1
DOWNLOAD_DUMPS=1
DOWNLOAD_WIKIDATA=0
IMPORT_DUMPS=1
EXTRACT_ABSTRACTS=1
EXTRACT_ALL=1
VERSION=0
BASH=0
LANGUAGE=
EXTRACTORS=.AnchorTextExtractor,.ArticleCategoriesExtractor,.ArticlePageExtractor,.ArticleTemplatesExtractor,.CategoryLabelExtractor,.ExternalLinksExtractor,.GalleryExtractor,.InfoboxExtractor,.InterLanguageLinksExtractor,.LabelExtractor,.PageIdExtractor,.PageLinksExtractor,.RedirectExtractor,.RevisionIdExtractor,.ProvenanceExtractor,.SkosCategoriesExtractor,.WikiPageLengthExtractor,.WikiPageOutDegreeExtractor,.GeoExtractor,.HomepageExtractor,.ImageExtractor,.MappingExtractor,.DisambiguationExtractor

# -s=cdwiae (c=download configs, d=download dumps, w=download wikidata dumps, i=import dumps, a=extract abstracts, e=extract all)
# -v=20170101 (wikipedia version)
# -l=en (language - required!)
# -e=.AnchorTextExtractor,.ArticleCategoriesExtractor,.ArticlePageExtractor... (dbpedia extractors, default are "see above")
for i in "$@"
do
case $i in
    -s=*)
    SETTINGS="${i#*=}"
    DOWNLOAD_CONFIGS=0
    DOWNLOAD_DUMPS=0
    IMPORT_DUMPS=0
    EXTRACT_ABSTRACTS=0
    EXTRACT_ALL=0
    if [[ $SETTINGS == *"c"* ]]; then
      DOWNLOAD_CONFIGS=1
    fi
    if [[ $SETTINGS == *"d"* ]]; then
      DOWNLOAD_DUMPS=1
    fi
    if [[ $SETTINGS == *"w"* ]]; then
      DOWNLOAD_WIKIDATA=1
    fi
    if [[ $SETTINGS == *"i"* ]]; then
      IMPORT_DUMPS=1
    fi
    if [[ $SETTINGS == *"a"* ]]; then
      EXTRACT_ABSTRACTS=1
    fi
    if [[ $SETTINGS == *"e"* ]]; then
      EXTRACT_ALL=1
    fi
    shift
    ;;
    -v=*)
    VERSION="${i#*=}"
    shift
    ;;
    -l=*)
    LANGUAGE="${i#*=}"
    shift
    ;;
    -e=*)
    EXTRACTORS="${i#*=}"
    shift
    ;;
    -b)
    BASH=1
    shift
    ;;
    *)
    #unknown option
    ;;
esac
done

if [[ $BASH == 1 ]]; then
  /bin/bash
else

if [[ -z "$LANGUAGE" ]]; then
  echo "A language flag is required (e.g. -l=en)"
  exit 1
fi

if [[ $VERSION != 0 ]]; then
  echo "download-dates=$VERSION-$VERSION" >> /root/extraction-framework/dump/download.doc.properties
fi

if [[ $DOWNLOAD_WIKIDATA != 0 ]]; then
  echo "download=wikidata:pages-articles.xml.bz" >> /root/extraction-framework/dump/download.doc.properties
fi

sed -i -- "s/!LANG!/$LANGUAGE/g" /root/extraction-framework/dump/download.doc.properties
sed -i -- "s/!LANG!/$LANGUAGE/g" /root/extraction-framework/dump/extraction.abstracts.doc.properties
sed -i -- "s/!LANG!/$LANGUAGE/g" /root/extraction-framework/dump/extraction.doc.properties

sed -i -- "s/!EXTRACT0RS!/$EXTRACTORS/g" /root/extraction-framework/dump/extraction.doc.properties

if [[ $DOWNLOAD_CONFIGS == 1 ]]; then
  cd /root/extraction-framework/core
  ../run download-ontology
  ../run download-mappings
  ../run generate-settings
fi
cd /root/extraction-framework
mvn install
if [[ $DOWNLOAD_DUMPS == 1 ]]; then
  cd /root/extraction-framework/dump
  ../run download config=download.doc.properties
fi
if [[ $IMPORT_DUMPS == 1 ]]; then
  cd /root/extraction-framework/dump
  service mysql restart
  ../run import
  service mysql stop
fi
if [[ $EXTRACT_ABSTRACTS == 1 ]]; then
  cd /root/extraction-framework/dump
  service mysql restart
  service apache2 restart
  ../run extraction extraction.abstracts.doc.properties
  service apache2 stop
  service mysql stop
fi
if [[ $EXTRACT_ALL == 1 ]]; then
  cd /root/extraction-framework/dump
  ../run extraction extraction.doc.properties
fi

fi

fi