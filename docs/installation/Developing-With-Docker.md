# Developing with Docker

This document is cherry-picked from some internal documentation at [Namely](https://github.com/namely/), which was originally authored by [Bobby Tables](https://github.com/bobbytables). It will outline how to develop on this application through Docker / Docker Compose.

## Make sure Docker is installed and setup.

If you are on Mac or Windows, the recommended way to have Docker installed (as of October 2016) is to use [Docker Toolbox](https://www.docker.com/products/docker-toolbox). It makes installation simple and gives us more flexibility.

If you are on Linux, you will skip the installation of the Docker Toolbox, and you will need to install `docker-compose` separately.

The rest of this document assumes you are on a Mac.

After you've installed the toolbox, head to your terminal and run:

```sh
$ docker-machine create --driver=virtualbox default
```

This will create a new virtual machine inside of VirtualBox called "default". Next, you'll want to up the memory on the virtual machine.

#### Increasing memory for VirtualBox

Make sure the machine is stopped, you can do this with:

```sh
$ docker-machine stop
```

1. Type into Spotlight or Alfred (whichever tool you use to search) "VirtualBox".
2. Once VirtualBox is open, you should see a "default" machine in the list on the left.
3. Click "default" and then "settings".
4. In the dialog that appears, click "system"
5. In the system dialog, change the memory to "8192" (8 gigs)

After this, you can start the machine again using `docker-machine`:

```sh
$ docker-machine start
```

### Using NFS for mounts

NFS (Network File System) is _much_ faster for file reads inside of virtualbox. Since our applications read a ton of files to operate (think: every ruby gem and their files), it's recommended to use NFS for mounted volumes.

Luckily, this is super easy to do with the tool https://github.com/adlogix/docker-machine-nfs

```sh
$ brew install docker-machine-nfs
$ docker-machine-nfs default
```

This will configure NFS against your VirtualBox VM and Mac OSX.

#### Why aren't we using Docker For Mac?

Because it is slowwwwww. VirtualBox + NFS is much faster and allows us to develop instead of wait.


### The annoying "is it running?" error

Commonly, you'll see this error:

```
Cannot connect to the Docker daemon. Is the docker daemon running on this host?
```

This is indicating that either Docker isn't running or hasn't been setup for the current terminal session, to make sure both are running, you can run these 2 commands:

```sh
$ docker-machine start default; eval $(docker-machine env default)
```

Or you may just need to evaluate the current environment:

```sh
$ eval $(docker-machine env default)
```

You may want to make an alias for this, or add it to your terminal's startup profile like so:

```sh
docker_running=$(docker-machine ls | grep default)
if [[ "$docker_running" == *"Stopped"* ]]
then
    docker-machine start default
    eval "$(docker-machine env default)"
    env | grep "DOCKER_HOST"
elif [[ "$docker_running" == *"Running"* ]]
then
    eval "$(docker-machine env default)"
fi
```

---

To see which machines are currently available for Docker, you can run:

```sh
$ docker-machine ls
```

This will give you output similar to:

```
NAME      ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER    ERRORS
default   *        virtualbox   Running   tcp://192.168.99.100:2376           v1.11.2
```

## Pointing your browser at VirtualBox

Up until now, you have viewed your local rails server at `localhost:3000`. To use this setup however, you'll need to change the URL to point to our VirtualBox IP address.

First, you'll need to obtain the IP address from the Docker Machine:

```sh
$ docker-machine ip
```

Under normal conditions, this IP will be `192.168.99.100`. So instead of visiting `localhost:3000`, you will visit `192.168.99.100:3000`.

## Running the application

After you've installed Docker, it's time to build the containers necessary to run this application locally.

This application uses [Docker Compose](https://docs.docker.io/compose) to make building and spinning up the containers easy.

Run:

```sh
$ docker-compose build
```

This will start building the containers (`app` and `db`). I'd go get a coffee, read hacker news, or go catch pokemon until it's done. It can take a _very_ long time initially.

---

Once the builds are done, you'll be able to run:

```sh
$ docker-compose up
```

This will start both the rails application and the database.

Once you see the rails server is running, set up the database:

```sh
$ docker-compose run app bundle exec rake db:drop db:create db:schema:load db:setup db:test:prepare
```

Run the tests:
```sh
$ docker-compose run app rspec && cucumber
```

Once that is done, go checkout [192.168.99.100:3000](192.168.99.100:3000).

## Being efficient

This section is for common tasks you'll need to do in order to keep pushing forward. It is encouraged to add to this section with a pull request when you find a trick that helps you develop with docker even more efficiently.

### When things get weird

On occasion, things will get weird. This is an unfortunate side affect of virtualization. If the error is obvious to fix and your fix doesn't fix it, then honestly **just stop and start the VM**.

It's likely something has just gone funky and needs some re-aligning. Stopping and starting the VM is easy:

```sh
$ docker-machine stop
$ docker-machine start
```

This will stop all running containers and stop and start the VM. You'll need to restart the containers manually, they will not come back up automatically.

Note: `docker-machine restart` may appear to be equivalent, but it is *not*. Only a full stop and start will give you a clean slate.

### Killing all running containers

It's not uncommon that you'll want to nuke all running containers in docker. To do this:

```sh
$ docker kill $(docker ps -q)
```

This will stop all currently running containers.

### Seeing all of the currently running containers

Sometimes `docker-compose ps` just isn't enough. Maybe another project started containers that you forgot about, in this case, you'll use this:

```sh
$ docker ps
```

This will show all currently running containers and their port mappings. If you see something like "unable to bind port: already in use", I'd run this command to see if a container already reserved that port and kill it if necessary.

### Aliases

Take the 1 minute it takes to do it and add some aliases for these tools, here's a quick snippet:

```sh
alias dco=docker-compose
alias dmc=docker-machine
```

Then you can do things with less keystrokes like:

```sh
$ dco stop
$ dco restart app
$ dco logs -f app
```

### Dropping into a container

It's possible to jump into a container to diagnose issues you may be having, you can do:

```sh
$ docker-compose run app bash
```

Now you have a terminal inside of the container for the `app` service (Rails).

### Running migrations

Created a migration? To migrate inside of the container, you can run:

```sh
$ docker-compose run app bundle exec rake db:migrate
```
