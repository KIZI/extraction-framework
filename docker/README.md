# DBpedia extraction framework in Docker

This is a fork of the dbpedia extraction framework which contains a Dockerfile for using the extractor wihin the Docker environment. This fork has also adapted some scripts in order to simplify some operations in Docker.

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
| -b  | Start an interactive container with the bash console. It is suitable if you want to launch the extraction process manually inside the container. | |

### Examples

It starts extraction for the czech chapter with the wikipedia dump version 20170201 and only for these extractors: .LabelExtractor,.MappingExtractor,.DisambiguationExtractor. It does not download any wikidata dump and does not use a mediawiki for the abstract extraction.
```
docker run -d --name dbpedia-extractor dbpedia-extractor -l=cs -s=cde -v=20170201 -e=.LabelExtractor,.MappingExtractor,.DisambiguationExtractor
```

It launches a container and attaches you into the console inside the container.
```
docker run -it --name dbpedia-extractor dbpedia-extractor -b
```

It starts a container for the czech chapter with default parameters.
```
docker run -d --name dbpedia-extractor dbpedia-extractor -l=cs
```

You can check extraction logs during running of the container or after completion.
```
docker logs dbpedia-extractor
```

If the extraction process fails, you may start the stopped container again. It will do nothing and will not start the extraction process again. You can connect to the restarted container and check errors or start some extraction parts inside the container again manually.
```
docker start dbpedia-extractor
docker exec -it dbpedia-extractor bash
```

After successfully completion you can copy extracted datasets from the docker container.
```
docker cp dbpedia-extractor:/root/datasets ./
```
