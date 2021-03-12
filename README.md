# Faasm Development Repo

This repo collects all the sub-repositories of the Faasm project and is used for
development.

A Faasm monorepo would be prohibitively large, builds would take ages, and most
development only requires changing one part of the system.

However, it's still convenient to have everything in one place, especially when
you _do_ need to touch all parts. Hence the existence of this repo. 

## Repo structure

Client-side (i.e. compiling wasm)

- [faasm/cpp](https://github.com/faasm/cpp) - tools for building C/C++ for using
  in Faasm.
- [faasm/python](https://github.com/faasm/python) - tools for building CPython
  and Python functions for use in Faasm.

Server-side (i.e. executing wasm)

- [faasm/faasm](https://github.com/faasm/faasm) - the WebAssembly runtime.
- [faasm/faabric](https://github.com/faasm/faabric) - serverless scheduling,
  messaging and state (independent of WebAssembly).

Note that Faabric is edited as a submodule of Faasm.

## Use

Once you've set up the repo, you can start the CLI for whichever project you 
want to work on:

```
# Faasm 
./bin/cli.sh faasm

# C++ applications
./bin/cli.sh cpp

# Python applications
./bin/cli.sh python
```

## Set-up

First you need to set up submodules:

```
git submodule update --init --recursive
```

The repos are tied together using the `/usr/local/faasm` directory, which you
can initialise with:

```
./bin/refresh_local.sh
```

