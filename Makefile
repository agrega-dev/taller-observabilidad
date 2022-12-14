.PHONY: build run stop clean

build:
	docker-compose build

run:
	docker-compose up

stop:
	docker-compose stop

clean:
	docker-compose down --remove-orphans --volumes
