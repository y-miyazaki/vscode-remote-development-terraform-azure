TERRAFORM_WORKSPACE=xxxxxxxxxxxx
CONTAINER_NAME=terraform-azure
IMAGE_NAME=terraform-azure
TAG=latest

check-arg-env:
ifndef env
	$(error env must add for make)
endif

build:
	docker build -f Dockerfile -t $(IMAGE_NAME):$(TAG) .

rm-state:
	rm -rf $(BASE_PATH)/.terraform

run: rm-state check-arg-env
	docker run -d --rm -v $(TERRAFORM_WORKSPACE):/workspace --env-file=env/.env.$(env) --name $(CONTAINER_NAME)-$(env) $(IMAGE_NAME):$(TAG)
