# Microgateway Custom Plugin Template

This repository contains a template project for creating custom KrakenD plugins. _(To be injected into Microgateway deployments)_

Any microgateway that wants to leverage a plugin should initialize a git-submodule in their `/plugins` directory with the respective plugin

## Steps

1. Initialize the go module system

```sh
go mod init yourmodulename
```

2. To build your plugin run - this specifically builds it as a go plugin _(required by krakenD)_

```sh
go build -buildmode=plugin -o yourplugin.so .
```

3. Go into the `Makefile` and update the `build` target to have the same command as step 2. _(namely making the name of
   the outputted `.so` file is correct)_

## Running locally

1. Authenticate to the [github container registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-to-the-container-registry)
```sh
export GH_PAT="your personal github access token here - must have read packages scope at a minimum"

echo $GH_PAT | docker login ghcr.io -u USERNAME --password-stdin
```

2. Update your `krakend.json` file to use the plugin you're working on
3. Build and run the docker image
```sh
docker buildx build -t gateway . && docker run gateway
```

Alternately, the make file includes a number of commands which can do this for you

```sh
# Log in to GHCR - make sure you have $GH_PAT set in your shell
make login

# Build and run the gateway
make br

# Build
make b

# Run
make r
```

## Make

The `Makefile` is required as it is used by other tooling (namely the `Dockerfile` for the microgateways) in order to
keep builds consistent across the company. As such please make sure the `all`, `build` and `clean` targets are all set
up to run correctly. Please feel free to add additional targets as required for your project, but please keep the 3
targets above limited in their scope.

## KrakenD Docs

[Intro to plugins](https://www.krakend.io/docs/extending/introduction/)

There are four different types of plugins you can write:

1. **[HTTP server plugins](https://www.krakend.io/docs/extending/http-server-plugins/)** (or handler plugins): They belong to the router layer and let you modify the request before KrakenD starts processing it, or modify the final response. You can have several plugins at once.
2. **[HTTP client plugins](https://www.krakend.io/docs/extending/http-client-plugins/)** (or proxy client plugins): They belong to the proxy layer and let you change how KrakenD interacts (as a client) with your backend services. You can have one plugin per backend.
3. **[Response Modifier plugins](https://www.krakend.io/docs/extending/plugin-modifiers/)**: They are strictly modifiers and let you change the responses received from your backends.
4. **[Request Modififer plugins](https://www.krakend.io/docs/extending/plugin-modifiers/)**: They are strictly modifiers and let you change the requests sent to your backends.
