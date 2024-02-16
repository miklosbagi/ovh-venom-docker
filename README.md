# OVH Venom Docker
This is a small experiment / test bed for running venom dockerized.

## Why?
First, I ended up releasing [ovh-venom on docker-hub](https://hub.docker.com/repository/docker/miklosbagi/ovh-venom), so we have the beta versions available too.  
This lead to the requirement to have a sample setup to test if these builds are working. This repo aims to achieve that.

# Structure
Fairly simple, but here goes:
- We have normal service build & compose files: `Makefile`, `docker-compose.yaml`, `.env`
- We extend the service with venom tests: `docker-compose-venom`, `.venom-env`, `tests` and updated Makefile of course.

We use posgres as the example service for this test. For no particular reason, this was the one in my left back pocket.

# Usage
`make env-up`

- Order of tests is defined by service startup
  - Tests can run in parallel by having multiple tests referencing a single service as `depends on`
  - Tests can run in proper order, again, by proper use of `depends on`

Failing tests [will be verbose](https://github.com/miklosbagi/ovh-venom-docker/actions/runs/7935684858/job/21669360339), otherwise you may see only containers starting and stopping.

## Extending
- Any venom variable can be expressed in `.venom.env`, including custom executors you may have, for as long as you mount them in a volume.


# Keep in mind
- All variables are to be passed to the venom container - can be a brain breaker if you haven't got used to this :)
- Complex variables (e.g. a postgres DSN) can be trouble as they break docker-compose env var parsing - hence the .env file.
