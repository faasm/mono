# Faasm Development Repo

This repo is used for developing the [Faasm](https://github.com/faasm) project.

*Note* submodules in this folder should be up-to-date with the latest `master`.
Don't push your local branch checkouts to them.

Having everything related to both the client and server side of Faasm in a
single repo would be prohibitively large and cause _very_ long builds.
Additionally, the system should really be treated in layers, independent of
those above them. 

However, it's still convenient to have everything in one place, especially when
you _do_ need to touch all parts. Hence the existence of this repo. 

## Layers

The Faasm project has a top layer which creates WebAssembly files, which are
executed by the Faasm runtime below, which depends on Faabric for messaging and 
state. 

- [faasm/cpp](https://github.com/faasm/cpp) - tools for building C/C++ for use
  in Faasm.
- [faasm/python](https://github.com/faasm/python) - tools for building CPython
  and Python functions for use in Faasm.
- [faasm/faasm](https://github.com/faasm/faasm) - the Faasm runtime (independent
  of specific languages used to compile the WebAssembly)
- [faasm/faabric](https://github.com/faasm/faabric) - serverless scheduling,
  messaging and state (independent of WebAssembly).

## Initial Set-up

First you need to update all the submodules:

```
git submodule update --init --recursive
```

The repos are tied together using the `/usr/local/faasm` directory, which you
can initialise with:

```
./bin/refresh_local.sh
```

If you want to run Python scripts outside the containerised environments, you 
can set up a suitable Python virtual envrionment with:

```
./bin/create_venv.sh
```

## Use

Once you've set up the repo, you can start the CLI for whichever project you 
want to work on:

```
# C++ applications
./bin/cli.sh cpp

# Python applications
./bin/cli.sh python

# Faasm 
./bin/cli.sh faasm

# Faabric
./bin/cli.sh faabric
```

# Faasm Development

To build and run the tests, you can then run the following:

```bash
# --- CPP CLI ---
# Build CPP functions required for the tests
inv compile.local

# --- Python CLI ---
# Build Python wrapper function
inv func

# Upload the Python functions
inv upload --local

# --- Faasm CLI ---
# Build the development tools
inv dev.tools

# Run codegen (this may take a while the first time it's run)
inv codegen.local
inv python.codegen

# Set up cgroup
./bin/cgroup.sh

# Run the tests
tests
```

## Running a local Faasm development cluster

You should be able to do the majority of development with the set-up detailed
above, however, to set up a local development cluster you can run:

```
# --- Faasm CLI ---
# Build the code
inv dev.tools
```

Then, outside the container:

```
# Mount your local build inside the containers
export FAASM_BUILD_MOUNT=/build/faasm

# Start up the local cluster
cd faasm
docker-compose up -d
```

This will mount the built binaries from the CLI container into the other 
containers, thus allowing you to rebuild and restart everything with local 
changes. 

For example, if you have changed code and want to restart the worker container:

```
# Inside the CLI container, rebuild the pool runner (executed by the worker)
inv dev.cc pool_runner

# Outside the container, restart the worker
docker-compose restart worker

# Tail the logs
docker-compose logs -f
```

## Tooling - editors, IDEs etc.

You can use custom containers that inherit from the existing CLI images if you
want to add text editors etc. 

Before running the `./bin/cli.sh` script, you need to set one or more of the
following environment variables:

```bash
# Faasm
FAASM_CLI_IMAGE

# Faabric
FAABRIC_CLI_IMAGE

# CPP
CPP_CLI_IMAGE

# Python
PYTHON_CLI_IMAGE
```

## Testing

We use [Catch2](https://github.com/catchorg/Catch2) for testing and your life 
will be much easier if you're familiar with their [command line
docs](https://github.com/catchorg/Catch2/blob/v2.x/docs/command-line.md).  This
means you can do things like:

```
# Run all the MPI tests
tests "[mpi]"

# Run a specific test
tests "Test some feature"
```

## Building outside of the container

If you want to build projects outside of the recommended containers, or just
run some of the CLI tasks, you can take a look at the [CLI
Dockerfile](../docker/cli.dockerfile) to see what's required:

To run the CLI, you should just need to do:

```bash
# Set up the venv
./bin/create_venv.sh

# Activate the virtualenv
source venv/bin/activate

# Check things work
cd faasm inv -r faasmcli/faasmcli -l

cd ../cpp inv -l

cd ../python inv -l
```
