#!/bin/bash
set -e

echo "Build image ($REPOSITORY_NAME:$DEFAULT_TAG)"
docker build -t $REPOSITORY_NAME:$DEFAULT_TAG .

echo "Export key for use by Docker-Compose"
export AUTHORIZED_KEY=$(cat test/ansible.pub)

echo "Run connection test"
docker-compose -f test/docker-compose.yml run test

echo "Log in on Docker Hub with user $DOCKER_USERNAME"
docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"

if [[ ! -z $TRAVIS_TAG ]]; then
  echo "Release found with Git tag $TRAVIS_TAG"

  echo "Tagging image with Git tag: $REPOSITORY_NAME:$TRAVIS_TAG"
  docker tag $REPOSITORY_NAME:$DEFAULT_TAG $REPOSITORY_NAME:$TRAVIS_TAG

  echo "Tagging image as latest: $REPOSITORY_NAME:latest"
  docker tag $REPOSITORY_NAME:$DEFAULT_TAG $REPOSITORY_NAME:latest
fi

echo "Push repository $REPOSITORY_NAME"
docker push $REPOSITORY_NAME

echo "Log out on Docker Hub"
docker logout

