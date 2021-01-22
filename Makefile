.phony : all, build, clean

all: build

build:
	docker-compose build

clean:
	docker-compose down
