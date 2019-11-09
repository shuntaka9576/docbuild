IMAGE_NAME=hozi894/docbuild:latest

build:
	docker image build . -t ${IMAGE_NAME}
run: build
	docker run -it ${IMAGE_NAME}
push: build
	docker push ${IMAGE_NAME}
start:
	docker run -itd hozi894/docbuild:latest
exec:
	docker exec -it hozi894/docbuild:latest /bin/sh

.PHONY test
