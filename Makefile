REPO = evertongava
NAME = grafana
TAG = 9.3.6
IMAGE = $(REPO)/$(NAME):$(TAG)

build:
	docker build --no-cache -t "$(IMAGE)" .

push:
	docker push "$(IMAGE)"