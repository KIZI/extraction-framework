# DBpedia extraction framework with Docker

This is a fork of the dbpedia extraction framework which contains a Dockerfile for using of the extractor wihin the Docker environment. This fork has also adapted some scripts in order to simplify some operations in Docker.

## Build the image

```
docker build -t dbpedia-extractor https://github.com/KIZI/extraction-framework.git#master:docker
```

## Run the container

```
docker run -d --name dbpedia-extractor dbpedia-extractor <parameters>
```

List of parameters:

| Flag | Description | Default |
| ---- | ----------- | ------- |
| -l   | A short name of a language. You have to specify only one language! Only this parameter is required | |
| -s   | An enumeration of the extraction steps <ul><li>c - download ontology, mappings and settings.</li><li>d - download a wikipedia dump for the set language and the common dump for the image extraction etc.</li><li>w - download the wikidata dump.</li><li>i - import the wikipedia dump into the mediawiki database for the abstract extraction.</li><li>a - extract abstracts from a mediawiki within the docker container.</li><li>e - extract data using specified extractors.</li></ul> | cdiae |
| -v   | A wikipedia dump version | newest |
| -e   | DBpedia extractors to be used | <ul><li>.AnchorTextExtractor</li><li>.ArticleCategoriesExtractor</li><li>.ArticlePageExtractor</li><li>.ArticleTemplatesExtractor</li><li>.CategoryLabelExtractor</li><li>.ExternalLinksExtractor</li><li>.GalleryExtractor</li><li>.InfoboxExtractor</li><li>.InterLanguageLinksExtractor</li><li>.LabelExtractor</li><li>.PageIdExtractor</li><li>.PageLinksExtractor</li><li>.RedirectExtractor</li><li>.RevisionIdExtractor</li><li>.ProvenanceExtractor</li><li>.SkosCategoriesExtractor</li><li>.WikiPageLengthExtractor</li><li>.WikiPageOutDegreeExtractor</li><li>.GeoExtractor</li><li>.HomepageExtractor</li><li>.ImageExtractor</li><li>.MappingExtractor</li><li>.DisambiguationExtractor</li></ul> |


```
-l=<language> (only this parameter is required! <language> = a short name of a language - en,de,cs,...)
```
