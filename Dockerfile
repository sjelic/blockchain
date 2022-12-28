FROM ubuntu:latest
RUN apt-get update --fix-missing # buildkit
RUN apt-get install -y wget bzip2 curl grep dpkg git build-essential
WORKDIR /workspaces/blockchain

