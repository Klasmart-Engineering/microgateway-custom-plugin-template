all: clean build

build:
	go build -buildmode=plugin -o <plugin-name>.so .

clean:
	go clean

login:
	echo ${GH_PAT} | docker login ghcr.io -u USERNAME --password-stdin

b:
	docker buildx build -t gateway .

r:
	docker run -p "8080:8080" gateway

br: b r
