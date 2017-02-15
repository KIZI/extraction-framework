# DBpedia extraction framework with Docker

This is a fork of the dbpedia extraction framework which contains a Dockerfile for using of the extractor wihin the Docker environment. This fork has also adapted some scripts in order to simplify some operations in Docker.

## Image building

```
docker build -t dbpedia-extractor https://github.com/KIZI/extraction-framework.git#master:docker
```

## Container running

```
docker run -d --name dbpedia-extractor dbpedia-extractor <parameters>
```
