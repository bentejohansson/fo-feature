.PHONY: all

all:
	docker build -t fo-feature -t docker.adeo.no:5000/fo/feature .
