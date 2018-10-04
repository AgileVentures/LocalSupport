# Developing with Docker

## Prerequisites

In order to run this container you'll need docker installation
* [Windows](https://docs.docker.com/docker-for-windows/)
* [OS X](https://docs.docker.com/docker-for-mac/)
* [Linux](https://docs.docker.com/linux/started/)

This application uses [Docker Compose](https://docs.docker.io/compose) to make building and spinning up the containers easy.

## Setup docker

Execute this setup just for the first time, or when you want to recreate everything from scratch.

**BE AWARE IT WILL DELETE ALL YOUR DATA, including the Postgres Database.**

```
$ ./docker/setup.sh
```

## Start docker

Start the application

```
$ ./docker/start.sh
```

## Stop docker

Stop the application

```
$ ./docker/stop.sh
```

ps: those docker commands were tested under the following environment:

- MacOS 10.13.6
- Docker version 18.06.0-ce, build 0ffa825
- docker-compose version 1.22.0, build f46880f

If it doesn't work for you, try to check your docker version and consider upgrading it if you have an older version.


Run the tests:
```
$ docker-compose run web rspec && cucumber
```

Once that is done, go checkout [localhost:3000](localhost:3000).

## Being efficient

This section is for common tasks you'll need to do in order to keep pushing forward. It is encouraged to add to this section with a pull request when you find a trick that helps you develop with docker even more efficiently.

### Killing all running containers

It's not uncommon that you'll want to nuke all running containers in docker. To do this:

```
$ docker kill $(docker ps -q)
```

This will stop all currently running containers.

### Seeing all of the currently running containers

Sometimes `docker-compose ps` just isn't enough. Maybe another project started containers that you forgot about, in this case, you'll use this:

```
$ docker ps
```

This will show all currently running containers and their port mappings. If you see something like "unable to bind port: already in use", I'd run this command to see if a container already reserved that port and kill it if necessary.

### Dropping into a container

It's possible to jump into a container to diagnose issues you may be having, you can do:

```
$ docker-compose run web bash
```

Now you have a terminal inside of the container for the `app` service (Rails).

### Contributing

To help with development please see our [contribution guidelines](../../CONTRIBUTING.md).

Please note that after running `git pull upstream develop`, or making changes to the Gemfile or package.json you will need to run `bundle install` or `npm install` respectively which can be done in your bash session above

Any command can run with docker-compose using;
```
$ docker-compose run SERVICE COMMAND
```
In this case COMMAND is either `bundle install` or `npm install` and as you can see from the docker-compose.yml file, SERVICE is web.