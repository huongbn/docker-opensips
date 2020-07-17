# docker-opensips
![License](https://img.shields.io/github/license/mach1el/docker-opensips?color=red&style=plastic)
![reposize](https://img.shields.io/github/repo-size/mach1el/docker-opensips?color=orange&style=plastic)
![dockerbuild](https://img.shields.io/docker/automated/mich43l/opensips?style=plastic)

Opensips - SIP proxy/server on docker.See also [RTPengine](https://github.com/machi1el/docker-rtpengine) ![RTPengine Docker](https://img.shields.io/badge/Docker-RTPengine-red) [kamailio](https://github.com/machi1el/docker-kamailio) ![Kamailio Docker](https://img.shields.io/badge/Docker-Kamailio-brightgreen)

### Pull from hub
  docker pull mich43l/opensips

### Build from source
  git clone https://github.com/machi1el/docker-opensips.git && cd docker-opensips
  docker image build -t opensips .

### Run
* docker run -tid --rm --network=host opensips
* docker run -tid --rm -p 5060:5060 opensips
* docker run -tid --restart=always --name=opensips -p 5060:5060 -v /path/to/cfg:/etc/opensips mich43l/opensips

### Notes
This using default its scripting,to use your custom scripting just `mount` */etc/opensips* to your path
