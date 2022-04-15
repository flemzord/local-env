# Local env

## How it works
One repo to rule them all.

## Deps
You need to install a few things:
- mkcert 
- nss

## Install
``make install``

### Customizations
In Makefile:
- ``clone``: Add one line to clone the repo.

In Docker-compose.yml:
- 'POSTGRES_MULTIPLE_DATABASES': Create multiple databases.

## URL
All url works by default in Google Chrome. For other tools, you should create url in your host files.
- https://traefik.app.localhost

Finish.
