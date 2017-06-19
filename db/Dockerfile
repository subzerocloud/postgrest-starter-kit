# example building using AWS ECR as the remote private registry
# export REMOTE_REPO=<yourawsid>.dkr.ecr.us-east-1.amazonaws.com/sandbox-pg
# docker build -t sandbox-pg .
# docker tag sandbox-pg $REMOTE_REPO:latest
# docker push $REMOTE_REPO:latest

FROM postgres:9.6-alpine

RUN apk add --update perl && rm -rf /var/cache/apk/*

COPY src /docker-entrypoint-initdb.d
