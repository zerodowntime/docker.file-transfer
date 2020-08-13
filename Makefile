##
## Magic Makefile
##

DOCKER_REPO ?= $(subst .,/,$(notdir $(PWD)))
DOCKER_TAG ?= latest

BUILD_PATH ?= /
DOCKERFILE_PATH ?= Dockerfile

, = ,
ALL_TAGS = $(subst $(,), ,$(DOCKER_TAG))
TAG_LIST = $(foreach tag,$(ALL_TAGS),-t "$(DOCKER_REPO):$(tag)")
ARG_LIST = $(foreach arg,$(BUILD_ARGS),--build-arg "$(arg)")

# ARG_LIST = += --no-cache

DOCKER_TAG += v1

image: build push

build:
	docker image build $(TAG_LIST) $(ARG_LIST) -f ".$(BUILD_PATH)/$(DOCKERFILE_PATH)" ".$(BUILD_PATH)"

push:
	$(foreach tag,$(ALL_TAGS),docker image push "$(DOCKER_REPO):$(tag)" &&) true

runit: build
	docker run -it --rm $(RUN_OPTS) "$(DOCKER_REPO):$(firstword $(ALL_TAGS))"
