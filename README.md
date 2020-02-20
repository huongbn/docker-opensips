# opensips-docker
Opensips - SIP proxy/server on docker.This repo used for build [opensips 2.4](https://www.opensips.org/About/Version-2-4-x) LTS on docker, aslo made to compact and simple for load balacing calls and recording calls.See also [RTPengine](https://github.com/t7hm1/rtpengine-docker) ![RTPengine Docker](https://img.shields.io/badge/RTPengine-docker-red)

### Build
	git clone https://github.com/t7hm1/opensips-docker.git && cd opensips-docker
	docker image build -t sip_server .

### Run
*	docker run -tid --rm --network=host sip_server
*	docker run -tid --rm -p 8080:8080 -p 5060:5060 sip_server

## License
![License](https://img.shields.io/github/license/t7hm1/opensips-docker?color=red&style=plastic)
